# DeerFlow Migration: 60-Second Cheat Sheet

For people who just need the commands without explanation.

---

## ON WINDOWS (Pre-Flight)

```powershell
cd C:\Users\liamg\deer-flow

git status          # Must show: nothing to commit
make clean          # Stop all
make stop           # Verify stopped

# Optional: Backup
# Right-click deer-flow → Send to → Compressed (zipped) folder

# Verify Git clean
git status
```

---

## ON LINUX (All-In-One Copy-Paste)

**Option 1: Via Git Clone**
```bash
cd ~
git clone https://github.com/[your-repo].git deer-flow
cd deer-flow
```

**Option 2: Via SCP (from Windows)**
```powershell
# On Windows Terminal
scp -r C:\Users\liamg\deer-flow pi@192.168.1.100:/home/pi/
```
```bash
# On Linux
cd /home/pi/deer-flow
```

---

## SYSTEM SETUP (Copy-Paste All)

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose python3.12 python3.12-venv make git nodejs npm
sudo usermod -aG docker $(whoami)
newgrp docker

# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env

# Install pnpm
npm install -g pnpm

# Verify
python3.12 --version && uv --version && node --version && pnpm --version && docker --version
```

---

## DEERFLOW SETUP (Copy-Paste All)

```bash
cd ~/deer-flow

cp .env.example .env
cp config.example.yaml config.yaml

chmod +x scripts/*.sh Makefile

# Verify
ls -la | grep -E "\.env|config\.yaml"
```

---

## INSTALL DEPENDENCIES (Takes 30-60 min)

```bash
# This does everything
make install

# If it fails, try individual steps:
# cd backend && uv sync --upgrade
# cd ../frontend && pnpm install --force
```

---

## TEST LOCAL (No Docker)

```bash
# Terminal 1
make start
# Wait 10 seconds

# Terminal 2
ps aux | grep -E "langgraph|uvicorn|next" | grep -v grep
# Should show 3 processes

# Browser: http://localhost:3000 (or http://[pi-ip]:3000)

# Stop
make stop
```

---

## TEST DOCKER

```bash
cd ~/deer-flow/docker

# Start
docker-compose -f docker-compose-dev.yaml up --build
# Wait 3-5 minutes

# Browser (new tab): http://localhost:2026

# Logs (new tab):
docker-compose -f docker-compose-dev.yaml logs -f frontend

# Stop (in docker-compose tab):
# Ctrl+C then:
docker-compose -f docker-compose-dev.yaml down
```

---

## PRODUCTION (Optional)

```bash
export DEER_FLOW_REPO_ROOT=~/deer-flow

# Generate secret
openssl rand -base64 32    # Copy output

# Create .env
nano ~/.env
# Paste:
# BETTER_AUTH_SECRET=[secret]
# TAVILY_API_KEY=key
# JINA_API_KEY=key
# Ctrl+X, Y, Enter

# Start
cd ~/deer-flow/docker
PORT=2026 docker-compose -f docker-compose.yaml up -d

# Access: http://localhost:2026
# Logs: docker-compose -f docker-compose.yaml logs -f
# Stop: docker-compose -f docker-compose.yaml down
```

---

## RASPBERRY PI ONLY (4GB Swap + Memory)

```bash
# Swap (4GB)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Docker memory
sudo nano /etc/docker/daemon.json
# Add: { "memory": "12000000000" }
# Ctrl+X, Y, Enter

sudo systemctl restart docker

# Pre-pull images
docker pull debian:bookworm-slim node:20-alpine python:3.12-slim
```

---

## TROUBLESHOOTING

```bash
# Port already in use?
sudo lsof -i :3000
kill -9 [PID]

# Permission denied?
sudo usermod -aG docker $(whoami)
newgrp docker

# Docker not responding?
sudo systemctl restart docker

# Out of memory?
docker system prune -a --volumes

# Container exited?
docker logs [container-name]

# Check all services
docker ps -a

# Full reset (nuclear)
docker system prune -a --volumes
cd ~
rm -rf deer-flow
# Re-transfer and reinstall
```

---

## DAILY WORKFLOW

```bash
# Morning: Start
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml up --build

# Access: http://localhost:2026

# Sync changes
git pull

# Restart if needed
docker-compose -f docker-compose-dev.yaml restart gateway frontend langgraph

# Evening: Stop
# Ctrl+C then:
docker-compose -f docker-compose-dev.yaml down
```

---

## KEY PORTS

| Service | Port | Access |
|---------|------|--------|
| Frontend (local) | 3000 | http://localhost:3000 |
| Gateway API | 8001 | http://localhost:8001 |
| LangGraph | 2024 | http://localhost:2024 |
| Nginx (use this) | 2026 | http://localhost:2026 |

---

## SUCCESS CHECKLIST

```bash
cd ~/deer-flow

# Run this:
test -d backend/.venv && echo "✓ Backend .venv" || echo "✗ Backend .venv missing"
test -d frontend/node_modules && echo "✓ Frontend node_modules" || echo "✗ Frontend node_modules missing"
test -f .env && echo "✓ .env" || echo "✗ .env missing"
test -f config.yaml && echo "✓ config.yaml" || echo "✗ config.yaml missing"
docker ps -a | wc -l && echo "✓ Docker ready"
python3.12 --version && echo "✓ Python"
uv --version && echo "✓ UV"
node --version && echo "✓ Node"
pnpm --version && echo "✓ pnpm"
```

All should show ✓

---

## REFERENCE DOCS

- Detailed guide: `WINDOWS_TO_LINUX_MIGRATION.md`
- Visual checklist: `MIGRATION_VISUAL_CHECKLIST.md`
- Quick reference: `LINUX_QUICK_REFERENCE.md`
- Troubleshooting: `TROUBLESHOOTING_DECISION_TREE.md`

---

**That's it. Copy-paste the sections, run them in order.**

**Stuck? Check `TROUBLESHOOTING_DECISION_TREE.md`**

**Problems? Check the detailed guides above.**

---

**Estimated total time (first-time setup):**
- Transfer: 5-30 min (depends on method)
- System setup: 20 min
- DeerFlow setup: 5 min
- Dependency install: 30-60 min
- Testing: 10 min
- **Total: 70-125 minutes**

**You'll have working DeerFlow on Linux. 🚀**
