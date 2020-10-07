locals {
  enhanced_monitoring_iam_role_name     = element(concat(aws_iam_role.enhanced_monitoring.*.name, [""]), 0)
  enhanced_monitoring_iam_role_arn      = element(concat(aws_iam_role.enhanced_monitoring.*.arn, [""]), 0)
  this_db_instance_address              = element(concat(aws_db_instance.this.*.address, [""]), 0)
  this_db_instance_arn                  = element(concat(aws_db_instance.this.*.arn, [""]), 0)
  this_db_instance_availability_zone    = element(concat(aws_db_instance.this.*.availability_zone, [""]), 0)
  this_db_instance_endpoint             = element(concat(aws_db_instance.this.*.endpoint, [""]), 0)
  this_db_instance_hosted_zone_id       = element(concat(aws_db_instance.this.*.hosted_zone_id, [""]), 0)
  this_db_instance_id                   = element(concat(aws_db_instance.this.*.id, [""]), 0)
  this_db_instance_resource_id          = element(concat(aws_db_instance.this.*.resource_id, [""]), 0)
  this_db_instance_status               = element(concat(aws_db_instance.this.*.status, [""]), 0)
  this_db_instance_name                 = element(concat(aws_db_instance.this.*.name, [""]), 0)
  this_db_instance_username             = element(concat(aws_db_instance.this.*.username, [""]), 0)
  this_db_instance_port                 = element(concat(aws_db_instance.this.*.port, [""]), 0)
  this_db_instance_ca_cert_identifier   = element(concat(aws_db_instance.this.*.ca_cert_identifier, [""]), 0)
}

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = local.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = local.enhanced_monitoring_iam_role_arn
}

output "this_db_instance_address" {
  description = "The address of the RDS instance"
  value       = local.this_db_instance_address
}

output "this_db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = local.this_db_instance_arn
}

output "this_db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = local.this_db_instance_availability_zone
}

output "this_db_instance_endpoint" {
  description = "The connection endpoint"
  value       = local.this_db_instance_endpoint
}

output "this_db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = local.this_db_instance_hosted_zone_id
}

output "this_db_instance_id" {
  description = "The RDS instance ID"
  value       = local.this_db_instance_id
}

output "this_db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = local.this_db_instance_resource_id
}

output "this_db_instance_status" {
  description = "The RDS instance status"
  value       = local.this_db_instance_status
}

output "this_db_instance_name" {
  description = "The database name"
  value       = local.this_db_instance_name
}

output "this_db_instance_username" {
  description = "The master username for the database"
  value       = local.this_db_instance_username
}

output "this_db_instance_port" {
  description = "The database port"
  value       = local.this_db_instance_port
}

output "this_db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = local.this_db_instance_ca_cert_identifier
}

output "this_db_subnet_group_id" {
  description = "The db subnet group name"
  value       = element(concat(aws_db_subnet_group.this.*.id, [""]), 0)
}

output "this_db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = element(concat(aws_db_subnet_group.this.*.arn, [""]), 0)
}

output "this_db_security_group_ids" {
  description = "The rds security group id's"
  value       = concat(var.vpc_security_group_ids, aws_security_group.this.*.id, [""])
}

