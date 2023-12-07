pipeline {
<<<<<<< Updated upstream

    parameters {
        string(name: 'DOCKER_BUILD_IMAGE', defaultValue: 'shegerlab23.jfrog.io/docker/ami-builder:env', description: 'Docker build image')
        string(name: 'DOCKER_URL', defaultValue: 'shegerlab23.jfrog.io', description: 'Docker registry URL')
        string(name: 'ZTPT_ACCOUNT', defaultValue: 'jfrog-api-token', description: 'JFrog API token credential ID')
    }

    agent {
        docker {
            label params.AGENT
            alwaysPull true
            image params.DOCKER_BUILD_IMAGE
            registryUrl "https://${params.DOCKER_URL}"
            registryCredentialsId params.ZTPT_ACCOUNT
            args '--entrypoint=\'\' -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Build Config') {
            steps {
                sh 'packer -version'
            }
        }

        stage('Initialize Packer') {
            steps {
                initializePacker()
            }
        }

        stage('Format Packer Configuration') {
            steps {
                formatPackerConfiguration()
=======
 agent {
    dockerfile {
        filename 'Dockerfile'
        dir '.'
        args '--entrypoint=\'\' -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

    stages {
        stage('Format Packer Configuration') {
            steps {
                script {
                    sh 'packer fmt build.json'
                }
>>>>>>> Stashed changes
            }
        }

        stage('Validate Packer Configuration') {
            steps {
<<<<<<< Updated upstream
                validatePackerConfiguration()
=======
                script {
                    sh 'packer validate build.json'
                }
>>>>>>> Stashed changes
            }
        }

        stage('Build AMI') {
            steps {
<<<<<<< Updated upstream
                buildAMI('AWS_CREDENTIAL_IDS', 'AWS_REGION')
=======
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'AWSCRED',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    script {
                        sh '''
                            cd packer
                            packer build -var "aws_access_key=${AWS_ACCESS_KEY_ID}" -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" -only=ubuntu-ami build.json
                        '''
                    }
                }
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

        cleanup {
            cleanWs()
            cleanUpDockerImages()
        }
    }
}

def initializePacker() {
    dir('packer') {
        script {
            sh 'packer init build.json.pkr.hcl'
        }
    }
}

def formatPackerConfiguration() {
    dir('packer') {
        script {
            sh 'packer fmt build.json.pkr.hcl'
        }
    }
}

def validatePackerConfiguration() {
    dir('packer') {
        script {
            sh 'packer fmt -check=true -diff=true build.json.pkr.hcl && packer validate build.json.pkr.hcl'
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
                    packer build -only=amazon-ebs.ubuntu-ami build.json.pkr.hcl
                """
            }
        }
=======
>>>>>>> Stashed changes
    }
}
