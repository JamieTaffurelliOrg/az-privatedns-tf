variable "resource_group_name" {
  type        = string
  description = "Resource Group name to deploy to"
}

variable "private_dns_zones" {
  type = list(object(
    {
      name = string
      a_records = optional(list(object(
        {
          name         = string
          time_to_live = number
          records      = list(string)
        }
      )), [])
      cname_records = optional(list(object(
        {
          name         = string
          time_to_live = number
          record       = list(string)
        }
      )), [])
    }
  ))
  description = "Private DNS zones to deploy"
}
