#!/bin/bash
set -e

echo "[INFO] Setting up Vault Kubernetes authentication..."

# Port forward Vault
kubectl port-forward svc/vault 8200:8200 &
sleep 5

# Get root token from logs
ROOT_TOKEN=$(kubectl logs vault-0 | grep "Root Token:" | awk '{print $3}')

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="$ROOT_TOKEN"

echo "[INFO] Enabling Kubernetes auth in Vault..."
vault auth enable kubernetes

vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host="https://kubernetes.default.svc.cluster.local" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

echo "[INFO] Vault Kubernetes authentication configured."
