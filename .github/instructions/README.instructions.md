---
applyTo: "**/*"
---

# Project Instructions

This directory defines the project-level engineering and operational standards for this repository.

## Scope
These instructions apply to code changes, documentation updates, reviews, and release preparation for the FRR-based BGP project.

## Examples directory
The `examples/k8s/` directory is a single end-to-end BGP gateway simulation example. It demonstrates the FRR sidecar pattern with Multus networking and BGP route exchange between two simulated gateways. The files are templates for adaptation and are not production defaults.

Files:
- `network.yaml` — combines `NodeNetworkConfigurationPolicy` for VLAN device (`vlan-enp4s0-2002`) and Multus `NetworkAttachmentDefinition` named `macvlan-enp4s0-2002`.
- `sim-gw-a.yaml` — Deployment `sim-gw-a` with ConfigMap `sim-gw-a-config` (daemons + frr.conf).
- `sim-gw-b.yaml` — Deployment `sim-gw-b` with ConfigMap `sim-gw-b-config` (daemons + frr.conf).

Apply order:
```sh
kubectl apply -n <namespace> -f examples/k8s/network.yaml
kubectl apply -n <namespace> -f examples/k8s/sim-gw-a.yaml
kubectl apply -n <namespace> -f examples/k8s/sim-gw-b.yaml
```

The example covers the following requirements:

1. ConfigMap-driven FRR configuration: `daemons` (zebra, bgpd, bfdd enabled) and `frr.conf` (BGP neighbors, route advertisement) mounted at `/etc/frr`, changeable without rebuilding the image. Interface addressing is owned by the init container, so `frr.conf` stays BGP-only.
2. Init container and dual-container pod: each Deployment creates one pod with an `init-net` container (creates the `net1`/`lo:src` interfaces) plus two containers — `svc` (busybox:1.36, the workload) and `bgp` (`bgp:testing`, the FRR sidecar).
3. Multus secondary interface: the pod's `net1` interface is attached via a `k8s.v1.cni.cncf.io/networks: macvlan-enp4s0-2002` annotation, backed by a macvlan bridge-mode NetworkAttachmentDefinition named `macvlan-enp4s0-2002`. No CNI IPAM — the `init-net` container brings it up and assigns the static address. Both Deployments use mutual `podAffinity` (`topologyKey: kubernetes.io/hostname`) to enforce same-node scheduling, since macvlan bridge mode is L2-local.
4. Deterministic data-plane addressing: `init-net` configures `net1` as 11.0.3.50/24 on sim-gw-a and 11.0.3.60/24 on sim-gw-b.
5. Business-logic loopback (`lo:src`): created by `init-net` as a labeled alias on `lo` — 22.0.3.50/24 on A, 33.0.3.60/24 on B — advertised over BGP so its traffic enters/exits through `net1`.
6. BGP peering and route advertisement: sim-gw-a (AS 65001) peers with sim-gw-b (AS 65002) over net1 and advertises 22.0.3.0/24; sim-gw-b advertises 33.0.3.0/24 in return.
7. Connectivity verification: the `svc` container continuously pings the peer's lo:src address every 10 seconds (via its own lo:src) and logs failures.

## Project goals
The project is designed to support BGP functionality in a Kubernetes environment using a sidecar pattern. The implementation must preserve a clear separation between application logic and routing logic while keeping the BGP service operationally reliable.

## Requirements
### 1. Kubernetes BGP sidecar
This repository is intended to support a Kubernetes BGP sidecar use case. The sidecar is expected to run FRR as the routing component and be injected into application pods to provide BGP functionality.

### 2. FRR image requirement
The sidecar image must use an official `quay.io/frrouting/frr` image and must not compile FRR during the Docker image build process.

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
