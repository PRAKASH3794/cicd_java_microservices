FROM gitpod/workspace-full:latest

# Install Docker (DinD), kubectl, helm, kind, trivy, jq
USER root
RUN apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release jq make python3-pip && \
    curl -fsSL https://get.docker.com | sh && \
    usermod -aG docker gitpod && \
    curl -fsSL https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && \
    curl -fsSL https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz | tar zx && mv linux-amd64/helm /usr/local/bin/ && rm -rf linux-amd64 && \
    curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64 && chmod +x /usr/local/bin/kind && \
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin && \
    rm -rf /var/lib/apt/lists/*
USER gitpod
