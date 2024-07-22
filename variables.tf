variable "region" {
  type        = string
  description = "AWS region"
}

variable "domain_name" {
  type        = string
  description = "Your base domain"
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

variable "remote_write_bucket" {
  description = "The S3 bucket URL for Loki remote write"
  type        = string
}

variable "remote_write_url" {
  description = "Remote write URL for Prometheus"
  type        = string
}

variable "remote_write_password" {
  description = "Remote write OAuth token for Prometheus"
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