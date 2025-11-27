# Venvit
require_venv_package:
  pkg.installed:
    - name: python3-venv
    - require_in:
      - virtualenv: /opt/venv-binwalk2
      - virtualenv: /opt/venv-binwalk3

# Binwalk 2 - venvi ja symbolilinkki
/opt/venv-binwalk2:
  virtualenv.managed:
    - python: python3
    - require:
      - pkg: base_ctf_tools

install_binwalk2:
  pip.installed:
    - name: binwalk==2.3.3
    - bin_env: /opt/venv-binwalk2
    - require:
      - virtualenv: /opt/venv-binwalk2

binwalk2_symlink:
  file.symlink:
    - name: /usr/local/bin/binwalk2
    - target: /opt/venv-binwalk2/bin/binwalk
    - require:
      - pip: install_binwalk2

# Binwalk 3 - samat ku ed.
/opt/venv-binwalk3:
  virtualenv.managed:
    - python: python3
    - require:
      - pkg: base_ctf_tools

install_binwalk3:
  pip.installed:
    - name: binwalk
    - bin_env: /opt/venv-binwalk3
    - upgrade: True # Saadaan päivittää
    - require:
      - virtualenv: /opt/venv-binwalk3

binwalk3_symlink:
  file.symlink:
    - name: /usr/local/bin/binwalk3
    - target: /opt/venv-binwalk3/bin/binwalk
    - require:
      - pip: install_binwalk3
