# Compute
# AWS Elastic Container Service is used for compute, the module also creates an alb for loadbalancing.

I have not created a domain, the subdomain created here should be glued to a domain to access it from external.

Otherwise the loadbalancer dns name is accessible from internet.

## Terraform versions

Terraform 0.12.

## Usage

```hcl
module "compute" {
  source = "<relative path to module>/compute"

  name = "my-ecs"
  .
  .
  .
  .
}
```
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## License

Apache 2 Licensed. See LICENSE for full details.
