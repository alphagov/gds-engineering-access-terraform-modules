# basic

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_excluded_groups"></a> [excluded\_groups](#input\_excluded\_groups) | List of group IDs to exclude from conditional access policies (break glass accounts) | `list(string)` | n/a | yes |
| <a name="input_trusted_locations"></a> [trusted\_locations](#input\_trusted\_locations) | Map of trusted IP locations for conditional access policies. | <pre>map(object({<br/>    display_name = string<br/>    ip_ranges    = list(string)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
