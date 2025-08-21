#!/bin/bash

set -e

# Configurations
REPO_URL="https://github.com/juliakreling/pizzaria-app-proway.git"
PROJECT_DIR="/opt/pizzaria-app-proway"

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
fi

# Stop existing containers and rebuild
cd "$PROJECT_DIR"
docker-compose up --build -d --force-recreate

# Create cron job to run every 5 minutes (no log redirection)
crontab -l 2>/dev/null | grep -q "deploy_pizzaria.sh" || (crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/deploy_pizzaria.sh") | crontab -

echo "Deployment completed! Access: http://localhost"
