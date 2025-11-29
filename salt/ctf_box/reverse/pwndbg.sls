# Pwndbg - from official site to salt stack

ensure_curl_for_pwndbg:
  pkg.installed:
    - name: curl

ensure_gdb_for_pwndbg:
  pkg.installed:
    - name: gdb

# Official pwndbg install
install_pwndbg_via_official_script:
  cmd.run:
    - name: curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb
    - runas: root
    - shell: /bin/bash
    # Idempotenssi: Tarkista onko pwndbg jo asennettu
    # Skripti luo ~/.local/share/pwndbg hakemiston
    - unless: test -d /root/.local/share/pwndbg
    - require:
      - pkg: ensure_curl_for_pwndbg
      - pkg: ensure_gdb_for_pwndbg

# All users pwndbg

{% for user_info in salt['user.list_users']() %}
  {% set user_home = salt['user.info'](user_info).get('home') %}
  {% set user_uid = salt['user.info'](user_info).get('uid') %}
  
  # Asenna vain "tavallisille" käyttäjille (ei system-käyttäjille)
  {% if user_uid >= 1000 and user_uid < 60000 and user_home and user_home != '/root' %}

install_pwndbg_for_{{ user_info }}:
  cmd.run:
    - name: curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb
    - runas: {{ user_info }}
    - shell: /bin/bash
    - unless: test -d {{ user_home }}/.local/share/pwndbg
    - require:
      - pkg: ensure_curl_for_pwndbg
      - pkg: ensure_gdb_for_pwndbg

ensure_gdbinit_for_{{ user_info }}:
  cmd.run:
    - name: |
        if ! grep -q "pwndbg" {{ user_home }}/.gdbinit 2>/dev/null; then
          echo "# pwndbg autoload (managed by Salt)" >> {{ user_home }}/.gdbinit
          echo "source {{ user_home }}/.local/share/pwndbg/gdbinit.py" >> {{ user_home }}/.gdbinit
        fi
    - runas: {{ user_info }}
    - shell: /bin/bash
    - require:
      - cmd: install_pwndbg_for_{{ user_info }}

  {% endif %}
{% endfor %}