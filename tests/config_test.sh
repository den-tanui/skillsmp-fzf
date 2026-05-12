#!/usr/bin/env bash
set -e

source ../lib/config.sh

# Test default config - global path should contain .agents/skills
result=$(config_get "skillPaths")
echo "$result" | grep -q "\.agents/skills" || { echo "FAIL: default global path"; exit 1; }

# Test defaultInstall returns either "global" or "local" (depends on existing config)
result=$(config_get "defaultInstall")
[[ "$result" == "global" ]] || [[ "$result" == "local" ]] || { echo "FAIL: default install"; exit 1; }

echo "PASS: config defaults"
