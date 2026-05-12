#!/usr/bin/env bash
set -e

source ../lib/github.sh

# Test parsing GitHub URL - should output: owner repo branch path
result=$(github_parse_url "https://github.com/BrownFineSecurity/iothackbot/tree/master/skills/nmap")
echo "$result" | grep -q "BrownFineSecurity iothackbot master skills/nmap" || { echo "FAIL: parsing"; exit 1; }

echo "PASS: GitHub parsing"
