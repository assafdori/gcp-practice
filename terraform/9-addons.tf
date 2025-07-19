# resource "kubernetes_namespace" "ingress_nginx" {
#   metadata {
#     name = "ingress-nginx"
#   }
#   # depends_on = [google_container_cluster.gke]
# }
#
# resource "helm_release" "ingress_nginx" {
#   name       = "ingress-nginx"
#   namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.13"
#
#   values = [
#     yamlencode({
#       controller = {
#         service = {
#           annotations = {
#             "cloud.google.com/load-balancer-type" = "External"
#           }
#         }
#       }
#     })
#   ]
#   depends_on = [kubernetes_namespace.ingress_nginx]
# }
