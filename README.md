# AWS Cloud Projects

Hands-on AWS portfolio projects covering architecture, deployment automation, security, verification, and troubleshooting.

> **Status:** Project documentation and starter scripts are being prepared. AWS deployments are not claimed until they have been run and verified in an active account.

## Projects

| # | Project | Services / tools | Status |
|---|---|---|---|
| 01 | [EC2 Web Server Deployment](./01-ec2-web-server/) | EC2, Security Groups, EBS, Amazon Linux 2023, Apache, Bash | Prepared; AWS deployment pending |
| 02 | [VPC Networking](./02-vpc-networking/) | VPC, public/private subnets, route tables, Internet Gateway, Terraform | Prepared; AWS deployment pending |
| 03 | Highly Available Web Tier | Application Load Balancer, Auto Scaling, EC2 | Planned |
| 04 | AWS Infrastructure with Terraform | Terraform, VPC, EC2, IAM | Planned |
| 05 | S3 and IAM Security | S3, IAM, bucket policies | Planned |

## Project standards

Each project aims to include architecture, prerequisites, implementation steps, scripts or infrastructure-as-code, verification, troubleshooting, security considerations, and cleanup instructions.

## Safety and cost

- Never commit AWS access keys, passwords, private keys, environment files, or sensitive Terraform state.
- Review current AWS pricing before creating resources and clean up test resources afterward.
- Restrict SSH to a trusted IP address; never expose it to the entire internet.
- Diagrams and scripts are not proof of a successful deployment. Evidence will be added after actual testing.
- The VPC starter does not create a NAT Gateway by default, avoiding NAT Gateway charges in the base design.

## About

Maintained by **Shekhar Pal**, aspiring Junior Cloud Engineer / Junior DevOps Engineer.

Focus: AWS, Linux, networking, Bash, Terraform, Git, security, and troubleshooting.
