
{%- if pillar.java is defined %}
include:
{%- if pillar.java.environment is defined %}
- java.environment
{%- endif %}
{%- endif %}
