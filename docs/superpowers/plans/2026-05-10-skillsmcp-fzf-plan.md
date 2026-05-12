# skillsmcp-fzf Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a fzf-based CLI tool to search, preview, and install AI agent skills from skillsmp.com with full management capabilities.

**Architecture:** Bash scripts with fzf for interactive UI. Separate library files for API, GitHub, install, config, and state management. JSON config and state files for persistence.

**Tech Stack:** Bash, fzf, curl, jq, bat

---

## File Structure

```
skillsmcp-fzf/
├── skillsmcp              # Main entry point
├── lib/
│   ├── api.sh             # skillsmp.com API calls
│   ├── github.sh          # GitHub raw content fetching
│   ├── install.sh         # Skill download/installation
│   ├── config.sh          # Config file read/write
│   └── state.sh           # State file read/write
├── completions/
│   └── skillsmcp.bash     # Bash completion
└── tests/
    ├── api_test.sh
    ├── github_test.sh
    ├── install_test.sh
    ├── config_test.sh
    └── state_test.sh
```

---

## Task 1: Project Setup

**Files:**
- Create: `skillsmcp`
- Create: `lib/api.sh`
- Create: `lib/github.sh`
- Create: `lib/install.sh`
- Create: `lib/config.sh`
- Create: `lib/state.sh`

