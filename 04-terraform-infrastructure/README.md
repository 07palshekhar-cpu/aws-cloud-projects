# Project 04 — End-to-End AWS Infrastructure with Terraform

## Status
**Prepared, not deployed.** AWS account access is unavailable. No infrastructure has been created, and no live deployment or successful Terraform apply is claimed.

## Goal and architecture

Provision a small web-server environment with Terraform, combining VPC networking and EC2 concepts.

~~~text
Internet -> Internet Gateway -> Public route table
                               -> Public subnet (10.30.1.0/24)
                               -> HTTP security group
                               -> EC2 / Amazon Linux 2023 / Apache
~~~

## Resources
- VPC with DNS support
- One public subnet and Internet Gateway
- Public route table and association
- Security group allowing HTTP on TCP 80
- EC2 instance using the latest matching Amazon Linux 2023 x86_64 AMI
- Encrypted gp3 root volume
- User data to install Apache and create a demo page
- Outputs for instance ID, public IP, and website URL

This is a single-instance learning lab, not a production design. It uses HTTP only and has no private tier, HTTPS, load balancer, monitoring, or high availability.

## Cost and security
EC2, EBS, and public IPv4 use may incur charges. Review current pricing before deployment. No resources were created by this repository update.

The default HTTP source is 0.0.0.0/0 for browser access; restrict it to a trusted CIDR when practical. SSH is not opened. IMDSv2 is required and the root EBS volume is encrypted.

## Files
- terraform/main.tf — provider, VPC, subnet, routes, security group, EC2
- terraform/variables.tf — Region, CIDRs, AZ, instance type, project name
- terraform/outputs.tf — resource IDs and website URL
- terraform/user_data.sh.tftpl — first-boot Apache setup
- terraform/terraform.tfvars.example — example inputs only

## Prerequisites
When AWS access is restored, use an authorized account, Terraform 1.5+, and permission to manage VPC and EC2 resources. Provider installation requires network access. Review costs and billing first. Use approved temporary credentials or an IAM role; never commit credentials.

## Local preparation

~~~bash
cd 04-terraform-infrastructure/terraform
terraform fmt -recursive
terraform init -backend=false
terraform validate
cp terraform.tfvars.example terraform.tfvars
~~~

Terraform init downloads the AWS provider. Validation checks configuration consistency but does not prove that resources can be created in AWS. Do not commit the local terraform.tfvars file.

## Deployment — only after account access is restored
1. Verify the active identity with aws sts get-caller-identity.
2. Confirm Region and Availability Zone.
3. Restrict the HTTP ingress CIDR if possible.
4. Run terraform plan -out=tfplan and inspect resources and costs.
5. Apply only a reviewed plan.
6. Wait for EC2 status checks and open the website URL from Terraform output.
7. Capture genuine verification evidence.

Do not deploy while account access is suspended or the target account is uncertain.

## Verification after deployment

~~~bash
terraform output
terraform output -raw website_url
sudo cloud-init status --long
sudo systemctl status httpd --no-pager
curl -I http://localhost/
sudo tail -n 100 /var/log/cloud-init-output.log
~~~

Expected outcome is an active Apache service and HTTP 200. These are expected checks, not current test results.

## Troubleshooting
- Website timeout: check instance status, public IPv4, route table, IGW attachment, and security group.
- Apache failure: inspect cloud-init output and the httpd journal.
- User-data failure: check AMI choice and outbound package access.
- Terraform initialization failure: check installation and provider-registry connectivity.
- Credential error: stop and resolve account access; do not paste keys into code.
- Unexpected planned replacement: inspect configuration and state before applying.

## Cleanup
After testing, confirm workspace, account, Region, and state before removing resources. Remove only resources belonging to this lab that you are certain can be deleted. Check for remaining billable resources.

## Future improvements
Add private tiers, an ALB and ASG, HTTPS, reusable modules, remote state with locking, monitoring, and automated checks.

## Author
**Shekhar Pal** — aspiring Junior Cloud Engineer / Junior DevOps Engineer.
