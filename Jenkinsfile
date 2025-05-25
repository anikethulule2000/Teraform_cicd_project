pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_VAR_key_name      = 'test2345'
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
        
        
        stage('Manual Approval') {
            steps {
                script {
                    def userInput = input(
                        id: 'userInput', message: 'Do you want to proceed?', parameters: [
                            choice(name: 'Proceed', choices: ['Yes', 'No'], description: 'Select Yes to continue')
                        ]
                    )
                    if (userInput == 'No') {
                        error("Pipeline stopped by user.")
                    }
                }
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

					def response = sh(script: "curl -s -o /dev/null -w \"%{http_code}\" ${WEB_URL}", returnStdout: true).trim()
					if (response == '200') {
						echo "Website is running fine. HTTP Status: ${response}"
					} else {
						error("Website verification failed. HTTP Status: ${response}")
					}
				}
			}
		}

    }
    
    post {
        success {
            echo 'Pipeline succeeded!'
            
        }
        failure {
            echo 'Pipeline failed!'
        }
        
    }
}
