# description

A fzf script to search,preview and install skills from skillsmp.com

# features

- curl '<https://skillsmp.com/api/skills?page=1&limit=12&sortBy=stars&search=nmap>'
- results:

```json
    {
  "skills": [
    {
      "id": "wgpsec-aboutsecurity-skills-tool-nmap-scan-skill-md",
      "name": "nmap-scan",
      "author": "wgpsec",
      "authorAvatar": "https://avatars.githubusercontent.com/u/20661677?v=4",
      "description": "使用 nmap 进行端口扫描和服务识别。当需要对目标进行精细端口扫描、服务版本探测、操作系统指纹识别、NSE 脚本漏洞扫描时使用。nmap 是最经典的网络扫描器，支持 SYN/TCP/UDP/ACK 等
多种扫描模式，内置 600+ NSE 脚本。任何涉及端口扫描、服务识别、漏洞脚本扫描、操作系统指纹的场景都应使用此技能。速度不如 naabu，但功能远超 naabu",
      "githubUrl": "https://github.com/wgpsec/AboutSecurity/tree/master/skills/tool/nmap-scan",
      "stars": 1241,
      "forks": 208,
      "updatedAt": "1777022804",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "brownfinesecurity-iothackbot-skills-nmap-skill-md",
      "name": "nmap",
      "author": "BrownFineSecurity",
      "authorAvatar": "https://avatars.githubusercontent.com/u/175156966?v=4",
      "description": "Professional network reconnaissance and port scanning using nmap. Supports various scan types (quick, full, UDP, stealth), service detection, vulnerability scanning, and N
SE scripts. Use when you need to enumerate network services, detect versions, or perform network reconnaissance.",
      "githubUrl": "https://github.com/BrownFineSecurity/iothackbot/tree/master/skills/nmap",
      "stars": 747,
      "forks": 113,
      "updatedAt": "1766554408",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "automateyournetwork-netclaw-workspace-skills-nmap-scan-management-skill-md",
      "name": "nmap-scan-management",
      "author": "automateyournetwork",
      "authorAvatar": "https://avatars.githubusercontent.com/u/44117002?u=47cc12572e97e5a83026c4682591555eb854f540&v=4",
      "description": "Custom nmap scans with arbitrary flags, plus scan history retrieval and management. Use when running nmap with custom flags, reviewing past scan results, comparing before/
after scans, or retrieving a previous scan by ID",
      "githubUrl": "https://github.com/automateyournetwork/netclaw/tree/main/workspace/skills/nmap-scan-management",
      "stars": 474,
      "forks": 131,
      "updatedAt": "1776551870",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "automateyournetwork-netclaw-workspace-skills-nmap-service-detection-skill-md",
      "name": "nmap-service-detection",
      "author": "automateyournetwork",
      "authorAvatar": "https://avatars.githubusercontent.com/u/44117002?u=47cc12572e97e5a83026c4682591555eb854f540&v=4",
      "description": "Service fingerprinting, OS detection, NSE script execution, and vulnerability scanning using nmap MCP. Use when identifying services on open ports, fingerprinting OS versi
ons, running NSE scripts for SSL or SMB checks, or scanning for known CVEs and vulnerabilities",
      "githubUrl": "https://github.com/automateyournetwork/netclaw/tree/main/workspace/skills/nmap-service-detection",
      "stars": 474,
      "forks": 131,
      "updatedAt": "1776551870",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "automateyournetwork-netclaw-workspace-skills-nmap-network-scan-skill-md",
      "name": "nmap-network-scan",
      "author": "automateyournetwork",
      "authorAvatar": "https://avatars.githubusercontent.com/u/44117002?u=47cc12572e97e5a83026c4682591555eb854f540&v=4",
      "description": "Host discovery and port scanning using nmap — ICMP/ARP host discovery, SYN/TCP/UDP port scanning with scope enforcement and audit logging. Use when discovering live hosts
on a subnet, scanning for open ports, verifying firewall rules, or doing pre/post-change port scans",
      "githubUrl": "https://github.com/automateyournetwork/netclaw/tree/main/workspace/skills/nmap-network-scan",
      "stars": 474,
      "forks": 131,
      "updatedAt": "1776551870",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "commonhuman-lab-nyxstrike-skills-nmap-recon-skill-md",
      "name": "nmap-recon",
      "author": "CommonHuman-Lab",
      "authorAvatar": "https://avatars.githubusercontent.com/u/233701618?v=4",
      "description": "Network reconnaissance workflow using nmap, masscan, and rustscan via NyxStrike tools",
      "githubUrl": "https://github.com/CommonHuman-Lab/nyxstrike/tree/master/skills/nmap-recon",
      "stars": 85,
      "forks": 22,
      "updatedAt": "1775763953",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "sneakerhax-containers-github-skills-nmap-skill-md",
      "name": "nmap",
      "author": "sneakerhax",
      "authorAvatar": "https://avatars.githubusercontent.com/u/8846726?u=2afbf2bb513bf0ef20d92c7454f3abcd81c88708&v=4",
      "description": "Run Nmap scans in Docker for a provided host, IP, or CIDR target.",
      "githubUrl": "https://github.com/sneakerhax/Containers/tree/main/.github/skills/nmap",
      "stars": 76,
      "forks": 9,
      "updatedAt": "1774460506",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "theneoai-awesome-skills-skills-tool-security-nmap-expert-skill-md",
      "name": "nmap-expert",
      "author": "theneoai",
      "authorAvatar": "https://avatars.githubusercontent.com/u/261626247?u=ec141f77ac86ebd0ecbd6a01425f281cfce5a2ce&v=4",
      "description": "Expert-level Nmap skill for network reconnaissance, port scanning, service detection, and security assessment. Triggers: 'Nmap', '网络扫描', '端口扫描', 'NSE脚本'. Works w
ith: Claude Code, Codex, OpenCode, Cursor, Cline, OpenClaw, Kimi.",
      "githubUrl": "https://github.com/theneoai/awesome-skills/tree/main/skills/tool/security/nmap-expert",
      "stars": 61,
      "forks": 24,
      "updatedAt": "1777523864",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "iammm0-secbot-skills-base-nmap-usage-skill-md",
      "name": "nmap-usage",
      "author": "iammm0",
      "authorAvatar": "https://avatars.githubusercontent.com/u/145631324?u=1a51371d6b04f1f0e3978ab5880371ce4bdb41c9&v=4",
      "description": "Professional nmap scanning techniques and optimization for penetration testing.\nUse this skill when you need to perform network reconnaissance, port scanning,\nor service
 enumeration during authorized security assessments.",
      "githubUrl": "https://github.com/iammm0/secbot/tree/npm-release/skills/base/nmap-usage",
      "stars": 60,
      "forks": 12,
      "updatedAt": "1770817299",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "terminalskills-skills-skills-nmap-recon-skill-md",
      "name": "nmap-recon",
      "author": "TerminalSkills",
      "authorAvatar": "https://avatars.githubusercontent.com/u/258481093?v=4",
      "description": "Perform network reconnaissance with Nmap. Use when a user asks to scan networks, discover hosts and services, detect OS versions, find open ports, enumerate service versio
ns, or perform initial reconnaissance for a penetration test.",
      "githubUrl": "https://github.com/TerminalSkills/skills/tree/main/skills/nmap-recon",
      "stars": 40,
      "forks": 4,
      "updatedAt": "1771973934",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "faberlens-hardened-skills-skills-nmap-pentest-scans-hardened-skill-md",
      "name": "nmap-pentest-scans-hardened",
      "author": "faberlens",
      "authorAvatar": "https://avatars.githubusercontent.com/u/263505617?v=4",
      "description": "Plan and orchestrate authorized Nmap host discovery, port and service enumeration, NSE profiling, and reporting artifacts for in-scope targets.",
      "githubUrl": "https://github.com/faberlens/hardened-skills/tree/main/skills/nmap-pentest-scans-hardened",
      "stars": 23,
      "forks": 1,
      "updatedAt": "1776793960",
      "path": "SKILL.md",
      "branch": "main"
    },
    {
      "id": "0x-professor-agent-skills-hub-skills-nmap-pentest-scans-skill-md",
      "name": "nmap-pentest-scans",
      "author": "0x-Professor",
      "authorAvatar": "https://avatars.githubusercontent.com/u/160357695?v=4",
      "description": "Plan and orchestrate authorized Nmap host discovery, port and service enumeration, NSE profiling, and reporting artifacts for in-scope targets.",
      "githubUrl": "https://github.com/0x-Professor/Agent-Skills-Hub/tree/main/skills/nmap-pentest-scans",
      "stars": 8,
      "forks": 2,
      "updatedAt": "1772147019",
      "path": "SKILL.md",
      "branch": "main"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 12,
    "total": 206,
    "totalPages": 2,
    "hasNext": true,
    "hasPrev": false,
    "totalIsExact": false
  },
  "filters": {
    "search": "nmap",
    "sortBy": "stars"
  }
}
```

