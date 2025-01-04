#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the Kubernetes version to install
KUBERNETES_VERSION="1.32.0-00"

echo "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing required dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "Adding Kubernetes GPG key..."
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg

echo "Adding Kubernetes APT repository..."
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package index..."
sudo apt-get update

echo "Installing kubeadm, kubelet, and kubectl..."
sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION

echo "Holding Kubernetes packages at the current version..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "Enabling and starting kubelet service..."
sudo systemctl enable kubelet
sudo systemctl start kubelet

echo "Disabling swap (required for Kubernetes)..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "Setting up sysctl parameters for Kubernetes networking..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

echo "Applying sysctl parameters..."
sudo sysctl --system

echo "Installation of kubeadm, kubelet, and kubectl is complete!"
