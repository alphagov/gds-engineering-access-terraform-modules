output "policy_id" {
  description = "The ID of the conditional access policy"
  value       = msgraph_resource.policy.id
}

output "policy_object_id" {
  description = "The object ID of the conditional access policy"
  value       = msgraph_resource.policy.output.id
}

output "policy_display_name" {
  description = "The display name of the conditional access policy"
  value       = msgraph_resource.policy.output.display_name
}

output "policy_resource_url" {
  description = "The full URL path to this policy resource"
  value       = msgraph_resource.policy.resource_url
}
