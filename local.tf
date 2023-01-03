locals {
  a_records = distinct(flatten([
    for private_dns_zone in var.private_dns_zones : [
      for a_record in private_dns_zone.a_records : {
        private_dns_zone_name = private_dns_zone.name
        a_record_name         = a_record.name
        time_to_live          = a_record.time_to_live
        records               = a_record.records
      }
  ]]))

  cname_records = distinct(flatten([
    for private_dns_zone in var.private_dns_zones : [
      for cname_record in private_dns_zone.cname_records : {
        private_dns_zone_name = private_dns_zone.name
        cname_record_name     = cname_record.name
        time_to_live          = cname_record.time_to_live
        record                = cname_record.record
      }
  ]]))
}
