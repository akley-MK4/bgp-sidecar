---
applyTo: "**/*"
---

# Release Checklist

## Release readiness
- [ ] The FRR-based BGP feature or fix is complete and validated.
- [ ] Relevant routing tests and verification steps have been executed successfully.
- [ ] Key BGP behaviors have been checked in the target environment.
- [ ] Neighbor, policy, and route propagation behavior have been reviewed.
- [ ] The Docker image for the BGP sidecar builds successfully.
- [ ] Dockerfile validation uses the image tag `bgp:testing` (for example, `docker build -t bgp:testing .`).
- [ ] The Docker image uses an official `quay.io/frrouting/frr` image without compiling FRR.
- [ ] Only `zebra`, `bgpd`, and `bfdd` are enabled; all other FRR daemons are disabled.
- [ ] The FRR container runs as the non-root `frr` user.
- [ ] The `zebra`, `bgpd`, and `bfdd` binaries have `CAP_NET_ADMIN`, `CAP_NET_RAW`, and `CAP_NET_BIND_SERVICE` file capabilities.
- [ ] The sidecar grants `NET_ADMIN`, `NET_RAW`, and `NET_BIND_SERVICE` capabilities.
- [ ] The FRR version used in the image is the intended target version.
- [ ] The sidecar is compatible with the Kubernetes pod deployment model.
- [ ] Documentation and examples are current and accurate.
- [ ] Dependencies and compatibility implications have been reviewed.
- [ ] Release notes or summary are prepared.
- [ ] Rollback or recovery considerations are documented.

## Final approval
- [ ] The change matches the intended scope.
- [ ] No unresolved high-risk issues remain.
- [ ] The change is ready for review and release sign-off.
