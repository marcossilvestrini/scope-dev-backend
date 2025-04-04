output "kubernetes_cluster" {
  description = "Details of the Kubernetes cluster"
  value = {
    id                   = mgc_kubernetes_cluster.cluster.id
    name                 = mgc_kubernetes_cluster.cluster.name
    version              = mgc_kubernetes_cluster.cluster.version
    description          = mgc_kubernetes_cluster.cluster.description
    allowed_cidrs        = mgc_kubernetes_cluster.cluster.allowed_cidrs
    async_creation       = mgc_kubernetes_cluster.cluster.async_creation
    enabled_server_group = mgc_kubernetes_cluster.cluster.enabled_server_group
    zone                 = mgc_kubernetes_cluster.cluster.zone
    created_at           = mgc_kubernetes_cluster.cluster.created_at
  }
}
