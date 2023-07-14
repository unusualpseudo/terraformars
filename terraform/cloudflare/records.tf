locals {
  dns_records = {
    txt = {
      name    = "@"
      value   = "hosted-email-verify=ga1tndtv"
      type    = "TXT"
      proxied = false
    },
    mx1 = {
      name     = "@"
      value    = "aspmx1.migadu.com"
      type     = "MX"
      priority = "10"
      proxied  = false
    },
    mx2 = {
      name     = "@"
      value    = "aspmx2.migadu.com"
      type     = "MX"
      priority = "20"
      proxied  = false
    },
    dkim_arc1 = {
      name    = "key1._domainkey"
      value   = "key1.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}._domainkey.migadu.com."
      type    = "CNAME"
      proxied = false
    },
    dkim_arc2 = {
      name    = "key2._domainkey"
      value   = "key2.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}._domainkey.migadu.com."
      type    = "CNAME"
      proxied = false
    },
    dkim_arc3 = {
      name    = "key3._domainkey"
      value   = "key3.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}._domainkey.migadu.com."
      type    = "CNAME"
      proxied = false
    },
    spf = {
      name    = "@"
      value   = "v=spf1 include:spf.migadu.com -all"
      type    = "TXT"
      proxied = false
    },
    dmarc = {
      name    = "_dmarc"
      value   = "v=DMARC1; p=quarantine;"
      type    = "TXT"
      proxied = false
    }
  }
}

resource "cloudflare_record" "email_dns" {
  for_each = local.dns_records
  name     = each.value.name
  type     = each.value.type
  zone_id  = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value    = each.value.value
  proxied  = each.value.proxied
  priority = can(each.value.priority) ? each.value.priority : null
}
