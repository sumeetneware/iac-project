# Terraform AWS Infrastructure Project


## Project Overview
This project provisions production-style AWS infrastructure using Terraform.
It includes:
- VPC networking
- EC2 compute
- Secure S3 storage
- Private RDS database
- Remote Terraform state
- Policy-as-Code using OPA


## Architecture
- Public subnet for EC2
- Private subnets for RDS
- S3 for storage
- Remote Terraform backend using S3 + DynamoDB
- OPA security validation


## Architecture
- Public subnet for EC2
- Private subnets for RDS
- S3 for storage
- Remote Terraform backend using S3 + DynamoDB
- OPA security validation


## Technologies
- Terraform
- AWS
- OPA (Open Policy Agent)
- GitHub



## Repository Structure
modules/
environments/
policies/



## Deployment
terraform init
terraform validate
terraform plan
terraform apply




## Remote State
Terraform remote state is stored in:
- AWS S3
- DynamoDB locking table



## Policy-as-Code
OPA policies validate:
- S3 bucket security
- SSH exposure
- Required tagging



## Cleanup
terraform destroy



## Author
Sumeet Neware
