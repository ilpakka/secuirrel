base_ctf_tools:
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
      # binwalkia varten
      - libunrar-dev
      - libsasquatch-dev
      # Muita tärkeitä tbd (jos muu linux?)
      - seclists
      - nmap
      - gobuster
      - john
      - hashcat
      - steghide
      - foremost
