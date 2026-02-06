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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_msgraph"></a> [msgraph](#requirement\_msgraph) | ~> 0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_msgraph"></a> [msgraph](#provider\_msgraph) | 0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [msgraph_resource.policy](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authentication_flow_transfer_methods"></a> [authentication\_flow\_transfer\_methods](#input\_authentication\_flow\_transfer\_methods) | A list of authentication flow transfer methods included in the policy | `list(string)` | `[]` | no |
| <a name="input_authentication_strength_policy_id"></a> [authentication\_strength\_policy\_id](#input\_authentication\_strength\_policy\_id) | ID of the authentication strength policy to require. Must be a full resource path i.e. /policies/authenticationStrengthPolicies/<UUID>. See https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths. | `string` | `null` | no |
| <a name="input_built_in_controls"></a> [built\_in\_controls](#input\_built\_in\_controls) | List of built-in grant controls (block, mfa, compliantDevice, etc.). Cannot be used together with authentication\_strength\_policy\_id. | `list(string)` | `null` | no |
| <a name="input_client_app_types"></a> [client\_app\_types](#input\_client\_app\_types) | List of client app types to include | `list(string)` | <pre>[<br/>  "all"<br/>]</pre> | no |
| <a name="input_exclude_guests"></a> [exclude\_guests](#input\_exclude\_guests) | Whether to exclude guests and external users | `bool` | `false` | no |
| <a name="input_excluded_applications"></a> [excluded\_applications](#input\_excluded\_applications) | List of application IDs to exclude | `list(string)` | `[]` | no |
| <a name="input_excluded_groups"></a> [excluded\_groups](#input\_excluded\_groups) | List of group IDs to exclude from conditional access policies (break glass accounts) | `list(string)` | n/a | yes |
| <a name="input_excluded_locations"></a> [excluded\_locations](#input\_excluded\_locations) | List of location names to exclude | `list(string)` | `[]` | no |
| <a name="input_excluded_platforms"></a> [excluded\_platforms](#input\_excluded\_platforms) | List of platforms to exclude from the policy | `list(string)` | `null` | no |
| <a name="input_grant_operator"></a> [grant\_operator](#input\_grant\_operator) | Grant controls operator: OR or AND | `string` | `"OR"` | no |
| <a name="input_included_applications"></a> [included\_applications](#input\_included\_applications) | List of application IDs to include | `list(string)` | <pre>[<br/>  "All"<br/>]</pre> | no |
| <a name="input_included_authentication_context_class_references"></a> [included\_authentication\_context\_class\_references](#input\_included\_authentication\_context\_class\_references) | List of authentication context class reference IDs to include (c1 through c25). Used to enforce step-up authentication for specific scenarios. | `list(string)` | `[]` | no |
| <a name="input_included_locations"></a> [included\_locations](#input\_included\_locations) | List of location names to include | `list(string)` | `[]` | no |
| <a name="input_included_platforms"></a> [included\_platforms](#input\_included\_platforms) | List of platforms to include in the policy. Required when using platform conditions. | `list(string)` | `null` | no |
| <a name="input_included_user_actions"></a> [included\_user\_actions](#input\_included\_user\_actions) | List of user actions to include | `list(string)` | `null` | no |
| <a name="input_included_users"></a> [included\_users](#input\_included\_users) | List of user IDs or groups to include | `list(string)` | <pre>[<br/>  "All"<br/>]</pre> | no |
| <a name="input_insider_risk_levels"></a> [insider\_risk\_levels](#input\_insider\_risk\_levels) | The insider risk level to trigger the policy. This feature requires Microsoft Entra Insider Risk Management. | `string` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The display name of the conditional access policy | `string` | n/a | yes |
| <a name="input_policy_state"></a> [policy\_state](#input\_policy\_state) | The state of the policy: enabled, disabled, or enabledForReportingButNotEnforced | `string` | `"enabled"` | no |
| <a name="input_sign_in_frequency"></a> [sign\_in\_frequency](#input\_sign\_in\_frequency) | Number of days or hours to enforce sign-in frequency. Required when sign\_in\_frequency\_interval is 'timeBased'. | `number` | `null` | no |
| <a name="input_sign_in_frequency_interval"></a> [sign\_in\_frequency\_interval](#input\_sign\_in\_frequency\_interval) | The interval to apply to sign-in frequency control. | `string` | `null` | no |
| <a name="input_sign_in_frequency_period"></a> [sign\_in\_frequency\_period](#input\_sign\_in\_frequency\_period) | The time period to enforce sign-in frequency. Required when sign\_in\_frequency\_interval is 'timeBased'. | `string` | `null` | no |
| <a name="input_sign_in_risk_levels"></a> [sign\_in\_risk\_levels](#input\_sign\_in\_risk\_levels) | List of sign-in risk levels to trigger the policy | `list(string)` | `[]` | no |
| <a name="input_user_risk_levels"></a> [user\_risk\_levels](#input\_user\_risk\_levels) | List of user risk levels to trigger the policy | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_display_name"></a> [policy\_display\_name](#output\_policy\_display\_name) | The display name of the conditional access policy |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The ID of the conditional access policy |
| <a name="output_policy_object_id"></a> [policy\_object\_id](#output\_policy\_object\_id) | The object ID of the conditional access policy |
| <a name="output_policy_resource_url"></a> [policy\_resource\_url](#output\_policy\_resource\_url) | The full URL path to this policy resource |
<!-- END_TF_DOCS -->
