terraform {
  required_version = ">= 1.11.0"
  required_providers {
    msgraph = {
      source  = "microsoft/msgraph"
      version = "~> 0.3"
    }
  }
}
