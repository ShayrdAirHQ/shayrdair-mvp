'use strict';

// Load .env
require('dotenv').config();

const { writeFile, mkdir } = require('fs/promises');
const path = require('path');
const { fetch } = require('undici');

const SITE_ID = process.env.WEBFLOW_SITE_ID;
const TOKEN  = process.env.WEBFLOW_API_TOKEN;

if (!SITE_ID || !TOKEN) {
  console.error('Missing WEBFLOW_SITE_ID or WEBFLOW_API_TOKEN');
  process.exit(1);
}

const API_BASE = 'https://api.webflow.com';

async function api(p, query) {
  const url = new URL(`${API_BASE}${p}`);
  if (query) Object.entries(query).forEach(([k, v]) => url.searchParams.set(k, v));
  const res = await fetch(url, {
    headers: {
      Authorization: `Bearer ${TOKEN}`,
      accept: 'application/json'
    }
  });
  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(`${res.status} ${res.statusText} ${url.toString()} :: ${text}`);
  }
  return res.json();
}

async function listCollections(siteId) {
  const data = await api(`/v2/sites/${siteId}/collections`);
  return data.collections || data;
}

async function listItems(collectionId) {
  let items = [];
  let next;
  do {
    const data = await api(`/v2/collections/${collectionId}/items`, next ? { next } : undefined);
    items = items.concat(data.items || []);
    next = data.pagination?.next;
  } while (next);
  return items;
}

function slugify(s) {
  return String(s || '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '') || 'collection';
}

async function main() {
  const stamp  = new Date().toISOString().slice(0,10).replace(/-/g,''); // YYYYMMDD
  const outDir = path.join(process.cwd(), '../../apps/webflow-export/cms-dumps', stamp);
  await mkdir(outDir, { recursive: true });

  const collections = await listCollections(SITE_ID);

  for (const col of collections) {
    const items = await listItems(col.id);
    const name  = slugify(col.displayName || col.slug || col.id);
    const file  = path.join(outDir, `${name}.json`);
    await writeFile(file, JSON.stringify({
      siteId: SITE_ID,
      collection: { id: col.id, slug: col.slug, displayName: col.displayName },
      count: items.length,
      items
    }, null, 2));
    console.log(`Wrote ${file} (${items.length} items)`);
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
