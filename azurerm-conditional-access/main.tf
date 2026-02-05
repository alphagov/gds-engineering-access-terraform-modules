locals {
  is_time_based_sign_in_frequency = var.sign_in_frequency_interval == "timeBased"
}

resource "azuread_conditional_access_policy" "policy" {
  display_name = var.policy_name
  state        = var.policy_state

  conditions {
    client_app_types = var.client_app_types

    authentication_flow_transfer_methods = length(var.authentication_flow_transfer_methods) > 0 ? var.authentication_flow_transfer_methods : null

    applications {
      included_user_actions = try(length(var.included_user_actions) > 0, false) ? var.included_user_actions : null
      included_applications = try(length(var.included_user_actions) > 0, false) ? null : var.included_applications
      excluded_applications = try(length(var.included_user_actions) > 0, false) ? null : var.excluded_applications
    }

    dynamic "locations" {
      for_each = length(var.included_locations) > 0 || length(var.excluded_locations) > 0 ? [1] : []
      content {
        included_locations = var.included_locations
        excluded_locations = var.excluded_locations
      }
    }

    users {
      included_users  = var.included_users
      excluded_users  = var.exclude_guests ? ["GuestsOrExternalUsers"] : []
      excluded_groups = var.excluded_groups
    }

    sign_in_risk_levels = length(var.sign_in_risk_levels) > 0 ? var.sign_in_risk_levels : null
    user_risk_levels    = length(var.user_risk_levels) > 0 ? var.user_risk_levels : null
    insider_risk_levels = var.insider_risk_levels
  }

  grant_controls {
    operator                          = var.grant_operator
    built_in_controls                 = var.built_in_controls
    authentication_strength_policy_id = var.authentication_strength_policy_id
  }

  dynamic "session_controls" {
    for_each = var.sign_in_frequency_interval != null ? [1] : []
    content {
      sign_in_frequency          = local.is_time_based_sign_in_frequency ? var.sign_in_frequency : null
      sign_in_frequency_interval = var.sign_in_frequency_interval
      sign_in_frequency_period   = local.is_time_based_sign_in_frequency ? var.sign_in_frequency_period : null
    }
  }
}
