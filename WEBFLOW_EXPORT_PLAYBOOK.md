# 🌐 Webflow Export Playbook

This playbook explains how to export builds from Webflow **and** capture CMS snapshots for review by ChatGPT, Windsurf, and Cursor using GitHub + Vercel.

---

## 🔄 Workflow Overview

1. Export **frontend code** from Webflow (`.zip`).
2. Optionally capture **CMS snapshots** (JSON data dumps).
3. Navigate to your repo root locally.
4. Run the export script → creates a unique branch, formats, pushes, and opens a PR.
5. GitHub Actions runs required checks:
   - ✅ `lint` → Prettier formatting + guardrail (`index.html` required)
   - ✅ `Vercel` → Deploys a live preview of the branch
   - ✅ `Vercel Preview Comments` → Adds preview URL in the PR
6. Review PR diffs (HTML/CSS/JS + CMS JSON) and the Vercel Preview with ChatGPT, Windsurf, and Cursor.
7. Once approved → **Squash and merge** → deploys to `main`.

---

## 📂 Step 1: Navigate to Repo Root

From your terminal:

```bash
cd ~/code/shayrdair-mvp
ls

