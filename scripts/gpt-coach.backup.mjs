import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { OpenAI } from "openai";

const args = new Map(process.argv.slice(2).map((a,i,arr)=>a.startsWith("--")?[a.replace(/^--/,""), arr[i+1] && !arr[i+1].startsWith("--") ? arr[i+1] : "true"]:null).filter(Boolean));
const snapshotPath = args.get("snapshot") || "exports/webflow-snapshot.css";
const diffJsonPath = args.get("diff") || "reports/diff.json";
const coachBasePath = args.get("base") || "reports/coach.md";
const outMdPath = args.get("out") || "reports/coach.gpt.md";
const outJsonPath = args.get("json") || "reports/coach.gpt.json";
const maxCssBytes = Number(args.get("maxCssBytes") || 200_000); // cap for token safety
const model = process.env.COACH_MODEL || "gpt-4.1";

function fail(msg){ console.error("ERROR:", msg); process.exit(1); }
function exists(p){ try{ fs.accessSync(p); return true; }catch{ return false; } }

if (!process.env.OPENAI_API_KEY) fail("OPENAI_API_KEY not set");
if (!exists(snapshotPath)) fail(`Snapshot not found: ${snapshotPath}`);
if (!exists(diffJsonPath)) fail(`Diff JSON not found: ${diffJsonPath}`);
if (!exists(coachBasePath)) fail(`Base coach report not found: ${coachBasePath}`);

const cssRaw = fs.readFileSync(snapshotPath, "utf8");
const cssBytes = Buffer.byteLength(cssRaw);
let cssSample = cssRaw;
if (cssBytes > maxCssBytes) {
  const head = cssRaw.slice(0, Math.floor(maxCssBytes * 0.6));
  const tail = cssRaw.slice(-Math.floor(maxCssBytes * 0.4));
  cssSample = head + "\n/* ...CSS truncated for token limit... */\n" + tail;
}

const diffJson = JSON.parse(fs.readFileSync(diffJsonPath, "utf8"));
const coachBase = fs.readFileSync(coachBasePath, "utf8");

const priorities = [
  "Tokenize repeated hex/colors/sizes",
  "Adopt rem scale (16px base)",
  "Reduce specificity (no !important)",
  "Utility/selector hygiene",
  "Spacing scale coherence"
].join(", ");

const system = "You are a senior CSS/Webflow architect. Be concise, opinionated, reproducible. Prefer minimal diffs, zero visual change, and file-scoped edits.";
const user = `
Repo: ~/code/shayrdair-mvp
Snapshot: ${snapshotPath}
Reports: ${diffJsonPath}, ${coachBasePath}
Priorities: ${priorities}
Constraints: No destructive ops; keep visuals identical; no !important; minimal diffs.

<DIFF_JSON>
${JSON.stringify(diffJson).slice(0, 100000)}
</DIFF_JSON>

<COACH_BASE_MD>
${coachBase}
</COACH_BASE_MD>

<CSS_SAMPLE bytes="${cssBytes}" used="${Buffer.byteLength(cssSample)}">
${cssSample}
</CSS_SAMPLE>

Tasks:
1) Output “Top 5 highest-impact fixes” ranked. For each: why, exact selectors/paths, and a minimal diff code block.
2) Provide measurable acceptance checks we can verify by rerunning reports.
3) Emit a single “Cursor Handoff Block” that edits:
   - exports/overrides/stylesmith-overrides.css (primary)
   - exports/webflow-snapshot.css (only if trivially safe)
Keep it one page, bullet-y, no fluff.
`;

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const resp = await client.responses.create({
  model,
  temperature: 0.2,
  reasoning: { effort: "medium" },
  input: [{ role: "system", content: system }, { role: "user", content: user }]
});

const content = resp.output_text || "# ERROR: No content generated";
fs.mkdirSync(path.dirname(outMdPath), { recursive: true });
fs.writeFileSync(outMdPath, content, "utf8");
fs.writeFileSync(outJsonPath, JSON.stringify({
  model, cssBytes, usedBytes: Buffer.byteLength(cssSample),
  snapshotPath, diffJsonPath, coachBasePath, outMdPath,
  createdAt: new Date().toISOString()
}, null, 2), "utf8");

console.log("Wrote", outMdPath, "and", outJsonPath);
