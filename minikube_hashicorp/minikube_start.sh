#!/bin/bash
set -e

echo "[INFO] Starting Minikube..."

# Start Minikube with Docker driver
minikube start --driver=docker

# Check cluster status
kubectl get nodes

echo "[INFO] Minikube is running."
