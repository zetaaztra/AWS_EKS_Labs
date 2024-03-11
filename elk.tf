resource "kubernetes_namespace" "elk" {
  metadata {
    name = "elk"
  }
}


resource "kubectl_manifest" "apply_all_elk" {
  depends_on = [ kubernetes_namespace.elk ]

  for_each = fileset("${path.module}/modules/elk", "*.yaml")

  yaml_body = file("${path.module}/modules/elk/${each.value}")
}