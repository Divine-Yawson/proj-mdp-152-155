pipeline {
    agent any

    environment {
        IMAGE_NAME = 'calculator-app'
        DOCKERHUB_REPO = 'divine2200/calculator-app'
        DEPLOYMENT_FILE = 'k8s/deployment.yaml'
        SERVICE_FILE = 'k8s/service.yaml'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'project-3', url: 'https://github.com/Divine-Yawson/proj-mdp-152-155.git'
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
                            dockerImage.push("latest")
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update the image tag in your Kubernetes deployment manifest
                    sh "sed -i 's|image:.*|image: ${DOCKERHUB_REPO}:${env.BUILD_NUMBER}|' ${DEPLOYMENT_FILE}"

                    // Apply the updated Kubernetes manifests
                    sh "kubectl apply -f ${DEPLOYMENT_FILE}"
                    sh "kubectl apply -f ${SERVICE_FILE}"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh "kubectl get pods -o wide"
                sh "kubectl get svc -o wide"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
