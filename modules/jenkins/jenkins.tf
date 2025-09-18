resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

resource "helm_release" "jenkins" {
  name       = var.release_name
  namespace  = kubernetes_namespace.ns.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.4.13"
  values     = [file("${path.module}/values.yaml")]
  
  depends_on = [kubernetes_namespace.ns]
}
