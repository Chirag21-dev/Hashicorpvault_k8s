#!/bin/bash
set -e

echo "[INFO] Adding HashiCorp Helm repo..."
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

echo "[INFO] Installing Vault in dev mode..."
helm install vault hashicorp/vault --set "server.dev.enabled=true"

echo "[INFO] Waiting for Vault pod to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=vault --timeout=180s

kubectl get pods
echo "[INFO] Vault installed successfully."
