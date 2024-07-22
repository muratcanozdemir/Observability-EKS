variable "zone_id" {
  type        = string
  description = "Your AWS Route53 Zone id"
}

variable "domain_name" {
  type        = string
  description = "Inherited from the main module, your base domain name"
}

variable "grafana_admin_user" {
  description = "Admin username for Grafana"
  type        = string
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "azure_ad_client_id" {
  description = "Azure AD Application (Client) ID"
  type        = string
}

variable "azure_ad_client_secret" {
  description = "Azure AD Client Secret"
  type        = string
}

variable "azure_ad_tenant_id" {
  description = "Azure AD Directory (Tenant) ID"
  type        = string
}

variable "remote_write_url" {
  description = "The URL for Prometheus remote write"
  type        = string
}

variable "token" {
  description = "The OAuth token for Prometheus remote write"
  type        = string
  sensitive   = true
}

variable "splunk_token" {
  description = "Splunk token for Promethes"
  type        = string
  sensitive   = true
}

variable "remote_write_bucket" {
  description = "The S3 bucket URL for Loki remote write"
  type        = string
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key"
}

variable "dynatrace_token" {
  type        = string
  description = "Dynatrace token"
}

variable "dynatrace_env_id" {
  type        = string
  description = "Dynatrace environment id"
}