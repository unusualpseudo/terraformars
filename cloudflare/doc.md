# Issues with Terraform state

[cf-terraforming](https://github.com/cloudflare/cf-terraforming) is an utility cmd that imports an existing cloudflare resources into a terraform state.

```shell
  cf-terraforming import \
  --resource-type "cloudflare_record" \
  --email $CLOUDFLARE_EMAIL \
  --key $CLOUDFLARE_API_KEY \
  --zone $CLOUDFLARE_ZONE_ID
```

Delete a ruleset resource

```shell
  curl --request DELETE \
  https://api.cloudflare.com/client/v4/accounts/{account_id}/rulesets/{ruleset_id} \
--header "Authorization: Bearer <API_TOKEN>"
```
