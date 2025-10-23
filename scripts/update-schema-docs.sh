#!/bin/bash
set -e

if [ -z "$DB_URL" ]; then
  echo "Error: DB_URL environment variable not set"
  exit 1
fi

echo "# ShayrdAir — Database Schema (Reference)" > db/schema/SCHEMA.md
echo "" >> db/schema/SCHEMA.md
echo "Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> db/schema/SCHEMA.md
echo "" >> db/schema/SCHEMA.md

psql "$DB_URL" -f db/sql/schema_markdown.sql -t -A >> db/schema/SCHEMA.md

echo "Schema documentation updated: db/schema/SCHEMA.md"
