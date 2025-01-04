#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "Adding Docker GPG key and repository..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index..."
sudo apt update

echo "Installing Containerd..."
sudo apt install -y containerd.io

echo "Configuring Containerd..."
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

echo "Restarting and enabling Containerd service..."
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "Verifying Containerd installation..."
containerd_version=$(containerd --version)
echo "Containerd installed successfully: $containerd_version"
sudo systemctl status containerd | grep "Active:"

echo "Installation and setup of Containerd are complete!"
