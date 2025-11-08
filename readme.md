# Expense Infrastructure Development - Terraform

This repository contains Terraform configurations for setting up the infrastructure of the Expense application in AWS development environment.

## Project Structure

```
├── 00-vpc/          # VPC and networking configuration
├── 10-sg/           # Security Groups
├── 20-bastion/      # Bastion host configuration
└── 50-app-alb/      # Application Load Balancer setup
```

## Infrastructure Components

### VPC (00-vpc)

- Creates a VPC with CIDR `10.0.0.0/16`
- Sets up public, private, and database subnets across multiple availability zones
- Implements VPC peering functionality
- Creates and stores subnet IDs in AWS Parameter Store

### Security Groups (10-sg)

- MySQL Security Group
- Backend Security Group
- Frontend Security Group
- Bastion Security Group
- Application Load Balancer Security Group

### Bastion Host (20-bastion)

- Deploys a bastion host in the public subnet
- Uses custom RHEL 9 DevOps AMI
- Configured with necessary security group rules

### Application Load Balancer (50-app-alb)

- Internal ALB deployment in private subnets
- HTTP listener on port 80
- Route53 record creation for `*.app-dev.learndevops.online`
- Default response configuration

## Prerequisites

- AWS Account
- Terraform >= 0.12
- AWS CLI configured
- S3 bucket for Terraform state: `expense-remote-state-dev-project`
- DynamoDB table for state locking: `expense-remote-state-dev-locking`

## Common Variables

```hcl
common_tags = {
    Project = "expense"
    Environment = "dev"
    Terraform = true
}

project_name = "expense"
environment = "dev"
```

## Deployment Order

1. VPC (`00-vpc`)
2. Security Groups (`10-sg`)
3. Bastion Host (`20-bastion`)
4. Application Load Balancer (`50-app-alb`)

## Usage

To deploy each component:

```bash
cd <component-directory>
terraform init
terraform plan
terraform apply
```

## State Management

- Remote state stored in S3
- State locking using DynamoDB
- Separate state files for each component

## DNS Configuration

- Domain: `learndevops.online`
- ALB subdomain pattern: `*.app-dev.learndevops.online`
- Route53 hosted zone ID: `Z021448929NXMW4P65QE`

## Security Considerations

- Bastion host is the only instance with public internet access
- All application components are in private subnets
- Security group rules control access between components
- Internal ALB for backend services
