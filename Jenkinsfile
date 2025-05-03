pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS_ID = 'Pradhisha-N'  // Your GitHub credentials ID
        GIT_REPO_URL = 'https://github.com/Pradhisha-N/microservice-repo.git'  // Your repository URL
        DOCKER_IMAGE_NAME = 'microservice'
        DOCKER_REGISTRY = 'pradhisha'
        SONARQUBE = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub using the configured credentials
                git branch: "${GITHUB_CREDENTIALS_ID}", url: "${GIT_REPO_URL}"
            }
        }

        stage('Build and Test') {
            when {
                branch 'Feature/*'
                branch 'Develop'
            }
            steps {
                script {
                    // Run Maven build and tests
                    sh 'mvn clean install'
                }
            }
        }

        stage('SonarQube Analysis') {
            when {
                branch 'Feature/*'
                branch 'Develop'
            }
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
            when {
                branch 'Develop'
            }
            steps {
                script {
                    // Build Docker image from Dockerfile
                    sh 'docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Push to Docker Registry') {
            when {
                branch 'Develop'
            }
            steps {
                script {
                    // Push Docker image to registry
                    sh 'docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                branch 'Develop'
            }
            steps {
                script {
                    // Apply Kubernetes manifests to deploy
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
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
