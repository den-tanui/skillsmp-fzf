#!/usr/bin/env bash
# Skill installation

source "$(dirname "${BASH_SOURCE[0]}")/api.sh"
source "$(dirname "${BASH_SOURCE[0]}")/github.sh"
source "$(dirname "${BASH_SOURCE[0]}")/state.sh"

install_skill() {
    local github_url="$1"
    local target_dir="$2"
    local branch="${3:-main}"

    # Parse URL
    read owner repo remote_branch path <<< "$(github_parse_url "$github_url")"
    branch="${remote_branch:-$branch}"
    path="${path:-}"

    # Create target directory
    mkdir -p "$target_dir"

    # Download recursively
    download_recursive "$owner" "$repo" "$path" "$target_dir" "$branch"

    # Get SHA of SKILL.md and add to state
    if [[ -f "$target_dir/SKILL.md" ]]; then
        local sha=$(github_get_sha "$owner" "$repo" "${path}/SKILL.md" "$branch")
        local skill_name=$(basename "$target_dir")
        state_add_skill "$skill_name" "$github_url" "$target_dir" "$branch" "$sha"
    fi
}

download_recursive() {
    local owner="$1"
    local repo="$2"
    local remote_path="$3"
    local local_path="$4"
    local branch="$5"

    local items=$(github_list_dir "$owner" "$repo" "$remote_path" "$branch")

    echo "$items" | jq -c '.[]' 2>/dev/null | while read item; do
        local name=$(echo "$item" | jq -r '.name')
        local type=$(echo "$item" | jq -r '.type')
        local item_path=$(echo "$item" | jq -r '.path')

        if [[ "$type" == "file" ]]; then
            echo "Downloading: $item_path"
            github_fetch_raw "$owner" "$repo" "$item_path" "$branch" > "$local_path/$name"
        elif [[ "$type" == "dir" ]]; then
            mkdir -p "$local_path/$name"
            download_recursive "$owner" "$repo" "$item_path" "$local_path/$name" "$branch"
        fi
    done
}