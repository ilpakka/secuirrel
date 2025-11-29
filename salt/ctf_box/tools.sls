# Base toolkit - most all ready in
universal_base_tools:
  pkg.installed:
    - pkgs:
      # Connect
      - curl
      - wget
      - netcat-traditional
      - nmap
      
      # Edit
      - vim
      - nano
      - grep
      
      # Files
      - unzip
      - p7zip-full
      - tar
      
      # Git venv
      - git
      - build-essential
      - python3
      - python3-pip
      
      # Henry can't live without tmux and tree
      - tmux
      - tree
      - file