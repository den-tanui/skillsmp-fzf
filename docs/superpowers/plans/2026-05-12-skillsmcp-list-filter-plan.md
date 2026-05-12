# Filter Toggle for `skillsmcp list` — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `Ctrl+T` keybinding to `skillsmcp list` that cycles between All/Local/Global filter modes.

**Architecture:** Add `--filter` flag to `generate-local-list` script. In `cmd_list`, track `FILTER_MODE` state, pass correct paths to script based on mode, update prompt dynamically, and cycle mode on `Ctrl+T`.

**Tech Stack:** Bash, fzf, AWK

---

## File Structure

| File | Change |
|------|--------|
| `lib/generate-local-list` | Modify: add `--filter` flag handling |
| `skillsmcp` | Modify: `cmd_list()` add toggle logic, keybinding, prompt |
| `docs/superpowers/plans/YYYY-MM-DD-filter-plan.md` | This file |

---

## Task 1: Add `--filter` flag to `generate-local-list`

**Files:**
- Modify: `lib/generate-local-list`

- [ ] **Step 1: Read current `generate-local-list`**

```bash
cat lib/generate-local-list
```

- [ ] **Step 2: Write updated `generate-local-list` with `--filter` flag**

```bash
#!/usr/bin/env bash
set -euo pipefail

use_ansi=false
filter_mode="all"
paths=()

for arg in "$@"; do
  case "$arg" in
    --ansi) use_ansi=true ;;
    --filter) filter_mode="$1"; shift ;;
    --filter=*) filter_mode="${arg#*=}" ;;
    -*) ;;
    *) paths+=("$arg") ;;
  esac
done

color_start=""
color_end=""
if [[ "$use_ansi" == "true" ]]; then
  color_start="\033[1;36m"
  color_end="\033[0m"
fi

for p in "${paths[@]}"; do
  if [[ -d "$p" ]]; then
    abs_p=$(cd "$p" 2>/dev/null && pwd || echo "$p")
    find "$abs_p" -maxdepth 2 -name "SKILL.md" 2>/dev/null
  fi
done | awk -v cs="$color_start" -v ce="$color_end" -v filter="$filter_mode" '
BEGIN { FS="/" }
!seen[$0]++ {
  abs_file = $0
  slug = $(NF-1)
  
  # Determine source: local if path contains .agents/skills
  is_local = (index(abs_file, ".agents/skills") > 0)
  
  # Skip based on filter mode
  if (filter == "local" && !is_local) next
  if (filter == "global" && is_local) next
  
  slug_fmt = slug
  gsub(/-/, " ", slug_fmt)
  n = split(slug_fmt, w, " ")
  name = ""
  for(i=1; i<=n; i++) name = name (i>1?" ":"") toupper(substr(w[i],1,1)) tolower(substr(w[i],2))
  
  printf "%s|%s%s%s\n", abs_file, cs, name, ce
}'
```

- [ ] **Step 3: Run test to verify it works**

```bash
chmod +x lib/generate-local-list
./lib/generate-local-list --ansi ./.agents/skills
./lib/generate-local-list --ansi --filter local ./.agents/skills
./lib/generate-local-list --ansi --filter global ~/.agents/skills ./.agents/skills
```

Expected: All three produce output (format: `path/to/SKILL.md|Skill Name`)

- [ ] **Step 4: Commit**

```bash
git add lib/generate-local-list
git commit -m "feat(generate-local-list): add --filter flag for local/global/all filtering"
```

---

## Task 2: Add filter toggle to `cmd_list`

**Files:**
- Modify: `skillsmcp` (lines ~194-255)

- [ ] **Step 1: Read current `cmd_list` function**

```bash
sed -n '193,255p' skillsmcp
```

- [ ] **Step 2: Write replacement for `cmd_list` function**

