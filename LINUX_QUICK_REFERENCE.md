# DeerFlow Linux Migration: Quick Reference Card

Print this or keep open in second monitor during migration.

---

## PHASE 1: WINDOWS PREPARATION

```powershell
# Windows Terminal / PowerShell

cd C:\Users\liamg\deer-flow

# Verify clean state
git status

# Stop all services
make clean
make stop

# (Optional) Create backup
# Right-click C:\Users\liamg\deer-flow → Send to → Compressed (zipped) folder
```

---

## PHASE 2: TRANSFER TO LINUX

### Via Git Clone (Easiest)
```bash
# On Linux Terminal
cd ~
git clone https://github.com/[your-repo].git deer-flow
cd deer-flow
```

### Via SCP (Fastest for LAN)
```powershell
# On Windows Terminal
scp -r C:\Users\liamg\deer-flow pi@192.168.1.100:/home/pi/
```

```bash
# On Linux (after SCP completes)
cd /home/pi/deer-flow
```

### Via USB Drive
```bash
# On Linux
cp -r /media/username/USB/deer-flow ~/
cd ~/deer-flow
```

---

## PHASE 3: LINUX SYSTEM SETUP

```bash
# Copy-paste each line one at a time

# 1. Update packages
sudo apt update
sudo apt upgrade -y

# 2. Install Docker
sudo apt install -y docker.io docker-compose

# 3. Add user to docker group
sudo usermod -aG docker $(whoami)
newgrp docker

# 4. Verify Docker
docker --version
docker-compose --version

# 5. Install Python 3.12
sudo apt install -y python3.12 python3.12-venv python3-pip

# 6. Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env

# 7. Install Node.js + pnpm
sudo apt install -y nodejs npm
npm install -g pnpm

# 8. Install Make
sudo apt install -y make git

# 9. Verify all
python3.12 --version
uv --version
node --version
pnpm --version
docker --version
```

---

## PHASE 4: DEERFLOW SETUP

```bash
cd ~/deer-flow

# Copy templates
cp .env.example .env
cp config.example.yaml config.yaml

# Make scripts executable
chmod +x scripts/*.sh
chmod +x Makefile

# Verify structure
ls -la

# Should see: .env, config.yaml, backend/, frontend/, docker/, etc.
```

---

## PHASE 5: INSTALL DEPENDENCIES

```bash
# Still in ~/deer-flow

# This takes 30-60 minutes
make install

# When done: ✓ All dependencies installed
```

---

## PHASE 6: TESTING

### Test 1: Local Dev (No Docker)
```bash
# Terminal 1
cd ~/deer-flow
make start

# Terminal 2 (new tab: Ctrl+Shift+T)
cd ~/deer-flow
sleep 5
ps aux | grep langgraph
ps aux | grep uvicorn
ps aux | grep next

# Browser
# http://localhost:3000
# (if Raspberry Pi on LAN: http://[pi-ip]:3000)

# Stop
make stop
```

### Test 2: Docker Dev
```bash
cd ~/deer-flow/docker

# Start
docker-compose -f docker-compose-dev.yaml up --build

# Wait 3-5 minutes for logs to show:
# nginx_1 | ... nginx started
# gateway_1 | Application startup complete
# langgraph_1 | ... listening on
# frontend_1 | ready - started server

# Browser (new tab)
# http://localhost:2026

# View logs (new terminal)
docker-compose -f docker-compose-dev.yaml logs -f frontend

# Stop (press Ctrl+C in docker-compose terminal)
docker-compose -f docker-compose-dev.yaml down
```

---

## PHASE 7: PRODUCTION (Optional)

```bash
cd ~/deer-flow

export DEER_FLOW_REPO_ROOT=~/deer-flow

# Generate secret (copy output)
openssl rand -base64 32

# Create .env with secret
nano ~/.env
# Paste:
# BETTER_AUTH_SECRET=[secret-from-above]
# TAVILY_API_KEY=your-key
# JINA_API_KEY=your-key

# Start production (background)
cd docker
PORT=2026 docker-compose -f docker-compose.yaml up -d

# Check status
docker-compose -f docker-compose.yaml ps

# Access
# http://localhost:2026

# View logs
docker-compose -f docker-compose.yaml logs -f

# Stop
docker-compose -f docker-compose.yaml down
```

---

## PHASE 8: RASPBERRY PI OPTIMIZATION

```bash
# Swap (4GB)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Docker memory limits
sudo nano /etc/docker/daemon.json
# Add: { "memory": "12000000000" }
# Ctrl+X, Y, Enter

sudo systemctl restart docker

# Pre-pull images
docker pull debian:bookworm-slim
docker pull node:20-alpine
docker pull python:3.12-slim
```

---

## DAILY WORKFLOW (After Setup)

```bash
# Morning: Start dev
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml up --build
# http://localhost:2026

# Afternoon: Sync changes from Windows
cd ~/deer-flow
git pull
make install  # if dependencies changed

# Restart services
docker-compose -f docker/docker-compose-dev.yaml restart gateway frontend langgraph

# View logs
docker-compose -f docker/docker-compose-dev.yaml logs -f

# Evening: Stop
# Ctrl+C in docker-compose terminal
docker-compose -f docker/docker-compose-dev.yaml down
```

---

## EMERGENCY COMMANDS

```bash
# Check what's using a port
sudo lsof -i :2026

# Kill process on port
sudo kill -9 [PID]

# Reset Docker completely
docker system prune -a --volumes

# Check disk space
df -h

# Check memory
free -h

# View all running containers
docker ps -a

# Stop all containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

# View docker logs
docker logs [container-name]

# SSH back to Windows from Linux (if needed)
# ssh [windows-username]@[windows-ip]
```

---

## PORTS TO REMEMBER

- Frontend (local): `3000`
- Gateway API: `8001`
- LangGraph Server: `2024`
- Nginx Reverse Proxy: `2026` ← Use this for browser
- Provisioner (optional): `8002`

---

## VERIFICATION CHECKLIST

Run this to verify everything after setup:

```bash
cd ~/deer-flow

echo "=== Git ===" && git status
echo "=== Python ===" && python3.12 --version
echo "=== UV ===" && uv --version
echo "=== Node ===" && node --version
echo "=== pnpm ===" && pnpm --version
echo "=== Docker ===" && docker --version
echo "=== Config ===" && ls -la .env config.yaml
echo "=== Backend ===" && cd backend && ls -la .venv && cd ..
echo "=== Frontend ===" && cd frontend && ls -la node_modules && cd ..
echo "=== Docker Status ===" && docker ps -a
```

All should show versions or "good" status.

---

## IF SOMETHING BREAKS

**Option 1: Quick Restart**
```bash
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml down
docker-compose -f docker-compose-dev.yaml up --build
```

**Option 2: Full Reset**
```bash
cd ~
rm -rf deer-flow
git clone https://github.com/[your-repo].git deer-flow
cd deer-flow
make install
```

**Option 3: Nuclear Option**
```bash
docker system prune -a --volumes
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```

---

**Quick Tips:**
- Always run commands from `~/deer-flow` unless specified
- `Ctrl+C` stops processes gracefully
- `Ctrl+Shift+T` opens new terminal tab (Linux)
- `docker-compose logs -f` shows real-time logs (press `Ctrl+C` to exit)
- If stuck: reboot Linux machine, restart Docker
