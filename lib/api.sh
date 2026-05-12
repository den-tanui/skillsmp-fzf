#!/usr/bin/env bash
# skillsmp.com API calls

# Retry wrapper for network calls
curl_retry() {
    local max_attempts=3
    local attempt=1
    local delay=1
    
    while [[ $attempt -le $max_attempts ]]; do
        if curl -s --fail "$@" > /dev/null 2>&1; then
            curl -s "$@"
            return 0
        fi
        echo "Attempt $attempt/$max_attempts failed, retrying..." >&2
        sleep $delay
        attempt=$((attempt + 1))
        delay=$((delay * 2))
    done
    echo "Failed after $max_attempts attempts" >&2
    return 1
}

api_search() {
    local query="${1:-}"
    local page="${2:-1}"
    local limit="${3:-20}"
    local sortBy="${4:-stars}"

    curl_retry "https://skillsmp.com/api/skills?page=$page&limit=$limit&sortBy=$sortBy&search=$query"
}

api_format_skill() {
    local json="$1"
    local name=$(echo "$json" | jq -r '.name')
    local author=$(echo "$json" | jq -r '.author')
    local stars=$(echo "$json" | jq -r '.stars')
    local description=$(echo "$json" | jq -r '.description')

    printf "%-30s %-20s ★%-5s - %s" "$name" "$author" "$stars" "$description"
}
