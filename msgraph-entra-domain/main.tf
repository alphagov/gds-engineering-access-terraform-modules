# Create domain
# The domain name is represented by the domain ID. It cannot be changed since it is an immutable identifier in Microsoft Graph.
resource "msgraph_resource" "this_domain" {
  url = "domains"
  body = {
    id = var.name
  }
  update_method = "PATCH"
  response_export_values = {
    all = "@"
  }
}

# Retrieve the status of the domain after its creation
data "msgraph_resource" "domain_status" {
  url = "domains/${msgraph_resource.this_domain.output.all.id}"
  response_export_values = {
    all = "@"
  }
}

# Retrieve domain DNS verification records
data "msgraph_resource" "domain_verification_dns_records" {
  url = "domains/${msgraph_resource.this_domain.output.all.id}/verificationDnsRecords"
  response_export_values = {
    all = "@"
  }
}

# Trigger domain verification after the DNS verification records have been added
resource "msgraph_resource_action" "domain_verify" {
  count = var.verify ? 1 : 0

  resource_url = "domains/${msgraph_resource.this_domain.output.all.id}"
  action       = "verify"
  method       = "POST"

  depends_on = [data.msgraph_resource.domain_status]

  lifecycle {
    # Ignore any change to prevent trying to verify more than once. Since the ID cannot be modified, this is safe to do
    ignore_changes = all
  }
}
