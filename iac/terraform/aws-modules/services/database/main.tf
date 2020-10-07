data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  name               = var.monitoring_role_name
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json

  tags = merge(
    {
      "Name" = format("%s", var.monitoring_role_name)
    },
    var.tags,
  )
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

locals {
  description = coalesce(var.description, "Database parameter group for ${var.identifier}")
}

resource "aws_db_parameter_group" "this" {
  count = var.create ? 1 : 0

  name_prefix = var.name_prefix
  description = local.description
  family      = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = merge(
  var.tags,
  {
    "Name" = format("%s", var.identifier)
  },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "this" {
  count = var.create ? 1 : 0

  name_prefix = var.name_prefix
  description = "Database subnet group for ${var.identifier}"
  subnet_ids  = var.subnet_ids

  tags = merge(
  var.tags,
  {
    "Name" = format("%s", var.identifier)
  },
  )
}

// create an empty security group if no security groups are provided

resource "aws_security_group" "this" {
  count = length(var.vpc_security_group_ids) > 0 ? 0 : 1

  name        =  format("%s-sg", var.name_prefix)
  description = "rds security group"
  vpc_id      =  var.rds_vpc_id

  tags = merge(
  var.tags,
  {
    "Name" = format("%s", var.identifier)
  },
  )
}


resource "aws_db_instance" "this" {
  count = var.create ? 1 : 0

  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.license_model

  name                                = var.name
  username                            = var.username
  password                            = var.password
  port                                = var.port
  domain                              = var.domain
  domain_iam_role_name                = var.domain_iam_role_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  replicate_source_db = var.replicate_source_db

  snapshot_identifier = var.snapshot_identifier

  vpc_security_group_ids = concat(var.vpc_security_group_ids, aws_security_group.this.*.id)
  db_subnet_group_name   = element(aws_db_subnet_group.this.*.name,0)
  parameter_group_name   = element(aws_db_parameter_group.this.*.name,0)
  option_group_name      = var.option_group_name

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  publicly_accessible = var.publicly_accessible
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? coalesce(var.monitoring_role_arn, join(", ", aws_iam_role.enhanced_monitoring.*.arn), null) : null

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier
  max_allocated_storage       = var.max_allocated_storage

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled == true ? var.performance_insights_retention_period : null

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window

  character_set_name = var.character_set_name

  ca_cert_identifier = var.ca_cert_identifier

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.identifier)
    },
  )

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}

#
# CloudWatch resources
#
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  count = var.create_cloudwatch_resources ? 1 : 0

  alarm_name          = "alarmDatabaseServerCPUUtilization-${var.identifier}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.*.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  count = var.create_cloudwatch_resources ? 1 : 0

  alarm_name          = "alarmDatabaseServerDiskQueueDepth-${var.identifier}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_disk_queue_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.*.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  count = var.create_cloudwatch_resources ? 1 : 0

  alarm_name          = "alarmDatabaseServerFreeStorageSpace-${var.identifier}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_disk_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.*.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  count = var.create_cloudwatch_resources ? 1 : 0

  alarm_name          = "alarmDatabaseServerFreeableMemory-${var.identifier}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_memory_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.*.id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
}