```bash
cmd_list() {
  # Handle help flag
  if [[ "${2:-}" == "--help" ]] || [[ "${2:-}" == "-h" ]]; then
    echo "Usage: skillsmcp list"
    echo ""
    echo "List installed skills with options to update or remove them."
    echo "Opens an interactive fzf interface."
    echo ""
    echo "Keybindings:"
    echo "  enter   - Copy skill to local project (.agents/skills)"
    echo "  ctrl+l  - Symlink skill to local project (.agents/skills)"
    echo "  ctrl+o  - Open in browser"
    echo "  ctrl+d  - Remove skill"
    echo "  ctrl+u  - Update skill"
    echo "  ctrl+t  - Toggle filter (All/Local/Global)"
    echo "  esc     - Exit"
    exit 0
  fi

  local filter_modes=("all" "local" "global")
  local filter_labels=("All" "Local" "Global")
  local filter_idx=0
  local toggle_file="/tmp/skillsmcp-list-toggle-$$"

  local paths=()
  paths+=("./.agents/skills")
  while read -r p; do
    [[ -n "$p" ]] && paths+=("$p")
  done <<< "$(config_get "skillPaths")"

  local skills=""

  while true; do
    local current_filter="${filter_modes[$filter_idx]}"
    local current_label="${filter_labels[$filter_idx]}"
    local prompt="${current_label} skills> "

    skills=$("$SCRIPT_DIR/lib/generate-local-list" --ansi --filter "$current_filter" "${paths[@]}")

    if [[ -z "$skills" ]]; then
      echo "No skills found in ${current_label} scope"
      exit 0
    fi

    rm -f "$toggle_file"

    local selected=$(echo "$skills" | fzf --ansi \
      --prompt="$prompt" \
      --delimiter="|" \
      --with-nth=2.. \
      --preview-window=right:60%:wrap \
      --preview="\"$SCRIPT_DIR/lib/preview\" --local {1}" \
      --expect=enter,ctrl-l,ctrl-o,ctrl-d,ctrl-u,ctrl-t,esc)

    local key=$(echo "$selected" | head -1)
    local choice=$(echo "$selected" | tail -1)

    # Toggle filter mode
    if [[ -f "$toggle_file" ]]; then
      rm -f "$toggle_file"
      filter_idx=$(( (filter_idx + 1) % 3 ))
      continue
    fi

    # Handle ESC or empty selection
    if [[ -z "$key" ]] || [[ "$key" == "esc" ]]; then
      echo "Exited"
      exit 0
    fi

    # Handle Enter key (may be empty string if Enter is default accept)
    if [[ -z "$key" ]]; then
      key="enter"
    fi

    # Execute action for selected key
    case "$key" in
      enter) copy_skill_local "$choice" ;;
      ctrl-l) symlink_skill_local "$choice" ;;
      ctrl-o) cmd_open_browser "$(echo "$choice" | cut -d"|" -f1)" ;;
      ctrl-d) remove_skill "$choice" ;;
      ctrl-u) update_skill "$choice" ;;
      ctrl-t) ;; # Handled above
    esac

    break
  done

  rm -f "$toggle_file"
}
```

- [ ] **Step 3: Add `ctrl+t` keybinding to fzf command**

Find this line in the new `cmd_list`:
```
      --expect=enter,ctrl-l,ctrl-o,ctrl-d,ctrl-u,esc)
```

Change to:
```
      --expect=enter,ctrl-l,ctrl-o,ctrl-d,ctrl-u,ctrl-t,esc)
```

Find this line:
```
      --bind="ctrl-t:execute-silent(touch $toggle_file)+abort" \
```

If not present, add it inside the fzf command before the closing `\` or add `ctrl-t` to the `--bind` chain:
```
      --bind="ctrl-t:execute-silent(touch $toggle_file)+abort" \
```

**Full fzf command should include:**
```
    local selected=$(echo "$skills" | fzf --ansi \
      --prompt="$prompt" \
      --delimiter="|" \
      --with-nth=2.. \
      --preview-window=right:60%:wrap \
      --preview="\"$SCRIPT_DIR/lib/preview\" --local {1}" \
      --expect=enter,ctrl-l,ctrl-o,ctrl-d,ctrl-u,ctrl-t,esc)
```

- [ ] **Step 4: Run test**

```bash
cd /home/projects/skillsmcp-fzf
chmod +x skillsmcp
# Test help output
./skillsmcp list --help | grep -A1 "ctrl+t"
# Expected: "  ctrl+t  - Toggle filter (All/Local/Global)"
```

- [ ] **Step 5: Commit**

```bash
git add skillsmcp
git commit -m "feat(cmd_list): add Ctrl+T filter toggle for All/Local/Global modes"
```

---

## Task 3: Integration Test

**Files:**
- Test: manual verification

- [ ] **Step 1: Test all three filter modes**

```bash
# Test all modes by simulating Ctrl+T presses
# Run in a subshell to avoid breaking current terminal
(
  # Mock fzf to just show what would happen
  echo "Testing filter modes..."
  
  # Test generate-local-list with all filters
  echo "=== All ==="
  ./lib/generate-local-list --ansi --filter all ./.agents/skills 2>/dev/null | head -3 || echo "(no local skills)"
  
  echo "=== Local ==="
  ./lib/generate-local-list --ansi --filter local ./.agents/skills 2>/dev/null | head -3 || echo "(no local skills)"
  
  echo "=== Global ==="
  ./lib/generate-local-list --ansi --filter global ~/.agents/skills ./.agents/skills 2>/dev/null | head -3 || echo "(no global skills)"
)
```

- [ ] **Step 2: Test prompt labels**

Verify the script outputs correct prompt labels for each mode by checking the code flow:
- Filter `all` → prompt `All skills> `
- Filter `local` → prompt `Local skills> `
- Filter `global` → prompt `Global skills> `

- [ ] **Step 3: Run existing tests**

```bash
cd /home/projects/skillsmcp-fzf
bats tests/ 2>/dev/null || echo "(bats not available or tests incomplete)"
```

---

## Self-Review Checklist

- [ ] `--filter` flag works with `local`, `global`, `all` values
- [ ] `generate-local-list` returns empty/no output for modes with no matching skills
- [ ] `Ctrl+T` cycles all three modes in order: all → local → global → all
- [ ] Prompt updates to show current filter mode
- [ ] Existing keybindings (enter, ctrl-l, ctrl-o, ctrl-d, ctrl-u) work unchanged
- [ ] Help text documents new `ctrl+t` binding
- [ ] Code handles empty results gracefully (shows message, exits cleanly)
- [ ] No placeholders or TODOs in implementation

---

**Plan complete.** To execute:

- **Subagent-Driven (recommended):** Each task above is self-contained. Dispatch `@fixer` per task.
- **Inline Execution:** Use `executing-plans` skill to work through tasks with checkpoints.