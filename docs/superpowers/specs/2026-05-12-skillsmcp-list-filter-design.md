# Filter Toggle for `skillsmcp list` — Design

## Overview

Add a `Ctrl+T` keybinding to `skillsmcp list` that toggles between three filter modes: **All**, **Local**, and **Global** skills.

## Filter Modes

| Mode | Scope |
|------|-------|
| `all` | Both local and global paths (default) |
| `local` | Only `./.agents/skills` |
| `global` | Only configured global paths from `skillPaths` |

## Changes

### `lib/generate-local-list`

Add `--filter {local|global|all}` flag (default: `all`).

```bash
# Example usage
./lib/generate-local-list --ansi --filter local ./.agents/skills
./lib/generate-local-list --ansi --filter global ~/.agents/skills
./lib/generate-local-list --ansi --filter all ./.agents/skills ~/.agents/skills
```

Behavior:
- `--filter local` — only scans `./.agents/skills`
- `--filter global` — only scans paths from `$SKILLSMCP_GLOBAL_PATHS` (space-separated env var)
- `--filter all` (default) — scans all provided paths

### `skillsmcp` — `cmd_list()`

**Keybinding:**
| Key | Action |
|-----|--------|
| `Ctrl+T` | Cycle filter: All → Local → Global → All |

**Prompt updates by mode:**
| Mode | Prompt |
|------|--------|
| `all` | `All skills> ` |
| `local` | `Local skills> ` |
| `global` | `Global skills> ` |

**Implementation:**
1. Set `FILTER_MODE=all` (default)
2. On `Ctrl+T`: cycle `all` → `local` → `global` → `all`
3. Update `generate-local-list` call to pass `--filter $FILTER_MODE`
4. For `local`: pass only `./.agents/skills`
5. For `global`: pass only the configured global paths
6. For `all`: pass all paths (existing behavior)

**Existing bindings unchanged:**
| Key | Action |
|-----|--------|
| `Enter` | Copy skill |
| `Ctrl+L` | Symlink skill |
| `Ctrl+O` | Open in browser |
| `Ctrl+D` | Remove skill |
| `Ctrl+U` | Update skill |
| `ESC` | Exit |

## Test Plan

- [ ] `Ctrl+T` cycles all three modes in order
- [ ] Prompt reflects current filter mode
- [ ] `all` shows both local and global skills
- [ ] `local` shows only `./.agents/skills`
- [ ] `global` shows only global paths
- [ ] Existing keybindings work in all modes
- [ ] `--help` lists new `Ctrl+T` binding