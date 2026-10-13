# bgp

BGP project repository.

## Overview
This repository is intended for BGP-related implementation, documentation, and project guidance, using FRR as the BGP implementation foundation.

## Project requirements
1. Kubernetes BGP sidecar: the project is intended to support a BGP sidecar pattern in which FRR runs inside a Kubernetes pod and provides BGP functionality for the workload.
2. FRR image requirement: the Docker image uses an official FRR image and does not compile FRR as part of the image build process.
3. Deployment requirement: the resulting sidecar must be compatible with Kubernetes pod deployment patterns and support BGP peering and route exchange as required by the deployment environment.

## Project Structure
```text
bgp/
├── .github/
│   ├── copilot-instructions.md
│   └── instructions/
│       ├── README.instructions.md
│       ├── development-guide.instructions.md
│       └── release-checklist.instructions.md
├── Dockerfile
├── Makefile
├── examples/
│   └── k8s/
│       ├── Dockerfile.svc
│       ├── Makefile
│       ├── README.md
│       ├── network.yaml
│       ├── sim-gw-a.yaml
│       └── sim-gw-b.yaml
├── LICENSE
├── README.md
└── ...
```

## Documentation
The project standards and guidance are organized under the `.github/instructions/` directory:

- `.github/instructions/README.instructions.md` — project-level instruction overview
- `.github/instructions/development-guide.instructions.md` — engineering and FRR-aligned workflow standards
- `.github/instructions/release-checklist.instructions.md` — release readiness and verification checklist

## FRR and BGP Standards
- Treat FRR as the reference BGP implementation for this project.
- Preserve route correctness, policy semantics, and neighbor behavior.
- Document protocol behavior when logic is non-trivial or operationally sensitive.
- Validate BGP and routing flows before merging or releasing.
- Maintain compatibility unless a breaking change is explicitly intended.

## Examples
The `examples/k8s/` directory contains a BGP gateway simulation example. See [examples/k8s/README.md](examples/k8s/README.md) for details.

## Build

### Root Makefile (BGP sidecar image)

The root `Makefile` builds the FRR-based sidecar image and imports it into the cluster's containerd runtime:

```sh
# Build the Docker image and import into containerd
make build-img

# Remove the built image tag
make rmi-repo-tag
```

| Target | Description |
|--------|-------------|
| `build-img` | Build `bgp:v1.0.0-beta.1` from `Dockerfile`, save as tar, import into containerd via `ctr` |
| `rmi-repo-tag` | Remove the `bgp:v1.0.0-beta.1` image from Docker |

See [examples/k8s/README.md](examples/k8s/README.md) for the svc image build and deployment targets.

## License
This project is licensed under the terms of the included `LICENSE` file.
