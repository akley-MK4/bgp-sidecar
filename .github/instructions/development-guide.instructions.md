---
applyTo: "**/*.{md,go,py,sh,yml,yaml,json,c,cpp,h,hpp,Dockerfile}"
---

# Development Guide

## 1. Purpose
This repository should remain easy to understand, extend, and validate while aligning with FRR-based BGP practices and deployment expectations.

The `examples/` directory is reserved for the Kubernetes sidecar example and its embedded FRR configuration. Keep environment-specific production values outside this directory.

## 2. Project requirement
This project includes a Kubernetes BGP sidecar requirement. The sidecar runs FRR inside the pod so that the pod can participate in BGP routing and peer with upstream BGP neighbors.

## 3. Build requirement
The Docker image must be based on an official `quay.io/frrouting/frr` image and must not compile FRR during the build process. The build only adds the runtime dependencies the sidecar needs (for example `libcap`) and sets the required file capabilities on the FRR daemon binaries. Pin the FRR version through a build argument so the target version is explicit and reproducible.

## 4. Deployment requirement
The resulting artifact must remain compatible with Kubernetes deployment patterns and support FRR BGP functionality in a pod environment without requiring manual host-level routing configuration.

## 5. Coding standards
- Use clear, descriptive, and consistent naming.
- Keep modules, functions, and files focused on a single responsibility.
- Avoid duplication and unnecessary complexity.
- Add comments only when they clarify intent, risk, or non-obvious routing logic.
- Keep formatting, indentation, and structure consistent with the surrounding code.

## 6. FRR integration expectations
- Treat FRR as the operational reference for BGP behavior and compatibility.
- Use an official `quay.io/frrouting/frr` image as the Docker base image and do not compile FRR in the project Dockerfile.
- Configure only `zebra`, `bgpd`, and `bfdd` as enabled daemons; all other FRR daemons must remain disabled.
- Run the FRR container as root (EUID=0); do not set `USER frr`. The `/usr/lib/frr/docker-start` entrypoint calls `is_user_root()` and refuses to start otherwise — `watchfrr` then fails to launch the child daemons and the container exits with no clear error. The individual daemons (`zebra`, `bgpd`, `bfdd`) drop their own privileges internally, so running as root does not mean the daemons stay root. Keep an explanatory comment next to this choice in the Dockerfile so it is not "re-fixed" to `USER frr`.
- Set `CAP_NET_ADMIN`, `CAP_NET_RAW`, and `CAP_NET_BIND_SERVICE` on the `zebra`, `bgpd`, and `bfdd` binaries in the Dockerfile.
- Grant the sidecar only the required `NET_ADMIN`, `NET_RAW`, and `NET_BIND_SERVICE` capabilities.
- Keep BGP configuration, policy, and route processing logic consistent with FRR semantics.
- Be cautious around route advertisement, filtering, neighbor state, and convergence behavior.
- When protocol behavior is changed, document the impact clearly.
- Favor build and runtime choices that are compatible with sidecar deployment in Kubernetes.

## 7. Change management
- Prefer the smallest reasonable change set.
- Keep unrelated cleanup out of functional work.
- Do not broaden scope during bug fixes or feature work.
- Preserve backward compatibility unless a breaking change is explicitly approved.
- Update affected documentation whenever behavior, configuration, or usage changes.

## 8. Validation requirements
Before concluding work, confirm that:
- relevant tests or checks have been run
- the affected BGP or routing workflow behaves as expected
- no obvious regression was introduced
- FRR compatibility assumptions remain valid
- the Docker image builds successfully from the pinned official FRR base image
- when validating the Dockerfile, tag the image as `bgp:testing` (for example, `docker build -t bgp:testing .`)
- the resulting FRR daemon configuration enables only `zebra`, `bgpd`, and `bfdd`
- the container runs as root (EUID=0) with no `USER frr` directive, and the required capabilities are configured
- the FRR daemon binaries have the required network file capabilities
- the sidecar deployment model remains compatible with Kubernetes usage
- documentation remains accurate and complete
