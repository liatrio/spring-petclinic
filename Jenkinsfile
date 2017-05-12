pipeline {
    agent none
    stages {
//        stage('Build') {
//            agent {
//                docker {
//                    image 'maven:3.5.0'
//                    args '--network=plumbing_default'
//                }
//            }
//            steps {
//                configFileProvider(
//                        [configFile(fileId: 'nexus', variable: 'MAVEN_SETTINGS')]) {
//                    sh 'mvn -s $MAVEN_SETTINGS clean deploy -DskipTests=true'
//                }
//            }
//        }
//        stage('Deploy to Tomcat') {
//            agent {
//                docker {
//                    image 'alpine'
//                }
//            }
//            steps {
//                sh 'cp target/petclinic.war /usr/share/jenkins/ref/petclinic/petclinic.war'
//            }
//        }
//        stage('Sonar') {
//            agent  {
//                docker {
//                    image 'sebp/sonar-runner'
//                    args '--network=plumbing_default'
//                }
//            }
//            steps {
//                sh '/opt/sonar-runner-2.4/bin/sonar-runner'
//            }
//        }
        stage('Selenium') {
            agent {
                docker {
                    image 'ruby:2.1.10'
                }
            }
            steps {
                sh 'gem install selenium-webdriver'
                sh 'add-apt-repository ppa:mozillateam/firefox-next'
                sh 'apt-get update -y'
                sh 'apt-get install xvfb firefox -y'
                sh 'gem install headless'
                sh 'ruby selenium.rb'
            }
        }
    }
}
