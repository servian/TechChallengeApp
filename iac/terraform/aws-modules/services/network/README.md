# Network
# Creates network resources as VPC, subnets, NAT gateways, Internet gateway, route tables, routes etc...

## Terraform versions

Terraform 0.12.

## Usage

```hcl
module "network" {
  source = "<relative path to module>/network"

  name = "servian-app"
  .
  .
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
