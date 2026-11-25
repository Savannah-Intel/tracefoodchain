#!/usr/bin/env bash
# each line below must be flagged by .semgrep/image-safety.yaml
podman image prune -f
docker system prune
crictl rmi 3f2a9c1d
ctr -n k8s.io images rm docker.io/library/nginx:1.27
podman volume prune -f
docker container prune
podman rmi -a
podman volume rm $(podman volume ls -q)
podman image prune -a -f
crictl rmi --prune
uv cache clean
rm -rf ~/.cache/uv
