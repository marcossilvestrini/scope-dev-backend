resource "mgc_kubernetes_cluster" "cluster" {
  provider             = mgc.br-se1
  name                 = var.name
  version              = var.k8s_version
  description          = var.description
  enabled_server_group = var.enabled_server_group
  allowed_cidrs        = var.allowed_cidrs
  async_creation       = var.async_creation

  lifecycle {
    prevent_destroy = true
  }
}
