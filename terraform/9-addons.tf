resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [google_container_cluster.gke]
}


resource "helm_release" "argocd" {

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = false
  verify           = false
  wait             = true
  version          = "8.3.0"

  depends_on = [kubernetes_namespace.argocd]

  lifecycle {
    ignore_changes = all
  }
}

resource "kubernetes_manifest" "argocd_root_app" {

  manifest = yamldecode(<<EOT
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "https://github.com/assafdori/gcp-practice.git"
    targetRevision: main
    path: bootstrap
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOT
  )
  depends_on = [helm_release.argocd]
}

