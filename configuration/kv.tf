resource "vault_generic_secret" "payments_gateway_foo" {
  path = "secret/payments/foo-gateway"

  # Values for these Keys must be updated manually by
  # an administrator post creation of secret
  data_json = <<EOT
{
  "merchant-id":     "",
  "merchant-secret": ""
}
EOT
}
