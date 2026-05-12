#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/state.sh"
source "${SCRIPT_DIR}/../lib/config.sh"

# Test state init and add
state_add_skill "test-skill" "https://github.com/owner/repo/tree/main/skills/test" "/path/to/test" "main" "abc123"

result=$(state_get_skill "test-skill" | jq -r '.sha')
[[ "$result" == "abc123" ]] || { echo "FAIL: sha mismatch"; exit 1; }

# Test remove
state_remove_skill "test-skill"
result=$(state_get_skill "test-skill" || echo "null")
[[ "$result" == "null" ]] || { echo "FAIL: skill still exists"; exit 1; }

echo "PASS: state management"