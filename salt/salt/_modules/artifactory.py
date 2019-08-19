# -*- coding: utf-8 -*-
'''
Module for configuring Artifactory.
===================================
'''

import json
import logging
import requests
import os

from collections import OrderedDict

from lxml import etree
from lxml import objectify

from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)


def _api_call(endpoint, data=None, headers=None, method='GET',
              **connection_args):

    if endpoint.startswith('/api') == False:
       endpoint = '/api' + endpoint

    return _rest_call(endpoint=endpoint,
                      data=data,
                      headers=headers,
                      method=method,
                      **connection_args)

def _rest_call(endpoint, data=None, headers=None, method='GET',
              **connection_args):

    log.debug('Got connection args: {}'.format(connection_args))

    # Set default values if empty
    if 'proto' not in connection_args:
        connection_args['proto'] = 'http'
    if 'host' not in connection_args:
        connection_args['host'] = 'localhost'
    if 'port' not in connection_args:
        connection_args['port'] = 80

    base_url = connection_args.get(
        'url',
        '{proto}://{host}:{port}/artifactory'.format(**connection_args)
    )

    username = connection_args.get('user', 'admin')
    password = connection_args.get('password', 'password')
    ssl_verify = connection_args.get('ssl_verify', True)

    # Prepare session object
    api_connection = requests.Session()
    api_connection.auth = (username, password)
    api_connection.verify = ssl_verify

    # Override default method if data given
    if(data and method == 'GET'):
        method = 'POST'

    endpoint_url = base_url + endpoint
    log.debug('Doing {0} request to {1}'.format(method, endpoint_url))

    # REST API call request
    resp = api_connection.request(
        method=method,
        url=endpoint_url,
        data=data,
        headers=headers
    )

    if resp.ok:
        return True, resp.text
    else:
        try:
            errors = json.loads(resp.text).get('errors')
            if errors:
                for error in errors:
                    log.error('%(status)s:%(message)s' % error)
            else:
                log.error('%(status)s:%(message)s' % json.loads(resp.text))
            return False, json.loads(resp.text)
        except ValueError:
            return False, resp.text


def get_license(**kwargs):
    endpoint = '/system/license'

    return _api_call(endpoint, **kwargs)


def add_license(license_key, **kwargs):
    endpoint = '/system/license'

    change_data = {
        'licenseKey': license_key,
    }

    return _api_call(
        endpoint=endpoint,
        data=json.dumps(change_data),
        headers={'Content-Type': 'application/json'},
        **kwargs
    )

def get_config(**kwargs):
    endpoint = '/system/configuration'

    return _api_call(endpoint, **kwargs)


def set_config(config_data, **kwargs):
    endpoint = '/system/configuration'

    return _api_call(
        endpoint=endpoint,
        data=config_data,
        headers={'Content-Type': 'application/xml'},
        **kwargs
    )


def get_ldap_config(name, **kwargs):

    result, config_data = get_config(**kwargs)
    config = objectify.fromstring(config_data.encode('ascii'))

    # Find existing LDAP settings with specified key ...
    ldap_config = None
    for ldap_setting_iter in config.security.ldapSettings.getchildren():
        if ldap_setting_iter.key.text == name:
            ldap_config = ldap_setting_iter
            break

    # ... and create new one if not exists
    if ldap_config is None:
        ldap_config = objectify.SubElement(
            config.security.ldapSettings, 'ldapSetting')
        objectify.SubElement(ldap_config, 'key')._setText(name)

    return result, etree.tostring(ldap_config)

