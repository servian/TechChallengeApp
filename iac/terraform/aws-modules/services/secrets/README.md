# secrets

# This file creates secrets in the AWS Secret Manager
# Note that this does not contain any actual secret values
# make sure to not commit any secret values to git!
# you could put them in secrets.tfvars which is in .gitignore


## Terraform versions

Terraform 0.12.

## Usage

```hcl
module "secrets" {
  source = "<relative path to module>/secrets"

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
