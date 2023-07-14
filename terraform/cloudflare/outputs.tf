output "cloudflare_tunnel" {
  value     = cloudflare_tunnel.homelab
  sensitive = true
}


output "zone_domain" {
  value     = data.sops_file.cloudflare_secrets.data["cloudflare_domain"]
  sensitive = true
}
