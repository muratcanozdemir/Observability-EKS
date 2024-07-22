resource "aws_route53_zone" "main" {
  #TODO Checkov compliance
  name = var.domain_name
}

module "observability" {
  source                 = "./prometheus-grafana-loki"
  azure_ad_client_id     = var.azure_ad_client_id
  azure_ad_client_secret = var.azure_ad_client_secret
  azure_ad_tenant_id     = var.azure_ad_tenant_id
  domain_name            = var.domain_name
  zone_id                = aws_route53_zone.main.zone_id

  remote_write_bucket = var.remote_write_bucket
  token               = var.remote_write_password
  remote_write_url    = var.remote_write_url
  datadog_api_key     = var.datadog_api_key
  dynatrace_env_id    = var.dynatrace_env_id
  dynatrace_token     = var.dynatrace_token
  splunk_token        = var.splunk_token

  grafana_admin_password = var.grafana_admin_password
  grafana_admin_user     = var.grafana_admin_user

}