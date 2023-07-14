data "sops_file" "cloudflare_secrets" {
  source_file = "cloudflare_secrets.sops.yaml"
  input_type  = "yaml"
}

data "cloudflare_zones" "domain" {
  filter {
    name = data.sops_file.cloudflare_secrets.data["cloudflare_domain"]
  }
}
