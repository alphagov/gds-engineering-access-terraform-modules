# The domain name is represented by the domain ID. It is an immutable identifier in Microsoft Graph, and therefore it cannot be changed.
# This resource is used to store the input in the terraform state once, so it can be checked against changes later
resource "terraform_data" "domain_name" {
  input = var.name

  lifecycle {
    ignore_changes = [input]
  }
}

# Create domain
resource "msgraph_resource" "this_domain" {
  url = "domains"
  body = {
    id = terraform_data.domain_name.output
  }

  response_export_values = {
    all = "@"
  }

  lifecycle {
    precondition {
      condition     = var.name == terraform_data.domain_name.output
      error_message = "The domain name is immutable and cannot be changed."
    }
  }
}

# Retrieve domain DNS verification records
data "msgraph_resource" "domain_verification_dns_records" {
  url = "domains/${msgraph_resource.this_domain.output.all.id}/verificationDnsRecords"
  response_export_values = {
    all = "value"
  }

  lifecycle {
    postcondition {
      condition     = length(self.response_export_values.all) > 0
      error_message = "No DNS records were returned for the domain."
    }
  }
}

# Trigger domain verification after the DNS verification records have been added
resource "msgraph_resource_action" "domain_verify" {
  count = var.verify ? 1 : 0

  resource_url = "domains/${msgraph_resource.this_domain.output.all.id}"
  action       = "verify"
  method       = "POST"

  depends_on = [msgraph_resource.this_domain]

  lifecycle {
    # Ignore any changes to prevent verifying more than once
    ignore_changes = all
  }
}

# Change domain properties. These can only be updated after the domain has been verified
resource "msgraph_resource_action" "update_domain" {
  count = var.verify && var.default ? 1 : 0

  resource_url = "domains/${msgraph_resource.this_domain.output.all.id}"
  method       = "PATCH"
  body = {
    isDefault = var.default
  }

  depends_on = [msgraph_resource_action.domain_verify]
}
