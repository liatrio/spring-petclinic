{% set sonarqube = salt['pillar.get']('sonarqube', {}) %}

include:
  - java

sonarqube-group:
  group.present:
    - name: {{ sonarqube.group }}
  
sonarqube-user:
  user.present:
    - name: {{ sonarqube.user }}
    - groups: 
      - {{ sonarqube.group }}

{% set package_name = ['sonarqube-', sonarqube.version] | join() %}
{% set package_download_path = [sonarqube.zipfile_destination, package_name] | join('/') %}
sonarqube-package:
  file.managed:
    - name: {{ package_download_path }}.zip
    - source: {{ sonarqube.mirror }}{{ package_name }}.zip
    - source_hash: {{ sonarqube.checksum }}
    - user: {{ sonarqube.user }}
    - group: {{ sonarqube.group }} 
    - mode: 644

  archive.extracted:
    - name: {{ sonarqube.home }}
    - source: {{ package_download_path }}.zip
    - user: {{ sonarqube.user }}
    - group: {{ sonarqube.group }}
    - if_missing: {{ sonarqube.home }}/{{ package_name }}

sonarqube-systemd:
  file.managed:
    - name: /etc/systemd/system/sonarqube.service 
    - source: salt://sonarqube/sonarqube.service.jinja
    - template: jinja
    - context: 
        sonarqube:
          user: {{ sonarqube.user }}
          group: {{ sonarqube.group }}
          bin_path: {{ sonarqube.home }}/{{ package_name }}/lib/sonar-application-{{ sonarqube.version }}.jar
      
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: sonarqube-systemd

sonarqube-service:
  service.running:
    - name: sonarqube
    - enable: True
    - watch: 
      - module: sonarqube-systemd
