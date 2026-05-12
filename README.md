# skillsmcp-fzf

[![asciicast](https://asciinema.org/a/IU39QiDgwnEmomG8.svg)](https://asciinema.org/a/IU39QiDgwnEmomG8)

An interactive fzf-based tool for searching, previewing, and installing skills from [skillsmp.com](https://skillsmp.com).

## Features

- 🔍 Search skills from skillsmp.com API with fuzzy filtering
- 👀 Preview skill details including descriptions and metadata
- 🌐 Open skill GitHub repositories directly in browser
- 💾 Install skills locally or globally
- 📄 View skill documentation (SKILL.md files)
- 🔄 Navigate paginated results
- ⚡ Keyboard-driven interface for efficient workflow

## Installation

### Prerequisites

- [fzf](https://github.com/junegunn/fzf) - Interactive fuzzy finder
- [jq](https://stedolan.github.io/jq/) - JSON processor
- [curl](https://curl.se/) - For API requests
- Bash shell

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/skillsmcp-fzf.git
   cd skillsmcp-fzf
   ```

2. Make the scripts executable:
   ```bash
   chmod +x lib/generate-list lib/generate-local-list lib/preview
   chmod +x skillsmcp
   ```

3. Optionally add the directory to your PATH for global access:
   ```bash
   export PATH="$PATH:/path/to/skillsmcp-fzf"
   ```

## Usage

### Main Command

The primary way to use skillsmcp-fzf is through the main `skillsmcp` command:

```bash
./skillsmcp search [query] [--ansi]
./skillsmcp list
./skillsmcp config [command]
```

- `search`: Search and install skills from skillsmp.com (interactive fzf interface)
- `list`: List installed skills with options to update/remove them
- `config`: Manage configuration (skill paths, default install location)

### Search Online Skills

```bash
./skillsmcp search [query] [--ansi]
```

- `query`: Optional search term to filter skills
- `--ansi`: Enable colored output

### Search Local Skills

```bash
./lib/generate-local-list [directory1] [directory2] ...
```

- Specify directories to search for locally installed skills
- If no directories provided, searches in default skill paths

### Interactive Mode

The search command outputs formatted results that work with fzf for interactive selection:

```bash
./skillsmcp search "nmap" | fzf --ansi --header-lines=1
```

Then use these keybindings in the fzf interface:
- **Enter**: Preview the selected skill
- **Ctrl+O**: Open the skill's GitHub repository in browser
- **Ctrl+G**: Install skill globally
- **Ctrl+L**: Install skill locally
- **Ctrl+M**: Load more results (pagination)
- **Ctrl+F**: Switch between API and fzf search modes
- **ESC**: Exit

### Preview Script

To preview skill documentation directly:

```bash
./lib/preview --remote <github_url>
./lib/preview --local <path_to_SKILL.md>
```

## Configuration

Skills are installed to paths defined in your skillsmcp configuration:

- Default paths: `$HOME/.agents/skills` and `/home/opt/skills`
- Installation mode: `global` or `local` (configurable)

Configuration is managed through `lib/config.sh` which reads from `$HOME/.config/skillsmcp/config.json`.

## Project Structure

```
skillsmcp-fzf/
├── skillsmcp              # Main command for searching and installing skills
├── lib/
│   ├── generate-list      # Script for fetching skills from API
│   ├── generate-local-list # Script for listing locally installed skills
│   ├── preview            # Script for previewing skill documentation
│   ├── config.sh          # Configuration management
│   ├── github.sh          # GitHub API helpers
│   ├── api.sh             # skillsmp.com API helpers
│   ├── install.sh         # Installation utilities
│   └── state.sh           # State management utilities
├── tests/
│   ├── config_test.sh     # Tests for config functionality
│   ├── github_test.sh     # Tests for GitHub helpers
│   ├── api_test.sh        # Tests for API helpers
│   └── state_test.sh      # Tests for state management
└── NOTES.md               # Example usage and API response samples
```

## How It Works

1. **API Interaction**: The `lib/generate-list` script queries the skillsmp.com API for skills matching your search criteria
2. **Result Formatting**: Results are formatted as pipe-separated values for easy parsing
3. **fzf Integration**: Output is designed to work seamlessly with fzf's preview and action capabilities
4. **Skill Installation**: When a skill is selected, the system downloads the SKILL.md and associated files from GitHub
5. **Local Management**: The `lib/generate-local-list` script helps manage skills already installed on your system

## Development

### Running Tests

```bash
# Run all tests
./tests/config_test.sh
./tests/github_test.sh
./tests/api_test.sh
./tests/state_test.sh
```

### Adding Features

1. Modify the relevant library files in `lib/`
2. Add corresponding tests in `tests/`
3. Update the main scripts if needed
4. Ensure all tests pass before submitting changes

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [skillsmp.com](https://skillsmp.com) for providing the skills API
- [fzf](https://github.com/junegunn/fzf) for the excellent fuzzy finder
- All contributors to the skills ecosystem