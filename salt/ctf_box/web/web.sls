ctf_web_tools:
  pkg.installed:
    - pkgs:
      - nmap
      - gobuster
      - sqlmap
      - ffuf
      # seclists, nikto poistettu

install_seclists:
  git.latest:
    - name: https://github.com/danielmiessler/SecLists.git
    - target: /opt/SecLists

install_nikto:
  git.latest:
    - name: https://github.com/sullo/nikto.git
    - target: /opt/nikto