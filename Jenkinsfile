pipeline {
    agent any

    environment {
        IMAGE_NAME = 'pradhisha/microservice-image'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Pradhisha-N/microservice-repo.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Verify JAR') {
            steps {
                sh 'ls -lh target'
                sh 'test -f target/microservice-0.0.1-SNAPSHOT.jar'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline completed successfully.'
        }
    }
}
