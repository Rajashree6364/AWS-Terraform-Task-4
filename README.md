# AWS Terraform Task 4

## Project Overview
This project demonstrates how to provision AWS infrastructure using Terraform.

## Technologies Used
- AWS
- Terraform
- AWS EC2
- Amazon VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group

## Resources Created
- VPC
- Public Subnet
- Internet Gateway
- Public Route Table and Association
- Security Group allowing SSH and HTTP traffic
- EC2 Instance
- Terraform output for the EC2 public IP

## Project Deployment
The AWS infrastructure is configured using `main.tf` and deployed with Terraform commands.

```bash
terraform init
terraform plan
terraform apply
```

## Website
An Apache web server was installed on the EC2 instance to test HTTP access.

## Security
Private SSH key files and Terraform state files are excluded from this repository using `.gitignore`.

## Author
Rajashree Mayekar

## GitHub Repository
https://github.com/Rajashree6364/AWS-Terraform-Task-4
