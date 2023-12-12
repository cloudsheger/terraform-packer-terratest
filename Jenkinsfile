// Added Jenkins global config shared libraries
@Library('jenkins-devops-libs@master')_

pipeline {

    parameters {
        string(name: 'DOCKER_BUILD_IMAGE', defaultValue: 'hadid.jfrog.io/docker/ami-builder:3', description: 'Docker build image')
        string(name: 'DOCKER_URL', defaultValue: 'hadid.jfrog.io', description: 'Docker registry URL')
        string(name: 'ZTPT_ACCOUNT', defaultValue: 'jfrog-api-token', description: 'JFrog API token credential ID')
        string(name: 'AGENT', defaultValue: 'docker', description: 'JFrog API token credential ID')

    }
    environment{
        AWS_CREDENTIAL_IDS = 'AWS_CREDENTIAL_IDS'
        AWS_REGION = 'AWS_REGION'
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
        dir('packer') {
          script {
            sh 'ls -la'
            packer.init(dir: '.')
          }     
        }
      }
    }
    stage('Validate') {
      steps {
        dir('packer') {
          script {
            packer.validate(template: '.')
          }
        }  
      }
    }

   stage('Format') {
      steps {
        dir('packer') {
          script {
            packer.fmt(
            check: true,
            diff: true,
            template: '.'
            )
          }
        }
      }
    }

    stage('Inspect') {
      steps {
        dir('packer') {
          script {
            packer.inspect('.')
          }
        }  
      }
    }

    stage('Build') {
      steps {
        buildAMI('AWS_CREDENTIAL_IDS', 'AWS_REGION')
      }
    }
  }
  post {
        always {
            cleanWs()
            //cleanUpDockerImages()
        }
  }
}

def buildAMI(awsAccessKeyIdCredentialId, awsRegionCredentialId) {
    dir('packer') {
        withCredentials([
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                credentialsId: awsAccessKeyIdCredentialId,
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]
        ]) {
            script {
                sh """
                    aws configure set aws_access_key_id "\${AWS_ACCESS_KEY_ID}"
                    aws configure set aws_secret_access_key "\${AWS_SECRET_ACCESS_KEY}"
                    aws configure set default.region "\${awsRegionCredentialId}"
                """
              packer.build(template: '.')
            }
        }
    }
}
