{% from 'sonarqube/map.jinja' import sonarqube with context %}

include:
  - java

sonarqube:
  pkg.installed:
    - name: sonar
    - require:
      - pkgrepo: sonar

  service.running:
    - name: sonar
    - enable: True
    - require:
      - pkg: sonarqube

sonarqube-repo:
  pkgrepo.managed:
    - name: sonar
    - humanname: Sonar
    - baseurl: https://downloads.sourceforge.net/project/sonar-pkg/rpm
    - gpgcheck: 0

sonarqube-wrapper-conf:
  file.replace:
    - name: /opt/sonar/conf/wrapper.conf
    - pattern: ^wrapper.java.command=.*$
    - repl: wrapper.java.command={{ sonarqube.java }}
    - prepend_if_not_found: True
    - watch_in:
      - service: sonarqube

sonarqube-config:
  file.blockreplace:
    - name: /opt/sonar/conf/sonar.properties
    - prepend_if_not_found: True
    - watch_in:
      - service: sonarqube

{% for key, value in sonarqube.get('config', {})|dictsort %}
sonarqube-config-{{ key }}:
  file.accumulated:
    - name: sonarqube-config-accumulator
    - filename: /opt/sonar/conf/sonar.properties
    - text: |
        {{ key }}={{ value }}
    - require_in:
      - file: sonarqube-config
{% endfor %}

{% for jar, url in sonarqube.get('plugins', {}).items() %}
{% set destination = '/opt/sonar/extensions/plugins/' + jar + '.jar' %}
{{ destination }}:
  cmd.run:
    - name: 'curl -L --silent "{{ url }}" > "{{ destination }}"'
    - unless: 'test -f "{{ destination }}"'
    - require:
      - pkg: sonarqube
    - prereq:
      - file: {{ destination }}

  file.managed:
    - name: {{ destination }}
    - user: sonar
    - group: sonar
    - mode: 644
    - replace: False
    - watch_in:
      - service: sonarqube
{% endfor %}
