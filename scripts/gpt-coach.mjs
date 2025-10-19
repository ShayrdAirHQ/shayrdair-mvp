import fs from "node:fs"; import path from "node:path"; import process from "node:process"; import { OpenAI } from "openai";
const fail=m=>{console.error("ERROR:",m);process.exit(1)}; const exists=p=>{try{fs.accessSync(p);return true}catch{return false}};
const args=new Map(process.argv.slice(2).map((a,i,arr)=>a.startsWith("--")?[a.replace(/^--/,""),arr[i+1]&&!arr[i+1].startsWith("--")?arr[i+1]:"true"]:null).filter(Boolean));
const snapshotPath=args.get("snapshot")||"exports/webflow-snapshot.css";
const diffJsonPath=args.get("diff")||"reports/diff.json";
const coachBasePath=args.get("base")||"reports/coach.md";
const outMdPath=args.get("out")||"reports/coach.gpt.md";
const outJsonPath=args.get("json")||"reports/coach.gpt.json";
const maxCssBytes=Number(args.get("maxCssBytes")||200000);
if(!process.env.OPENAI_API_KEY)fail("OPENAI_API_KEY not set");
if(!exists(snapshotPath))fail(`Snapshot not found: ${snapshotPath}`);
if(!exists(diffJsonPath))fail(`Diff JSON not found: ${diffJsonPath}`);
if(!exists(coachBasePath))fail(`Base coach report not found: ${coachBasePath}`);
const preferred=(process.env.COACH_MODEL||"gpt-5,gpt-4.1,gpt-4o,gpt-4o-mini").split(",").map(s=>s.trim()).filter(Boolean);
const cssRaw=fs.readFileSync(snapshotPath,"utf8"); const cssBytes=Buffer.byteLength(cssRaw);
let cssSample=cssRaw; if(cssBytes>maxCssBytes){const head=cssRaw.slice(0,Math.floor(maxCssBytes*0.6)); const tail=cssRaw.slice(-Math.floor(maxCssBytes*0.4)); cssSample=head+"\n/* ...CSS truncated for token limit... */\n"+tail;}
const diffJson=JSON.parse(fs.readFileSync(diffJsonPath,"utf8")); const coachBase=fs.readFileSync(coachBasePath,"utf8");
const system="You are a senior CSS/Webflow architect. Be concise, opinionated, reproducible. Prefer minimal diffs, zero visual change, and file-scoped edits.";
const user=`
Repo: ~/code/shayrdair-mvp
Snapshot: ${snapshotPath}
Reports: ${diffJsonPath}, ${coachBasePath}
Priorities: Tokenize repeated hex/colors/sizes → adopt rem (16px) → avoid !important → utility hygiene → spacing scale coherence.
Constraints: No destructive ops; keep visuals identical; minimal diffs.

<DIFF_JSON>
${JSON.stringify(diffJson).slice(0,100000)}
</DIFF_JSON>

<COACH_BASE_MD>
${coachBase}
</COACH_BASE_MD>

<CSS_SAMPLE bytes="${cssBytes}" used="${Buffer.byteLength(cssSample)}">
${cssSample}
</CSS_SAMPLE>

Tasks:
1) Output “Top 5 highest-impact fixes” ranked, with: why, exact selectors/paths, and minimal diff code blocks.
2) Provide measurable acceptance checks for the next StyleSmith run.
3) Emit one “Cursor Handoff Block” to edit:
   - exports/overrides/stylesmith-overrides.css (primary)
   - exports/webflow-snapshot.css (only if trivially safe).
Keep to one page, bullets, no fluff.
`.trim();
const client=new OpenAI({apiKey:process.env.OPENAI_API_KEY});
async function tryResponses(model,promptStr){return client.responses.create({model,input:promptStr})}
async function tryChat(model,sys,usr){return client.chat.completions.create({model,messages:[{role:"system",content:sys},{role:"user",content:usr}]})}
let content=null, chosenModel=null, lastErr=null;
for(const model of preferred){try{const r=await tryResponses(model,`${system}\n\n${user}`); content=r.output_text?.trim(); if(content){chosenModel=model; break}}
catch(e1){lastErr=e1; try{const c=await tryChat(model,system,user); content=(c.choices?.[0]?.message?.content||"").trim(); if(content){chosenModel=model; break}}catch(e2){lastErr=e2}}}
if(!content){console.error("Last error:",lastErr?.status||"",lastErr?.error??lastErr?.message); fail("All model attempts failed. Set COACH_MODEL to a single model you can access (e.g., gpt-4o).")}
fs.mkdirSync(path.dirname(outMdPath),{recursive:true}); fs.writeFileSync(outMdPath,content,"utf8");
fs.writeFileSync(outJsonPath,JSON.stringify({chosenModel,cssBytes,usedBytes:Buffer.byteLength(cssSample),snapshotPath,diffJsonPath,coachBasePath,outMdPath,createdAt:new Date().toISOString()},null,2),"utf8");
console.log("Wrote",outMdPath,"and",outJsonPath,"using model",chosenModel);
