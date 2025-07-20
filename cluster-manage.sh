#!/bin/bash

set -e

CLUSTER_NAME="kind-cluster"

create_registry() {
  docker run -d -p 5000:5000 --restart=always --name kind-registry registry:2
  docker network connect "kind" kind-registry
}

destroy_registry() {
  if docker ps -a --format '{{.Names}}' | grep -q "^kind-registry$"; then
    docker kill kind-registry
    docker remove kind-registry
  fi
}


create_cluster() {
  echo "🟢 Creating Kind cluster with Terraform..."
  terraform init
  terraform apply -auto-approve
  echo "✅ Cluster created."
  cp kubeconfig.yaml ~/.kube/kind-cluster.yaml
}

destroy_cluster() {
  echo "🛑 Destroying Kind cluster with Terraform..."
  terraform destroy -auto-approve
  echo "🧹 Cleaning up kubeconfig..."
  rm -rf ./kubeconfig.yaml ~/.kube/kind-cluster.yaml terraform.tfstate* .terraform .terraform.lock.hcl
  echo "✅ Cluster destroyed and cleaned."
}

case "$1" in
  create)
    create_registry
    create_cluster
    ;;
  destroy)
    destroy_registry
    destroy_cluster
    ;;
  re-create)
    destroy_registry
    destroy_cluster
    create_registry
    create_cluster
    ;;
  *)
    echo "Usage: $0 {create|destroy|re-create}"
    exit 1
    ;;
esac

