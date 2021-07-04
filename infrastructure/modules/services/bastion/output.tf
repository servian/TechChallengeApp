output "bastion_public_ip" {
  value       = aws_instance.servian_tc_bastion_host.*.public_ip
  description = "Public IP address of the bastion hosts"
}

output "bastion_sg_id" {
  value       = aws_security_group.servian_tc_bastion_sg.id
  description = "ID of the Bastion host Security group"
}
