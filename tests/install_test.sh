#!/usr/bin/env bash
set -e

source ../lib/install.sh
source ../lib/github.sh
source ../lib/state.sh

# Test download skill to temp dir
tmpdir=$(mktemp -d)
install_skill "https://github.com/BrownFineSecurity/iothackbot/tree/master/skills/nmap" "$tmpdir/nmap" "main"

[[ -f "$tmpdir/nmap/SKILL.md" ]] || { echo "FAIL: SKILL.md not downloaded"; exit 1; }

rm -rf "$tmpdir"
echo "PASS: install skill"