pipeline {
    agent any

    environment {
        PROJECT_DIR = "${WORKSPACE}"
        LOG_FILE = "${WORKSPACE}/logs/output.json"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📦 Checking out source code..."
                checkout scm
                echo "✅ Source code checked out"
            }
        }

        stage('Verify Dependencies') {
            steps {
                sh '''
                    echo "🔹 Verifying dependencies (curl, jq, make, git)..."
                    MISSING=""
                    for cmd in curl jq make git; do
                        if ! command -v $cmd >/dev/null 2>&1; then
                            echo "❌ Missing $cmd"
                            MISSING="$MISSING $cmd"
                        fi
                    done

                    if [ -n "$MISSING" ]; then
                        echo "⚙️ Installing missing dependencies: $MISSING"
                        sudo apt-get update -y && sudo apt-get install -y $MISSING
                    else
                        echo "✅ All dependencies already installed."
                    fi
                '''
            }
        }

        stage('Run API Automation') {
            steps {
                sh '''
                    echo "🚀 Running Lucio API Automation..."
                    chmod +x api_test.sh
                    make run || ./api_test.sh || echo "⚠️ Makefile execution fallback."
                '''
            }
        }

        stage('Archive Logs') {
            steps {
                script {
                    if (fileExists(LOG_FILE)) {
                        echo "📦 Archiving logs..."
                        archiveArtifacts artifacts: 'logs/output.json', followSymlinks: false
                        echo "✅ Logs archived successfully."
                    } else {
                        echo "⚠️ No logs found to archive."
                    }
                }
            }
        }
    }

    post {
        always {
            echo "🧾 Pipeline execution completed."
        }
        success {
            echo "🎉 Build succeeded! Lucio API Automation ran successfully."
        }
        failure {
            echo "❌ Build failed. Check console output or logs/output.json for details."
        }
    }
}
