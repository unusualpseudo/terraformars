
resource "cloudflare_zone_settings_override" "cloudflare_settings" {
  zone_id = data.cloudflare_zones.domain.zones[0]["id"]
  settings {
    ssl                      = "strict"
    always_use_https         = "on"
    min_tls_version          = "1.2"
    opportunistic_encryption = "on"
    tls_1_3                  = "zrt"
    automatic_https_rewrites = "on"
    universal_ssl            = "on"
    browser_check            = "on"
    challenge_ttl            = 1800
    privacy_pass             = "on"
    security_level           = "high"
    brotli                   = "on"
    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }
    rocket_loader           = "on"
    always_online           = "off"
    development_mode        = "off"
    http3                   = "on"
    zero_rtt                = "on"
    ipv6                    = "off"
    websockets              = "off"
    opportunistic_onion     = "on"
    pseudo_ipv4             = "off"
    ip_geolocation          = "on"
    email_obfuscation       = "on"
    server_side_exclude     = "off"
    hotlink_protection      = "on"
    origin_max_http_version = 2
  }
}
