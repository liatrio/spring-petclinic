
{%- if pillar.artifactory is defined %}
include:
{%- if pillar.artifactory.server is defined %}
- artifactory.server
{%- endif %}
{%- if pillar.artifactory.client is defined %}
- artifactory.client
{%- endif %}
{%- endif %}
