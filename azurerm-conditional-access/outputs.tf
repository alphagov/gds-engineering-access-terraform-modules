output "policy_id" {
  description = "The ID of the conditional access policy"
  value       = azuread_conditional_access_policy.policy.id
}

output "policy_object_id" {
  description = "The object ID of the conditional access policy"
  value       = azuread_conditional_access_policy.policy.object_id
}

output "policy_display_name" {
  description = "The display name of the conditional access policy"
  value       = azuread_conditional_access_policy.policy.display_name
}

output "policy_display_name2" {
  description = "The display name of the conditional access policy"
  value       = azuread_conditional_access_policy.policy.display_name
}
