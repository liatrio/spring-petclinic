{%- from "java/map.jinja" import environment with context %}

{%- if environment.version == '10' %}

java_archive:
  archive.extracted:
    - name: {{ environment.home_dir }}
    - source: https://download.java.net/java/GA/jdk{{ environment.version }}/{{ environment.version }}.{{ environment.release}}/{{ environment.oracle_hash }}/{{ environment.version }}/openjdk-{{ environment.version }}.{{ environment.release}}_linux-x64_bin.tar.gz
    - options: zxvf
    {%- if environment.get('verify_sha256_hash', False) %}
    - source_hash: {{ environment.sha256_hash }}
    {%- else %}
    - skip_verify: true
    {%- endif %}

{%- else %}

java_packages:
  pkg.installed:
  - name: {{ environment.pkgs | string }}

{%- if environment.get('development', False) %}

java_dev_packages:
  pkg.installed:
  - name: {{ environment.dev_pkgs | string }}

{%- endif %}

java_home_symlink:
  file.symlink:
  - name: {{ environment.home_dir }}
  - target: /usr/lib/jvm/java-{{ environment.version }}-openjdk-amd64
  - force: true

{%- endif %}
