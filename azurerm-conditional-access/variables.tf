variable "policy_name" {
  description = "The display name of the conditional access policy"
  type        = string
}

variable "policy_state" {
  description = "The state of the policy: enabled, disabled, or enabledForReportingButNotEnforced"
  type        = string
  default     = "enabled"

  validation {
    condition     = contains(["enabled", "disabled", "enabledForReportingButNotEnforced"], var.policy_state)
    error_message = "Policy state must be enabled, disabled or enabledForReportingButNotEnforced."
  }
}

variable "client_app_types" {
  description = "List of client app types to include"
  type        = list(string)
  default     = ["all"]
}

variable "included_applications" {
  description = "List of application IDs to include"
  type        = list(string)
  default     = ["All"]
}

variable "excluded_applications" {
  description = "List of application IDs to exclude"
  type        = list(string)
  default     = []
}

variable "included_user_actions" {
  description = "List of user actions to include"
  type        = list(string)
  default     = null
}

variable "included_locations" {
  description = "List of location names to include"
  type        = list(string)
  default     = []
}

variable "excluded_locations" {
  description = "List of location names to exclude"
  type        = list(string)
  default     = []
}

variable "included_users" {
  description = "List of user IDs or groups to include"
  type        = list(string)
  default     = ["All"]
}

variable "excluded_groups" {
  description = "List of group IDs to exclude from conditional access policies (break glass accounts)"
  type        = list(string)

  validation {
    condition = alltrue([
      for group_id in var.excluded_groups :
      can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", group_id))
    ])
    error_message = "All excluded_groups values must be valid Entra ID Object IDs (UUIDs in the format xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx), not display names."
  }
}

variable "exclude_guests" {
  description = "Whether to exclude guests and external users"
  type        = bool
  default     = false
}

variable "built_in_controls" {
  description = "List of built-in grant controls (block, mfa, compliantDevice, etc.)"
  type        = list(string)
}

variable "authentication_strength_policy_id" {
  description = "ID of the authentication strength policy to require. Must be a full resource path i.e. /policies/authenticationStrengthPolicies/<UUID>. See https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths."
  type        = string
  default     = null

  validation {
    condition = var.authentication_strength_policy_id == null || (
      can(regex("^/policies/authenticationStrengthPolicies/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.authentication_strength_policy_id))
    )
    error_message = "authentication_strength_policy_id must be a full resource path i.e. /policies/authenticationStrengthPolicies/<UUID>. See https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths#built-in-authentication-strengths."
  }
}

variable "grant_operator" {
  description = "Grant controls operator: OR or AND"
  type        = string
  default     = "OR"
}

variable "sign_in_risk_levels" {
  description = "List of sign-in risk levels to trigger the policy"
  type        = list(string)
  default     = []
}

variable "sign_in_frequency" {
  description = "Number of days or hours to enforce sign-in frequency. Required when sign_in_frequency_interval is 'timeBased'."
  type        = number
  default     = null
}

variable "sign_in_frequency_interval" {
  description = "The interval to apply to sign-in frequency control."
  type        = string
  default     = null

  validation {
    condition     = var.sign_in_frequency_interval == null || contains(["timeBased", "everyTime"], var.sign_in_frequency_interval)
    error_message = "sign_in_frequency_interval must be timeBased or everyTime."
  }
}

variable "sign_in_frequency_period" {
  description = "The time period to enforce sign-in frequency. Required when sign_in_frequency_interval is 'timeBased'."
  type        = string
  default     = null

  validation {
    condition     = var.sign_in_frequency_period == null || contains(["days", "hours"], var.sign_in_frequency_period)
    error_message = "sign_in_frequency_period must be days or hours."
  }
}
