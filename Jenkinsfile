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
                echo '✅ Source code checked out'
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    echo "🔹 Installing dependencies..."
                    apt-get update -y
                    apt-get install -y curl jq make git
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
            echo "🎉 Build successful!"
        }
        failure {
            echo "❌ Build failed. Check console or logs/output.json for details."
        }
    }
}
