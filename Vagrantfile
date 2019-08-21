Vagrant.configure("2") do |config|

  config.vm.define 'jenkins', primary: true do |jenkins|
    jenkins.vm.box = 'liatrio-engineering/jenkins-nexus'
    jenkins.vm.hostname = 'liatrio-jenkins'
    jenkins.vm.network :private_network, type: 'dhcp'
    jenkins.vm.network :forwarded_port, guest: 8080, host: 16016

    jenkins.vm.provider :virtualbox do |vbox|
      vbox.gui = false  
      vbox.customize ['modifyvm', :id, '--cpus', 2] 
      vbox.customize ['modifyvm', :id, '--memory', 2048] 
    end

    jenkins.vm.provision :salt do |salt|
      salt.masterless = true
      salt.run_highstate = true
      salt.verbose = true
      salt.minion_id = 'jenkins'
      salt.minion_config = 'salt/minion.yml'
      salt.pillar({
        'jenkins' => {
          'url' => "http://#{jenkins.vm.hostname}:8080",
          'user' => '',
          'password' => '',
          'client' => {
            'source' => {
            },
            'enabled' => true,
            'master' => {
              'host': 'localhost',
              'port': '8080',
              'protocol': 'http'
            },
            'lib' => { 
              'ldop-shared-library' => {
                'enabled' => true,
                'url' => 'https://github.com/liatrio/pipeline-library.git',
                'branch' => 'master'
              }
            },
            'job' => {
              'petclinic' => {
                'type' => 'workflow-scm',
                'displayname': 'petclinic',
                'concurrent' => false,
                'scm' => {
                  'type' => 'git',
                  'url' => 'https://github.com/BMWilding/spring-petclinic.git',
                  'branch' => 'get-jenkins-working',
                  'script' => 'Jenkinsfile',
                  'github' => {
                    'url' => 'https://github.com/BMWilding/spring-petclinic',
                    'name' => 'spring-petclinic'
                  }
                },
                'trigger' => {
                  'pollscm' => {
                    'spec' => ''"H/15 * * * *"
                  }
                }
              }
            }
          }
        }
      })
    end

  end

  config.vm.define 'sonarqube' do |sonarqube|
    sonarqube.vm.box = "centos/7"
    sonarqube.vm.hostname = 'liatrio-sonarqube'
    sonarqube.vm.network 'private_network', type: 'dhcp'
    sonarqube.vm.network 'forwarded_port', guest: 9000 , host: 16017

    sonarqube.vm.provider :virtualbox do |vbox|
      vbox.gui = false  
      vbox.customize ['modifyvm', :id, '--cpus', 2] 
      vbox.customize ['modifyvm', :id, '--memory', 2048] 
    end

    sonarqube.vm.provision :salt do |salt|
      salt.masterless = true
      salt.run_highstate = true
      salt.verbose = true
      salt.minion_id = 'sonarqube'
      salt.minion_config = 'salt/minion.yml'
      salt.pillar({
        'sonarqube' => {
          'mirror' => 'https://binaries.sonarsource.com/Distribution/sonarqube/',
          'version' => '7.9.1',
          'checksum' => '67f3ccae79245397480b0947d7a0b5661dc650b87f368b39365044ebcc88ada0',
          'user' =>  'sonarqube',
          'group' => 'sonarqube',
          'config' =>  'sonarqube.config',
          'zipfile_destination' => '/tmp',
          'home' => '/opt'
        },
        'java' => {
          'environment' => {
            'enabled' => true,
            'version' => '11',
            'platform' => 'openjdk',
            'development' => false
          }
        }
      })
    end
  end

  config.vm.define 'artifactory' do |artifactory|
    artifactory.vm.box = "centos/7"
    artifactory.vm.hostname = 'liatrio-artifactory'
    artifactory.vm.network 'private_network', type: 'dhcp'
    artifactory.vm.network 'forwarded_port', guest: 9000 , host: 16018

    artifactory.vm.provider :virtualbox do |vbox|
      vbox.gui = false  
      vbox.customize ['modifyvm', :id, '--cpus', 2] 
      vbox.customize ['modifyvm', :id, '--memory', 1024] 
    end

    artifactory.vm.provision :salt do |salt|
      salt.masterless = true
      salt.run_highstate = true
      salt.verbose = true
      salt.minion_id = 'artifactory'
      salt.minion_config = 'salt/minion.yml'
      salt.pillar({
        'artifactory' => {
          'server' => {
            'enabled' => true,
            'edition' => 'oss',
            'version' => '6.1.2',
            'source' => {
              'engine' => 'package'
            }
          },
          'client' => {
            'enabled' => true,
            'server' => {
              'host' => artifactory.vm.hostname,
              'port' => '9000',
              'user' => 'admin',
              'password' => 'password'
            }
          },
          'liatriomaven' => {
            'name' => 'liatriomaven',
            'package_type' => 'maven',
            'repo_type' => 'local'
          }
        }
      })
    end

  end

end
