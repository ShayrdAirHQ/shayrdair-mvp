# 🌐 Webflow Export Playbook

This playbook explains how to export a build from Webflow and get it reviewed by ChatGPT, Windsurf, and Cursor using our GitHub + Vercel workflow.

---

## 🔄 Workflow Overview
1. Export code from Webflow (`.zip`).
2. Navigate to your repo root locally.
3. Run the export script → creates a timestamped branch, formats, pushes, and opens a PR.
4. GitHub Actions runs required checks:
   - ✅ `lint` → Prettier formatting + guardrail (requires `index.html`)
   - ✅ `Vercel` → Deploys a live preview of the branch
   - ✅ `Vercel Preview Comments` → Adds preview URL to the PR
5. Review the PR diffs + live preview with ChatGPT, Windsurf, and Cursor.
6. Once approved → **Squash and merge** → deploys to `main`.

---

## 📂 Step 1: Navigate to Repo Root
From your terminal:

```bash
cd ~/code/shayrdair-mvp
ls

