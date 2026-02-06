locals {
  is_time_based_sign_in_frequency = var.sign_in_frequency_interval == "timeBased"

  # Determine which application condition type to use (mutually exclusive)
  use_user_actions = var.included_user_actions != null && length(var.included_user_actions) > 0
  use_auth_context = length(var.included_authentication_context_class_references) > 0
  use_applications = !local.use_user_actions && !local.use_auth_context

  # Build applications object based on condition type
  applications_body = merge(
    local.use_applications ? {
      includeApplications = var.included_applications
      excludeApplications = length(var.excluded_applications) > 0 ? var.excluded_applications : null
    } : {},
    local.use_user_actions ? {
      includeUserActions = var.included_user_actions
    } : {},
    local.use_auth_context ? {
      includeAuthenticationContextClassReferences = var.included_authentication_context_class_references
    } : {}
  )

  # Build locations object (only if locations are specified)
  locations_body = (length(var.included_locations) > 0 || length(var.excluded_locations) > 0) ? {
    locations = {
      includeLocations = var.included_locations
      excludeLocations = length(var.excluded_locations) > 0 ? var.excluded_locations : null
    }
  } : {}

  # Build platforms object (only if platforms are specified)
  platforms_body = var.included_platforms != null ? {
    platforms = {
      includePlatforms = var.included_platforms
      excludePlatforms = var.excluded_platforms
    }
  } : {}

  # Build sign-in risk levels (only if specified)
  sign_in_risk_body = length(var.sign_in_risk_levels) > 0 ? {
    signInRiskLevels = var.sign_in_risk_levels
  } : {}

  # Build user risk levels (only if specified)
  user_risk_body = length(var.user_risk_levels) > 0 ? {
    userRiskLevels = var.user_risk_levels
  } : {}

  # Build insider risk levels (only if specified)
  insider_risk_body = var.insider_risk_levels != null ? {
    insiderRiskLevels = var.insider_risk_levels
  } : {}

  # Build authentication flow transfer methods (only if specified)
  auth_flow_body = length(var.authentication_flow_transfer_methods) > 0 ? {
    authenticationFlows = {
      transferMethods = var.authentication_flow_transfer_methods
    }
  } : {}

  # Build grant controls
  grant_controls_body = merge(
    {
      operator = var.grant_operator
    },
    var.built_in_controls != null ? {
      builtInControls = var.built_in_controls
    } : {},
    var.authentication_strength_policy_id != null ? {
      authenticationStrength = {
        id = var.authentication_strength_policy_id
      }
    } : {}
  )

  # Build session controls (only if sign-in frequency is specified)
  session_controls_body = var.sign_in_frequency_interval != null ? {
    sessionControls = {
      signInFrequency = merge(
        {
          isEnabled         = true
          frequencyInterval = var.sign_in_frequency_interval
        },
        local.is_time_based_sign_in_frequency ? {
          value = var.sign_in_frequency
          type  = var.sign_in_frequency_period
        } : {}
      )
    }
  } : {}

  # Build excluded users list
  excluded_users = var.exclude_guests ? ["GuestsOrExternalUsers"] : null
}

resource "msgraph_resource" "policy" {
  url = "identity/conditionalAccess/policies"

  body = merge(
    {
      displayName = var.policy_name
      state       = var.policy_state

      conditions = merge(
        {
          clientAppTypes = var.client_app_types
          applications   = local.applications_body
          users = {
            includeUsers  = var.included_users
            excludeUsers  = local.excluded_users
            excludeGroups = length(var.excluded_groups) > 0 ? var.excluded_groups : null
          }
        },
        local.locations_body,
        local.platforms_body,
        local.sign_in_risk_body,
        local.user_risk_body,
        local.insider_risk_body,
        local.auth_flow_body
      )

      grantControls = local.grant_controls_body
    },
    local.session_controls_body
  )

  response_export_values = {
    all          = "@"
    id           = "id"
    display_name = "displayName"
  }

  lifecycle {
    precondition {
      condition     = (var.built_in_controls != null) != (var.authentication_strength_policy_id != null)
      error_message = "Exactly one of built_in_controls or authentication_strength_policy_id must be specified, not both or neither."
    }
    precondition {
      condition     = (local.use_applications ? 1 : 0) + (local.use_user_actions ? 1 : 0) + (local.use_auth_context ? 1 : 0) == 1
      error_message = "Exactly one of included_applications, included_user_actions or included_authentication_context_class_references must be specified."
    }
  }
}
