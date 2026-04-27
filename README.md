# Project 2: Infrastructure as Code with Terraform on AWS

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/e8a386bc-c3dc-4ff0-8253-effd59364e0d" />


## Overview

This project provisions and manages a complete AWS infrastructure stack using **Terraform** with a **modular architecture**.

The infrastructure includes:

* VPC
* Public & Private Subnets across 2 Availability Zones
* Internet Gateway & Route Tables
* Security Groups
* EC2 Launch Template
* Auto Scaling Group
* RDS MySQL Database in Private Subnets
* Remote Backend using S3 + DynamoDB
* TFLint + Checkov + pre-commit hooks
* GitHub Actions CI/CD pipeline

---

## Architecture Diagram

```text
                +----------------------+
                |      GitHub Repo      |
                |  GitHub Actions CI/CD |
                +----------+-----------+
                           |
                           v
                 Terraform Init / Plan / Apply
                           |
                           v
+---------------------------------------------------------------+
|                            AWS Cloud                           |
|                                                               |
|  +--------------------- VPC -------------------------------+   |
|  |                                                        |   |
|  |  Public Subnet AZ-a       Public Subnet AZ-b          |   |
|  |  +----------------+       +----------------+          |   |
|  |  | EC2 via ASG    |       | EC2 via ASG    |          |   |
|  |  +----------------+       +----------------+          |   |
|  |                                                        |   |
|  |  Private Subnet AZ-a      Private Subnet AZ-b         |   |
|  |  +----------------+       +----------------+          |   |
|  |  |   RDS MySQL    |<----->| Standby (Multi-AZ)|       |   |
|  |  +----------------+       +----------------+          |   |
|  +--------------------------------------------------------+   |
+---------------------------------------------------------------+
```

---

## Project Structure

```bash
terraform-aws-infra/
├── .github/workflows/terraform.yml
├── .pre-commit-config.yaml
├── backend.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── variables.tf
├── versions.tf
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── database/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

## Step-by-Step Implementation

### Step 1: Install Tools

```bash
sudo apt update
sudo apt install unzip git -y
```

Install Terraform, AWS CLI, Git.

### Step 2: Configure Terraform Basics

Created:

* versions.tf
* provider.tf
* variables.tf

Run:

```bash
terraform init
terraform validate
```

### Step 3: Configure Remote Backend

Created:

* S3 Bucket for state file
* DynamoDB table for locking

backend.tf:

```hcl
terraform {
  backend "s3" {
    bucket         = "jagadeesh-terraform-state-12345"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock"
  }
}
```

### Step 4: Networking Module

Created:
VPC

<img width="1614" height="770" alt="Screenshot 2026-04-27 153924" src="https://github.com/user-attachments/assets/52b8bf23-2a60-4df8-a7d4-69c58823e9cc" />

SUBNETS

<img width="1601" height="459" alt="Screenshot 2026-04-27 154014" src="https://github.com/user-attachments/assets/d669b517-cab9-46e2-b019-06ca3b0fc42b" />

ROUTE TABLES

<img width="1607" height="718" alt="Screenshot 2026-04-27 154045" src="https://github.com/user-attachments/assets/5f8ee03b-f49a-409f-b882-b5182629b0e8" />

INTERNET GATEWAY

<img width="1581" height="689" alt="Screenshot 2026-04-27 154100" src="https://github.com/user-attachments/assets/7547a708-b4b1-412d-8e69-f89d838fb284" />

* VPC
* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* Route Table
* Associations

Run:

```bash
terraform plan
terraform apply --auto-approve
```

### Step 5: Security Module

Created Security Groups:

* EC2 SG → SSH, HTTP, HTTPS
* RDS SG → MySQL from EC2 SG

### Step 6: Compute Module

Created:

* Launch Template
<img width="1565" height="701" alt="Screenshot 2026-04-27 154817" src="https://github.com/user-attachments/assets/25ae86d9-6593-41fa-81b6-08206cf21d41" />

  
* Auto Scaling Group
  <img width="1557" height="684" alt="Screenshot 2026-04-27 154556" src="https://github.com/user-attachments/assets/0ad28cfd-36c5-4677-8904-5d69643b1288" />
  
*Ec2 Instances
<img width="1579" height="728" alt="Screenshot 2026-04-27 154700" src="https://github.com/user-attachments/assets/248e6094-0573-4eb5-9d87-c8e8beda6420" />

Features:

* IMDSv2 enabled

### Step 7: Database Module
<img width="1833" height="761" alt="Screenshot 2026-04-27 155056" src="https://github.com/user-attachments/assets/19fa4fce-c752-47b9-93fd-3bb308855fa5" />


Created:

* DB Subnet Group
* RDS MySQL Instance

Features:

* Multi-AZ
* Encrypted Storage
* Deletion Protection
* Auto Minor Upgrade
* Copy Tags to Snapshot

### Step 8: Outputs

Created outputs for:

* Launch Template ID
* ASG Name
* RDS Endpoint
  
  <img width="1169" height="253" alt="Screenshot 2026-04-27 152439" src="https://github.com/user-attachments/assets/d554f6f2-3955-4d6f-be00-56f6d4f5bf42" />


### Step 9: Code Quality & Security

Installed:

```bash
tflint
checkov
pre-commit
```

checkov:

<img width="1100" height="589" alt="Screenshot 2026-04-27 155535" src="https://github.com/user-attachments/assets/bf311a03-9884-4139-9f62-97a6f17b9e49" />

Pre-commit:

<img width="1079" height="572" alt="Screenshot 2026-04-27 155819" src="https://github.com/user-attachments/assets/d13ba79e-52a8-4dfb-84d9-75e61182bc97" />



Configured `.pre-commit-config.yaml`

Run:

```bash
pre-commit run --all-files
```

### Step 10: GitHub Actions CI/CD

<img width="1906" height="850" alt="Screenshot 2026-04-27 151758" src="https://github.com/user-attachments/assets/2c984765-804b-45cf-b46b-fcb41c618479" />


Created workflow:

```yaml
fmt → validate → tflint → checkov → plan → apply
```

Added GitHub Secrets:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* 
<img width="1013" height="306" alt="Screenshot 2026-04-27 153417" src="https://github.com/user-attachments/assets/e4a069d9-7815-4e56-baf0-45ae6cbdd738" />


---

## Commands Used Frequently

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply --auto-approve
terraform output
```

---

## Outputs Example

```bash
autoscaling_group_name = "terraform-20260427070759109000000003"
launch_template_id = "lt-029743474db78d257"
rds_endpoint = "terraform-20260427093343743400000002.cluwyo0qcenk.eu-north-1.rds.amazonaws.com:3306"
```
<img width="1169" height="253" alt="Screenshot 2026-04-27 152439" src="https://github.com/user-attachments/assets/9d0f2b6b-5d29-4dd1-8ab9-dc8cc1e5c407" />

### Connection Details

```text
Host: terraform-20260427093343743400000002.cluwyo0qcenk.eu-north-1.rds.amazonaws.com
Port: 3306
User: admin
Database: mydb
```

---

## Best Practices Implemented

* Modular Terraform code
* Remote backend
* State locking
* Security scanning
* Linting
* CI/CD automation
* Multi-AZ database
* Encryption at rest
* IMDSv2 enabled

---

## Future Enhancements

* Route 53 DNS
* Terraform Workspaces
* Scheduled Drift Detection
* PR comments with Terraform Plan

---

## Author

**REDDI JAGADEESWARA RAO**
