pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Pradhisha-N/microservice-repo.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean install'
                sh 'ls target'

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
                sh 'docker build -t pradhisha/microservice-image:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                    sh 'docker push pradhisha/microservice-image:latest'
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
}
