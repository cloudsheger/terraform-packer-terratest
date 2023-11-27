pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            dir '.'
            args '--entrypoint=\'\' -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Initialize Packer') {
            steps {
                initializePacker()
            }
        }

        stage('Format Packer Configuration') {
            steps {
                formatPackerConfiguration()
            }
        }

        stage('Validate Packer Configuration') {
            steps {
                validatePackerConfiguration()
            }
        }

        stage('Build AMI') {
            steps {
                buildAMI('AWS_CREDENTIAL_IDS', 'AWS_REGION')
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
    }
}
