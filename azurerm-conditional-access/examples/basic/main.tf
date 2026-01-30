#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

# Note Microsoft's recommended naming standards here: https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access#set-naming-standards-for-your-policies

# Create named locations for trusted IP ranges
resource "azuread_named_location" "trusted_locations" {
  for_each = var.trusted_locations

  display_name = each.value.display_name
  ip {
    ip_ranges = each.value.ip_ranges
    trusted   = true
  }
}

module "conditional_access_policies" {
  source   = "../../"
  for_each = local.conditional_access_policies

  policy_name                       = each.value.policy_name
  policy_state                      = lookup(each.value, "policy_state", "enabledForReportingButNotEnforced") # Default to reporting only to reduce risk of lockout due to policy misconfiguration
  client_app_types                  = lookup(each.value, "client_app_types", ["all"])
  included_applications             = lookup(each.value, "included_applications", ["All"])
  excluded_applications             = lookup(each.value, "excluded_applications", [])
  included_user_actions             = lookup(each.value, "included_user_actions", null)
  included_locations                = lookup(each.value, "included_locations", [])
  excluded_locations                = lookup(each.value, "excluded_locations", [])
  included_users                    = lookup(each.value, "included_users", ["All"])
  excluded_groups                   = each.value["excluded_groups"]
  exclude_guests                    = lookup(each.value, "exclude_guests", false)
  grant_operator                    = lookup(each.value, "grant_operator", "OR")
  built_in_controls                 = lookup(each.value, "built_in_controls", null)
  authentication_strength_policy_id = lookup(each.value, "authentication_strength_policy_id", null)
  sign_in_risk_levels               = lookup(each.value, "sign_in_risk_levels", [])
  sign_in_frequency_enabled         = lookup(each.value, "sign_in_frequency_enabled", false)

  # All policies depend on named locations being created first
  depends_on = [azuread_named_location.trusted_locations]
}
