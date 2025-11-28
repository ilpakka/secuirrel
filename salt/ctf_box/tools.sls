ctf_base_tools:
  pkg.installed:
    - pkgs:
      - git
      - vim
      - tmux
      - curl
      - build-essential   # Kääntämiseen tarvittavat paketit
      - python3-pip
      - python3-venv      # TÄRKEÄ: Pythonin virtuaaliympäristöille
      - cmake
