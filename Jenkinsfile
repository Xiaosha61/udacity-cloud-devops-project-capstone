pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
        }
    }
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
    }
}
