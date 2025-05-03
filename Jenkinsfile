pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS_ID = 'Pradhisha-N'
        GIT_REPO_URL = 'https://github.com/Pradhisha-N/microservice-repo.git'
        DOCKER_IMAGE_NAME = 'microservice-image'
        DOCKER_REGISTRY = 'pradhisha'
        SONARQUBE = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the correct branch
                git branch: "${BRANCH_NAME}", url: "${GIT_REPO_URL}"
            }
        }

        stage('Build and Test') {
            steps {
                sh '''
                mvn clean install
                echo "Listing contents of target directory:"
                ls -lah target
                '''
            }
        }

        stage('Check JAR') {
            steps {
                sh 'test -f target/microservice-0.0.1-SNAPSHOT.jar && echo "JAR exists" || (echo "JAR missing!" && exit 1)'
            }
        }

        stage('SonarQube Analysis') {
            when {
                anyOf {
                    branch pattern: "Feature/.*", comparator: "REGEXP"
                    branch 'Develop'
                    branch 'Main'
                }
            }
            steps {
                script {
                    withSonarQubeEnv(SONARQUBE) {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=microservice'
                    }
                }
            }
        }

        stage('Docker Build') {
            when {
                anyOf {
                    branch 'Develop'
                    branch 'Main'
                }
            }
            steps {
                sh '''
                echo "Building Docker image..."
                docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Push to Docker Registry') {
            when {
                anyOf {
                    branch 'Develop'
                    branch 'Main'
                }
            }
            steps {
                sh 'docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:${BUILD_NUMBER}'
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                branch 'Develop'
            }
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
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
