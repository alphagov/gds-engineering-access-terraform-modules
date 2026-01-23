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
    If the value is set to 'true' the domain becomes the default.
    It is not possible to demote the domain with a value of 'false'.
    Demotion happens by the virtue of promoting another domain to be the default.
  EOD
  type        = bool
  default     = false
}
