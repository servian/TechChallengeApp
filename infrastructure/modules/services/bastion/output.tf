output "bastion_public_ip" {
  value       = aws_instance.servian_tc_bastion_host.*.public_ip
  description = "Public IP address of the bastion hosts"
}
