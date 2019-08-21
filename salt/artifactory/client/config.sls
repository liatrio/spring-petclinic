{% from "artifactory/map.jinja" import client with context %}
{%- if client.server.license_key is defined %}
add_license_data:
  artifactory.add_license_key:
  - license_key: {{client.server.license_key}}
{%- endif %}

{%- if client.server.ldap_server is defined %}
ldap:
    artifactory.configure_ldap:
      - uri: {{client.server.ldap_server}}
      - enabled: {{client.server.ldap_server_enabled|default('true')}}
{%- if client.server.get('ldap_dn_pattern') %}
      - dn_pattern: {{client.server.ldap_dn_pattern}}
{%- endif %}
{%- if client.server.get('ldap_account_base') %}
      - base: {{client.server.ldap_account_base}}
{%- endif %}
{%- if client.server.get('ldap_searchFilter') %}
      - search_filter: {{client.server.ldap_searchFilter}}
{%- endif %}
      - search_subtree: {{client.server.ldap_searchSubtree|default('true')}}
{%- if client.server.get('ldap_managerDn') %}
      - manager_dn: {{client.server.ldap_managerDn}}
      - manager_pass: {{client.server.ldap_managerPass}}
{%- endif %}
      - attr_mail: {{client.server.ldap_attr_mail|default('mail')}}
      - create_users: {{client.server.ldap_create_users|default('true')}}
      - safe_search: {{client.server.ldap_safe_search|default('true')}}
{%- endif %}
