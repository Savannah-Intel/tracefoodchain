#!/usr/bin/env bash
# allowed: scale to zero (reversible), read-only verbs, throwaway Jobs, GitOps apply
kubectl -n medialabs scale deploy/medialabs-orchestrator --replicas=0
kubectl --context k3d-aimlops-staging -n climavue-staging scale statefulset/ocr-worker --replicas 0
kubectl get pods -A
kubectl -n medialabs delete job uat-content-radar
kubectl -n medialabs delete pod medialabs-web-6fd79bf9cc-cs8ww
kubectl apply -k deploy/k3d-medialabs
k3d cluster list
# prose mention is not a call: never run `k3d cluster delete`
