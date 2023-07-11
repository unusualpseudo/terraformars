
resource "cloudflare_zone_settings_override" "cloudflare_settings" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  settings {
    ssl                      = "strict"
    always_use_https         = "on"
    min_tls_version          = "1.2"
    opportunistic_encryption = "on"
    tls_1_3                  = "zrt"
    automatic_https_rewrites = "on"
    universal_ssl            = "on"
    # /firewall/settings
    browser_check  = "on"
    challenge_ttl  = 1800
    privacy_pass   = "on"
    security_level = "high"
    # /speed/optimization
    brotli = "on"
    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }
    rocket_loader = "on"
    # /caching/configuration
    always_online    = "off"
    development_mode = "off"
    # /network
    http3               = "on"
    zero_rtt            = "on"
    ipv6                = "off"
    websockets          = "off"
    opportunistic_onion = "on"
    pseudo_ipv4         = "off"
    ip_geolocation      = "on"
    # /content-protection
    email_obfuscation       = "on"
    server_side_exclude     = "off"
    hotlink_protection      = "on"
    origin_max_http_version = 2
    # /workers
    security_header {
      enabled = false
    }
  }
}


resource "cloudflare_ruleset" "zone_waf_ruleset" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = "Spike custom waf"
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



resource "random_id" "tunnel-secret" {
  byte_length = 40
}

resource "cloudflare_tunnel" "homelab" {
  name       = "homelab"
  account_id = data.sops_file.cloudflare_secrets.data["cloudflare_account_id"]
  secret     = random_id.tunnel-secret.b64_std
}
