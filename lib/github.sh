#!/usr/bin/env bash
# GitHub API calls

github_parse_url() {
    local url="$1"
    # https://github.com/owner/repo/tree/branch/path
    # or https://github.com/owner/repo
    local parsed=$(echo "$url" | sed -E 's|https://github.com/([^/]+)/([^/]+)(/tree/([^/]+))?(/.*)?|\1 \2 \4 \5|')
    echo "$parsed" | awk '{
        owner=$1; repo=$2; branch=$3; path=$4;
        if (path != "") sub("^/", "", path);
        print owner, repo, branch, path
    }'
}

_github_curl() {
    local token
    token=$(get_github_token 2>/dev/null || echo "${GITHUB_TOKEN:-}")
    
    local auth_args=()
    if [[ -n "$token" ]]; then
        auth_args=("-H" "Authorization: token $token")
    fi
    
    curl_retry "${auth_args[@]}" "$@"
}

github_fetch_raw() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    _github_curl -H "Accept: application/vnd.github.raw+json" \
        "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch"
}

github_list_dir() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    _github_curl "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch"
}

github_get_sha() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    _github_curl "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch" | jq -r '.sha // empty'
}
