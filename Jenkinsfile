pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'microservice-image'
        DOCKER_REGISTRY = 'pradhisha'
        SONARQUBE = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git branch: 'main', url: 'https://github.com/Pradhisha-N/microservice-repo.git'
            }
        }

        stage('Build and Test') {
            
            steps {
                script {
                    // Run Maven build and tests
                    sh 'mvn clean install'
                }
            }
        }

        stage('SonarQube Analysis') {
            
            steps {
                script {
                    // Perform SonarQube analysis
                    withSonarQubeEnv(SONARQUBE) {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=microservice'
                    }
                }
            }
        }

        stage('Docker Build') {
            
            steps {
                script {
                    // Build Docker image from Dockerfile
                    sh '''
                    docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push to Docker Registry') {
            
            steps {
                script {
                    // Push Docker image to registry
                    sh '''
                    docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:${BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            
            steps {
                script {
                    // Apply Kubernetes manifests to deploy
                    sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
