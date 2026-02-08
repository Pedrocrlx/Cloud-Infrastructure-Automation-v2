# SaaS Platform Engineering v2

![Build Status](https://img.shields.io/github/actions/workflow/status/Pedrocrlx/Cloud-Infrastructure-Automation-v2/ci.yaml?label=Build&logo=github-actions)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-7B42BC?logo=terraform)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Minikube-326CE5?logo=kubernetes)
![Docker](https://img.shields.io/badge/Docker-Multi--Stage-2496ED?logo=docker)
![Helm](https://img.shields.io/badge/Helm-v3-0F1689?logo=helm)

## Project Overview

This project represents the next evolutionary step in my Cloud Engineering journey. Building upon the foundational knowledge established in my previous repository (Cloud Infrastructure Automation), this project shifts focus from pure Infrastructure Provisioning to the Full Software Supply Chain.

While the previous project focused on Static Infrastructure (creating VMs/Clusters/DBs for Odoo), this project implements a modern Platform Engineering approach. It encompasses the entire lifecycle of a cloud-native application: from a reproducible Local Development Environment (DevContainers) to Automated CI/CD Pipelines and Package Management via Helm.

### Objective
To simulate a real-world SaaS Platform setup where:
1. Developers work in identical, isolated environments.
2. Infrastructure is managed as code (IaC) but decoupled from application logic.
3. Deployment is versioned, packaged, and automated via Continuous Integration.

---

## Architectural Evolution

This project introduces advanced DevOps patterns that complement the previous work:

### 1. Developer Experience (DevEx) & Reproducibility
* **Previous Approach:** Manual installation of tools (Terraform, Kubectl) on the host machine.
* **Current Architecture:** Utilization of DevContainers. The entire development environment (VS Code extensions, CLI tools, Runtimes) is defined as code. This eliminates the "It works on my machine" problem entirely.

### 2. The Software Supply Chain (CI/CD)
* **Previous Approach:** Infrastructure focus; application deployment was implied or manual.
* **Current Architecture:** A robust GitHub Actions Pipeline that:
    * Lints the code.
    * Builds optimized Docker images.
    * Pushes artifacts to the GitHub Container Registry (GHCR).
    * Ensures that what runs in production is exactly what was tested in CI.

### 3. Packaging & Orchestration (Helm vs. Raw Manifests)
* **Previous Approach:** Dynamic templating using Terraform to inject variables into raw YAML files.
* **Current Architecture:** Adoption of Helm Charts.
    * Helm treats the application as a versioned package.
    * Allows for complex deployment strategies (Hooks, Rollbacks) that raw manifests cannot handle easily.
    * Terraform is now strictly used for Platform Infrastructure (Namespaces, Cert-Manager), while Helm handles Application Delivery.

### 4. Security First Design
* **Implementation:** The Docker container is built using a Multi-Stage Build process and runs as a non-root user (appuser). This adheres to the Principle of Least Privilege, critical for production Kubernetes environments.

---

## Technology Stack

| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Application** | Python (Flask) | A lightweight SaaS simulation API ensuring 12-Factor App compliance. |
| **Containerization** | Docker | Creating immutable, optimized, and secure application artifacts. |
| **Orchestration** | Kubernetes (Minikube) | Local simulation of a production-grade cluster. |
| **IaC** | Terraform | Management of Cluster Resources (Namespaces) and System Add-ons. |
| **Packaging** | Helm | Standardized application packaging and templating. |
| **CI/CD** | GitHub Actions | Automated build and release pipeline integrated with GHCR. |
| **Automation** | GNU Make | Abstraction layer to simplify complex commands into single targets. |

---

## Project Structure

```bash
.
├── .devcontainer/      # Definition of the reproducible coding environment
├── .github/workflows/  # CI/CD Pipelines (GitHub Actions)
├── app/                # Application Source Code & Dockerfile
├── charts/             # Helm Charts for Application Delivery
├── docs/               # Documentation for the project
├── infra/              # Terraform (Infrastructure as Code)
├── scripts/            # Helper scripts for build/run logic
├── CHANGELOG.md        # History of changes to the project
├── LICENSE             # License for the project
├── Makefile            # The Command Center (Automation)
└── README.md           # This documentation
```

---

## Getting Started

Prerequisites: Docker and VS Code or your preferred IDE (with DevContainers extension or CLI). Everything else is installed automatically inside the container.
1. Initialize the Environment

Open the project in Your IDE. When prompted, click "Reopen in Container" or use the DevContainers CLI "devcontainer up and then -> devcontainer exec --workspace-folder . bash". Once inside the terminal, the environment is fully configured.
2. The One-Command Setup

We use a Makefile to abstract complexity. You don't need to memorize kubectl or terraform commands.

## Setup

```bash
make setup ## Initializes Terraform, starts Minikube, and creates the Namespaces (dev, prod).
```

## Validation

```bash
make tests ## Show pods running.
```

## Tunnel (run in another terminal but make sure you are inside of devcontainer)

```bash
make tunnel ## Exposes the cluster on localhost:8080.
```

## Final Test

```bash
make curl ## Curl the cluster on localhost:8080.
```

## Cleanup

```bash
make infra-destroy ## Stops Minikube and deletes the Namespaces (dev, prod).
make clean ## Removes the Terraform state files, Docker images, containers, and Helm releases.
```

## Future Roadmap

- GitOps Implementation: Integrate ArgoCD to automatically sync the cluster state with this repository, removing the need for manual helm install commands.

- Observability: Implement Prometheus & Grafana stacks via Terraform to monitor application metrics.

- Multi-Tenancy: Evolve the Helm Chart to support dynamic "Per-Client" deployments driven by external configuration files.

## Author

Pedro Santos - Cloud & DevOps Engineer in Training.