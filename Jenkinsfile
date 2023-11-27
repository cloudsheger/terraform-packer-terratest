pipeline {
    agent {
        docker {
            label params.AGENT
            alwaysPull true
            image env.DOCKER_BUILD_IMAGE
            registryUrl "https://${DOCKER_URL}"
            registryCredentialsId env.DOCKER_CRED
            args '--entrypoint=\'\' -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_LOGIN_TOKEN = 'dockerhub-jenkins-token'
        DOCKER_CRED = credentials("${DOCKER_LOGIN_TOKEN}")
        DOCKER_URL = 'docker.io'
        DOCKER_BUILD_IMAGE = 'cloudsheger/ami-builder:env'
        CURRENT_TIMESTAMP = new Date().format("yyyy-MM-dd-HH-mm")
    }

    stages {
        stage('Build Config') {
            steps {
                sh 'packer -version'
            }
        }

        stage('Initialize Packer') {
            steps {
                dir('packer') {
                    script {
                        sh 'packer init build.json.pkr.hcl'
                    }
                }
            }
        }

        // Add other stages as needed

        stage('Build AMI') {
            steps {
                dir('packer') {
                    buildAMI('AWS_CREDENTIAL_IDS', 'AWS_REGION')
                }
            }
        }
    }

    post {
        success {
            echo 'Packer commands executed successfully!'
        }
        failure {
            error 'Packer commands failed!'
        }

        cleanup {
            cleanWs()
            cleanUpDockerImages()
        }
    }
}

def buildAMI(awsAccessKeyIdCredentialId, awsRegionCredentialId) {
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
                packer build -only=amazon-ebs.ubuntu-ami build.json.pkr.hcl
            """
        }
    }
}
