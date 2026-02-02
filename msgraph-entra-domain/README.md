# Description

Module to manage Entra ID domains.

## Usage

Add the domain in Entra:
```hcl
module "entra_domain" {
  source = "<repo_url>/msgraph-entra-domain"
  name   = "domain_name"
}
```

Get the domain verification DNS records from the terraform output:
``` hcl
# $ terraform output
entra_domain_verification_dns_records = {
  "value" = [
    {
      "@odata.type" = "#microsoft.graph.domainDnsTxtRecord"
      "id" = "aceff52c-06a5-447f-ac5f-256ad243cc5c"
      "isOptional" = false
      "label" = "sandbox.id.digital.gov.uk"
      "recordType" = "Txt"
      "supportedService" = "Email"
      "text" = "MS=ms36738167"
      "ttl" = 3600
    },
  ]
}
```

Add the records to the domain's DNS provider. Required fields:
* recordType
* value
* TTL

Trigger domain verification:
```hcl
module "entra_domain" {
  source  = "<repo_url>/msgraph-entra-domain"
  name    = "domain_name"
+ verify  = true
+ default = true # optionally make it default
}
```

## Caveats

### Verifying a domain

If the module is declared with `verify = true` for the first time, there will be an error! This is due to failing verification, because it is not possible to know the DNS records before creating the domain.

To fix it, change `verify` to `false`, and make note of the DNS records from the terraform output. Add them in the DNS provider, and once ready change `verify` to `true`.

### Updating domain properties

Any changes to domain properties, are only possible after the domain is verified.

* `Domain name`: this is represented by the domain ID. Because it is an immutable identifier in Microsoft Graph, it cannot be changed.
* `Any other property`: most properties are read-only, but changes to properties are only possible after domain verification.

### Demoting a domain

The API doesn't allow demoting a domain. Demotion happens by the virtue of promoting another domain to be the default for the Entra tenancy.
Therefore changing `default` value to `false` is not possible.

### Destroying a domain

The destruction of the domain can only happen in the following conditions:
* The domain is **not** the default domain for the Entra tenancy
* The domain is **not** in use (meaning there are no users assigned to this domain)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13 |
| <a name="requirement_msgraph"></a> [msgraph](#requirement\_msgraph) | ~> 0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_msgraph"></a> [msgraph](#provider\_msgraph) | ~> 0.3 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [msgraph_resource.this_domain](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/resources/resource) | resource |
| [msgraph_resource_action.domain_verify](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/resources/resource_action) | resource |
| [msgraph_resource_action.update_domain](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/resources/resource_action) | resource |
| [terraform_data.domain_name](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [msgraph_resource.domain_verification_dns_records](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/data-sources/resource) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default"></a> [default](#input\_default) | Whether to set this domain as default for new users. This is the same as making it the Primary domain.<br/>Only a value of 'true' is allowed, since it is not possible to demote a domain. Demotion happens by the virtue of promoting another domain to be the default. | `bool` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Fully qualified domain name to add to the Microsoft Entra ID tenancy | `string` | n/a | yes |
| <a name="input_verify"></a> [verify](#input\_verify) | Whether to automatically verify the domain (requires DNS verification records to be added) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_verification_dns_records"></a> [domain\_verification\_dns\_records](#output\_domain\_verification\_dns\_records) | DNS records required by Entra for domain verification<br/><br/>The records become available after setting up the domain in Entra.<br/>They remain active until the domain is verified. Afterwards, the records will be emptied out automatically<br/>`terraform plan` will show a diff after verification to clear them<br/>The diff changes have no consequence and can be safely applied |
<!-- END_TF_DOCS -->
