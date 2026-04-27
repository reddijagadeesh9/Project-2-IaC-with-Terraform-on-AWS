# Project 2: Infrastructure as Code with Terraform on AWS

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
* Auto Scaling Group

Features:

* IMDSv2 enabled

### Step 7: Database Module

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

### Step 9: Code Quality & Security

Installed:

```bash
tflint
checkov
pre-commit
```

Configured `.pre-commit-config.yaml`

Run:

```bash
pre-commit run --all-files
```

### Step 10: GitHub Actions CI/CD

Created workflow:

```yaml
fmt → validate → tflint → checkov → plan → apply
```

Added GitHub Secrets:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

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
