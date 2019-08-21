# -*- coding: utf-8 -*-
'''
Management of artifactory configuration
=======================================
'''

import json


def __virtual__():
    if 'artifactory.get_license' in __salt__:
        return 'artifactory'
    else:
        return False, 'Execution module "artifactory" is not loaded'


def add_license_key(name, license_key, **kwargs):

    kwargs = __salt__['pillar.get']('artifactory:client:server')
    kwargs.pop('license_key', None)

    result, old_license_data = __salt__['artifactory.get_license'](**kwargs)

    result, res_data = __salt__['artifactory.add_license'](
        license_key,
        **kwargs
    )

    # Prepare data to return
    ret = {
        'name': name,
        'changes': {},
        'result': result,
        'comment': '',
        'pchanges': {},
    }

    if result:
        result, new_license_data = __salt__['artifactory.get_license'](**kwargs)

        if old_license_data != new_license_data:
            ret['changes'] = {
                'old': json.dumps(old_license_data),
                'new': json.dumps(new_license_data),
            }
        ret['comment'] = res_data
    else:
        ret['comment'] = res_data['message']
        if ret['comment'] == ('License could not be installed due '
                              'to an error: License already exists.'):
            ret['result'] = True

    return ret

def configure_ldap(name, uri, base=None, enabled=True, dn_pattern=None,
                   manager_dn=None, manager_pass=None, search_subtree=True,
                   search_filter='(&(objectClass=inetOrgPerson)(uid={0}))',
                   attr_mail='mail', create_users=True, safe_search=True):

    kwargs = __salt__['pillar.get']('artifactory:client:server')

    result, ldap_config_old = __salt__['artifactory.get_ldap_config'](name, **kwargs)

    result, res_data = __salt__['artifactory.set_ldap_config'](
        name, uri, base, enabled, dn_pattern, manager_dn, manager_pass,
        search_subtree, search_filter, attr_mail, create_users, safe_search,
        **kwargs
    )

    # Prepare data to return
    ret = {
        'name': name,
        'changes': {},
        'result': result,
        'comment': '',
        'pchanges': {},
    }

    if result:
        result, ldap_config_new = __salt__['artifactory.get_ldap_config'](name, **kwargs)
        if ldap_config_old != ldap_config_new:
            ret['changes'] = {
                'old': ldap_config_old,
                'new': ldap_config_new,
            }
        ret['comment'] = res_data
    else:
        ret['comment'] = res_data.get('errors')[0]['message']

    return ret

def configure_repo(name, **kwargs):

    repo_config = kwargs
    repo_name = repo_config['key']

    rclass = repo_config.pop('repo_type', 'local')
    if 'rclass' not in repo_config:
        repo_config['rclass'] = rclass

    packageType = repo_config.pop('package_type', 'generic')
    if 'packageType' not in repo_config:
        repo_config['packageType'] = packageType

    kwargs = __salt__['pillar.get']('artifactory:client:server')

    result, repo_config_old = __salt__['artifactory.get_repo'](repo_name, **kwargs)

    # Prepare data to return
    ret = {
        'name': name,
        'changes': {},
        'result': result,
        'comment': '',
        'pchanges': {},
    }

    result, res_data = __salt__['artifactory.set_repo'](repo_name, repo_config, **kwargs)

    if result:
        result, repo_config_new = __salt__['artifactory.get_repo'](repo_name, **kwargs)
        if repo_config_old != repo_config_new:
            ret['changes'] = {
                'old': repo_config_old,
                'new': repo_config_new,
            }
        ret['comment'] = res_data
    else:
        ret['comment'] = res_data.get('errors')[0]['message']

    return ret
