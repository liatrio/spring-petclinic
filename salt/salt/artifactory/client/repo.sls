{% from "artifactory/map.jinja" import client with context %}
{%- for repo_name, repo in client.repo.iteritems() %}

artifactory_repo_{{ repo_name }}:
  artifactory.configure_repo:
  - key: {{ repo_name }}
{%- for key, value in repo.iteritems() %}
  - {{key}}: {{value}}
{%- endfor %}

{%- endfor %}
