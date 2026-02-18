# Run this CI/CD Stack Online (Gitpod or GitHub Codespaces)

This adds a **one-click online environment** to run Jenkins + SonarQube + Nexus + Docker Registry + a local **Kubernetes (kind)** cluster and deploy the provided microservices with **Helm**.

## Option A: Gitpod (recommended for quick start)

1. Push this repo to your Git provider.
2. Prefix the repo URL with `https://gitpod.io/#/` and open it.
3. Wait for the workspace to build; it will automatically run `infra/bootstrap.sh`.
4. Open the exposed ports:
   - Jenkins → **8080** (user: `admin`, pass: `admin`)
   - SonarQube → **9000** (admin/admin)
   - Nexus → **8081** (admin/admin123)

> If Jenkins doesn't auto-load jobs, create a Multibranch Pipeline pointing to this same repo (inside the workspace) and build.

## Option B: GitHub Codespaces (or VS Code Dev Containers)

1. Open the repo in Codespaces (or Reopen in Container in VS Code).
2. The devcontainer runs `infra/bootstrap.sh` automatically.
3. Access services on forwarded ports: 8080, 9000, 8081.

## Configure Jenkins Job

- **Multibranch Pipeline** → repo URL: the current workspace folder.
- Set environment variables in job (or at folder level):
  - `REGISTRY_URL=localhost:5000`
  - `REGISTRY_NAMESPACE=demo`
  - `NEXUS_URL=http://nexus:8081` *(or leave empty and use Artifactory if you wire it)*
  - `KUBE_NAMESPACE=dev`
  - `HELM_RELEASE_PREFIX=demo`
  - `SONARQUBE_ENV=SonarQube`
- Credentials already stubbed in JCasC:
  - `docker-registry-creds` *(fill username/password if pushing to a real registry; for local `registry:2` often no auth)*
  - `nexus-creds` (admin/admin123 by default)
  - `kubeconfig` (file credential created from `infra/jcasc/kubeconfig` if you upload it)

## Build & Deploy

- Commit a change in `services/users-service` (e.g., edit `HelloController`).
- Jenkins will detect changes, build & test, Sonar scan, build/push Docker image to `localhost:5000`, and deploy to kind via Helm.
- Access the service through the kind ingress (map DNS or use `kubectl port-forward` if needed).

## Notes

- This is a **demo** setup (single VM workspace). For production, use managed Jenkins agents and a real Kubernetes cluster.
- Gitpod/Codespaces policies on Docker-in-Docker can change; if DinD is restricted, switch to remote executors or a tiny K3s cluster.
