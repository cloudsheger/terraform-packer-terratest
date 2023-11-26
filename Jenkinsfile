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
                        sh 'packer fmt build.json'
                    }
                }
            }
        }

        stage('Validate Packer Configuration') {
            steps {
                dir('packer') {
                    script {
                        sh 'packer validate build.json'
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
                            sh 'packer build -var "aws_access_key=${AWS_ACCESS_KEY_ID}" -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" -only=ubuntu-ami build.json'
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
