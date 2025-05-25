pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_VAR_key_name      = 'test234'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        
        
       

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    def WEB_URL = sh(script: 'terraform output -raw web_server_url', returnStdout: true).trim()
                    echo "Web server URL: ${WEB_URL}"
                    
                    
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo 'Pipeline succeeded!'
            
        }
        failure {
            echo 'Pipeline failed!'
        }
        cleanup {
            // Clean up workspace
            cleanWs()
        }
    }
}
