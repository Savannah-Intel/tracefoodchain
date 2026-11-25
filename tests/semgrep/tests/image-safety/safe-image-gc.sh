#!/usr/bin/env bash
# fixture: the sanctioned retention-aware GC is excluded from every image-prune rule
podman image prune -a -f
crictl rmi --prune
uv cache clean
