
output "alb_hostname" {
  value = element(aws_alb.this.*.dns_name,0)
}