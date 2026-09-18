# FRR sidecar config

This directory contains a minimal example FRR configuration for a BGP sidecar running in Kubernetes.

## Files
- `frr.conf` — basic FRR BGP config template

## Notes
- Replace the AS numbers, router ID, and peer addresses for your environment.
- In Kubernetes, this file can be mounted into `/etc/frr/frr.conf`.
