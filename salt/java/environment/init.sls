{%- from "java/map.jinja" import environment with context %}
{%- if environment.enabled %}

include:
{%- if environment.platform == 'openjdk' %}
- java.environment.openjdk
{%- elif environment.platform == 'oracle-java' %}
- java.environment.oracle
{%- endif %}

{%- endif %}
