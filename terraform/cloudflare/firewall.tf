resource "cloudflare_ruleset" "zone_waf_ruleset" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = "custom waf"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules {
    description = "GEOIP Rule"
    action      = "block"
    enabled     = true
    expression  = "(ip.geoip.country ne \"${data.sops_file.cloudflare_secrets.data["country"]}\")"
  }
  rules {
    action      = "block"
    description = "High Threat Level Protection"
    enabled     = true
    expression  = "(cf.threat_score gt 1)"
  }
  rules {
    action      = "block"
    description = "Block Bad Bots"
    enabled     = true
    expression  = "(http.user_agent contains \"Yandex\") \nor (http.user_agent contains \"muckrack\") \nor (http.user_agent contains \"Qwantify\") \nor (http.user_agent contains \"Sogou\") \nor (http.user_agent contains \"BUbiNG\") \nor (http.user_agent contains \"knowledge\") \nor (http.user_agent contains \"CFNetwork\") \nor (http.user_agent contains \"Scrapy\") \nor (http.user_agent contains \"SemrushBot\") \nor (http.user_agent contains \"AhrefsBot\") \nor (http.user_agent contains \"Baiduspider\") \nor (http.user_agent contains \"python-requests\") \nor ((http.user_agent contains \"crawl\") \nor (http.user_agent contains \"Crawl\") \nor (http.user_agent contains \"bot\" and not http.user_agent contains \"bingbot\" and not http.user_agent contains \"Google\" and not http.user_agent contains \"Twitter\")\nor (http.user_agent contains \"Bot\" and not http.user_agent contains \"Google\") \nor (http.user_agent contains \"Spider\") \nor (http.user_agent contains \"spider\") \nand not cf.client.bot)"
  }
}
