#!/bin/bash

set -e

# Configurations
REPO_URL="https://github.com/juliakreling/pizzaria-app-proway.git"
PROJECT_DIR="/pizzaria-app-proway"

echo "[INFO] Starting Pizzaria deployment..."

# Install Docker and dependencies
sudo apt update -y
sudo apt install -y docker.io docker-compose git
sudo systemctl start docker
sudo systemctl enable docker
echo "[INFO] Dependencies successfully installed!"

# Update or clone repository
if [ -d "$PROJECT_DIR" ]; then
   echo "[INFO] Updating repository..."
   cd "$PROJECT_DIR"
   git pull
else
   echo "[INFO] Cloning repository..."
   git clone "$REPO_URL" "$PROJECT_DIR"
   cd "$PROJECT_DIR"
fi

# Stop existing containers and rebuild
cd "$PROJECT_DIR"
docker-compose down
docker-compose up --build -d --force-recreate

