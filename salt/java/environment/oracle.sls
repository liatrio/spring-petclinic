{%- from "java/map.jinja" import environment with context %}

{{ environment.prefix }}:
  file.directory:
  - user: root
  - group: root
  - mode: 755
  - makedirs: True

download_java_source:
  cmd.run:
    - name: "curl {{ environment.dl_opts }} '{{ environment.oracle_cookie }}' '{{ environment.source_url }}'"
    - cwd: {{ environment.prefix }}
    - unless: test -d {{ environment.java_real_home }}
    - require:
      - file: {{ environment.prefix }}

unpack_java_source:
  archive.extracted:
    - name: {{ environment.java_real_home }}
    - source: "{{ environment.prefix }}/{{ environment.oracle_file_name }}"
    - require:
      - cmd: download_java_source

java_install:
  alternatives.install:
    - name: java-home-link
    - link: {{ environment.java_home }}
    - path: {{ environment.java_real_home }}
    - priority: 30

java_profile_file:
  file.managed:
  - name: /etc/profile.d/java.sh
  - source: salt://java/files/java.sh
  - user: root
  - group: root
  - mode: 644
  - template: jinja
  - require:
    - alternatives: java_install

setup_java_paths:
  cmd.run:
  - name: . /etc/profile
  - cwd: /root
  - require:
    - file: java_profile_file