def set_ldap_config(name, uri, base=None, enabled=True, dn_pattern=None,
                    manager_dn=None, manager_pass=None, search_subtree=True,
                    search_filter='(&(objectClass=inetOrgPerson)(uid={0}))',
                    attr_mail='mail', create_users=True, safe_search=True,
                    **kwargs):

    result, config_data = get_config(**kwargs)
    config = objectify.fromstring(config_data.encode('ascii'))

    # NOTE! Elements must ber sorted in exact order!
    key_map = OrderedDict([
        ('enabled', 'enabled'),
        ('ldapUrl', 'uri'),
        ('userDnPattern', 'dn_pattern'),
        ('search', ''),
        ('autoCreateUser', 'create_users'),
        ('emailAttribute', 'attr_mail'),
        ('ldapPoisoningProtection', 'safe_search'),
    ])

    key_map_search = OrderedDict([
        ('searchFilter', 'search_filter'),
        ('searchBase', 'base'),
        ('searchSubTree', 'search_subtree'),
        ('managerDn', 'manager_dn'),
        ('managerPassword', 'manager_pass'),
    ])

    # Find existing LDAP settings with specified key ...
    ldap_config = None
    for ldap_setting_iter in config.security.ldapSettings.getchildren():
        if ldap_setting_iter.key.text == name:
            ldap_config = ldap_setting_iter
            search_config = ldap_config.search
            break

    # ... and create new one if not exists
    if ldap_config is None:
        ldap_config = objectify.SubElement(
            config.security.ldapSettings, 'ldapSetting')
        objectify.SubElement(ldap_config, 'key')._setText(name)

    # LDAP options
    for xml_key, var_name in key_map.iteritems():

        # Search subtree must follow element order
        if xml_key == 'search' and not hasattr(ldap_config, 'search'):
            search_config = objectify.SubElement(ldap_config, 'search')
            break

        if var_name in locals():
            # Replace None with empty strings
            var_value = locals()[var_name] or ''
            if isinstance(var_value, bool):
                # Boolean values should be lowercased
                xml_text = str(var_value).lower()
            else:
                xml_text = str(var_value)

            if hasattr(ldap_config, xml_key):
                ldap_config[xml_key]._setText(xml_text)
            else:
                objectify.SubElement(ldap_config, xml_key)._setText(
                    xml_text)

    # Search options (same code as above but using search_config)
    for xml_key, var_name in key_map_search.iteritems():
        if var_name in locals():
            # Replace None with empty strings
            var_value = locals()[var_name] or ''
            if isinstance(var_value, bool):
                # Boolean values should be lowercased
                xml_text = str(var_value).lower()
            else:
                xml_text = str(var_value)

            if hasattr(search_config, xml_key):
                search_config[xml_key]._setText(xml_text)
            else:
                objectify.SubElement(search_config, xml_key)._setText(
                    xml_text)

    change_data = etree.tostring(config)

    return set_config(change_data, **kwargs)


def list_repos(**kwargs):
    endpoint = '/repositories'

    return _api_call(endpoint, **kwargs)


def get_repo(name, **kwargs):
    result, repo_list = list_repos(**kwargs)
    if name in [r['key'] for r in json.loads(repo_list)]:
        endpoint = '/repositories/' + name
        return _api_call(endpoint, **kwargs)
    else:
        return True, {}


def set_repo(name, repo_config, **kwargs):
    log.debug('Got repo parameters: {}'.format(repo_config))

    result, repo_list = list_repos(**kwargs)
    if name in [r['key'] for r in json.loads(repo_list)]:
        method = 'POST'
    else:
        method = 'PUT'

    endpoint = '/repositories/' + name

    return _api_call(
        endpoint=endpoint,
        method=method,
        data=json.dumps(repo_config),
        headers={'Content-Type': 'application/json'},
        **kwargs
    )

def deploy_artifact(source_file, endpoint, **kwargs):

    endpoint = endpoint + "/" + os.path.basename(source_file)
    # There is an issue with zero lenght files sending for Requests 2.x
    # https://github.com/requests/requests/issues/4215
    # Need to verify filesize before sending.
    if os.path.getsize(source_file) > 0:
        with open(source_file, 'rb') as input_file:
            result, status = _rest_call(
                 endpoint=endpoint,
                 method='PUT',
                 data=input_file,
                 **kwargs
            )
    else:
        result, status = _rest_call(
                 endpoint=endpoint,
                 method='PUT',
                 data='',
                 **kwargs
            )
    if result == False:
        raise CommandExecutionError(status)
    return status

def delete_artifact(item_to_delete, **kwargs):

    return _rest_call(
        endpoint=item_to_delete,
        method='DELETE',
        **kwargs
    )

