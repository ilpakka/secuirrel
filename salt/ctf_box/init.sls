{# salt/ctf_box/init.sls #}
{# Main orchestrator for CTF box configuration with pillar-based logic #}

{%- set cfg = pillar.get('ctf_box', {}) %}
{%- set profile = pillar.get('profile', 'full') %}
{%- set install = pillar.get('install', {}) %}

{# Feature flags - default all to True for 'full' profile #}
{%- set forensics_enabled = install.get('forensics_tools', True) %}
{%- set reverse_enabled = install.get('reverse_tools', True) %}
{%- set web_enabled = install.get('web_tools', True) %}
{%- set cracking_enabled = install.get('cracking_tools', True) %}
{%- set user_profile = pillar.get('user_profile', none) %}

# Base tools are always installed
include:
  - ctf_box.tools

# Category-based tool installations (controlled by pillar flags)
{%- if forensics_enabled %}
  - ctf_box.forensics
{%- endif %}

{%- if reverse_enabled %}
  - ctf_box.reverse
{%- endif %}

{%- if web_enabled %}
  - ctf_box.web
{%- endif %}

{%- if cracking_enabled %}
  - ctf_box.cracking
{%- endif %}

# User-specific profiles (optional)
{%- if user_profile %}
  - ctf_box.users.{{ user_profile }}
{%- endif %}