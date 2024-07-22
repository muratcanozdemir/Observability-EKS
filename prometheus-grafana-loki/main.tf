resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  values           = [file("${path.module}/prometheus-values.yaml")]
  depends_on = [
    kubernetes_secret.prometheus_remote_write,
    kubernetes_secret.remote-write-splunk-secret,
    kubernetes_secret.remote-write-datadog,
    kubernetes_secret.remote-write-dynatrace
  ]
}

resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = "monitoring"
  create_namespace = false
  values           = [file("${path.module}/loki-values.yaml")]
  depends_on = [
    kubernetes_secret.remote-write-splunk-secret,
    kubernetes_secret.remote-write-datadog,
    kubernetes_secret.remote-write-dynatrace
  ]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = false
  values           = [file("${path.module}/grafana-values.yaml")]
  set {
    name  = "adminUser"
    value = var.grafana_admin_user
  }
  set {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }
  set {
    name  = "grafana.ini.auth.generic_oauth.client_id"
    value = var.azure_ad_client_id
  }
  set {
    name  = "grafana.ini.auth.generic_oauth.client_secret"
    value = var.azure_ad_client_secret
  }
  set {
    name  = "grafana.ini.auth.generic_oauth.auth_url"
    value = "https://login.microsoftonline.com/${var.azure_ad_tenant_id}/oauth2/v2.0/authorize"
  }
  set {
    name  = "grafana.ini.auth.generic_oauth.token_url"
    value = "https://login.microsoftonline.com/${var.azure_ad_tenant_id}/oauth2/v2.0/token"
  }
  set {
    name  = "grafana.ini.auth.generic_oauth.api_url"
    value = "https://graph.microsoft.com/oidc/userinfo"
  }
  depends_on = [
    aws_route53_record.grafana,
    aws_s3_bucket.loki_archive,
  aws_route53_record.prometheus]
}

###################################################################################
## Resources needed with the Helm deployments #####################################
###################################################################################

resource "aws_route53_record" "prometheus" {
  # checkov:skip=CKV2_AWS_23: Likely a bug in Checkov
  zone_id = aws_route53_zone.main.zone_id
  name    = "prometheus.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [module.eks.prometheus_lb_dns]
}

resource "aws_route53_record" "grafana" {
  # checkov:skip=CKV2_AWS_23: Likely a bug in Checkov
  zone_id = aws_route53_zone.main.zone_id
  name    = "grafana.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [module.eks.grafana_lb_dns]
}

resource "aws_s3_bucket" "loki_archive" {
  # TODO Checkov compliance
  bucket = "loki-archive"
}

#######################################################################
#################### SECRETS ##########################################
#######################################################################

resource "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "prometheus-remote-write-oauth-secret"
    namespace = "monitoring"
  }

  data = {
    admin_username = "${var.grafana_admin}"
    admin_password = "${var.grafana_password}"
  }
}

resource "kubernetes_secret" "prometheus_remote_write" {
  metadata {
    name      = "prometheus-remote-write-oauth-secret"
    namespace = "monitoring"
  }

  data = {
    token = base64encode("${var.token}")
  }
}

resource "kubernetes_secret" "remote-write-splunk-secret" {
  metadata {
    name      = "remote-write-splunk-secret"
    namespace = "monitoring"
  }

  data = {
    token = base64encode("${var.splunk_token}")
  }
}

resource "kubernetes_secret" "remote-write-datadog" {
  metadata {
    name      = "remote-write-splunk-secret"
    namespace = "monitoring"
  }

  data = {
    api_key = base64encode("${var.datadog_api_key}")
  }
}

resource "kubernetes_secret" "remote-write-dynatrace" {
  metadata {
    name      = "remote-write-splunk-secret"
    namespace = "monitoring"
  }

  data = {
    api_token = base64encode("${var.dynatrace_token}")
  }
}

