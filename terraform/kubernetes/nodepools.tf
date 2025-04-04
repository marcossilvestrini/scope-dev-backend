resource "mgc_kubernetes_nodepool" "nodepool-wa" {
  provider     = mgc.br-se1
  name         = "nodepool-wa"
  cluster_id   = mgc_kubernetes_cluster.cluster.id
  flavor_name  = "cloud-k8s.i1-c8-r32-d100"
  replicas     = 1
  min_replicas = 1
  max_replicas = 3  
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [replicas]
  }
}
