#Ghidra
#

{% set ghidra_version = '11.4.2' %}
{% set ghidra_build_date = '20250826' %}
{% set ghidra_filename = 'ghidra_' ~ ghidra_version ~ '_PUBLIC_' ~ ghidra_build_date ~ '.zip' %}
{% set ghidra_url = 'https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_' ~ ghidra_version ~ '_build/' ~ ghidra_filename %}
{% set ghidra_install_dir = '/opt/ghidra_' ~ ghidra_version ~ '_PUBLIC' %}
{% set ghidra_sha256 = '795a02076af16257bd6f3f4736c4fc152ce9ff1f95df35cd47e2adc086e037a6' %}

# JDK-21
install_openjdk_for_ghidra:
  pkg.installed:
    - name: openjdk-21-jdk

download_ghidra_zip:
  cmd.run:
    - name: wget -O /tmp/{{ ghidra_filename }} {{ ghidra_url }}
    - creates: /tmp/{{ ghidra_filename }}
    - require:
      - pkg: install_openjdk_for_ghidra

extract_ghidra:
  archive.extracted:
    - name: /opt/
    - source: /tmp/{{ ghidra_filename }}
    - source_hash: sha256={{ ghidra_sha256 }}
    - archive_format: zip
    - if_missing: {{ ghidra_install_dir }}/ghidraRun
    - require:
      - cmd: download_ghidra_zip

make_ghidrarun_executable:
  file.managed:
    - name: {{ ghidra_install_dir }}/ghidraRun
    - mode: '0755'
    - replace: False
    - require:
      - archive: extract_ghidra

cleanup_ghidra_zip:
  file.absent:
    - name: /tmp/{{ ghidra_filename }}
    - require:
      - archive: extract_ghidra

create_ghidra_command:
  file.symlink:
    - name: /usr/local/bin/ghidra
    - target: {{ ghidra_install_dir }}/ghidraRun
    - force: True
    - require:
      - file: make_ghidrarun_executable