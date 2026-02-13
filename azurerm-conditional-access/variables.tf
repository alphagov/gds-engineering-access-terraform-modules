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

variable "authentication_flow_transfer_methods" {
  description = "A list of authentication flow transfer methods included in the policy"
  type        = list(string)
  default     = []

  validation {
    condition = var.authentication_flow_transfer_methods == null || alltrue([
      for transfer_method in var.authentication_flow_transfer_methods :
      contains(["authenticationTransfer", "deviceCodeFlow"], transfer_method)
    ])
    error_message = "authentication_flow_transfer_methods must contain only: authenticationTransfer, deviceCodeFlow."
  }
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
  description = "List of built-in grant controls (block, mfa, compliantDevice, etc.). Cannot be used together with authentication_strength_policy_id."
  type        = list(string)
  default     = null
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

  validation {
    condition = alltrue([
      for level in var.sign_in_risk_levels :
      contains(["low", "medium", "high", "hidden", "none", "unknownFutureValue"], level)
    ])
    error_message = "sign_in_risk_levels must contain only: low, medium, high, hidden, none, unknownFutureValue."
  }
}

variable "user_risk_levels" {
  description = "List of user risk levels to trigger the policy"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for level in var.user_risk_levels :
      contains(["low", "medium", "high", "hidden", "none", "unknownFutureValue"], level)
    ])
    error_message = "user_risk_levels must contain only: low, medium, high, hidden, none, unknownFutureValue."
  }
}

variable "insider_risk_levels" {
  description = "The insider risk level to trigger the policy. This feature requires Microsoft Entra Insider Risk Management."
  type        = string
  default     = null

  validation {
    condition = var.insider_risk_levels == null || contains(
      ["minor", "moderate", "elevated", "unknownFutureValue"],
      var.insider_risk_levels
    )
    error_message = "insider_risk_levels must be one of: minor, moderate, elevated, unknownFutureValue."
  }
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

variable "included_platforms" {
  description = "List of platforms to include in the policy. Required when using platform conditions."
  type        = list(string)
  default     = null

  validation {
    condition = var.included_platforms == null || alltrue([
      for platform in var.included_platforms :
      contains(["all", "android", "iOS", "linux", "macOS", "windows", "windowsPhone", "unknownFutureValue"], platform)
    ])
    error_message = "included_platforms must contain only: all, android, iOS, linux, macOS, windows, windowsPhone, unknownFutureValue."
  }
}

variable "excluded_platforms" {
  description = "List of platforms to exclude from the policy"
  type        = list(string)
  default     = null

  validation {
    condition = var.excluded_platforms == null || alltrue([
      for platform in var.excluded_platforms :
      contains(["all", "android", "iOS", "linux", "macOS", "windows", "windowsPhone", "unknownFutureValue"], platform)
    ])
    error_message = "excluded_platforms must contain only: all, android, iOS, linux, macOS, windows, windowsPhone, unknownFutureValue."
  }
}

variable "included_service_principals" {
  description = "A list of service principal IDs explicitly included in the policy. Can be set to ServicePrincipalsInMyTenant to include all service principals. This is a mandatory argument when excluded_service_principals is set. Workload Identities Premium licenses are required to use service principal conditions in conditional access policies."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.included_service_principals) == 0 || (alltrue([
      for sp in var.included_service_principals : sp == "ServicePrincipalsInMyTenant" || can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", sp))
    ]))
    error_message = "Must be a list of Entra ID Service Principal/Enterprise Application Object IDs (not to be confused with App Registration Object IDs). Can be set to ServicePrincipalsInMyTenant to include all service principals. This is a mandatory argument when excluded_service_principals is set. Workload Identities Premium licenses are required to use service principal conditions in conditional access policies."
  }
}

variable "excluded_service_principals" {
  description = "A list of service principal IDs explicitly excluded in the policy."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.excluded_service_principals) == 0 || (alltrue([
      for sp in var.excluded_service_principals : can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", sp))
    ]) && length(var.included_service_principals) > 0)
    error_message = "Must be a list of Entra ID Service Principal/Enterprise Application Object IDs (not to be confused with App Registration Object IDs). Must also set included_service_principals when this argument is used."
  }
}
