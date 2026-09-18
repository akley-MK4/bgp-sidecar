# Copilot Instructions

This repository is maintained as a focused BGP project built around the FRR (Free Range Routing) stack as the BGP implementation foundation.

## Project principles
- Keep the codebase readable, maintainable, and predictable.
- Prefer small, well-scoped changes over broad refactors.
- Document non-obvious logic and changed behavior.
- Validate critical BGP and routing flows before merging or releasing.
- Maintain compatibility unless a breaking change is explicitly approved.

## FRR-specific expectations
- Treat FRR as the reference BGP implementation and align integrations with its operational model.
- Preserve routing correctness, interface behavior, and configuration semantics when modifying BGP-related logic.
- Be careful with neighbor state, route advertisement, policy handling, and convergence-related changes.
- Prefer configuration and behavior that remain compatible with FRR deployment practices.

## Contribution expectations
- Follow the repository structure and naming conventions.
- Keep commit scope narrow and aligned to a single objective.
- Update relevant documentation when behavior, APIs, configuration, or workflows change.
- Avoid unrelated cleanup or formatting churn in functional work.
- Ensure new changes are reviewable and testable.

## Quality bar
- Prefer clarity over cleverness.
- Preserve existing behavior unless a change intentionally modifies it.
- Add or update tests for meaningful BGP behavior changes when applicable.
- Prefer explicit, deterministic logic over implicit assumptions.
