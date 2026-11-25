#!/usr/bin/env bash
# allowed: listing, removing your own image by explicit tag, the retention-aware GC, uv cache prune
podman images
podman rmi localhost/medialabs-api:abc1234
bash scripts/safe-image-gc.sh --apply
uv cache prune
