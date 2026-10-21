variable "aws_region" {
  description = "AWS Region to use."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "ID of an existing VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "At least two public subnet IDs in different Availability Zones for the ALB."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "Provide at least two public subnet IDs."
  }
}

variable "private_subnet_ids" {
  description = "Private subnet IDs in different Availability Zones for ASG instances."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "Provide at least two private subnet IDs."
  }
}

variable "instance_type" {
  description = "EC2 instance type; verify current pricing and availability."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum ASG capacity."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum ASG capacity."
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Initial desired ASG capacity."
  type        = number
  default     = 2
}
