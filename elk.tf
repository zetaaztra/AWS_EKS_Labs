resource "kubernetes_namespace" "elk" {
  metadata {
    name = "elk"
  }
}

resource "null_resource" "apply_null_resource" {
 depends_on = [
    kubernetes_namespace.elk,
  ]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl apply -f elk/"
    working_dir = "./modules/elk"
  }
}


resource "null_resource" "get_services" {
  depends_on = [null_resource.apply_null_resource]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl get services -o wide  > services_output.txt"
    working_dir = "./modules/elk"
  }
}

