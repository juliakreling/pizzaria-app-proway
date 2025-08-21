#!/bin/bash

set -e

# Configurações
REPO_URL="https://github.com/juliakreling/pizzaria-app-proway.git"
PROJECT_DIR="/opt/pizzaria-app-proway"

echo "[INFO] Iniciando deploy da Pizzaria..."

# Install Docker and dependencies
sudo apt update -y
sudo apt install -y docker.io docker-compose git
sudo systemctl start docker
sudo systemctl enable docker
echo "[INFO] Dependências instaladas com sucesso!"

# Atualiza ou clona repositório
if [ -d "$PROJECT_DIR" ]; then
   echo "[INFO] Atualizando repositório..."
   cd "$PROJECT_DIR"
   git pull
else
   echo "[INFO] Clonando repositório..."
   git clone "$REPO_URL" "$PROJECT_DIR"
fi

# Para containers existentes e reconstrói
cd "$PROJECT_DIR"
docker-compose up --build -d --force-recreate

# Cria cron para rodar a cada 5 minutos (sem log redirecionado)
crontab -l 2>/dev/null | grep -q "deploy_pizzaria.sh" || (crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/deploy_pizzaria.sh") | crontab -

echo "Deploy concluído! Acesse: http://localhost"