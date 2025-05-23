pipeline {
    agent any

    environment {
        IMAGE_NAME = 'calculator-app'
        DOCKERHUB_REPO = 'divine2200/calculator-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'project-1', url: 'https://github.com/Divine-Yawson/proj-mdp-152-155.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKERHUB_REPO}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    script {
                        docker.withRegistry('', 'dockerhub-creds') {
                            dockerImage.push("${env.BUILD_NUMBER}")
                        }
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker stop calculator-app || true'
                    sh 'docker rm calculator-app || true'

                    docker.image("${DOCKERHUB_REPO}:${env.BUILD_NUMBER}").run(
                        "--name calculator-app -p 8080:8080 -d"
                    )
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
