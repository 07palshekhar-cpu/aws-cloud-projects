# Project 02 — AWS VPC Networking: Public and Private Subnets

## Status
**Design and Terraform starter prepared; not deployed.** AWS account access is unavailable, so no live VPC or gateway has been created or verified. Do not describe this as a completed deployment until tested.

## Goal
Learn VPC CIDRs, public and private subnets, Internet Gateway (IGW), route tables, subnet associations, Security Groups versus network ACLs, and NAT Gateway trade-offs.

## Architecture
~~~text
                         Internet
                            |
                       Internet GW
                            |
             Public route: 0.0.0.0/0 -> IGW
                            |
              +-------------+--------------+
              | VPC: 10.20.0.0/16         |
              |                            |
              | Public subnet              |
              | 10.20.1.0/24               |
              | ap-south-1a                |
              |                            |
              | Private subnet             |
              | 10.20.2.0/24               |
              | ap-south-1b                |
              | VPC-local route only       |
              +----------------------------+
~~~

This base version intentionally creates **no NAT Gateway**, avoiding its hourly and data-processing charges. The private subnet has no default route to the internet.

## Address plan

| Resource | CIDR / setting | Purpose |
|---|---|---|
| VPC | 10.20.0.0/16 | Private IPv4 address space |
| Public subnet | 10.20.1.0/24 | Subnet whose route table points to IGW |
| Private subnet | 10.20.2.0/24 | No direct internet route |
| Public route | 0.0.0.0/0 -> IGW | Internet route |
| Private route | VPC-local only | No default internet route |

Confirm the CIDRs do not overlap with networks you need to connect to.

## Files
- terraform/main.tf — VPC, subnets, IGW, and route tables.
- terraform/variables.tf — Region and CIDR inputs.
- terraform/outputs.tf — resource IDs after a successful apply.
- architecture.txt — topology summary.

## Prerequisites
When AWS access is restored, use an authorized account, Terraform, AWS CLI, and permissions for VPC resources. The starter defaults to Mumbai (ap-south-1). Review current AWS pricing and account billing before deployment.

Never put access keys in Terraform files or commit local credentials. Prefer an approved IAM role or short-lived credentials.

## Prepare locally

From the repository root:
~~~bash
cd 02-vpc-networking/terraform
terraform fmt -recursive
terraform init -backend=false
terraform validate
terraform plan
~~~

Terraform init needs to download the AWS provider, so it requires provider-registry network access. Formatting and source review can be done without AWS credentials; a plan that queries AWS may require credentials. Do not run terraform apply until account access, permissions, region, and costs have been confirmed.

## Deployment outline (after access is restored)
1. Confirm the intended AWS account and Region.
2. Run aws sts get-caller-identity to verify the active identity.
3. Review terraform plan carefully.
4. Apply only after understanding every planned resource.
5. In the VPC console, confirm VPC, subnets, IGW, route tables, and associations.
6. Verify the public route table sends 0.0.0.0/0 to the IGW.
7. Verify the private route table has no internet default route.
8. Capture genuine screenshots and real command output; redact sensitive details.

## Interview concepts

**What makes a subnet public?** Its associated route table has a route to an Internet Gateway. For an EC2 instance to be reachable from the internet, additional requirements apply, including public IPv4 addressing, suitable security-group/NACL rules, and a working return route.

**What makes a subnet private?** It has no direct route to an Internet Gateway. This design has only the VPC-local route. Outbound internet access can be added through a NAT device if deliberately configured.

**IGW vs NAT Gateway:** An IGW connects a VPC to the internet for appropriately addressed and routed resources. A NAT Gateway allows private resources to initiate outbound connections without accepting unsolicited inbound internet connections through that NAT path. NAT Gateways cost extra and are not created by this base configuration.

**Security Group vs Network ACL:** Security Groups are stateful and apply to network interfaces/resources. Network ACLs are stateless subnet-level filters, so return traffic rules must be considered.

## Troubleshooting
- No internet route in public subnet: check the route table and IGW attachment.
- Subnet uses wrong route table: inspect explicit and main route-table associations.
- Instance unreachable: check public IPv4, security-group rules, NACLs, host firewall, and service status.
- CIDR overlap error: choose non-overlapping IPv4 ranges.
- Terraform provider errors: check Terraform version, provider initialization, and provider-registry connectivity.
- Unexpected planned deletions: stop and inspect plan and state before applying.

## Cleanup
If deployed, review the Terraform plan before destroying anything. Destroy only after confirming the state and account/Region refer to this lab and no resource needs to be retained. Review resources created outside Terraform separately. No AWS cleanup is required yet because this project has not been deployed.

## Extensions
1. Add a NAT Gateway and private route after reviewing pricing.
2. Create public and private subnets in two Availability Zones.
3. Add EC2 instances and test reachability.
4. Add VPC Flow Logs.
5. Reuse the VPC in a later ALB and Auto Scaling project.

## Author
**Shekhar Pal** — aspiring Junior Cloud Engineer / Junior DevOps Engineer.
