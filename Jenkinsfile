pipeline {
    agent any

    environment {
        NAME  = "Sai Kumar Mojjada"
        EMAIL = "saikumarmsk7799@gmail.com"
        CLUB  = "lucio"
        LOG_FILE = "logs/output.json"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MojjadaCode-Git/lucio-api-automation.git'
                echo '✅ Source code checked out successfully.'
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    echo "🔹 Installing dependencies..."
                    sudo apt-get update -y
                    sudo apt-get install -y curl jq make git
                    echo "✅ Dependencies installed successfully."
                '''
            }
        }

        stage('Run API Automation') {
            steps {
                sh '''
                    echo "🔹 Running API Automation Script..."
                    chmod +x api_test.sh
                    ./api_test.sh | tee ${LOG_FILE}
                    echo "✅ API Automation script executed."
                '''
            }
        }

        stage('Archive Logs') {
            steps {
                echo "📦 Archiving logs..."
                archiveArtifacts artifacts: 'logs/output.json', fingerprint: true
                echo '✅ Logs archived successfully.'
            }
        }
    }

    post {
        always {
            echo "🧾 Pipeline execution completed."
        }
        success {
            echo "🎉 Build successful! Logs saved in Jenkins artifacts."
        }
        failure {
            echo "❌ Build failed. Please check Jenkins console or logs/output.json for details."
        }
    }
}
