ctf_forensics_tools:
  pkg.installed:
    - pkgs:
      - steghide
      - libimage-exiftool-perl
      - ffmpeg

install_volatility3:
  pip.installed:
    - name: volatility3