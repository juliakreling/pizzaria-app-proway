#!/bin/bash

set -e

# Configurations
REPO_URL="https://github.com/juliakreling/pizzaria-app-proway.git"
PROJECT_DIR="/pizzaria-app-julia"

echo "[INFO] Starting Pizzaria deployment..."

# Install Docker and dependencies
sudo apt update -y
sudo apt install -y docker.io docker-compose git cron
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl enable cron
sudo systemctl start cron
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
docker-compose up --build -d --force-recreate

# Create cron job to run every 5 minutes (no log redirection)
crontab -l 2>/dev/null | grep -q "deploy_pizzaria.sh" || (crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/deploy_pizzaria.sh") | crontab -

echo "Deployment completed! Access: http://localhost"
