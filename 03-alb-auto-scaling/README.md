# Project 03 — Highly Available Web Tier with ALB and Auto Scaling

## Status
**Terraform starter prepared; not deployed.** AWS account access is unavailable. No ALB, target group, Auto Scaling Group, or EC2 instance has been created or tested. Only mark this project deployed after real verification.

## Goal
Create a web tier that distributes HTTP requests across EC2 instances and replaces unhealthy instances automatically. The design spans two Availability Zones.

## Architecture
~~~text
                         Users / Browser
                               |
                         HTTP :80
                               |
                    Application Load Balancer
                               |
                         Target Group
                         /           \
                        /             \
               EC2 instance A     EC2 instance B
                 AZ-a                AZ-b
                        \             /
                         Auto Scaling Group
                               |
                      Launch Template + User Data
~~~

## Components
- Application Load Balancer (ALB): receives HTTP requests and forwards them to healthy targets.
- Target group: registers instances and checks their health.
- Launch template: defines the AMI, instance type, security groups, and user data.
- Auto Scaling Group (ASG): maintains desired capacity and replaces unhealthy instances.
- Security groups: permit HTTP from clients to the ALB and HTTP from the ALB to instances.
- Two public subnets in different Availability Zones for the ALB. Instances are intended to live in private subnets in a production-style design.

## Cost warning
ALBs and EC2 instances can incur ongoing charges. NAT Gateways also cost extra if added for private-subnet outbound access. This starter intentionally keeps deployment pending. Review current pricing before creating resources and delete test resources afterward.

## Current implementation scope
This is a learning starter, not a full production deployment. The Terraform in this folder defines the launch template, instance security group, target group, ALB, listener, and ASG, with subnet IDs supplied as inputs. It assumes a suitable VPC and two subnets already exist. For safe use, the instance subnets should be private and the ALB subnets should be public, in separate Availability Zones.

The base configuration is HTTP-only to keep the lab understandable. Do not use it for production traffic without HTTPS, a suitable certificate, hardened access, logging, monitoring, and a reviewed network design.

## Files
- terraform/main.tf — ALB, target group, listener, launch template, ASG, security groups.
- terraform/variables.tf — Region, subnet IDs, CIDRs, and capacity controls.
- terraform/outputs.tf — ALB DNS name and resource IDs.
- terraform/terraform.tfvars.example — example inputs with placeholders.

## Prerequisites
When AWS access is restored:
- An authorized account with permission to create EC2, ELB, Auto Scaling, and security-group resources.
- A VPC with two public ALB subnets in separate Availability Zones.
- Two private instance subnets in separate Availability Zones.
- Outbound package access from instances during boot, configured through an approved route such as a NAT Gateway or suitable package mirroring.
- Terraform and AWS CLI installed.
- A review of current AWS prices and billing status.

Use approved temporary credentials or an IAM role. Never commit access keys.

## Prepare locally
From the repository root:
~~~bash
cd 03-alb-auto-scaling/terraform
terraform fmt -recursive
terraform init -backend=false
terraform validate
~~~

The AWS provider must be downloaded during init. Validation checks configuration structure, not whether resources can be created in your account. Do not run apply until the input subnet IDs, account, region, IAM permissions, network routes, and expected costs have been reviewed.

## Deployment outline after account access is restored
1. Verify the active account using aws sts get-caller-identity.
2. Confirm both ALB subnets are public, in different AZs, and route to an IGW.
3. Confirm instance subnets are private and have a planned path for package installation during first boot.
4. Provide correct subnet IDs and allowed admin CIDR in a local terraform.tfvars file that is not committed.
5. Run terraform plan and review every planned resource.
6. Apply only after reviewing cost and network security.
7. Wait for target health checks to pass.
8. Open the ALB DNS name in a browser and refresh several times to see the instance identifier change.
9. Test ASG replacement only in a controlled lab and capture actual evidence.

## Verification ideas
- Check ALB state is active.
- Check target group health shows healthy targets.
- Use the ALB DNS name to request the webpage.
- Inspect ASG desired, minimum, and maximum capacity.
- Terminate one lab instance only after confirming it belongs to this project, then observe whether ASG launches a replacement.
- Record actual results and timestamps; do not fabricate screenshots or outputs.

## Troubleshooting
- **Targets unhealthy:** check instance status, app service, target-group health-check path/port, instance security-group inbound rule, and subnet routes.
- **ALB times out:** check ALB subnet routing, ALB security-group inbound HTTP rule, listener, and target health.
- **Instances fail user data:** inspect cloud-init logs and confirm outbound package access.
- **ASG cannot launch:** inspect launch-template configuration, subnet capacity, instance quotas, AMI availability, and IAM permissions.
- **Terraform plan wants unexpected replacements:** stop and review inputs, provider version, and state before applying.

## Security checklist
- Allow client HTTP only to the ALB security group.
- Allow instance HTTP only from the ALB security group, not from the entire internet.
- Avoid SSH ingress from 0.0.0.0/0; prefer managed access or tightly restricted trusted IPs.
- Add HTTPS before any real public use.
- Keep secrets out of user data and source control.
- Consider ALB access logs, CloudWatch alarms, patching, and least privilege.

## Cleanup
Review the plan and confirm account, Region, and state before destroying resources. Remove only project resources, and inspect separately created VPCs, subnets, NAT Gateways, EIPs, and volumes for possible ongoing charges.

## Author
**Shekhar Pal** — aspiring Junior Cloud Engineer / Junior DevOps Engineer.
