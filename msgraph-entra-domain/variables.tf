variable "name" {
  description = "Fully qualified domain name to add to the Microsoft Entra ID tenancy"
  type        = string
}

variable "verify" {
  description = "Whether to automatically verify the domain (requires DNS verification records to be added)"
  type        = bool
  default     = false
}
