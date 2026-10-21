variable "aws_region" {
  description = "AWS Region for the VPC lab."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the lab VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "IPv4 CIDR for the private subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "public_az" {
  description = "Availability Zone for the public subnet; confirm availability in the Region."
  type        = string
  default     = "ap-south-1a"
}

variable "private_az" {
  description = "Availability Zone for the private subnet; confirm availability in the Region."
  type        = string
  default     = "ap-south-1b"
}
