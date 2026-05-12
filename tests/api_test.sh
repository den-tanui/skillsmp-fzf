#!/usr/bin/env bash
set -e

source ../lib/api.sh

# Test search returns JSON
result=$(api_search "nmap" 1 5 stars)
echo "$result" | jq -e '.skills' >/dev/null || { echo "FAIL: not valid JSON"; exit 1; }

# Test parsing
count=$(echo "$result" | jq '.skills | length')
[[ "$count" -gt 0 ]] || { echo "FAIL: no results"; exit 1; }

echo "PASS: API search"
