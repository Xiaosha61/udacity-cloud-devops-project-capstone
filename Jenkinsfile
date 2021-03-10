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
                  sh 'docker push xiaoshax/dummy_node_service'
              }
         }
    }
}
