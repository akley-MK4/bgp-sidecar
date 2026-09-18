---
applyTo: "**/*"
---

# Project Instructions

This directory defines the project-level engineering and operational standards for this repository.

## Scope
These instructions apply to code changes, documentation updates, reviews, and release preparation for the FRR-based BGP project.

## Project goals
The project is designed to support BGP functionality in a Kubernetes environment using a sidecar pattern. The implementation must preserve a clear separation between application logic and routing logic while keeping the BGP service operationally reliable.

## Requirements
### 1. Kubernetes BGP sidecar
This repository is intended to support a Kubernetes BGP sidecar use case. The sidecar is expected to run FRR as the routing component and be injected into application pods to provide BGP functionality.

### 2. FRR build requirement
The sidecar image must be able to build a specified FRR version during the Docker image build process. The build must include the required dependencies and compile FRR in a reproducible way.

### 3. Deployment requirement
The resulting sidecar must be compatible with Kubernetes deployment patterns, expose the required BGP interfaces, and support integration with routing peers and network policy configuration.

## Non-goals
- This project is not intended to replace the full FRR distribution or introduce a different BGP implementation.
- This project does not aim to provide general-purpose Kubernetes networking beyond the BGP sidecar use case.
- This project does not assume a host-level routing stack is required when the sidecar is the routing component.

## Documents
- `development-guide.instructions.md` — coding standards, workflow, and review expectations for BGP and FRR integration work
- `release-checklist.instructions.md` — release verification and sign-off checklist

## Team expectations
- Keep work aligned with the project goals and FRR operational model.
- Prefer clarity, maintainability, and routing correctness.
- Use these guidelines as the default standard for collaboration.
