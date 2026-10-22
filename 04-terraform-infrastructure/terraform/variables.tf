variable "aws_region" {
  description = "AWS Region for this learning environment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short prefix used in resource names and tags."
  type        = string
  default     = "aws-tf-demo"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name)) && length(var.project_name) <= 20
    error_message = "Use up to 20 lowercase letters, numbers, or hyphens."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR block for the public subnet."
  type        = string
  default     = "10.30.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet; confirm it is available in the selected Region."
  type        = string
  default     = "ap-south-1a"
}

variable "instance_type" {
  description = "EC2 instance type; review current pricing and account eligibility before deployment."
  type        = string
  default     = "t3.micro"
}

variable "http_ingress_cidr" {
  description = "IPv4 CIDR allowed to reach HTTP. Restrict this to a trusted CIDR when practical."
  type        = string
  default     = "0.0.0.0/0"
  validation {
    condition     = can(cidrhost(var.http_ingress_cidr, 0))
    error_message = "http_ingress_cidr must be a valid IPv4 CIDR."
  }
}

variable "root_volume_size" {
  description = "Encrypted root EBS volume size in GiB."
  type        = number
  default     = 8
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 30
    error_message = "Choose a root volume between 8 and 30 GiB for this lab."
  }
}
