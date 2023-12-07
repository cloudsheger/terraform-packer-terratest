// for dynamic retrieval
library identifier: 'jenkins-devops-libs@master', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'https://github.com/cloudsheger/jenkins-devops-libs.git'])
// if added in Jenkins global config shared libraries
//@Library('jenkins-devops-libs')_
// if added in Jenkins global config shared libraries and the github api plugin is bugging out and slamming github with requests
//library('jenkins-devops-libs')_


pipeline {

    parameters {
        string(name: 'DOCKER_BUILD_IMAGE', defaultValue: 'hadid.jfrog.io/docker/ami-builder:env', description: 'Docker build image')
        string(name: 'DOCKER_URL', defaultValue: 'hadid.jfrog.io', description: 'Docker registry URL')
        string(name: 'ZTPT_ACCOUNT', defaultValue: 'jfrog-cred.hadid', description: 'JFrog API token credential ID')
        string(name: 'AGENT', defaultValue: 'docker', description: 'JFrog API token credential ID')
    }

    agent {
        docker {
            label params.AGENT
            alwaysPull true
            image params.DOCKER_BUILD_IMAGE
            registryUrl "https://${params.DOCKER_URL}"
            registryCredentialsId params.ZTPT_ACCOUNT
            //args '--entrypoint=\'\' -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
    stage('Init') {
      steps {
        sh 'curl -L https://raw.githubusercontent.com/cloudsheger/terraform-packer-terratest/master/packer/build.json.pkr.hcl -o build.json.pkr.hcl'
        //sh 'curl -L https://raw.githubusercontent.com/cloudsheger/ansible-terraform-packer/main/scripts/ubuntu.pkr.json -o ubuntu.pkr.json'

        script {
          packer.init(dir: '.')
        }
      }
    }
    stage('Check Docker') {
            steps {
                script {
                    echo "PATH: ${env.PATH}"
                    sh 'docker version'
                }
            }
        }  
    stage('Validate') {
      steps {
        script {
          packer.validate(template: 'build.json.pkr.hcl')
        }
      }
    } 
   stage('Format') {
      steps {
        script {
          packer.fmt(
            check: true,
            diff: true,
            template: '.'
          )
        }
      }
    }

    stage('Inspect') {
      steps {
        script {
          packer.inspect('build.json.pkr.hcl')
        }
      }
    }

    stage('Build') {
      steps {
        script {
          packer.build(template: 'build.json.pkr.hcl')
        }
      }
    }
  }
}

