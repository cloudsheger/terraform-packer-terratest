pipeline {
    agent {
        docker {
            image 'hashicorp/packer'
            args '-v $HOME/.packer.d:/root/.packer.d'
        }
    }

    stages {
        stage('Format Packer Configuration') {
            steps {
                script {
                    sh 'packer fmt build.json'
                }
            }
        }

        stage('Validate Packer Configuration') {
            steps {
                script {
                    sh 'packer validate build.json'
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
                    script {
                        sh '''
                            cd packer
                            packer build -var "aws_access_key=${AWS_ACCESS_KEY_ID}" -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}" -only=ubuntu-ami build.json
                        '''
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
