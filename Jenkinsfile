pipeline {
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
                dir('packer') {
                    script {
                        try {
                            sh 'packer fmt build.json'
                        } catch (Exception e) {
                            error "Failed to format build.json. ${e.getMessage()}"
                        }
                    }
                }
            }
        }

        stage('Validate Packer Configuration') {
            steps {
                dir('packer') {
                    script {
                        try {
                            sh 'packer validate build.json'
                        } catch (Exception e) {
                            error "Failed to validate build.json. ${e.getMessage()}"
                        }
                    }
                }
            }
        }

        stage('Build AMI') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'AWSCRED',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    dir('packer') {
                        script {
                            try {
                                sh 'packer build -var "aws_access_key=${AWS_ACCESS_KEY_ID}" -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" -only=ubuntu-ami build.json'
                            } catch (Exception e) {
                                error "Failed to build AMI. ${e.getMessage()}"
                            }
                        }
                    }
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
    }
}
