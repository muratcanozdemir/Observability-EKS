output "prometheus_url" {
  value = "http://prometheus.${var.domain_name}"
}

output "grafana_url" {
  value = "http://grafana.${var.domain_name}"
}
