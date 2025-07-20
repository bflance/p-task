# kind-cluster

A local Kubernetes development environment using Kind, Terraform, Helm, and a sample Flask app.

Was tested on MacOS

## Prerequisites
1. Edit your /etc/hosts file locally to add this:

```sh
sudo vim /etc/hosts
127.0.0.1       localhost my-app.local podinfo.local jenkins.local
```


2. Install the following tools using Homebrew:

```sh
brew install kind terraform helm helmfile docker
helm plugin install https://github.com/databus23/helm-diff
```

- **kind**: For running local Kubernetes clusters using Docker.
- **terraform**: For infrastructure as code (provisions the Kind cluster).
- **helm**: Kubernetes package manager.
- **helmfile**: Declarative spec for deploying Helm charts.
- **helm-diff**: For proper work of helmfile
- **docker**: For building and running containers.

Ensure Docker is running before proceeding.

## Quick Start


### 1. Create the Cluster and Local Registry

```sh
./cluster-manage.sh create
```

This will:
- Start a local Docker registry on port 5000.
- Create a Kind cluster using Terraform.
- Copy the kubeconfig to `~/.kube/kind-cluster.yaml`.

### 2. Build and Push the App Docker Image

```sh
cd app && ./build-app.sh && cd ..
```

> **Note:**  
To check if your Docker image was loaded into the local registry properly, run: \
`curl http://localhost:5000/v2/_catalog`


### 3. Deploy Applications with Helmfile

```sh
export KUBECONFIG=~/.kube/kind-cluster.yaml
helmfile apply
```

This will deploy:
- Your Flask app (via the local Helm chart)
- NGINX Ingress Controller
- Podinfo demo app

### 4. Access the App

Then visit [http://localhost:30080/my-app1/](http://localhost:30080/my-app1) to see the app1

Then visit [http://localhost:30080/my-app2](http://localhost:30080/my-app2) to see the app2


or visit [http://jenkins.local:30080/](http://jenkins.local:30080//) to see jenkins (admin/admin)

> **Note:**  
Due to nature of this deployment (kubernetes inside docker,via nginx), it is required to use NodePort, forwarded from laptop > docker > kubernetes NodePort)


Enjoy!

### 5. Destroy the Cluster

```sh
./cluster-manage.sh destroy
```

This will remove the Kind cluster and local registry.

---