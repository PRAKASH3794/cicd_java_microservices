#!/usr/bin/env bash
set -euo pipefail

# 1) Start the local stack (Jenkins, SonarQube, Nexus, Registry)
echo "[1/5] Starting local CI/CD services via docker-compose..."
cd infra
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not available in this environment."; exit 1
fi

COMPOSE_PROJECT_NAME=cicd docker compose -f docker-compose.yaml up -d
cd - >/dev/null

# 2) Create kind cluster (if not exists)
if ! kind get clusters | grep -q cicd-kind; then
  echo "[2/5] Creating kind cluster 'cicd-kind'..."
  kind create cluster --name cicd-kind --config infra/kind-config.yaml
fi

# 3) Install ingress-nginx
echo "[3/5] Installing ingress-nginx..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=180s || true

# 4) Create kubeconfig credential file for Jenkins
echo "[4/5] Exporting kubeconfig for Jenkins credentials..."
KCFG=infra/jcasc/kubeconfig
kind get kubeconfig --name cicd-kind > $KCFG

# 5) Print endpoints
echo "[5/5] Services are starting. Endpoints (if port forwarding available):"
echo "  Jenkins:    http://localhost:8080  (admin/admin)"
echo "  SonarQube:  http://localhost:9000  (default creds: admin/admin)"
echo "  Nexus:      http://localhost:8081  (default creds: admin/admin123)"
echo "  Registry:   http://localhost:5000"
