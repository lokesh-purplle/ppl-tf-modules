# GKE kubernetes nodepool for GKE cluster

Terraform module for GKE kubernetes nodepool.
RBAC only, no legacy endpoints or basic auth, no client certificates either.

Usage

```
module "devnodepool" {
  source       = "github.com/yellowmegaman/terraform-google-kubernetes-node-pool"
  zone         = "europe-west4-b"
  name         = "devcluster"
  kube_version = "1.12.5-gke.5"
  cluster_name = "devcluster"
  machine_type = "n1-standard-2"
}
```

Configuration above will:
- spawn nodepool for GKE cluster, 3 nodes initial, autoscaled to 9 if needed
