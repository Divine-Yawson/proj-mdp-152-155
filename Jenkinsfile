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
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG_FILE')]) {
                    script {
                        sh '''
                            export KUBECONFIG=$KUBECONFIG_FILE

                            # Update the image tag in the deployment file
                            sed -i 's|image:.*|image: divine2200/calculator-app:${BUILD_NUMBER}|' ${DEPLOYMENT_FILE}

                            # Apply the Kubernetes manifests
                            kubectl apply -f ${DEPLOYMENT_FILE}
                            kubectl apply -f ${SERVICE_FILE}
                        '''
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG_FILE
                        kubectl get pods -o wide
                        kubectl get svc -o wide
                    '''
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
