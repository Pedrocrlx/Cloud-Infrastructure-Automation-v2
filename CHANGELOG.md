# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-02-01
### Added
- **Infrastructure (Terraform):**
    - Created `infra/` module to manage Cluster resources.
    - Automated creation of Namespaces (`dev`, `prod`).
    - Integrated `helm_release` to install `cert-manager` automatically.
- **Automation:**
    - Updated `Makefile` with robust `infra-*` commands.
    - Implemented `cluster-start` logic to auto-provision Minikube if missing.

## [0.1.0] - 2026-01-27
### Added
- **Dev Environment:**
    - Configured DevContainer with Docker-in-Docker support.
    - Automated installation of Terraform, Helm, Kubectl, and Python 3.12.
    - Added VS Code extensions for consistent developer experience.
- **Application:**
    - Created basic Python Flask API (`app/src/app.py`).
    - Implemented endpoints: `/` (Root), `/health` (Probes), `/config` (Debug).
- **Containerization:**
    - Added `Dockerfile` based on `python:3.12-slim`.
    - Implemented non-root user (`appuser`) for security.
- **Automation:**
    - Added `scripts/build_docker.sh` for consistent image building.
    - Added `scripts/run_local.sh` for local testing.
    - Added `Makefile` to simplify commands (`make build`, `make run`, `make test`).
- **Documentation:**
    - Initial `spec.md` defining project architecture and "Chunked Overflow" strategy.
    - Added `CODING_GUIDELINES.md`.

## [0.0.0] - 2026-01-27
### Started
- Project initialization.
- Defined architectural concepts: Separation of Concerns (Terraform vs. Helm).