-display: formatted name (i.e nmap-pentest-scans becomes Nmap Pentest Scans) - description
-preview window fetches the SKILL.md from githuburl+path eg
curl -s "<https://api.github.com/repos/kepano/obsidian-skills/contents/skills/obsidian-markdown/SKILL.md>" \
 -H "Accept: application/vnd.github.raw+json"
to get raw markdown

- List all files in a directory:
  curl -s "<https://api.github.com/repos/kepano/obsidian-skills/contents/skills/obsidian-markdown>" \
   | jq -r '.[].name'
  This helps us to find other files eg in references/
- example of downloading SKILL.md plus the references:
  download_skill() {
  local owner="kepano"
  local repo="obsidian-skills"
  local remote_path="$1"
  local local_dir="$2"

  # Create root directory

  mkdir -p "$local_dir"
  download_recursive() {
    local remote="$1"
    local local="$2"
    local items=$(curl -s "<https://api.github.com/repos/$owner/$repo/contents/$remote>")
      echo "$items" | jq -c '.[]' 2>/dev/null | while read item; do
        local name=$(echo "$item" | jq -r '.name')
        local type=$(echo "$item" | jq -r '.type')
        if [ "$type" = "file" ]; then
          echo "Downloading: $remote/$name"
          curl -s -H "Accept: application/vnd.github.raw+json" \
            "<https://api.github.com/repos/$owner/$repo/contents/$remote/$name>" \
            | base64 -d > "$local/$name"
        elif [ "$type" = "dir" ]; then
          mkdir -p "$local/$name"
          download_recursive "$remote/$name" "$local/$name"
        fi
      done
  }
  download_recursive "$remote_path" "$local_dir"
  }

# Usage

download_skill "skills/obsidian-markdown" "./obsidian-markdown"

- when installing a skill, download all the files to a directory named after the skill eg obsidian-markdown
