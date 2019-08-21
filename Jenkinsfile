#!/bin/env groovy

@Library('ldop-shared-library') _

pipeline {
  agent none

  environment {
    IMAGE = 'liatrio/petclinic-tomcat'
    TAG = '1.0.0'
  }

  stages {

    stage('Build') {
      agent {
        docker {
          image 'maven:3.5.0'
          args '-e admin -e password'
        }
      }
      steps {
        configFileProvider([configFile(fileId: 'nexus', variable: 'MAVEN_SETTINGS')]) {
          sh 'mvn -s $MAVEN_SETTINGS clean deploy -DskipTests=true -B'
        }
      }
    }
    stage('Sonar') {
      agent  {
        docker {
          image 'sebp/sonar-runner'
          args '-e admin -e admin'
        }
      }
      steps {
        sh '/opt/sonar-runner-2.4/bin/sonar-runner -e -D sonar.login=${SONAR_ACCOUNT_LOGIN} -D sonar.password=${SONAR_ACCOUNT_PASSWORD}'
      }
    }

    stage('Get Artifact') {
      agent {
        docker {
          image 'maven:3.5.0'
          args '-e admin -e password'
        }
      }
      steps {
        sh 'mvn clean'
        script {
          pom = readMavenPom file: 'pom.xml'
          getArtifact(pom.groupId, pom.artifactId, pom.version, 'petclinic')
        }
      }
    }

    stage('Build container') {
      agent any
      steps {
        script {
          if ( env.BRANCH_NAME == 'master' ) {
            pom = readMavenPom file: 'pom.xml'
            TAG = pom.version
          } else {
            TAG = env.BRANCH_NAME
          }
          sh "docker build -t ${IMAGE}:${TAG} ."
        }
      }
    }

    stage('Run local container') {
      agent any
      steps {
        sh 'docker rm -f petclinic-tomcat-temp || true'
        sh "docker run -d --name petclinic-tomcat-temp ${IMAGE}:${TAG}"
      }
    }

    stage('Smoke-Test & OWASP Security Scan') {
      agent {
        docker {
          image 'maven:3.5.0'
          args '--network=${LDOP_NETWORK_NAME}'
        }
      }
      steps {
        sh "cd regression-suite && mvn clean -B test -DPETCLINIC_URL=http://petclinic-tomcat-temp:8080/petclinic/"
      }
    }
    stage('Stop local container') {
      agent any
      steps {
        sh 'docker rm -f petclinic-tomcat-temp || true'
      }
    }

    stage('Deploy to dev') {
      when {
        branch 'master'
      }
      agent any
      steps {
        sh "docker run -d petclinic-tomcat-temp ${IMAGE}:${TAG}"
      }
    }
    
    stage('Smoke test dev') {
      steps {
        sh "echo Smoked like salmon!"
      }
    }

  }
}
