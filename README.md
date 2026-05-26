# Terraform AWS Infrastructure Project

## Project Overview

This project provisions a production-style AWS cloud infrastructure environment using Terraform and Infrastructure as Code (IaC) principles. The primary objective of this project is to demonstrate practical DevOps and Cloud Engineering skills by automating the deployment, configuration, and governance of AWS infrastructure resources.

The infrastructure includes secure networking, compute resources, cloud storage, database services, remote Terraform state management, and Policy-as-Code validation using Open Policy Agent (OPA). The project follows modular Terraform design practices, enabling reusable, scalable, and maintainable infrastructure code.

The project follows Infrastructure as Code (IaC) best practices including:

- Modular Terraform structure
- Remote state management
- Resource tagging
- Secure cloud architecture
- Policy validation
- Reusable Terraform modules

---

# Architecture
The infrastructure architecture follows a layered and modular cloud design approach commonly used in enterprise AWS environments. The project separates networking, compute, storage, database, and governance responsibilities into reusable Terraform modules.

The environment is designed with security and scalability considerations in mind. Public-facing resources such as the EC2 instance are deployed in a public subnet, while sensitive backend resources such as the RDS database are deployed within private subnets to reduce external exposure.

Terraform remote state management is implemented using AWS S3 and DynamoDB to support collaborative and production-style infrastructure workflows. Additionally, OPA Policy-as-Code integration validates Terraform plans before deployment to enforce security and compliance standards.

## Infrastructure Components

### Networking
- VPC
- Public subnet
- Private subnets
- Internet Gateway
- Route tables

### Compute
- EC2 instance
- Security groups

### Storage
- Secure S3 bucket
- Versioning enabled
- Encryption enabled
- Public access blocked

### Database
- Private RDS MySQL instance
- DB subnet group
- DB security group

### Terraform Backend
- Remote state stored in S3
- State locking using DynamoDB

### Security & Governance
- OPA Policy-as-Code
- Tag enforcement
- SSH restriction checks
- S3 security validation

---

# Architecture Diagram

```text
Internet
   │
Internet Gateway
   │
VPC
├── Public Subnet
│     └── EC2 Instance
│
├── Private Subnet 1
├── Private Subnet 2
│     └── RDS MySQL
│
├── Secure S3 Bucket
│
└── Terraform Backend
      ├── S3 Remote State
      └── DynamoDB Lock Table
```

---

# Technologies Used

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure provisioning and automation |
| AWS | Cloud infrastructure platform |
| Amazon VPC | Network isolation and segmentation |
| EC2 | Compute resource deployment |
| Amazon S3 | Secure object storage and Terraform backend |
| Amazon RDS | Managed MySQL database service |
| DynamoDB | Terraform state locking |
| Open Policy Agent (OPA) | Policy-as-Code and security validation |
| Rego | Policy language used by OPA |
| Git & GitHub | Version control and project hosting |
| AWS CLI | AWS authentication and backend setup |
---


# Repository Structure

```text
iac-project/
│
├── modules/
│   ├── network/
│   ├── compute/
│   ├── storage/
│   └── database/
│
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
│
├── policies/
│   ├── s3/
│   ├── security-groups/
│   └── tags/
│
├── README.md
├── .gitignore
└── architecture-diagram.png
```

---

# Prerequisites

Install the following tools before deployment.

## 1. Terraform

Download and install Terraform:

https://developer.hashicorp.com/terraform/downloads

Verify installation:

```bash
terraform -version
```

---

## 2. AWS CLI

Install AWS CLI:

https://aws.amazon.com/cli/

Verify installation:

```bash
aws --version
```

---

## 3. Git

Install Git:

https://git-scm.com/downloads

Verify installation:

```bash
git --version
```

---

## 4. Open Policy Agent (OPA)

Install OPA:

https://www.openpolicyagent.org/docs?current-os=windows#1-download-opa

Verify installation:

```bash
opa version
```

---

# AWS Configuration

Configure AWS credentials using AWS CLI.

