variable "name" {
  description = "Fully qualified domain name to add to the Microsoft Entra ID tenancy"
  type        = string
}

variable "verify" {
  description = "Whether to automatically verify the domain (requires DNS verification records to be added)"
  type        = bool
  default     = false
}

variable "default" {
  description = <<-EOD
    Whether to set this domain as default for new users. This is the same as making it the Primary domain.
    Only a value of 'true' is allowed, since it is not possible to demote a domain. Demotion happens by the virtue of promoting another domain to be the default.
  EOD
  type        = bool
  default     = null

  validation {
    condition     = var.default == null || var.default == true
    error_message = "Value must be 'true'. The domain can only be promoted, not vice-versa"
  }
}
