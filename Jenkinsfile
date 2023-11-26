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
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                credentialsId: awsAccessKeyIdCredentialId,
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]
        ]) {
            script {
                sh """
                    packer build \
                    -var 'aws_access_key=${AWS_ACCESS_KEY_ID}' \
                    -var 'aws_secret_key=${AWS_SECRET_ACCESS_KEY}' \
                    -var 'aws_region=${AWS_REGION}' \
                    -only=ubuntu-ami build.json.pkr.hcl
                """
            }
        }
    }
}
