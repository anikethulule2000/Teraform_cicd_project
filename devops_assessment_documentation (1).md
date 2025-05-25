
# DevOps Assessment Documentation

## Automated AWS Deployment Pipeline with Terraform, GitHub, and Jenkins

---

## 1. Project Overview

This project automates the deployment of a web application on AWS using Infrastructure as Code (IaC) with Terraform, triggered by GitHub commits, and managed via Jenkins CI/CD pipeline.

### Key Features

- **Infrastructure as Code (IaC)** – AWS resources defined in Terraform  
- **Automated CI/CD Pipeline** – Triggered by GitHub commits (Poll SCM)  
- **Secure AWS Environment** – VPC, Subnets, Security Groups with least privilege  
- **Self-Documented** – Clear README, architecture diagram, and setup instructions  
- **Manual Approval Gate** – Ensures controlled deployments  

---

## 2. Architecture Diagram

![architecture-diagram](https://github.com/user-attachments/assets/0584e617-d441-4e2b-bd93-098838f3e1fd)

### AWS Components

- VPC (10.0.0.0/16) with Public & Private Subnets  
- EC2 Instance (t2.micro) running Apache Web Server  
- Security Groups (HTTP/HTTPS/SSH access)  
- Internet Gateway & Route Tables  
- Jenkins Pipeline (Terraform Init → Validate → Plan → Approve → Apply)  

---

## 3. Prerequisites

Ensure the following before starting the setup:

### AWS Account

- IAM User with Programmatic Access (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)  
- Required Permissions:  
  - `AmazonEC2FullAccess`  
  - `AmazonVPCFullAccess`  
  - `IAMReadOnlyAccess` (optional)  

### GitHub Account

- Repository to store Terraform code  

### Jenkins Server

- Installed and accessible (local/cloud)  
- Plugins Required:  
  - Terraform  
  - Git  
  - Pipeline  
  - Email Extension  

### Local Setup

- Terraform (v1.0+)  
- AWS CLI (configured with credentials)  
- Git  

---

## 4. Setup Instructions

### Jenkins Setup (Including Mail Configuration)

1. **Install Required Jenkins Plugins**  
   - Terraform Plugin  
   - Git Plugin  
   - Pipeline Plugin  
   - Email Extension Plugin  

2. **Add AWS Credentials to Jenkins**  
   - Go to: `Manage Jenkins` → `Manage Credentials` → `Global`  
   - Add AWS keys as secret text or username/password  

3. **Configure Email Notification**  
   - Go to: `Manage Jenkins` → `Configure System`  
   - Under **E-mail Notification**:  
     - SMTP Server: e.g., `smtp.gmail.com`  
     - Use SMTP Authentication: Yes  
     - Provide email credentials  
     - SMTP Port: 465 (SSL) or 587 (TLS)  
     - Set system admin email  

   - Under **Extended E-mail Notification**:  
     - Add default subject/content templates if needed  

4. **Create a New Pipeline Job**  
   - Choose **Pipeline** type  
   - Use **Pipeline script from SCM**  
   - Set GitHub repo and path to Jenkinsfile  
   - Set **Poll SCM**: `H/5 * * * *`  

5. **Enable Email Notifications in Jenkinsfile**  
   ```groovy
   post {
     success {
       mail to: 'yourteam@example.com',
            subject: "SUCCESS: Deployment Pipeline",
            body: "The pipeline has successfully deployed the AWS infrastructure."
     }
     failure {
       mail to: 'yourteam@example.com',
            subject: "FAILURE: Deployment Pipeline",
            body: "The pipeline failed. Please check Jenkins for details."
     }
   }
   ```

---

## 5. Pipeline Execution Flow

| Stage                | Action                                      |
|----------------------|---------------------------------------------|
| Checkout             | Pulls latest code from GitHub               |
| Terraform Init       | Initializes Terraform backend               |
| Terraform Plan       | Shows infrastructure changes                |
| Manual Approval      | Requires admin approval before applying     |
| Terraform Apply      | Provisions AWS resources                    |
| Verify Deployment    | Checks if web server is accessible (HTTP 200)|

---

## 6. Accessing the Deployed Application

After successful deployment:

- Web Server URL: `http://<EC2_PUBLIC_IP>`  
- Run to get IP: `terraform output web_server_public_ip`  

**Expected Output**:  
`Hello World`

---

## 7. Cleanup (Destroy Infrastructure)

### Option 1: Manual Cleanup

```bash
terraform destroy
```

### Option 2: Jenkins Cleanup Stage (Optional)

```groovy
post {
  cleanup {
    sh 'terraform destroy -auto-approve'
  }
}
```

---

## 8. Security Best Practices

- **IAM Least Privilege** – Grant only required permissions  
- **No Hardcoded Secrets** – Use Jenkins credentials store  
- **Secure Subnets** – Future-ready for private DB tier  
- **State File Security** – Use remote backend with S3 & DynamoDB (optional)  

---

## 9. Troubleshooting

| Issue                  | Solution                                  |
|------------------------|-------------------------------------------|
| Jenkins not triggering | Check Poll SCM & Jenkins logs            |
| Terraform Errors       | Run `terraform validate` locally         |
| EC2 Inaccessible       | Verify Security Groups & Route Tables     |
| Apache Not Running     | Check EC2 logs (`/var/log/cloud-init-output.log`) |

---

## 10. Future Improvements

- Remote State Management (S3 + DynamoDB)  
- Multi-Environment Support (Dev/Staging/Prod)  
- Blue-Green Deployments using Load Balancer  
- Infrastructure Testing with Terratest  

---

## Conclusion

This project demonstrates a fully automated AWS deployment pipeline using Terraform + Jenkins + GitHub, adhering to IaC and DevOps best practices.
