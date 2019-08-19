{% from "artifactory/map.jinja" import client with context %}
{%- if client.enabled %}

artifactory_client_install:
  pkg.installed:
  - names: {{ client.pkgs }}

include:
- artifactory.client.config
{%- if client.repo is defined %}
- artifactory.client.repo
{%- endif %}
{%- endif %}
