---
applyTo: "**/*.{md,go,py,sh,yml,yaml,json,c,cpp,h,hpp,Dockerfile}"
---

# Development Guide

## 1. Purpose
This repository should remain easy to understand, extend, and validate while aligning with FRR-based BGP practices and deployment expectations.

## 2. Project requirement
This project includes a Kubernetes BGP sidecar requirement. The sidecar runs FRR inside the pod so that the pod can participate in BGP routing and peer with upstream BGP neighbors.

## 3. Build requirement
The Docker image must compile and install the target FRR version during the build process, including any required dependencies and runtime requirements for a sidecar deployment.

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
- the Docker image can build the selected FRR version successfully
- when validating the Dockerfile, tag the image as `bgp:testing` (for example, `docker build -t bgp:testing .`)
- the sidecar deployment model remains compatible with Kubernetes usage
- documentation remains accurate and complete
