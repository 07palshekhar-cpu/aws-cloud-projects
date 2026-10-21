terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "alb" {
  name_prefix = "aws-project-alb-"
  description = "Allow public HTTP to the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from clients for this learning lab"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "aws-project-alb-sg"
    Project = "aws-cloud-projects"
  }
}

resource "aws_security_group" "instances" {
  name_prefix = "aws-project-web-"
  description = "Allow web traffic only from the ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP only from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "aws-project-instance-sg"
    Project = "aws-cloud-projects"
  }
}

resource "aws_lb" "web" {
  name               = "aws-cloud-projects-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = {
    Project = "aws-cloud-projects"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "aws-cloud-projects-web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Project = "aws-cloud-projects"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "aws-cloud-projects-web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instances.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -Eeuo pipefail
    dnf install -y httpd
    INSTANCE_ID=$(ec2-metadata --instance-id 2>/dev/null | awk '{print $2}' || hostname)
    cat > /var/www/html/index.html <<HTML
    <!doctype html>
    <html lang="en">
    <head><meta charset="utf-8"><title>ALB Auto Scaling Demo</title></head>
    <body>
      <h1>AWS ALB + Auto Scaling Demo</h1>
      <p>Served by an EC2 instance managed by an Auto Scaling Group.</p>
      <p>Instance identifier: $INSTANCE_ID</p>
    </body>
    </html>
    HTML
    systemctl enable --now httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "aws-cloud-projects-asg-instance"
      Project = "aws-cloud-projects"
    }
  }

  tags = {
    Project = "aws-cloud-projects"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "aws-cloud-projects-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Project"
    value               = "aws-cloud-projects"
    propagate_at_launch = true
  }

  depends_on = [aws_lb_listener.http]
}
