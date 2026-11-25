#!/usr/bin/env bash
# each line below must be flagged by .semgrep/cluster-safety.yaml
k3d cluster delete aimlops-staging
k3d cluster create aimlops-staging --servers 1
k3d node delete k3d-aimlops-staging-server-0
kubectl --context k3d-aimlops-staging delete namespace medialabs
kubectl delete ns savannah
kubectl -n medialabs delete pvc --all
kubectl delete pv pvc-06d61bf3
kubectl delete crd httpproxies.projectcontour.io
kubectl delete -k deploy/k3d-medialabs
kubectl delete deploy --all -n climavue-staging
kubectl delete pods --all-namespaces --all
helm uninstall contour -n projectcontour
podman rm -f k3d-aimlops-staging-server-0
docker stop k3d-aimlops-staging-serverlb
podman volume rm k3d-aimlops-staging-images
podman system reset
rm -rf /var/lib/rancher/k3s/storage
