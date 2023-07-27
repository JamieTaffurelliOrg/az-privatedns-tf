variable "resource_group_name" {
  type        = string
  description = "Resource Group name to deploy to"
}

variable "private_dns_zones" {
  type = list(object(
    {
      name                              = string
      link_dns_resolver_virtual_network = optional(bool, false)
      registration_enabled              = optional(bool, false)
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
  default     = []
  description = "Private DNS zones to deploy"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
