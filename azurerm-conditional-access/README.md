<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# azurerm-conditional-access

## Description

This module creates Entra ID Conditional Access policies with a consistent, reusable pattern.

## Features

- Flexible configuration for all common conditional access scenarios
- Support for location-based policies
- Risk-based authentication controls
- Application and user action targeting
- Session controls (sign-in frequency)
- Guest user exclusion options

## Usage

```hcl
module "conditional_access_policy" {
  source = "./modules/conditional_access"

  policy_name           = "CA01 - Block Untrusted Locations"
  policy_state          = "enabled"
  client_app_types      = ["all"]
  included_applications = ["All"]
  included_locations    = ["All"]
  excluded_locations    = ["AllTrusted"]
  included_users        = ["All"]
  excluded_groups       = ["break-glass-group-id"]
  built_in_controls     = ["block"]

}
```

```hcl
module "mfa_with_auth_strength" {
  source = "./modules/conditional_access"

  policy_name  = "CA01 - Require Phishing-Resistant MFA"
  policy_state = "enabled"

  authentication_strength_policy_id = "/policies/authenticationStrengthPolicies/00000000-0000-0000-0000-000000000004"

  included_applications = ["All"]
  included_users        = ["All"]
  excluded_groups       = ["break-glass-group-id"]
}
```

> [!NOTE]
> Built-in authentication strengths are documented [here](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths)

## Example Policies

### Block from Untrusted Locations

```terraform
module "network_block" {
  source = "./modules/conditional_access"

  policy_name        = "CA01 - Block Untrusted Locations"
  included_locations = ["All"]
  excluded_locations = ["AllTrusted"]
  built_in_controls  = ["block"]
}
```

### Require MFA for Risky Sign-ins

```terraform
module "mfa_risky_signins" {
  source = "./modules/conditional_access"

  policy_name               = "CA05 - MFA for Risky Sign-ins"
  sign_in_risk_levels       = ["high", "medium"]
  built_in_controls         = ["mfa"]
  sign_in_frequency_enabled = true
}
```

### Block Legacy Authentication

```terraform
module "block_legacy_auth" {
  source = "./modules/conditional_access"

  policy_name      = "CA02 - Block Legacy Auth"
  client_app_types = ["exchangeActiveSync", "other"]
  built_in_controls = ["block"]
}
```

## Developer Onboarding

1. This repository uses pre-commit. Please install prerequisite tools first:

```zsh
brew install tflint checkov trivy terraform-docs
```

1. Then complete steps 1. and 3. from the [pre-commit quick start](https://pre-commit.com/#quick-start).

If pre-commit detects issues when you attempt to commit changes, a dialogue box similar to the one below will appear. Click 'Show Command Output' to see details:

![pre-commit](./docs/pre-commit.png)

> [!TIP]
> terraform-docs can be executed manually for troubleshooting etc. using the following command:

```zsh
terraform-docs markdown table --indent 2 --output-mode inject --output-file README.md <module name>
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.7 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_built_in_controls"></a> [built\_in\_controls](#input\_built\_in\_controls) | List of built-in grant controls (block, mfa, compliantDevice, etc.) | `list(string)` | n/a | yes |
| <a name="input_excluded_groups"></a> [excluded\_groups](#input\_excluded\_groups) | List of group IDs to exclude from conditional access policies (break glass accounts) | `list(string)` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The display name of the conditional access policy | `string` | n/a | yes |
| <a name="input_authentication_strength_policy_id"></a> [authentication\_strength\_policy\_id](#input\_authentication\_strength\_policy\_id) | ID of the authentication strength policy to require. Must be a full resource path i.e. /policies/authenticationStrengthPolicies/<UUID>. See https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths. | `string` | `null` | no |
| <a name="input_client_app_types"></a> [client\_app\_types](#input\_client\_app\_types) | List of client app types to include | `list(string)` | <pre>[<br/>  "all"<br/>]</pre> | no |
| <a name="input_exclude_guests"></a> [exclude\_guests](#input\_exclude\_guests) | Whether to exclude guests and external users | `bool` | `false` | no |
| <a name="input_excluded_applications"></a> [excluded\_applications](#input\_excluded\_applications) | List of application IDs to exclude | `list(string)` | `[]` | no |
| <a name="input_excluded_locations"></a> [excluded\_locations](#input\_excluded\_locations) | List of location names to exclude | `list(string)` | `[]` | no |
| <a name="input_grant_operator"></a> [grant\_operator](#input\_grant\_operator) | Grant controls operator: OR or AND | `string` | `"OR"` | no |
| <a name="input_included_applications"></a> [included\_applications](#input\_included\_applications) | List of application IDs to include | `list(string)` | <pre>[<br/>  "All"<br/>]</pre> | no |
| <a name="input_included_locations"></a> [included\_locations](#input\_included\_locations) | List of location names to include | `list(string)` | `[]` | no |
| <a name="input_included_user_actions"></a> [included\_user\_actions](#input\_included\_user\_actions) | List of user actions to include | `list(string)` | `null` | no |
| <a name="input_included_users"></a> [included\_users](#input\_included\_users) | List of user IDs or groups to include | `list(string)` | <pre>[<br/>  "All"<br/>]</pre> | no |
| <a name="input_policy_state"></a> [policy\_state](#input\_policy\_state) | The state of the policy: enabled, disabled, or enabledForReportingButNotEnforced | `string` | `"enabled"` | no |
| <a name="input_sign_in_frequency"></a> [sign\_in\_frequency](#input\_sign\_in\_frequency) | Number of days or hours to enforce sign-in frequency. Required when sign\_in\_frequency\_interval is 'timeBased'. | `number` | `null` | no |
| <a name="input_sign_in_frequency_interval"></a> [sign\_in\_frequency\_interval](#input\_sign\_in\_frequency\_interval) | The interval to apply to sign-in frequency control. | `string` | `null` | no |
| <a name="input_sign_in_frequency_period"></a> [sign\_in\_frequency\_period](#input\_sign\_in\_frequency\_period) | The time period to enforce sign-in frequency. Required when sign\_in\_frequency\_interval is 'timeBased'. | `string` | `null` | no |
| <a name="input_sign_in_risk_levels"></a> [sign\_in\_risk\_levels](#input\_sign\_in\_risk\_levels) | List of sign-in risk levels to trigger the policy | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_display_name"></a> [policy\_display\_name](#output\_policy\_display\_name) | The display name of the conditional access policy |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The ID of the conditional access policy |
| <a name="output_policy_object_id"></a> [policy\_object\_id](#output\_policy\_object\_id) | The object ID of the conditional access policy |
<!-- END_TF_DOCS -->
