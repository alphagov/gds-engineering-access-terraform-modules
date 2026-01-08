data "azuread_groups" "break_glass_groups" {
  object_ids = var.excluded_groups
}
