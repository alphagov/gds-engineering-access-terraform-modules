output "domain_verification_dns_records" {
  description = <<-EOD
  DNS records required by Entra for domain verification

  The records become available after setting up the domain in Entra.
  They remain active until the domain is verified. Afterwards, the records will be emptied out automatically
  `terraform plan` will show a diff after verification to clear them
  The diff changes have no consequence and can be safely applied
  EOD

  value = {
    instructions = "Add these DNS records in the domain's DNS provider"
    value = [
      for r in data.msgraph_resource.domain_verification_dns_records.output.all : r
      if r.recordType == "Txt"
    ]
  }
}

output "domain_verification_dns_records2" {
  description = <<-EOD
  DNS records required by Entra for domain verification

  The records become available after setting up the domain in Entra.
  They remain active until the domain is verified. Afterwards, the records will be emptied out automatically
  `terraform plan` will show a diff after verification to clear them
  The diff changes have no consequence and can be safely applied
  EOD

  value = {
    instructions = "Add these DNS records in the domain's DNS provider"
    value = [
      for r in data.msgraph_resource.domain_verification_dns_records.output.all : r
      if r.recordType == "Txt"
    ]
  }
}
