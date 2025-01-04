#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating system packages..."
sudo apt-get update

echo "Installing required dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

echo "Adding Kubernetes GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Adding Kubernetes APT repository..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package index..."
sudo apt-get update

echo "Installing kubelet, kubeadm, and kubectl..."
sudo apt-get install -y kubelet kubeadm kubectl

echo "Marking Kubernetes packages to hold current versions..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "Enabling and starting kubelet service..."
sudo systemctl enable --now kubelet

echo "Kubernetes tools installation is complete!"
