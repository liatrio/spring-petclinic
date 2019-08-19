Vagrant.configure("2") do |config|

  config.vm.define 'jenkins' do |jenkins|
    jenkins.vm.box = 'liatrio-engineering/jenkins-nexus'
    jenkins.vm.hostname = 'liatrio-jenkins'
    jenkins.vm.network :private_network, type: 'dhcp'
    jenkins.vm.network :forwarded_port, guest: 8080, host: 16016

    jenkins.vm.provider :virtualbox do |vbox|
      vbox.gui = false  
      vbox.customize ['modifyvm', :id, '--cpus', 2] 
      vbox.customize ['modifyvm', :id, 'memory', 2048] 
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
      vbox.customize ['modifyvm', :id, 'memory', 2048] 
    end
  end

  config.vm.define 'artifactory' do |artifactory|
    artifactory.vm.box = "centos/7"
    artifactory.vm.hostname = 'liatrio-artifactory'
    artifactory.vm.network 'private_network', type: 'dhcp'
    artifactory.vm.network 'forwarded_port', guest: 9000 , host: 16017

    artifactory.vm.provider :virtualbox do |vbox|
      vbox.gui = false  
      vbox.customize ['modifyvm', :id, '--cpus', 2] 
      vbox.customize ['modifyvm', :id, 'memory', 1024] 
    end

end
