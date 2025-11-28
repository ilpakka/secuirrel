{# salt/ctf_box/user_config.sls #}
{%- set cfg = pillar.get('ctf_box', {}) %}
{%- set user = cfg.get('user', 'default') %}