# DNS records are available after setting up the domain.
# They remain until the domain is verified. Afterwards, the records will be emptied out
# `terraform plan` will show a diff after verification to clear them
# The diff changes have no consequence and they can be safely applied
output "domain_verification_dns_records" {
  value = data.msgraph_resource.domain_verification_dns_records.output.all
}
