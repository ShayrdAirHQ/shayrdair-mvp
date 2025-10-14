#!/usr/bin/env bash
set -euo pipefail
sed -E \
 -e 's/(sk-[A-Za-z0-9]{20,})/[REDACTED_API_KEY]/g' \
 -e 's/([A-Za-z0-9_]*SECRET[A-Za-z0-9_]*=)[^[:space:]]+/\1[REDACTED]/g' \
 -e 's/([A-Za-z0-9_]*API[_-]?KEY[A-Za-z0-9_]*=)[^[:space:]]+/\1[REDACTED]/g' \
 -e 's/([A-Za-z0-9_]*ACCESS[_-]?TOKEN[A-Za-z0-9_]*=)[^[:space:]]+/\1[REDACTED]/g'
