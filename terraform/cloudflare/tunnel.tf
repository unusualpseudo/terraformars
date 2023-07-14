resource "random_id" "tunnel-secret" {
  byte_length = 40
}

resource "cloudflare_tunnel" "homelab" {
  name       = "homelab"
  account_id = data.sops_file.cloudflare_secrets.data["cloudflare_account_id"]
  secret     = random_id.tunnel-secret.b64_std
}
