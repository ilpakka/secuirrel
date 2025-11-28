![Secuirrel](inc/logo_h1.png)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) ![Salt](https://img.shields.io/badge/Miniprojekti-h6-red) ![By](https://img.shields.io/badge/creatöörit-ilpakka_and_hneryi-orange)
# Secuirrel - Your Personal SecOps Setup with SaltStack

This project provides a SaltStack configuration (states) to quickly and repeatably set up a Linux workstation. The goal is to automate the installation of tools, applications and configurations involving SecOps or Capture-The-Flag happenings.

Since the entire setup is version-controlled, tracking changes and reverting to previous configurations is straightforward.

## Goals and Features

The main objective is to create a flexible and automated way to configure any Linux machine to your exact specifications.

*   **🚀 Fast Deployment:** Get a new, clean Linux machine configured and ready for work with a single command.
*   **🔁 Reproducibility:** Every installation is identical, eliminating configuration drift and the "it works on my machine" problem.
*   **🛠️ Modularity:** Base utilities, complex applications, and user-specific dotfiles are separated into their own manageable state files.
*   **👥 User Profiles:** Apply different sets of tools and configurations for different users or roles (e.g., `developer`, `sysadmin`) on the same machine.
*   **✅ Idempotency:** The Salt state can be applied multiple times without breaking anything; only necessary changes are made.
*   **🔧 Centralized Management:** Keep the configuration for all your tools, packages, and dotfiles in one central repository.

## Project Structure

```
secuirrel/
├── salt/
│   ├── top.sls                 # The main control file, determines which states to run
│   └── workstation/
│       ├── init.sls            # Orchestrates all workstation states
│       ├── base.sls            # Base packages and utilities (installed via package manager)
│       ├── custom_apps.sls     # Installation for custom or third-party applications
│       └── users/              # User-specific profiles and dotfiles
│           ├── user_a.sls
│           └── user_b.sls
└── README.md
```

## Getting Started

These instructions are intended to be run directly on the target machine (in a masterless configuration).

### 1. Prerequisites

*   A Linux distribution (e.g., Arch, Debian, Ubuntu, Fedora).
*   `git` and `salt-minion` installed.

For **Debian/Ubuntu-based systems**, you can install the prerequisites with:
```bash
sudo apt update
sudo apt install -y git salt-minion
```

### 2. Clone the Repository

Clone this repository to your machine:
```bash
git clone https://github.com/ilpakka/secuirrel.git
cd secuirrel
```

### 3. Apply the Configuration

Navigate to the project's root directory (`secuirrel/`) and execute `salt-call`.

#### A) Base Installation Only

This installs all common tools and system-wide configurations defined in the base states, but excludes any user-specific settings.
```bash
sudo salt-call --local --file-root=./salt state.apply
```

#### B) Base Installation + User Profile

This applies the base configuration and additionally deploys the settings for a specific user profile (e.g., installing their preferred tools and dotfiles).
```bash
# Replace <PROFILE_NAME> with your desired user profile (e.g., 'user_a')
sudo salt-call --local --file-root=./salt state.apply pillar='{"user_profile": "<PROFILE_NAME>"}'
```
---

## Roadmap & Current Status (Checklist)
- [x] **Basic Salt Structure:** A modular structure with `top.sls` and `init.sls` for easy management.
- [ ] **Core Packages:** Installation of common utilities (e.g., `htop`, `vim`, `curl`, `git`) via the system package manager.
- [ ] **Custom Software Installation:** Logic to download, extract, and install applications from source archives or AppImages.
- [x] **User Profiles:** A flexible system to apply specific configurations based on a user profile passed via `pillar` data.
- [ ] **Dotfiles Management:** Automatically manage and deploy personal configuration files (e.g., `.zshrc`, `.vimrc`, `.tmux.conf`).
- [x] **Install from Git:** Support for cloning software or configurations directly from Git repositories.
- [ ] **Secrets Management:** A secure way to handle sensitive data like API keys (e.g., using Salt's GPG renderer). TBD
- [ ] **Support matrix?** Mac os with brew? Ansible? TBD

## Extending the Configuration

This project is designed to be easily extensible. See salt documentation for extended help.

*   **To add a new system-wide package:**
    Add the package name to the list in `salt/workstation/base.sls`.

*   **To add a new user profile (e.g., "carlos"):**
    1.  Create a new file: `salt/workstation/users/carlos.sls`.
    2.  Define the states for the new user in the file (e.g., packages to install, dotfiles to manage).
    3.  Add the new profile to the logic in `salt/workstation/init.sls`:
        ```yaml
        {% elif user == 'carlos' %}
        include:
          - workstation.users.carlos
        ```
        
## Links
Salt documentation
https://docs.saltproject.io/en/latest/contents.html
