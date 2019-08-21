{%- from "artifactory/map.jinja" import server with context %}
{%- if server.enabled %}

artifactory_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

artifactory_storage_config:
  file.managed:
  - name: /etc/opt/jfrog/artifactory/storage.properties
  - source: salt://artifactory/files/storage.properties
  - template: jinja
  - require:
    - pkg: artifactory_packages
  - watch_in:
    - service: artifactory_service

{%- if server.license is defined %}

artifactory_license_config:
  file.managed:
  - name: /etc/opt/jfrog/artifactory/artifactory.lic
  - contents_pillar: artifactory:server:license
  - require:
    - pkg: artifactory_packages
  - watch_in:
    - service: artifactory_service

{%- endif %}

{%- if server.database.engine == "postgresql" %}

artifactory_lib_postresql:
  file.managed:
  - name: /var/opt/jfrog/artifactory/tomcat/lib/postgresql.jar
  - source: {{ server.lib.postgresql }}
  - skip_verify: True
  - require:
    - pkg: artifactory_packages
  - watch_in:
    - service: artifactory_service

{%- elif server.database.engine == "mysql" %}

artifactory_lib_mysql:
  file.managed:
  - name: /var/opt/jfrog/artifactory/tomcat/lib/mysql.jar
  - source: {{ server.lib.mysql }}
  - skip_verify: True
  - require:
    - pkg: artifactory_packages
  - watch_in:
    - service: artifactory_service

{%- endif %}

artifactory_service:
  service.running:
  - name: {{ server.service }}
  - enable: true

{%- endif %}
