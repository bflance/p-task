terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "null" {}

resource "null_resource" "create_kind_cluster" {
  # Create cluster
  provisioner "local-exec" {
    command = "kind create cluster --name kind-cluster --config=kind-config.yaml"
  }

  # Delete cluster on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name kind-cluster"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "export_kubeconfig" {
  provisioner "local-exec" {
    command = "kind get kubeconfig --name kind-cluster > ./kubeconfig.yaml"
  }

  depends_on = [null_resource.create_kind_cluster]
}

