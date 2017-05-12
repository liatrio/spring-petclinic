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
                sh 'apt-get update -y'
                sh 'wget https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz'
                sh 'tar -xvzf geckodriver-v0.16.1-linux64.tar.gz'
                sh 'rm geckodriver-v0.16.1-linux64.tar.gz'
                sh 'chmod +x geckodriver'
                sh 'cp geckodriver /usr/local/bin/'
                sh 'apt-get install xvfb -y'
                sh 'gem install headless'
                sh 'ruby selenium.rb'
            }
        }
    }
}
