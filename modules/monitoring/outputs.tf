output "prometheus_service_name" {
  description = "Prometheus service name"
  value       = "prometheus-kube-prometheus-prometheus"
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = "prometheus-grafana"
}

output "namespace" {
  description = "Monitoring namespace"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}