Run:

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region
Output format
```

Verify AWS access:

```bash
aws sts get-caller-identity
```

---

# Deployment Instructions

## Step 1 — Clone Repository

```bash
git clone https://github.com/sumeetneware/iac-project.git
```

Move into environment directory:

```bash
cd iac-project/environments/dev
```

---

# Step 2 — Create Terraform Backend Resources

Terraform backend resources must be created before initializing Terraform.

## Create S3 Backend Bucket

Replace bucket name with globally unique name.

```bash
aws s3 mb s3://your-terraform-state-bucket
```

Enable versioning:

```bash
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled
```

---

## Create DynamoDB Lock Table

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

# Step 3 — Update Backend Configuration

Open:

```text
environments/dev/main.tf
```

Update backend block:

```hcl
backend "s3" {
  bucket         = "your-terraform-state-bucket"
  key            = "dev/terraform.tfstate"
  region         = "ap-south-1"
  dynamodb_table = "terraform-locks"
  encrypt        = true
}
```

---

# Step 4 — Update terraform.tfvars

Open:

```text
environments/dev/terraform.tfvars
```

Update values:

```hcl
aws_region  = "ap-south-1"

db_username = "admin"
db_password = "StrongPassword123!"
```

---

# Step 5 — Initialize Terraform

```bash
terraform init
```

If prompted to copy state to backend:

```text
yes
```

---

# Step 6 — Validate Terraform Configuration

```bash
terraform validate
```

---

# Step 7 — Format Terraform Files

```bash
terraform fmt
```

---

# Step 8 — Preview Infrastructure Changes

```bash
terraform plan
```

---

# Step 9 — Deploy Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

Terraform will provision:

- VPC
- Subnets
- Route tables
- Internet Gateway
- EC2 instance
- S3 bucket
- RDS MySQL database
- Security groups

---

# Verify Infrastructure

Verify resources in AWS Console:

## VPC
- VPC
- Subnets
- Route tables

## EC2
- Instance running
- Public IP available

## S3
- Versioning enabled
- Encryption enabled
- Public access blocked

## RDS
- MySQL database running
- Private deployment

## DynamoDB
- Terraform lock table

---

# Terraform Outputs

View Terraform outputs:

```bash
terraform output
```

---

# Policy-as-Code (OPA)

This project integrates Open Policy Agent (OPA) to implement Policy-as-Code for infrastructure governance and security validation.

OPA evaluates Terraform execution plans before infrastructure deployment to identify potential security and compliance issues. Terraform plans are converted into JSON format and analyzed using Rego policies to enforce infrastructure standards.


Policies include:

- Prevent public S3 buckets
- Prevent public SSH access
- Enforce required tags

---

# Generate Terraform Plan JSON

```bash
terraform plan -out=tfplan.binary
```

Convert plan to JSON:

```bash
terraform show -json tfplan.binary > tfplan.json
```

---

# Run OPA Security Policies

## Validate S3 Security

```bash
opa eval \
--input tfplan.json \
--data ../../policies/s3/deny_public_s3.rego \
"data.terraform.security.deny"
```

---

## Validate SSH Exposure

```bash
opa eval \
--input tfplan.json \
--data ../../policies/security-groups/no_public_ssh.rego \
"data.terraform.security.deny"
```

---

## Validate Required Tags

```bash
opa eval \
--input tfplan.json \
--data ../../policies/tags/required_tags.rego \
"data.terraform.security.deny"
```

---

# Security Features

This project implements:

- Remote Terraform state
- State locking
- S3 encryption
- S3 versioning
- Public access blocking
- Private database deployment
- Policy-as-Code validation
- Resource tagging

---

# Resource Tags

All resources include standard tags:

```hcl
tags = {
  ManagedBy   = "Terraform"
  Environment = "Dev"
  Project     = "IaC-Project"
}
```

---

# Cleanup Instructions

IMPORTANT: Destroy infrastructure after testing to avoid AWS charges.

Run:

```bash
terraform destroy
```

Type:

```text
yes
```

---

# Important Notes

- Use your own AWS credentials
- Backend bucket names must be globally unique
- Never commit Terraform state files
- Never commit AWS credentials
- Destroy infrastructure after testing

---

# Common Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Format Files

```bash
terraform fmt
```

## Preview Changes

```bash
terraform plan
```

## Apply Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# Future Improvements

Potential enhancements:

- NAT Gateway
- Load Balancer
- Auto Scaling
- GitHub Actions CI/CD
- AWS Secrets Manager
- Multi-environment support
- Docker/ECS/EKS integration

---

# Author

Sumeet Neware

---

