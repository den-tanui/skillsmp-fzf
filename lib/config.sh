#!/usr/bin/env bash
# Config management

CONFIG_FILE="${HOME}/.config/skillsmcp/config.json"

config_init() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" <<EOF
{
  "skillPaths": ["${HOME}/.agents/skills", "/home/opt/skills"],
  "defaultInstall": "global"
}
EOF
    fi
}

config_get() {
    local key="$1"
    local default="${2:-}"
    config_init
    case "$key" in
        skillPaths) jq -r '.skillPaths[]' "$CONFIG_FILE" 2>/dev/null || echo "$default" ;;
        defaultInstall) jq -r '.defaultInstall' "$CONFIG_FILE" 2>/dev/null || echo "$default" ;;
        *) echo "$default" ;;
    esac
}

config_set() {
    local key="$1"
    local value="$2"
    config_init
    local tmp=$(mktemp)
    jq ".$key = \"$value\"" "$CONFIG_FILE" > "$tmp" && mv "$tmp" "$CONFIG_FILE"
}

# Get GitHub token from config or env var
get_github_token() {
    # Check env var first
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        echo "$GITHUB_TOKEN"
        return
    fi
    # Check config file
    config_init
    jq -r '.githubToken // empty' "$CONFIG_FILE" 2>/dev/null
}
