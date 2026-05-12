# skillsmcp-fzf Design Specification

## Overview

A fzf-based CLI tool to search, preview, and install AI agent skills from skillsmp.com with full management capabilities.

## CLI Structure

```
skillsmcp search    # Search and install skills (main interactive mode)
skillsmcp list      # List/manage installed skills (update/remove)
skillsmcp config   # Show/edit configuration
```

## Keybindings

### Search Mode

| Key | Action |
|-----|--------|
| `Enter` | Preview SKILL.md with bat |
| `Ctrl+O` | Open GitHub repo in browser |
| `Ctrl+G` | Install to global directory |
| `Ctrl+L` | Install to project-local directory |
| `ESC` | Graceful exit (clear message, no error) |

### List Mode

| Key | Action |
|-----|--------|
| `Enter` | Preview installed SKILL.md with bat |
| `Ctrl+D` | Remove selected skill (delete directory) |
| `Ctrl+U` | Update selected skill (re-download from GitHub) |
| `Ctrl+O` | Open GitHub repo in browser |
| `ESC` | Graceful exit |

## Data Flow

1. **Search**: Call skillsmp.com API → parse JSON → display in fzf
2. **Preview**: Fetch SKILL.md via GitHub API → show in fzf preview window using bat
3. **Install**: Download skill files recursively to target directory
4. **List**: Read state file → display installed skills in fzf
5. **Update**: Compare SHA → re-download if changed
6. **Remove**: Delete skill directory → update state file

## State File

Location: `~/.local/share/skillsmcp/state.json`

```json
{
  "skills": {
    "nmap": {
      "githubUrl": "https://github.com/BrownFineSecurity/iothackbot/tree/master/skills/nmap",
      "path": "/home/.agents/skills/nmap",
      "branch": "main",
      "installedAt": 1777523864,
      "sha": "abc123..."
    }
  }
}
```

## Config File

Location: `~/.config/skillsmcp/config.json`

```json
{
  "skillPaths": [
    "/home/.agents/skills",
    "/home/projects/myproject/.agents/skills"
  ],
  "defaultInstall": "global"
}
```

Default global path: `~/.agents/skills/`
Default project path: `./.agents/skills/`

## Update Detection

- Store current Git commit SHA when installing (fetch via GitHub API)
- On update: fetch latest SHA from GitHub API → compare → re-download if different

## Components

| Component | Purpose |
|-----------|---------|
| `skillsmcp` | Main entry point, handles subcommands |
| `lib/api.sh` | skillsmp.com API calls |
| `lib/github.sh` | GitHub raw content fetching |
| `lib/install.sh` | Skill download/installation logic |
| `lib/config.sh` | User preferences (locations, defaults) |
| `lib/state.sh` | State file read/write |

## Error Handling

- Network failures: Show error, allow retry
- Invalid skill format: Skip with warning
- Permission errors: Clear message with suggestion
- Missing state/config: Create with defaults

## Testing

- Mock API responses for offline testing
- Unit tests for each component