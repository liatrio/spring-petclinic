pipeline {
    agent none
    stages {
       stage('Build') {
           agent {
               docker {
                   image 'maven:3.5.0'
                   args '-e INITIAL_ADMIN_USER -e INITIAL_ADMIN_PASSWORD --network=${LDOP_NETWORK_NAME}'
               }
           }
           steps {
               configFileProvider(
                       [configFile(fileId: 'nexus', variable: 'MAVEN_SETTINGS')]) {
                   sh 'mvn -s $MAVEN_SETTINGS clean deploy -DskipTests=true -B'
               }
           }
       }
       stage('Deploy to Tomcat') {
           agent {
               docker {
                   image 'alpine'
               }
           }
           steps {
               sh 'echo deploying to tomcat'
               //sh 'cp target/petclinic.war /usr/share/jenkins/ref/tomcat/petclinic.war'
           }
       }
       stage('Sonar') {
           agent  {
               docker {
                   image 'sebp/sonar-runner'
                   args '--network=${LDOP_NETWORK_NAME}'
               }
           }
           steps {
               sh 'echo running Sonar'
               //sh '/opt/sonar-runner-2.4/bin/sonar-runner'
           }
       }
        stage('Selenium') {
            agent {
                docker {
                    image 'liatrio/selenium-firefox'
                    args '--network=${LDOP_NETWORK_NAME}'
                }
            }
            steps {
                sh 'echo running Selenium'
                //sh 'ruby petclinic_spec.rb'
            }
        }
    }
}
