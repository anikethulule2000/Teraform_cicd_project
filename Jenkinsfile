pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_VAR_key_name       = 'terraform_test'
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

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    def userInput = input(
                        id: 'userInput',
                        message: 'Do you want to proceed?',
                        parameters: [
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

					echo "Waiting for 2 minutes before verifying the deployment..."
					sleep(time: 3, unit: 'MINUTES')

					def response = sh(script: "curl -s -o /dev/null -w \"%{http_code}\" ${WEB_URL}", returnStdout: true).trim()
					if (response == '200') {
						echo "Website is running fine. HTTP Status: ${response}"
					} else {
						error("Website verification failed. HTTP Status: ${response}")
					}

					// Save WEB_URL to env for use in post block
					env.DEPLOYED_URL = WEB_URL
				}
			}
		}
    }

    post {
        success {
            echo 'Pipeline succeeded!'
            mail to: 'anikethulule7219@gmail.com',
                 subject: "SUCCESS: Jenkins Pipeline '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                 body: """Good news!

The pipeline has completed successfully.

Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
Build URL: ${env.BUILD_URL}
Website URL: ${env.DEPLOYED_URL}
"""
        }
        failure {
            echo 'Pipeline failed!'
            mail to: 'anikethulule7219@gmail.com',
                 subject: "FAILURE: Jenkins Pipeline '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                 body: """Attention required!

The pipeline has failed.

Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
Build URL: ${env.BUILD_URL}
"""
        }
    }
}
