#!/usr/bin/env bash
# State management

STATE_FILE="${HOME}/.local/share/skillsmcp/state.json"

state_init() {
    mkdir -p "$(dirname "$STATE_FILE")"
    if [[ ! -f "$STATE_FILE" ]]; then
        echo '{"skills":{}}' > "$STATE_FILE"
    fi
}

state_read() {
    state_init
    cat "$STATE_FILE"
}

state_write() {
    state_init
    echo "$1" > "$STATE_FILE"
}

state_add_skill() {
    local name="$1"
    local github_url="$2"
    local path="$3"
    local branch="$4"
    local sha="$5"
    local installedAt="$(date +%s)"

    state_init
    local tmp=$(mktemp)
    jq ".skills[\"$name\"] = {\"githubUrl\":\"$github_url\",\"path\":\"$path\",\"branch\":\"$branch\",\"sha\":\"$sha\",\"installedAt\":$installedAt}" "$STATE_FILE" > "$tmp"
    mv "$tmp" "$STATE_FILE"
}

state_remove_skill() {
    local name="$1"
    state_init
    local tmp=$(mktemp)
    jq "del(.skills[\"$name\"])" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

state_get_skill() {
    local name="$1"
    state_init
    jq -c ".skills[\"$name\"] // null" "$STATE_FILE"
}