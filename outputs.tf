# VPC
output "vpc_id" {
  description   = "The ID of the VPC"
  value         = module.techchallenge-vpc.vpc_id
}

# Public subnet
output "public_subnets" {
  description   = "List of IDs of public subnets"
  value         = module.techchallenge-vpc.public_subnets
}

# Database subnet
output "database_subnets" {
  description   = "List of IDs of public subnets"
  value         = module.techchallenge-vpc.database_subnets
}

# Launch template
output "techchallenge-template_id" {
  description = "The ID of the launch template"
  value       = module.techchallenge-asg.launch_template_id
}

output "techchallenge-lt_arn" {
  description = "The ARN of the launch template"
  value       = module.techchallenge-asg.launch_template_arn
}

output "techchallenge-asg_id" {
  description = "The autoscaling group id"
  value       = module.techchallenge-asg.autoscaling_group_id
}

output "techchallenge-asg_name" {
  description = "The autoscaling group name"
  value       = module.techchallenge-asg.autoscaling_group_name
}

output "techchallenge-asg_lt_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = module.techchallenge-asg.autoscaling_group_arn
}

output "techchallenge-asg_min_size" {
  description = "The minimum size of the autoscale group"
  value       = module.techchallenge-asg.autoscaling_group_min_size
}

output "techchallenge-asg_max_size" {
  description = "The maximum size of the autoscale group"
  value       = module.techchallenge-asg.autoscaling_group_max_size
}

output "techchallenge-asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = module.techchallenge-asg.autoscaling_group_desired_capacity
}

output "techchallenge-asg_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = module.techchallenge-asg.autoscaling_group_default_cooldown
}

output "techchallenge-asg_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = module.techchallenge-asg.autoscaling_group_health_check_grace_period
}

output "techchallenge-asg_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = module.techchallenge-asg.autoscaling_group_health_check_type
}

output "techchallenge-asg_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = module.techchallenge-asg.autoscaling_group_availability_zones
}

output "techchallenge-asg_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = module.techchallenge-asg.autoscaling_group_vpc_zone_identifier
}

output "techchallenge-asg_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.techchallenge-asg.autoscaling_group_load_balancers
}

output "techchallenge-asg_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = module.techchallenge-asg.autoscaling_group_target_group_arns
}

output "techchallenge-alb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.techchallenge-alb.lb_id
}

output "techchallenge-alb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.techchallenge-alb.lb_arn
}

output "techchallenge-alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.techchallenge-alb.lb_dns_name
}

output "techchallenge-alb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.techchallenge-alb.lb_arn_suffix
}

output "techchallenge-alb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.techchallenge-alb.lb_zone_id
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.techchallenge-alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.techchallenge-alb.http_tcp_listener_ids
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.techchallenge-alb.target_group_arns
}

output "target_group_attachments" {
  description = "ARNs of the target group attachment IDs."
  value       = module.techchallenge-alb.target_group_attachments
}

# Security group
output "techchallenge-ssh" {
  description   = "SSH security group ID"
  value         = module.techchallenge-ssh-sg.security_group_id
}

output "techchallenge-http" {
  description   = "HTTP security group ID"
  value         = module.techchallenge-http-sg.security_group_id
}

output "techchallenge-db" {
  description   = "DB security group ID"
  value         = module.techchallenge-db-sg.security_group_id
}