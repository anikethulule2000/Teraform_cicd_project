# DevOps Assessment Documentation

## Automated AWS Deployment Pipeline with Terraform, GitHub, and Jenkins

---

### 1. Project Overview

This project automates the deployment of a web application on AWS using Infrastructure as Code (IaC) with Terraform, triggered by GitHub commits, and managed via Jenkins CI/CD pipeline.

**Key Features**

- ✓ Infrastructure as Code (IaC) – AWS resources defined in Terraform  
- ✓ Automated CI/CD Pipeline – Triggered by GitHub commits (Poll SCM)  
- ✓ Secure AWS Environment – VPC, Subnets, Security Groups with least privilege  
- ✓ Self-Documented – Clear README, architecture diagram, and setup instructions  
- ✓ Manual Approval Gate – Ensures controlled deployments  

---

### 2. Architecture Diagram

![architecture-diagram](https://github.com/user-attachments/assets/0584e617-d441-4e2b-bd93-098838f3e1fd)

**AWS Components**

- VPC (10.0.0.0/16) with Public & Private Subnets  
- EC2 Instance (t2.micro) running Apache Web Server  
- Security Groups (HTTP/HTTPS/SSH access)  
- Internet Gateway & Route Tables  
- Jenkins Pipeline (Terraform Init →  Plan → Approve → Apply)  

---

### 3. Prerequisites

Before running this project, ensure you have:

**1. AWS Account**  
- IAM User with Programmatic Access (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)  
- Required Permissions:  
  - `AmazonEC2FullAccess`  
  - `AmazonVPCFullAccess`  
  - `IAMReadOnlyAccess` (optional)  

**2. GitHub Account**  
- A repository to store Terraform code  

**3. Jenkins Server**  
- Installed and accessible (local/cloud)  
- Plugins:  
  - Terraform
   - Git 
   - Pipeline 
   - Email Extension 

**4. Local Machine Setup**  
- Terraform (v1.0+)  
- AWS CLI (configured with credentials)  
- Git  

---

### 4. Setup Instructions

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
      


4. **Create a New Pipeline Job**  
   - Choose **Pipeline** type  
   - Use **Pipeline script from SCM**  
   - Set GitHub repo and path to Jenkinsfile  
   - Set **Poll SCM**: `* * * * *`  



### 5. Pipeline Execution Flow

| Stage                | Action                                      |
|----------------------|---------------------------------------------|
| 1. Checkout          | Pulls latest code from GitHub               |
| 2. Terraform Init    | Initializes Terraform backend               |
| 3. Terraform Validate| Validates Terraform configuration files     |
| 4. Terraform Plan    | Shows infrastructure changes                |
| 5. Manual Approval   | Requires admin approval before applying     |
| 6. Terraform Apply   | Provisions AWS resources                    |
| 7. Verify Deployment | Checks if the web server is accessible (HTTP 200) |

---

### 6. Accessing the Deployed Application

After successful deployment:  
- Web Server URL: `http://<EC2_PUBLIC_IP>`  
- Find Public IP:
```bash
terraform output web_server_public_ip
```

**Expected Output:**  
- "Hello World"

---

### 7. Cleanup (Destroy Infrastructure)

**Option 1: Manual Cleanup**
```bash
terraform destroy
```

**Option 2: Jenkins Cleanup Stage (Optional)**

Add a post-build stage in `Jenkinsfile`:
```groovy
post {
  cleanup {
    sh 'terraform destroy -auto-approve'
  }
}
```

---

### 8. Security Best Practices

- IAM Least Privilege – Only necessary permissions  
- No Hardcoded Secrets – AWS keys stored in Jenkins credentials  
- Secure Subnets – Private subnet for databases (future use)  
- Terraform State Security – Remote backend with S3 & DynamoDB (optional)  

---

### 9. Troubleshooting

| Issue                  | Solution                                  |
|------------------------|-------------------------------------------|
| Jenkins not triggering | Check Poll SCM schedule and Jenkins logs |
| Terraform Plan Errors  | Run `terraform validate` locally         |
| EC2 Not Accessible     | Verify Security Groups & Route Tables     |
| Apache Not Running     | Check EC2 user_data logs (`/var/log/cloud-init-output.log`) |

---

### 10. Future Improvements

- Remote State Management (S3 + DynamoDB)  
- Multi-Environment Support (Dev/Staging/Prod)  
- Blue-Green Deployments (Using Load Balancer)  
- Infrastructure Testing (Terratest)  

---

### Conclusion

This project demonstrates a fully automated AWS deployment pipeline using Terraform + Jenkins + GitHub, following Infrastructure as Code (IaC) and DevOps best practices.
