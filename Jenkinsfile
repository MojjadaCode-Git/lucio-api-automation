pipeline {
    agent any

    environment {
        EMAIL = "saikumarmsk7799@gmail.com"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "✅ Source code checked out"
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    sudo apt-get update -y
                    sudo apt-get install -y make curl jq
                '''
            }
        }

        stage('Run API Automation') {
            steps {
                sh 'make run'
            }
        }

        stage('Archive Logs') {
            steps {
                archiveArtifacts artifacts: 'logs/output.json', fingerprint: true
                echo "📦 Logs archived as Jenkins artifact"
            }
        }
    }

    post {
        always {
            echo "🧾 Pipeline execution completed."
        }
    }
}

