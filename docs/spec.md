# Project Specification: SaaS Platform v2

## 1. Overview
This project aims to build a modern infrastructure orchestration platform, focusing on the strict separation of concerns between **Infrastructure Provisioning** (Terraform) and **Application Delivery** (Helm & CI/CD).

The goal is to simulate a real-world production environment where multiple clients can have their applications instantiated in an isolated but centrally managed manner.

### Philosophy: "Chunked Overflow"
The project will be developed in isolated modules. We will only proceed to the next module when the previous one is tested, documented, and fully functional.

## 2. Technology Stack & Tooling

| Area | Tool | Justification |
| :--- | :--- | :--- |
| **App Language** | Python (Flask) | Lightweight, easy to read, ideal for creating a "Dummy App" to focus on infrastructure. |
| **Containerization** | Docker | Industry standard for application packaging. |
| **Infrastructure (IaC)** | Terraform | Responsible for the "factory floor" (Cluster, Namespaces, Networking). Does not manage App lifecycles. |
| **Orchestration** | Kubernetes (Minikube) | Local simulation of a Cloud environment without costs. |
| **Package Management** | **Helm** | (Core Focus) To create application templates, manage versions, and releases. Replaces manual injection logic. |
| **CI/CD** | GitHub Actions | Automation for Linting, Building, Pushing, and Deploying. |
| **Registry** | Docker Hub / GH Packages | To store versioned application images. |

## 3. Architecture & Environment

### 3.1. Separation of Concerns
* **Terraform:** Manages immutable or long-lived infrastructure (Cluster, Namespaces, Quotas, RBAC).
* **Helm:** Manages the application lifecycle (Deployments, Services, Ingress, HPA).

### 3.2. Development Environment
* **DevContainers:** Ensures that Terraform, Helm, Kubectl, and Python versions are identical across any machine or OS.
* **Task Runners (Shell/Make):** Complex logic is encapsulated in scripts (e.g., `./scripts/build.sh`) that run both locally and in CI, ensuring portability.

### 3.3. Networking & Security
* **Ingress:** Routes traffic to services based on host headers.
* **cert-manager:** Automates TLS certificate management within the cluster (using Self-Signed issuers for local simulation).

## 4. Application Definition (The Dummy App)
The application validates the orchestration, not business logic. It must expose:

1.  `GET /` -> Returns basic info and **App Version** (Proof of Rolling Update).
2.  `GET /health` -> Returns `200 OK` (Proof of Liveness/Readiness Probes).
3.  `GET /config` -> Returns JSON with environment variables (Proof of ConfigMap/Secret injection).

## 5. Implementation Plan (Chunks)

### **Chunk 0: Portable Environment (DevContainer)** ✅
* **Goal:** Configure `.devcontainer` so that opening VS Code installs all tools automatically.
* **Output:** VS Code terminal ready with `terraform`, `helm`, `kubectl`, and `python` installed.

### **Chunk 1: Application & Automation Scripts** ✅
* **Goal:** Create the Python App with the 3 endpoints and helper scripts (`make build`, `make run`).
* **Output:** Container running locally and responding to endpoints.

### **Chunk 2: Base Infrastructure & Cert-Manager**
* **Goal:** Terraform provisions the environment (Namespaces) and installs `cert-manager`.
* **Output:** Cluster ready to host secure applications.

### **Chunk 3: The Helm Chart (The Blueprint)**
* **Goal:** Create a generic Chart supporting Ingress, TLS, and Config injection.
* **Output:** Manual deploy of the app using `helm install`.

### **Chunk 4: CI/CD Pipeline**
* **Goal:** GitHub Actions orchestrates the scripts and Helm deployment.
* **Output:** `git push` to main -> Automatic Deployment.

## 6. Definition of Done (DoD) - Phase v2 (CI & Orchestration Foundation)

The current phase (v2) is considered complete when the following criteria are met:

1.  **Reproducible Development Environment:**
    * Any developer can clone the repository and start working immediately using VS Code DevContainers, with all dependencies (Terraform, Docker, Helm, Minikube) pre-configured.

2.  **Infrastructure as Code (IaC):**
    * Terraform successfully provisions the base cluster resources (Namespaces `dev` and `prod`) without manual intervention.
    * `make infra-apply` is the only command required to set up the logical infrastructure.

3.  **Automated Continuous Integration (CI):**
    * A `git push` to the `main` branch automatically triggers a GitHub Actions pipeline.
    * The pipeline successfully lints the code, builds the Docker image, and pushes a versioned artifact to the **GitHub Container Registry (GHCR)**.

4.  **Standardized Packaging (Helm):**
    * The application is packaged as a Helm Chart (`charts/saas-app`).
    * The application can be deployed to the local cluster using `helm install` and successfully enters the `Running` state.
    * The application responds to health checks (`/health`) via port-forwarding.

*(Note: Automated Continuous Deployment (CD) and Ingress configuration are explicitly scoped for Phase v3 - GitOps Implementation).*