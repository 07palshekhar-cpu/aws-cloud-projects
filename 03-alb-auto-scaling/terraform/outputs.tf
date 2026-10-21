output "alb_dns_name" {
  description = "DNS name to use for the HTTP learning demo."
  value       = aws_lb.web.dns_name
}

output "alb_arn" {
  description = "Application Load Balancer ARN."
  value       = aws_lb.web.arn
}

output "target_group_arn" {
  description = "Target group ARN."
  value       = aws_lb_target_group.web.arn
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name."
  value       = aws_autoscaling_group.web.name
}
