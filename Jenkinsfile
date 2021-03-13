pipeline {
    agent any
    // agent {
    //     dockerfile {
    //         filename 'Dockerfile'
    //     }
    // }
    environment {
        HOME = '.'
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm --version'
                sh 'node --version'
                sh 'npm install'
            }
        }

        stage('Linting') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t dummy_node_service .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker tag dummy_node_service xiaoshax/dummy_node_service"
                withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                    sh 'docker push xiaoshax/dummy_node_service'
                }
            }
        }

        stage('Deploy Application') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-west-2') {
                    sh "aws eks --region us-west-2 update-kubeconfig --name capstone1"
                    sh "kubectl config use-context arn:aws:eks:us-west-2:737302360365:cluster/capstone1"
                    sh "kubectl apply -f deployment/deployment.yml"
                    sh "kubectl get nodes"
                    sh "kubectl get deployment"
                    sh "kubectl get pod -o wide"
                    sh "kubectl get service/udacity-devops-capstone"
                }
            }
        }
    }
}
