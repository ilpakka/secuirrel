# /srv/salt/binwalk/init.sls
#
# Global env and binwalk versions for all users who has home. Initial support for bash.

install_binwalk2_from_apt:
  pkg.installed:
    - name: binwalk

create_binwalk2_symlink:
  file.symlink:
    - name: /usr/local/bin/binwalk2
    - target: /usr/bin/binwalk
    - force: True
    - require:
      - pkg: install_binwalk2_from_apt

# Binwalk3 RUST
install_binwalk3_os_deps:
  pkg.installed:
    - pkgs:
      - curl
      - build-essential
      - libfontconfig1-dev
      - liblzma-dev

{%- for user_info in salt['user.list_users']() %}
  {%- set user_home = salt['user.info'](user_info).get('home') %}
  {%- set user_uid = salt['user.info'](user_info).get('uid') %}
  
  {# Only install for regular users (UID 1000-59999), skip system users #}
  {%- if user_uid >= 1000 and user_uid < 60000 and user_home and user_home != '/root' %}

install_rustup_for_{{ user_info }}:
  cmd.run:
    - name: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - runas: {{ user_info }}
    - creates: {{ user_home }}/.cargo/bin/rustc
    - require:
      - pkg: install_binwalk3_os_deps

configure_shell_for_{{ user_info }}:
  file.append:
    - name: {{ user_home }}/.bashrc
    - text: |
        # Cargo environment
        . "$HOME/.cargo/env"
    - require:
      - cmd: install_rustup_for_{{ user_info }}

install_binwalk3_for_{{ user_info }}:
  cmd.run:
    - name: {{ user_home }}/.cargo/bin/cargo install binwalk
    - runas: {{ user_info }}
    - creates: {{ user_home }}/.cargo/bin/binwalk
    - require:
      - cmd: install_rustup_for_{{ user_info }}

  {%- endif %}
{%- endfor %}


create_global_binwalk3_wrapper:
  file.managed:
    - name: /usr/local/bin/binwalk
    - mode: '0755'
    - contents: |
        #!/bin/bash
        # Global wrapper for user-specific Binwalk v3 installations
        # Managed by Salt - DO NOT EDIT MANUALLY
        
        # Detect current user (handle sudo correctly)
        CURRENT_USER="${SUDO_USER:-$USER}"
        USER_HOME=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
        BINWALK_PATH="$USER_HOME/.cargo/bin/binwalk"
        
        # check install
        if [ ! -x "$BINWALK_PATH" ]; then
            echo "Error: Binwalk v3 not installed for user '$CURRENT_USER'" >&2
            echo "Hint: Use 'binwalk2' for the system-wide v2 installation" >&2
            echo "      Or install v3 with: cargo install binwalk" >&2
            exit 1
        fi
        
        exec "$BINWALK_PATH" "$@"