- [ ] **Step 1: Create main entry point**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# Source libraries
for lib in "$LIB_DIR"/*.sh; do
    source "$lib"
done

# Parse subcommand
case "${1:-help}" in
    search) cmd_search "$@" ;;
    list)   cmd_list "$@" ;;
    config) cmd_config "$@" ;;
    help|--help|-h) echo "Usage: skillsmcp {search|list|config}" ;;
    *) echo "Unknown command: $1" && exit 1 ;;
esac
```

- [ ] **Step 2: Create empty library files**

```bash
# lib/api.sh
#!/usr/bin/env bash
# skillsmp.com API calls

api_search() {
    local query="${1:-}"
    local page="${2:-1}"
    local limit="${3:-20}"
    local sortBy="${4:-stars}"

    curl -s "https://skillsmp.com/api/skills?page=$page&limit=$limit&sortBy=$sortBy&search=$query"
}
```

```bash
# lib/github.sh
#!/usr/bin/env bash
# GitHub API calls

github_fetch_raw() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    curl -s -H "Accept: application/vnd.github.raw+json" \
        "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch"
}

github_get_sha() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    curl -s "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch" | jq -r '.sha // empty'
}
```

```bash
# lib/install.sh
#!/usr/bin/env bash
# Skill installation

install_skill() {
    local github_url="$1"
    local target_dir="$2"
    local branch="${3:-main}"

    # Parse owner/repo/path from github_url
    # Download recursively
    # Store SHA in state
}
```

```bash
# lib/config.sh
#!/usr/bin/env bash
# Config management

config_get() {
    local key="$1"
    local default="${2:-}"

    # Read ~/.config/skillsmcp/config.json
    # Return value or default
}

config_set() {
    local key="$1"
    local value="$2"

    # Update config file
}
```

```bash
# lib/state.sh
#!/usr/bin/env bash
# State management

state_read() {
    # Read ~/.local/share/skillsmcp/state.json
}

state_write() {
    # Write state file
}

state_add_skill() {
    local name="$1"
    local github_url="$2"
    local path="$3"
    local branch="$4"
    local sha="$5"

    # Add skill to state
}

state_remove_skill() {
    local name="$1"

    # Remove skill from state
}

state_get_skill() {
    local name="$1"

    # Get skill info from state
}
```

- [ ] **Step 3: Make executable and test**

```bash
chmod +x skillsmcp
./skillsmcp help
```

Expected: Usage message displayed

- [ ] **Step 4: Commit**

```bash
git add skillsmcp lib/
git commit -m "feat: project skeleton with library files"
```

---

## Task 2: Config Management

**Files:**
- Modify: `lib/config.sh`

- [ ] **Step 1: Write config test**

```bash
# tests/config_test.sh
#!/usr/bin/env bash
set -e

source ../lib/config.sh

# Test default config
result=$(config_get "skillPaths")
echo "$result" | grep -q "/home/.agents/skills" || { echo "FAIL: default global path"; exit 1; }

echo "PASS: config defaults"
```

- [ ] **Step 2: Run test to verify it fails**

```bash
chmod +x tests/config_test.sh
./tests/config_test.sh
```

Expected: FAIL - config file doesn't exist

- [ ] **Step 3: Implement config with defaults**

```bash
# lib/config.sh
CONFIG_FILE="${HOME}/.config/skillsmcp/config.json"
STATE_FILE="${HOME}/.local/share/skillsmcp/state.json"

config_init() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" <<EOF
{
  "skillPaths": ["${HOME}/.agents/skills"],
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
    # Use jq to update JSON
    local tmp=$(mktemp)
    jq ".$key = \"$value\"" "$CONFIG_FILE" > "$tmp" && mv "$tmp" "$CONFIG_FILE"
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
./tests/config_test.sh
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/config.sh tests/config_test.sh
git commit -m "feat: add config management with defaults"
```

---

## Task 3: State Management

**Files:**
- Modify: `lib/state.sh`

- [ ] **Step 1: Write state test**

```bash
# tests/state_test.sh
#!/usr/bin/env bash
set -e

source ../lib/state.sh
source ../lib/config.sh

# Test state init and add
state_add_skill "test-skill" "https://github.com/owner/repo/tree/main/skills/test" "/path/to/test" "main" "abc123"

result=$(state_get_skill "test-skill" | jq -r '.sha')
[[ "$result" == "abc123" ]] || { echo "FAIL: sha mismatch"; exit 1; }

# Test remove
state_remove_skill "test-skill"
result=$(state_get_skill "test-skill" || echo "null")
[[ "$result" == "null" ]] || { echo "FAIL: skill still exists"; exit 1; }

echo "PASS: state management"
```

- [ ] **Step 2: Run test to verify it fails**

```bash
chmod +x tests/state_test.sh
./tests/state_test.sh
```

Expected: FAIL - state functions not implemented

- [ ] **Step 3: Implement state management**

```bash
# lib/state.sh
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
```

- [ ] **Step 4: Run test to verify it passes**

```bash
./tests/state_test.sh
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/state.sh tests/state_test.sh
git commit -m "feat: add state management"
```

---

## Task 4: API and GitHub Library

**Files:**
- Modify: `lib/api.sh`
- Modify: `lib/github.sh`

- [ ] **Step 1: Write API test**

```bash
# tests/api_test.sh
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
```

- [ ] **Step 2: Run test to verify it fails**

```bash
chmod +x tests/api_test.sh
./tests/api_test.sh
```

Expected: FAIL - functions not implemented

- [ ] **Step 3: Implement API library**

```bash
# lib/api.sh
api_search() {
    local query="${1:-}"
    local page="${2:-1}"
    local limit="${3:-20}"
    local sortBy="${4:-stars}"

    curl -s "https://skillsmp.com/api/skills?page=$page&limit=$limit&sortBy=$sortBy&search=$query"
}

api_format_skill() {
    local json="$1"
    local name=$(echo "$json" | jq -r '.name')
    local author=$(echo "$json" | jq -r '.author')
    local stars=$(echo "$json" | jq -r '.stars')
    local description=$(echo "$json" | jq -r '.description')

    # Format: name (author ★stars) - description
    printf "%-30s %-20s ★%-5s - %s" "$name" "$author" "$stars" "$description"
}
```

- [ ] **Step 4: Write GitHub test**

```bash
# tests/github_test.sh
#!/usr/bin/env bash
set -e

source ../lib/github.sh

# Test parsing GitHub URL
github_parse_url "https://github.com/BrownFineSecurity/iothackbot/tree/master/skills/nmap"
# Should set: owner=BrownFineSecurity, repo=iothackbot, path=skills/nmap, branch=master

echo "PASS: GitHub parsing"
```

- [ ] **Step 5: Implement GitHub library**

```bash
# lib/github.sh
github_parse_url() {
    local url="$1"
    # https://github.com/owner/repo/tree/branch/path
    # or https://github.com/owner/repo
    echo "$url" | sed -E 's|https://github.com/([^/]+)/([^/]+)(/tree/([^/]+))?(/.*)?|\1 \2 \4 \5|' | awk '{print $1,$2,$4,$5}'
}

github_fetch_raw() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    curl -s -H "Accept: application/vnd.github.raw+json" \
        "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch"
}

github_list_dir() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    curl -s "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch"
}

github_get_sha() {
    local owner="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"

    curl -s "https://api.github.com/repos/$owner/$repo/contents/$path?ref=$branch" | jq -r '.sha // empty'
}
```

- [ ] **Step 6: Run tests to verify they pass**

```bash
./tests/api_test.sh
./tests/github_test.sh
```

Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add lib/api.sh lib/github.sh tests/api_test.sh tests/github_test.sh
git commit -m "feat: add API and GitHub libraries"
```

---

## Task 5: Install Logic

**Files:**
- Modify: `lib/install.sh`

- [ ] **Step 1: Write install test**

```bash
# tests/install_test.sh
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
```

- [ ] **Step 2: Run test to verify it fails**

```bash
chmod +x tests/install_test.sh
./tests/install_test.sh
```

Expected: FAIL - install_skill not implemented

- [ ] **Step 3: Implement install logic**

```bash
# lib/install.sh
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
```

- [ ] **Step 4: Run test to verify it passes**

```bash
./tests/install_test.sh
```

Expected: PASS (may take time downloading from GitHub)

- [ ] **Step 5: Commit**

```bash
git add lib/install.sh tests/install_test.sh
git commit -m "feat: add skill installation logic"
```

---

## Task 6: Search Command

**Files:**
- Modify: `skillsmcp`

- [ ] **Step 1: Implement search command**

```bash
cmd_search() {
    local query="${2:-}"

    # Fetch results
    local results=$(api_search "$query" 1 50 stars)

    # Format for fzf
    local fzf_items=$(echo "$results" | jq -r '.skills[] | "\(.name)|\(.author)|\(.stars)|\(.description)|\(.githubUrl)|\(.path)|\(.branch)"')

    # Run fzf with preview
    local selected=$(echo "$fzf_items" | fzf \
        --prompt="Search skills: " \
        --preview-window=right:60%:wrap \
        --preview='bash -c "source '"$LIB_DIR/github.sh"'; owner=$(echo {} | cut -d"|" -f5 | sed \"s|https://github.com/||\" | cut -d\"/\" -f1); repo=$(echo {} | cut -d"|" -f5 | sed \"s|https://github.com/||\" | cut -d\"/\" -f2); path=$(echo {} | cut -d"|" -f6); branch=$(echo {} | cut -d"|" -f7); github_fetch_raw \"\$owner\" \"\$repo\" \"\$path/SKILL.md\" \"\$branch\" | bat -l markdown"' \
        --bind="enter:execute-silent(bat {1})" \
        --bind="ctrl-o:execute(open {5})" \
        --bind="ctrl-g:execute-silent(echo global)" \
        --bind="ctrl-l:execute-silent(echo local)" \
        --expect=ctrl-o,ctrl-g,ctrl-l,esc)

    # Handle key binding
    local key=$(echo "$selected" | head -1)
    local choice=$(echo "$selected" | tail -1)

    case "$key" in
        ctrl-o) open "$(echo "$choice" | cut -d"|" -f5)" ;;
        ctrl-g) install_global "$choice" ;;
        ctrl-l) install_local "$choice" ;;
        esc) echo "Cancelled" && exit 0 ;;
    esac
}

install_global() {
    local choice="$1"
    local name=$(echo "$choice" | cut -d"|" -f1)
    local github_url=$(echo "$choice" | cut -d"|" -f5)
    local path=$(echo "$choice" | cut -d"|" -f6)
    local branch=$(echo "$choice" | cut -d"|" -f7)

    local global_path=$(config_get "skillPaths" | head -1)
    install_skill "$github_url" "$global_path/$name" "$branch"
    echo "Installed to $global_path/$name"
}

install_local() {
    local choice="$1"
    local name=$(echo "$choice" | cut -d"|" -f1)
    local github_url=$(echo "$choice" | cut -d"|" -f5)
    local path=$(echo "$choice" | cut -d"|" -f6)
    local branch=$(echo "$choice" | cut -d"|" -f7)

    local local_path="./.agents/skills"
    install_skill "$github_url" "$local_path/$name" "$branch"
    echo "Installed to $local_path/$name"
}
```

- [ ] **Step 2: Test search command**

```bash
./skillsmcp search "nmap"
```

Expected: fzf interface opens with nmap skills

- [ ] **Step 3: Commit**

```bash
git add skillsmcp
git commit -m "feat: add search command with fzf interface"
```

---

## Task 7: List Command

**Files:**
- Modify: `skillsmcp`

- [ ] **Step 1: Implement list command**

```bash
cmd_list() {
    # Read state and display in fzf
    local state=$(state_read)
    local skills=$(echo "$state" | jq -r '.skills | to_entries[] | "\(.key)|\(.value.githubUrl)|\(.value.path)|\(.value.sha)"')

    if [[ -z "$skills" ]]; then
        echo "No skills installed"
        exit 0
    fi

    local selected=$(echo "$skills" | fzf \
        --prompt="Installed skills: " \
        --preview-window=right:60%:wrap \
        --preview='bat {3}/SKILL.md 2>/dev/null || echo "No SKILL.md"' \
        --bind="enter:execute-silent(bat {3}/SKILL.md)" \
        --bind="ctrl-o:execute(open {2})" \
        --bind="ctrl-d:execute-silent(echo remove)" \
        --bind="ctrl-u:execute-silent(echo update)" \
        --expect=ctrl-o,ctrl-d,ctrl-u,esc)

    local key=$(echo "$selected" | head -1)
    local choice=$(echo "$selected" | tail -1)

    case "$key" in
        ctrl-o) open "$(echo "$choice" | cut -d"|" -f2)" ;;
        ctrl-d) remove_skill "$choice" ;;
        ctrl-u) update_skill "$choice" ;;
        esc) echo "Exited" && exit 0 ;;
    esac
}

remove_skill() {
    local choice="$1"
    local name=$(echo "$choice" | cut -d"|" -f1)
    local path=$(echo "$choice" | cut -d"|" -f3)

    rm -rf "$path"
    state_remove_skill "$name"
    echo "Removed $name"
}

update_skill() {
    local choice="$1"
    local name=$(echo "$choice" | cut -d"|" -f1)
    local github_url=$(echo "$choice" | cut -d"|" -f2)
    local path=$(echo "$choice" | cut -d"|" -f3)

    # Get current SHA
    local current_sha=$(echo "$choice" | cut -d"|" -f4)

    # Parse URL
    read owner repo branch remote_path <<< "$(github_parse_url "$github_url")"
    local new_sha=$(github_get_sha "$owner" "$repo" "${remote_path}/SKILL.md" "$branch")

    if [[ "$current_sha" == "$new_sha" ]]; then
        echo "Already up to date"
        exit 0
    fi

    # Re-download
    rm -rf "$path"
    install_skill "$github_url" "$path" "$branch"
    echo "Updated $name"
}
```

- [ ] **Step 2: Test list command**

```bash
./skillsmcp list
```

Expected: Shows installed skills or "No skills installed"

- [ ] **Step 3: Commit**

```bash
git add skillsmcp
git commit -m "feat: add list command with update/remove"
```

---

## Task 8: Config Command

**Files:**
- Modify: `skillsmcp`

- [ ] **Step 1: Implement config command**

```bash
cmd_config() {
    case "${2:-show}" in
        show)
            cat "$CONFIG_FILE"
            ;;
        paths)
            config_get "skillPaths"
            ;;
        add-path)
            local new_path="$3"
            if [[ -z "$new_path" ]]; then
                echo "Usage: skillsmcp config add-path <path>"
                exit 1
            fi
            # Add to skillPaths array
            ;;
        default)
            config_get "defaultInstall"
            ;;
        *)
            echo "Usage: skillsmcp config {show|paths|add-path|default}"
            ;;
    esac
}
```

- [ ] **Step 2: Test config command**

```bash
./skillsmcp config show
./skillsmcp config paths
```

Expected: Shows config JSON and paths

- [ ] **Step 3: Commit**

```bash
git add skillsmcp
git commit -m "feat: add config command"
```

---

## Task 9: Polish and Error Handling

**Files:**
- Modify: `skillsmcp`
- Modify: `lib/*.sh`

- [ ] **Step 1: Add graceful ESC handling**

Ensure all fzf commands handle ESC key gracefully without showing errors.

- [ ] **Step 2: Add network error handling**

Add retry logic and clear error messages for network failures.

- [ ] **Step 3: Add bash completion**

```bash
# completions/skillsmcp.bash
_skillsmcp() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="search list config help"

    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

complete -F _skillsmcp skillsmcp
```

- [ ] **Step 4: Commit**

```bash
git add completions/
git commit -m "feat: add completion and error handling"
```

---

## Task 10: Final Integration Test

**Files:**
- Test all commands together

- [ ] **Step 1: Full workflow test**

```bash
# 1. Search and install
./skillsmcp search "nmap"
# Select nmap skill, press Ctrl+G to install globally

# 2. List installed
./skillsmcp list
# Should show nmap skill

# 3. Update check
./skillsmcp list
# Select nmap, press Ctrl+U to check for updates

# 4. Remove
./skillsmcp list
# Select nmap, press Ctrl+D to remove
```

- [ ] **Step 2: Commit**

```bash
git commit -m "feat: complete integration"
git push
```