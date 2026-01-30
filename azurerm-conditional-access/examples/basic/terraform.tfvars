reporting_only_for_all_policies = true

excluded_groups = [
  "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "f9e8d7c6-b5a4-3210-fedc-ba0987654321"
]

trusted_locations = {
  office_hq = {
    display_name = "Office HQ"
    ip_ranges    = ["203.0.113.0/24", "198.51.100.0/24"]
  }
  branch_office = {
    display_name = "Branch Office"
    ip_ranges    = ["192.0.2.0/24"]
  }
}
