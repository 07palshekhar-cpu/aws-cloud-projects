# Project 01 — Apache Web Server on Amazon EC2

## Overview

Deploy a static website on an Amazon EC2 instance using Amazon Linux 2023 and Apache HTTP Server. The EC2 user-data script installs Apache, creates a sample page, enables the service, starts it, and checks the local HTTP endpoint.

**Status:** Documentation and script prepared. The AWS deployment has not yet been run or verified because AWS account access is unavailable. This repository does not claim a live deployment.

## Objectives

- Understand the EC2 launch workflow.
- Configure a security group for HTTP access.
- Automate first-boot setup using EC2 user data.
- Manage Apache on Amazon Linux 2023.
- Verify service health and HTTP responses.
- Troubleshoot logs, connectivity, and port 80.
- Consider EBS storage, security, and cloud costs.

## Architecture

~~~text
Browser
   |
   | HTTP :80
   v
EC2 Security Group
   |
   v
Amazon EC2 (Amazon Linux 2023)
   |-- cloud-init / EC2 user data
   |-- Apache httpd
   |-- /var/www/html/index.html
   |
   v
HTTP response
~~~

This is a single-instance learning lab using unencrypted HTTP. It is not production-ready and does not include HTTPS, a load balancer, autoscaling, or a custom domain.

## Services and tools

| Service / tool | Purpose |
|---|---|
| Amazon EC2 | Runs the web server |
| Security Groups | Controls instance network traffic |
| Amazon EBS | Provides block storage |
| Amazon Linux 2023 | Operating system |
| Apache HTTP Server | Serves the website |
| EC2 user data | Runs first-boot setup |
| Bash | Automation and troubleshooting |
| Git / GitHub | Version control and documentation |

## Prerequisites

When AWS access is restored, use an authorized account with permission to launch EC2 resources. Select an Amazon Linux 2023 AMI in a supported Region. Review current instance, storage, and public IPv4 pricing before launching. An EC2 key pair is needed only if you plan to connect using SSH.

Do not store AWS credentials in this repository.

## Launch outline

1. Open the EC2 console and choose **Launch instance**.
2. Set the name to aws-ec2-apache-demo.
3. Select an Amazon Linux 2023 AMI.
4. Choose an instance type after reviewing current price and account eligibility; do not assume an instance is free.
5. Configure the security group:
   - Allow inbound HTTP TCP port 80 from 0.0.0.0/0 only for this public demonstration.
   - If SSH is required, allow TCP port 22 only from your trusted public IP using a /32 rule. Never expose SSH to everyone.
   - Alternatively, use a supported managed access method after configuring its prerequisites.
6. Keep the EBS volume modest and review storage and public IPv4 charges.
7. Under **Advanced details**, paste the contents of [user-data.sh](./user-data.sh) into **User data**.
8. Review the configuration and launch the instance.
9. Wait for the instance status checks to pass.
10. Open http://PUBLIC-IP/ in a browser. HTTP is unencrypted and is used here only for the basic lab.

## User-data script

The [user-data.sh](./user-data.sh) script is designed for Amazon Linux 2023. It installs Apache using dnf, writes an HTML page, enables and starts httpd, and performs a local HTTP check.

EC2 user data normally runs during first boot. Editing the user-data field later does not automatically rerun the script on an existing instance.

## Verification

After connecting through an approved access method, run:

~~~bash
sudo cloud-init status --long
sudo systemctl status httpd --no-pager
sudo systemctl is-enabled httpd
sudo ss -lntp | grep ':80'
curl -I http://localhost/
curl http://localhost/
~~~

Expected checks after a successful deployment:
- cloud-init reports completion.
- Apache is active and enabled.
- Apache listens on TCP port 80.
- curl returns an HTTP success response such as 200 OK.
- The page includes the heading **AWS EC2 Apache Demo**.

These are expected results, not claimed test results. Record actual output after running the project.

## Troubleshooting

### Website does not load externally
- Confirm the instance is running and status checks pass.
- Confirm the security group allows inbound TCP 80 from the intended client network.
- Check subnet routing and whether the instance has a reachable public IPv4 address.
- Review network ACLs and local firewall rules if configured.
- Test locally first with curl -I http://localhost/.

### Apache is not running

~~~bash
sudo systemctl status httpd --no-pager
sudo journalctl -u httpd -n 100 --no-pager
sudo tail -n 100 /var/log/cloud-init-output.log
~~~

### User data did not complete

~~~bash
sudo cloud-init status --long
sudo tail -n 150 /var/log/cloud-init-output.log
sudo less /var/log/cloud-init.log
~~~

Check the AMI/OS and package repository connectivity. User data is not a replacement for ongoing configuration management.

### Port 80 is not listening

~~~bash
sudo ss -lntp | grep ':80'
sudo apachectl configtest
~~~

Check the Apache logs and configuration before changing services.

## Security considerations

- Use least-privilege permissions.
- Restrict SSH to a trusted IP, or avoid opening SSH if managed access is configured.
- Expose only ports needed for the lab.
- Do not store secrets in user data or commit credentials. User data may be accessible to principals with appropriate instance permissions.
- Add HTTPS and a valid certificate before any production use.
- Redact private keys, account details, and other sensitive information in screenshots.
- Review billing and clean up all resources after testing.

## Cleanup

After capturing required evidence:
1. Terminate the EC2 instance.
2. Review whether EBS volumes, snapshots, Elastic IP addresses, or other resources remain.
3. Remove only resources confirmed to belong to this lab and no longer needed.
4. Check billing for remaining resources.

Cleanup can be destructive. Confirm resource IDs and ownership before deletion.

## Evidence to add after deployment

Add genuine screenshots to [screenshots/](./screenshots/):
- EC2 instance state and status checks
- Security group inbound rules with sensitive details redacted
- Successful systemctl and curl verification
- Browser showing the served page

Label screenshots with the date and test context. Do not fabricate outputs or present a diagram as proof of deployment.

## Future improvements

- Add HTTPS.
- Place the instance behind an Application Load Balancer.
- Use an Auto Scaling Group across multiple Availability Zones.
- Provision infrastructure with Terraform.
- Add monitoring and alarms.
- Add CI checks for scripts and documentation.

## Author

**Shekhar Pal** — aspiring Junior Cloud Engineer / Junior DevOps Engineer.
