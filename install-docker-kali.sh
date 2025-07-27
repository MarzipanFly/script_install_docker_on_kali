#!/bin/bash

set -e

echo "[+] Удаляем старые/конфликтующие пакеты..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo apt remove -y docker-buildx docker-compose docker-cli || true

echo "[+] Устанавливаем зависимости..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "[+] Добавляем GPG-ключ Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "[+] Добавляем репозиторий Docker (Debian bookworm)..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian bookworm stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Обновляем apt и устанавливаем Docker и плагины..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[+] Настраиваем автозапуск Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[+] Проверяем работу Docker..."
sudo docker run hello-world

echo "[+] Добавляем поддержку старой команды 'docker-compose' (симлинк)..."
sudo ln -sf /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

echo "[✔] Установка завершена. Используйте:"
echo "    docker compose up -d"
echo "или docker-compose (через симлинк)"
