locals {
  # Conditional access policy configurations
  conditional_access_policies = {
    require_mfa = {
      policy_name               = "CA01 - All Users: Require MFA"
      client_app_types          = ["all"]
      included_applications     = ["All"]
      excluded_applications     = []
      included_users            = ["All"]
      excluded_groups           = data.azuread_groups.break_glass_groups.object_ids
      built_in_controls         = ["mfa"]
      sign_in_frequency_enabled = true
      depends_on_locations      = false
      policy_state              = "enabledForReportingButNotEnforced"
    }

    network_block = {
      policy_name           = "CA02 - All Users: Block For All Users When From Untrusted Location"
      client_app_types      = ["all"]
      included_applications = ["All"]
      excluded_applications = []
      included_locations    = ["All"]
      excluded_locations    = ["AllTrusted"]
      included_users        = ["All"]
      excluded_groups       = data.azuread_groups.break_glass_groups.object_ids
      built_in_controls     = ["block"]
      depends_on_locations  = true
      policy_state          = "enabledForReportingButNotEnforced"
    }

    legacy_authentication_block = {
      policy_name           = "CA03 - All Users: Block For All Users When Legacy Authentication Used"
      client_app_types      = ["exchangeActiveSync", "other"]
      included_applications = ["All"]
      excluded_applications = []
      included_users        = ["All"]
      excluded_groups       = data.azuread_groups.break_glass_groups.object_ids
      built_in_controls     = ["block"]
      depends_on_locations  = false
      policy_state          = "enabledForReportingButNotEnforced"
    }

    secure_security_info_registration = {
      policy_name           = "CA04 - All Users: Combined Security Info Registration with TAP"
      client_app_types      = ["all"]
      included_applications = []
      excluded_applications = []
      included_user_actions = ["urn:user:registersecurityinfo"]
      included_locations    = ["All"]
      excluded_locations    = ["AllTrusted"]
      included_users        = ["All"]
      excluded_groups       = data.azuread_groups.break_glass_groups.object_ids
      exclude_guests        = true
      built_in_controls     = ["mfa"]
      depends_on_locations  = true
      policy_state          = "enabledForReportingButNotEnforced"
    }

    restrict_device_code_flow = {
      policy_name           = "CA05 - All Users: Restrict Device Code Flow and Authentication Transfer"
      client_app_types      = ["all"]
      included_applications = ["All"]
      excluded_applications = []
      included_users        = ["All"]
      excluded_groups       = data.azuread_groups.break_glass_groups.object_ids
      built_in_controls     = ["block"]
      depends_on_locations  = false
      policy_state          = "enabledForReportingButNotEnforced"
    }

    phishing_resistant_mfa = {
      policy_name                       = "CA - Require Phishing-Resistant MFA for Admins"
      client_app_types                  = ["all"]
      included_applications             = ["All"]
      excluded_applications             = []
      included_users                    = ["All"]
      excluded_groups                   = data.azuread_groups.break_glass_groups.object_ids
      grant_operator                    = "AND"
      authentication_strength_policy_id = "/policies/authenticationStrengthPolicies/<policy GUID>" # Look up Phishing-resistant MFA strength policy GUID: https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths
      policy_state                      = "enabledForReportingButNotEnforced"
    }

    passwordless_mfa = {
      policy_name                       = "CA - Require Passwordless MFA"
      client_app_types                  = ["all"]
      included_applications             = ["All"]
      excluded_applications             = []
      included_users                    = ["All"]
      excluded_groups                   = data.azuread_groups.break_glass_groups.object_ids
      grant_operator                    = "AND"
      authentication_strength_policy_id = "/policies/authenticationStrengthPolicies/<policy GUID>" # Look up Passwordless MFA strength policy GUID: https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths
      policy_state                      = "enabledForReportingButNotEnforced"
    }
  }
}
