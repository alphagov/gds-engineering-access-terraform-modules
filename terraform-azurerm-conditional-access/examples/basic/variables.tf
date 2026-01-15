variable "reporting_only_for_all_policies" {
  type        = bool
  default     = true
  description = "If true, all conditional access policies will be created in reporting-only mode."
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

variable "trusted_locations" {
  type = map(object({
    display_name = string
    ip_ranges    = list(string)
  }))
  description = "Map of trusted IP locations for conditional access policies."
}
