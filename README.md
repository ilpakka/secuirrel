![Secuirrel](inc/logo_h1.png)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) ![Salt](https://img.shields.io/badge/Miniprojekti-h6-red) ![By](https://img.shields.io/badge/creators-ilpakka_and_hneryi-black)

# Secuirrel - Automated CTF SecOps Workstation Setup with SaltStack

This project provides a SaltStack configuration to quickly and repeatably set up Kali/Debian/Ubuntu Linux installations into fully-equipped CTF (Capture The Flag)/SecOps rigs. The goal is to automate the installation of security tools, forensics applications, and exploitation frameworks used in CTF competitions and security research.

Since the entire setup is version-controlled, tracking changes and reverting to previous configurations is straightforward.

## Goals and Features

The main objective is to create a flexible and automated way to configure CTF workstations with specialized toolsets.

*   **🚀 Fast Deployment:** Transform a clean Linux installation into a CTF-ready machine with a single command.
*   **🔁 Reproducibility:** Every installation is identical, eliminating configuration drift and the "it works on my machine" problem.
*   **🛠️ Modularity:** Base utilities, specialized tools, and user-specific configurations are separated into manageable state files organized by CTF category.
*   **👥 User Profiles:** Apply different sets of tools for different users or specializations (e.g., web exploitation, binary exploitation, forensics).
*   **✅ Idempotency:** Salt states can be applied multiple times safely; only necessary changes are made.
*   **🔧 Centralized Management:** Keep all tool configurations, package definitions, and setup scripts in one Git repository.

## Project Structure

```
salt/
├── top.sls                 # Master orchestration file
└── ctf_box/
    ├── init.sls            # Main orchestrator with pillar-based logic
    ├── tools.sls           # Universal base tools (vim, tmux, git, etc.)
    │
    ├── cracking/           # Password cracking tools
    │   ├── cracking.sls
    │   └── init.sls
    │
    ├── forensics/          # Forensics & reverse engineering tools
    │   ├── binwalk.sls     # Binwalk v2 (apt) & v3 (cargo)
    │   ├── forensics.sls
    │   └── init.sls
    │
    ├── reverse/            # Reverse engineering & binary analysis
    │   ├── ghidra.sls      # NSA Ghidra + JDK 21
    │   ├── init.sls
    │   └── pwndbg.sls      # GDB plugin with official installer
    │
    ├── web/                # Web exploitation tools
    │   ├── init.sls
    │   └── web.sls
    │
    └── users/              # User-specific profiles
        └── user.sls        # Example user profile
```

## Installation & Usage

### Prerequisites

*   A clean installation of a Debian-based Linux distribution (e.g., Debian, Kali, Ubuntu) [11].
*   Salt configured for either master-minion or masterless mode [11].
*   Git installed on the system [11].

### Quick Start (Masterless)

```bash
# 1. Clone the repository
git clone https://github.com/ilpakka/secuirrel.git
cd secuirrel

# 2. Install Salt (if not already installed)
#    Follow the official Salt documentation for your specific OS.

# 3. Apply the full configuration
sudo salt-call --local --file-root=./salt state.apply
```

### Master-Minion Setup

```bash
# On the Salt Master
sudo salt 'your-minion-id' state.apply

# Apply a specific category of tools
sudo salt 'your-minion-id' state.apply ctf_box.forensics

# Apply with a specific user profile
sudo salt 'your-minion-id' state.apply pillar='{"user_profile": "henry"}'
```

## Roadmap & Implementation Status

### ✅ Completed Features

- [x] **Modular Salt Structure:** Category-based organization (`forensics/`, `reverse/`, `web/`, `cracking/`) [10]
- [x] **Binwalk Dual-Version Support:** v2 via apt (`binwalk2`) and v3 via cargo (`binwalk`) with user-specific installations [7]
- [x] **Ghidra Installation:** Automated download, extraction, and JDK 21 setup with version management [4]
- [x] **Pwndbg Official Installation:** GDB plugin installed via official script with multi-user support [3]
- [x] **User Profile System:** Pillar-based flexible configuration for different user needs [10]
- [x] **Git-Based Tool Installation:** Support for cloning and building tools from Git repositories [3]
- [x] **Base Toolkit:** Essential utilities (curl, wget, vim, tmux, git, python3) [5]
- [x] **Web Exploitation Tools:** nmap, gobuster, sqlmap, ffuf, nikto, seclists [6]
- [x] **Forensics Tools:** steghide, volatility, exiftool, ffmpeg [8]
- [x] **Password Cracking Tools:** john, hashcat, hydra [9]

### 🚧 In Progress / Planned future

- [ ] **Moar tools:** Lots still missing.
- [ ] **Secrets Management:** Secure handling of API keys and licenses (GPG renderer)
- [ ] **Crypto/Stego Tools:** CyberChef, stegsolve, zsteg
- [ ] **Network Analysis:** Wireshark plugins, tcpdump configurations
- [ ] **Custom Scripts and better support:** Collection of CTF helper scripts and foe .zsh support (now only bash)
- [ ] **Multi-Platform Support:** macOS with Homebrew, Ansible fallback for non-Salt environments
- [ ] **Container Support:** Docker/Podman images for isolated tool environments
- [ ] **Automatic Updates:** Scheduled tool version checks and updates

## Extending the Configuration

Adding new tools is straightforward:

1. **Create a new state file** in the appropriate category (e.g., `ctf_box/web/new_tool.sls`)
2. **Update the category orchestrator** (e.g., `ctf_box/web/web.sls`) to include the new state
3. **Test the installation** on a minion: `sudo salt 'minion' state.apply ctf_box.web.new_tool`
4. **Commit changes** to version control

### Example: Adding a New Tool

```yaml
# ctf_box/forensics/new_forensics_tool.sls
install_new_forensics_tool:
  pkg.installed:
    - name: awesome-forensics-tool
```

Then add to `ctf_box/forensics/forensics.sls`:
```yaml
include:
  - ctf_box.forensics.binwalk
  - ctf_box.forensics.new_forensics_tool  # <-- New line
```

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request with a clear description

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.

## Links

Salt documentation https://docs.saltproject.io/en/latest/contents.html