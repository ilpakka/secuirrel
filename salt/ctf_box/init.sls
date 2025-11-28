{# salt/ctf_box/init.sls #}
{%- set cfg = pillar.get('ctf_box', {}) %}
{%- set profile = pillar.get('profile', 'full') %}
{%- set install = pillar.get('install', {}) %}

# keys
{%- set binwalk_enabled = install.get('binwalk_tools', True) %}
{%- set web_enabled = install.get('web_tools', True) %}
{%- set forensics_enabled = install.get('forensics_tools', True) %}
{%- set cracking_enabled = install.get('cracking_tools', True) %}

include:
  - ctf_box.tools	# always True

  {%- if binwalk_enabled and profile in ['full'] %}
  - ctf_box.binwalk
  {%- endif %}

  {%- if web_enabled and profile in ['full'] %}
  - ctf_box.web
  {%- endif %}

  {%- if forensics_enabled and profile in ['full'] %}
  - ctf_box.forensics
  {%- endif %}

  {%- if cracking_enabled and profile in ['full'] %}
  - ctf_box.cracking
  {%- endif %}

# user config

  # {%- if cfg.get('user') %}
  # - userconfig_later_maybe_maybe
  # {%- endif %}

