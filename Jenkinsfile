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
                dir('packer') {
                    script {
                        sh 'packer init build.json.pkr.hcl'
                    }
                }
            }
        }

        stage('Format Packer Configuration') {
            steps {
                dir('packer') {
                    script {
                        sh 'packer fmt build.json.pkr.hcl'
                    }
                }
            }
        }

        stage('Validate Packer Configuration') {
            steps {
                dir('packer') {
                    script {
                        sh 'packer fmt -check=true -diff=true build.json.pkr.hcl && packer validate build.json.pkr.hcl'
                    }
                }
            }
        }

        stage('Build AMI') {
            steps {
                packerBuild('AWS_CREDENTIAL_IDS', 'AWS_REGION')
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



def packerBuild(awsAccessKeyIdCredentialId,awsRegionCredentialId) {
    dir('packer') {
        withCredentials([
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: awsAccessKeyIdCredentialId,
                usernameVariable: 'AWS_ACCESS_KEY',
                passwordVariable: 'AWS_SECRET_KEY'
            ]
        ]) {
            script {
                sh """
                    aws configure set aws_access_key_id "${AWS_ACCESS_KEY}"
                    aws configure set aws_secret_access_key "${AWS_SECRET_KEY}"
                    aws configure set default.region "${awsRegionCredentialId}"
                    packer build -only=ubuntu-ami build.json.pkr.hcl
                """
            }
        }
    }
}
