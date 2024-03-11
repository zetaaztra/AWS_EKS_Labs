resource "kubernetes_namespace" "elk" {
  metadata {
    name = "elk"
  }
}

resource "null_resource" "install_kubectl" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "sudo apt-get update && sudo apt-get install -y kubectl"
    working_dir = path.module
  }
}

resource "null_resource" "apply_null_resource" {
 depends_on = [
    kubernetes_namespace.elk,
    null_resource.install_kubectl
  ]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "kubectl apply -f ./modules/elk"
    working_dir = path.module
  }
}


resource "null_resource" "get_services" {
  depends_on = [null_resource.apply_null_resource]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl get services -o wide  > services_output.txt"
    working_dir = path.module
  }
}

