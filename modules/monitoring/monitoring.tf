resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# Prometheus
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"
  
  values = [
    file("${path.module}/prometheus-values.yaml")
  ]
  
  depends_on = [kubernetes_namespace.monitoring]
}

# Grafana
resource "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "grafana-admin-credentials"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  
  data = {
    admin-user     = var.grafana_admin_user
    admin-password = var.grafana_admin_password
  }
  
  type = "Opaque"
}
