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

variable "dns_resolver" {
  type = object(
    {
      name                                     = string
      virtual_network_name                     = string
      virtual_network_name_resource_group_name = string
      subnet_name                              = string
      inbound_endpoint_name                    = string
    }
  )
  description = "Private DNS resolver"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
