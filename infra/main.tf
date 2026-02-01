# 1. Create Namespaces (Dev & Prod)
resource "kubernetes_namespace" "envs" {
  for_each = var.environments

  metadata {
    name = each.key
    labels = {
      "managed-by" = "terraform"
      "purpose"    = "application-hosting"
    }
  }
}

# 2. Install cert-manager (System Component)
# This handles SSL certificates automatically in the cluster
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.13.3"
  namespace  = "cert-manager"
  
  # Create the namespace for cert-manager itself if it doesn't exist
  create_namespace = true

  # CRITICAL: Install Custom Resource Definitions (CRDs)
  set {
    name  = "installCRDs"
    value = "true"
  }

  # Wait for it to be ready before finishing
  wait = true
}