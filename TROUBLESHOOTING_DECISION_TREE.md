# DeerFlow Linux Migration: Troubleshooting Decision Tree

Use this when something goes wrong. Follow the flowchart to find solutions.

---

## MAIN TROUBLESHOOTING FLOWCHART

```
┌─ PROBLEM AREA ──────────────────────────────────┐
│                                                   │
│  1. Transfer/Git Issues                          │
│  2. System/Tool Installation Issues              │
│  3. Dependency Installation Issues               │
│  4. Docker Issues                                │
│  5. Application Runtime Issues                   │
│  6. Port/Network Issues                          │
│  7. Performance Issues                           │
│  8. Permission Issues                            │
│                                                   │
└────────────────────────────────────────────────────┘
```

---

## 1. TRANSFER/GIT ISSUES

### Problem: "fatal: not a git repository"

**Diagnosis:**
```bash
cd ~/deer-flow
git status
```

**Expected:** Shows branch info, NOT an error

**If error occurs:**

**Solution Option A - Re-clone (5 min)**
```bash
cd ~
rm -rf deer-flow
git clone https://github.com/[repo].git deer-flow
cd deer-flow
```

**Solution Option B - Restore from backup (3 min)**
```bash
cd ~
rm -rf deer-flow
unzip ~/deer-flow.zip
cd deer-flow
```

**Solution Option C - Initialize git (2 min)**
```bash
cd ~/deer-flow
git init
git remote add origin https://github.com/[repo].git
git fetch origin
git checkout -b main origin/main
```

---

### Problem: "Permission denied (publickey)" during git clone/push

**Diagnosis:**
```bash
ssh -T git@github.com
```

**If error:** SSH key not configured

**Solution (5 min):**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"
# Press Enter 3 times to use defaults

# Copy key to clipboard
cat ~/.ssh/id_ed25519.pub

# Go to GitHub Settings → SSH Keys → New SSH Key
# Paste the key
# Save

# Test
ssh -T git@github.com
# Expected: "Hi [username]! You've successfully authenticated..."
```

---

### Problem: "error: Your local changes would be overwritten by merge"

**Diagnosis:**
```bash
git status
```

**Shows:** Modified files in red

**Solution (2 min):**
```bash
# Backup your changes
cp .env .env.backup
cp config.yaml config.yaml.backup

# Reset to clean state
git reset --hard

# Restore if needed
cp .env.backup .env
cp config.yaml.backup config.yaml
```

---

## 2. SYSTEM/TOOL INSTALLATION ISSUES

### Problem: "Command not found: docker"

**Diagnosis:**
```bash
which docker
docker --version
```

**If no output:** Docker not installed

**Solution (5 min):**
```bash
sudo apt update
sudo apt install -y docker.io

# Verify
docker --version
```

---

### Problem: "docker: command not found (but docker.io is installed)"

**Diagnosis:**
```bash
dpkg -l | grep docker
```

**Shows:** `ii docker.io` but `docker` not in PATH

**Solution (1 min):**
```bash
# Check Docker service running
sudo systemctl status docker

# If not running:
sudo systemctl start docker

# Add to path
export PATH="/usr/bin:$PATH"
docker --version
```

---

### Problem: "permission denied while trying to connect to Docker daemon socket"

**Diagnosis:**
```bash
docker ps
```

**Error:** `permission denied ... /var/run/docker.sock`

**Solution (2 min):**
```bash
# Add user to docker group
sudo usermod -aG docker $(whoami)

# Activate new group
newgrp docker

# Test
docker ps
```

---

### Problem: "Python 3.12 not found"

**Diagnosis:**
```bash
python3.12 --version
```

**If error:** Python 3.12 not installed

**Solution (3 min):**
```bash
# Check available versions
apt search python3 | grep "3.12"

# Install
sudo apt install -y python3.12 python3.12-dev python3.12-venv

# Verify
python3.12 --version
```

---

### Problem: "uv: command not found"

**Diagnosis:**
```bash
uv --version
which uv
```

**Solution (2 min):**
```bash
# Install
curl -LsSf https://astral.sh/uv/install.sh | sh

# Activate
source $HOME/.cargo/env

# Verify
uv --version

# Make permanent
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

### Problem: "npm: command not found"

**Diagnosis:**
```bash
npm --version
node --version
```

**Solution (3 min):**
```bash
sudo apt update
sudo apt install -y nodejs npm

# Verify
npm --version
node --version
```

---

## 3. DEPENDENCY INSTALLATION ISSUES

### Problem: "make: command not found"

**Diagnosis:**
```bash
which make
```

**Solution (1 min):**
```bash
sudo apt install -y make

# Verify
make --version
```

---

### Problem: "make install" fails on Python part

**Diagnosis:**
```bash
cd ~/deer-flow/backend
uv sync
```

**Look for:** Error in output

**Common solutions:**

**If "No space left on device":**
```bash
# Check disk
df -h

# Clean Docker
docker system prune -a --volumes
docker image prune -a

# Retry
uv sync --upgrade
```

**If "network error":**
```bash
# Retry with aggressive timeout
uv sync --upgrade --timeout 300
```

**If "build failed on Rust/C extension":**
```bash
# Install build tools
sudo apt install -y build-essential

# Retry
uv sync --upgrade
```

---

### Problem: "make install" fails on Node part

**Diagnosis:**
```bash
cd ~/deer-flow/frontend
pnpm install
```

**Look for:** Error in output

**Common solutions:**

**If "ERESOLVE unable to resolve dependency tree":**
```bash
# Force install
pnpm install --force

# Or use legacy peer deps
pnpm install --legacy-peer-deps
```

**If "node_modules is corrupted":**
```bash
# Remove and reinstall
rm -rf node_modules
pnpm install --force
```

**If "network timeout":**
```bash
# Use different registry
pnpm config set registry https://registry.npmjs.org/
pnpm install --force
```

---

## 4. DOCKER ISSUES

### Problem: "docker-compose: command not found"

**Diagnosis:**
```bash
docker-compose --version
docker compose version
```

**Solution (2 min):**
```bash
# Install
sudo apt install -y docker-compose

# Or use docker compose (newer syntax)
docker compose version

# Both should work
```

---

### Problem: "Couldn't connect to Docker daemon at unix:///var/run/docker.sock"

**Diagnosis:**
```bash
docker ps
```

**Error:** Connection refused

**Solution (2 min):**
```bash
# Check if Docker service is running
sudo systemctl status docker

# If not running
sudo systemctl start docker

# Verify
docker ps
```

---

### Problem: "ERROR: The Docker daemon seems incompatible with this version of docker-compose"

**Diagnosis:**
```bash
docker --version
docker-compose --version
```

**Solution (3 min):**
```bash
# Update docker-compose
sudo apt update
sudo apt install --upgrade docker-compose

# Or use new syntax (docker compose instead of docker-compose)
cd ~/deer-flow/docker
docker compose -f docker-compose-dev.yaml up
```

---

### Problem: "Container exits immediately after starting"

**Diagnosis:**
```bash
# Check container status
docker ps -a

# View logs
docker logs [container-name]
```

**Example:** Container named `deer-flow-gateway` exited

**Solution:**
```bash
# View detailed error logs
docker logs deer-flow-gateway

# If error is about missing file/directory
# Check volume mounts in docker-compose.yaml
nano ~/deer-flow/docker/docker-compose-dev.yaml

# Verify host paths exist
ls -la ~/deer-flow/backend/
ls -la ~/deer-flow/frontend/

# Rebuild
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml build --no-cache
docker-compose -f docker-compose-dev.yaml up
```

---

### Problem: "Insufficient memory during docker build"

**Diagnosis:**
```bash
free -h
docker info | grep Memory
```

**If <2GB available:** Out of memory

**Solution (5 min on RPi):**
```bash
# Create swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Verify
free -h

# Retry build
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml build --no-cache
```

---

### Problem: "Build fails with 'No space left on device'"

**Diagnosis:**
```bash
df -h
du -sh ~/deer-flow
docker system df
```

**If <5GB available:** Disk full

**Solution (5 min):**
```bash
# Clean old Docker artifacts
docker system prune -a --volumes

# Check space
docker system df

# Remove large files (if any)
rm -rf ~/deer-flow/node_modules
rm -rf ~/deer-flow/backend/.venv

# Reinstall
cd ~/deer-flow
make install
```

---

## 5. APPLICATION RUNTIME ISSUES

### Problem: "Application startup complete" but services hang

**Diagnosis:**
```bash
cd ~/deer-flow
make start

# In another tab
ps aux | grep python
ps aux | grep node
```

**Services running but unresponsive**

**Solution (3 min):**
```bash
# Kill all services
make stop

# Kill any hanging processes
pkill -9 langgraph
pkill -9 uvicorn
pkill -9 node

# Wait 5 seconds
sleep 5

# Restart
make start
```

---

### Problem: "ModuleNotFoundError: No module named '[package]'"

**Diagnosis:**
```bash
cd ~/deer-flow/backend
uv run python -c "import [package]"
```

**Solution:**
```bash
# Reinstall dependencies
cd ~/deer-flow/backend
uv sync --upgrade

# Or specific package
uv add [package-name]
```

---

### Problem: "cannot import name '[module]' from partially initialized package"

**This usually means circular imports or corrupted env**

**Solution (5 min):**
```bash
# Full reset
cd ~/deer-flow
make clean

# Remove and reinstall
rm -rf backend/.venv frontend/node_modules

# Reinstall
make install

# Restart
make start
```

---

## 6. PORT/NETWORK ISSUES

### Problem: "Address already in use: ('[', '0.0.0.0', 3000, ']')"

**Port 3000 already in use**

**Diagnosis:**
```bash
sudo lsof -i :3000
```

**Output shows process using port**

**Solution Option A (Kill old process):**
```bash
# Get PID
PID=$(lsof -t -i :3000)

# Kill it
kill -9 $PID

# Wait 2 seconds
sleep 2

# Restart
make start
```

**Solution Option B (Use different port):**
```bash
# Change port in config or environment
export FRONTEND_PORT=3001
make start
```

---

### Problem: "Cannot connect to http://localhost:3000"

**Diagnosis:**
```bash
# Check if service is running
ps aux | grep "next dev" | grep -v grep

# Check port
sudo lsof -i :3000
```

**If no process:** Service not started

**If process exists but can't connect:**

**Solution:**
```bash
# Check firewall
sudo ufw status

# If enabled, allow port
sudo ufw allow 3000

# Test connection
curl -I http://localhost:3000

# If still fails, check service logs
cd ~/deer-flow
make stop
make start 2>&1 | tail -50
```

---

### Problem: "Cannot access from remote machine (Raspberry Pi)"

**On Windows laptop, trying to access `http://192.168.1.100:3000` - times out**

**Diagnosis:**
```bash
# On Linux machine
hostname -I
```

**Note the IP. Then from Windows:**
```powershell
ping 192.168.1.100
```

**If no response:** Network issue

**Solution:**
```bash
# On Linux, verify services are bound to 0.0.0.0 (not 127.0.0.1)
sudo lsof -i :3000 | head -5

# Should show: 0.0.0.0:3000
# NOT: 127.0.0.1:3000

# If showing 127.0.0.1, edit docker-compose or Makefile
# and change `localhost` to `0.0.0.0`

# Also check firewall
sudo ufw allow 3000
sudo ufw allow 8001
sudo ufw allow 2024
sudo ufw allow 2026
```

---

## 7. PERFORMANCE ISSUES

### Problem: "System very slow during build/install"

**Diagnosis:**
```bash
free -h
top -n 1
```

**If <500MB free RAM:** Low memory

**Solution (on Raspberry Pi):**
```bash
# Enable swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Monitor memory
watch free -h

# Increase Docker memory limit
sudo nano /etc/docker/daemon.json

# Add or modify:
# { "memory": "12000000000" }

# Ctrl+X, Y, Enter
sudo systemctl restart docker

# Retry installation
make install
```

---

### Problem: "Docker image build takes >30 minutes"

**Diagnosis:**
```bash
# Check if this is normal (first build is slower)
docker images
```

**Solution:**
```bash
# Skip rebuild if images already exist
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml up
# Don't use --build flag

# If you need to rebuild
docker-compose -f docker-compose-dev.yaml build --no-cache --progress=plain
```

---

## 8. PERMISSION ISSUES

### Problem: "Permission denied" when accessing files

**Diagnosis:**
```bash
ls -la ~/deer-flow
# Check if your user owns the directory
```

**If owned by root:** Permission issue

**Solution:**
```bash
# Take ownership
sudo chown -R $(whoami):$(whoami) ~/deer-flow

# Set permissions
chmod -R u+rwx ~/deer-flow

# Verify
ls -la ~/deer-flow
```

---

### Problem: "Cannot write to config.yaml" or ".env"

**Diagnosis:**
```bash
ls -la ~/deer-flow/{config.yaml,.env}
```

**If showing `r--` or owned by root:** Read-only or wrong owner

**Solution:**
```bash
# Make writable
chmod 644 ~/deer-flow/config.yaml
chmod 644 ~/deer-flow/.env

# Or if owned by root
sudo chown $(whoami):$(whoami) ~/deer-flow/config.yaml
sudo chown $(whoami):$(whoami) ~/deer-flow/.env

# Verify
ls -la ~/deer-flow/{config.yaml,.env}
```

---

## NUCLEAR OPTIONS (Last Resort)

### Complete Reset (Deletes everything - 30 min recovery)

```bash
# Stop everything
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml down
docker system prune -a --volumes

# Delete and reinstall
cd ~
rm -rf deer-flow

# Re-transfer from Windows/Git
git clone https://github.com/[repo].git deer-flow
cd deer-flow

# Full setup
make install

# Test
make start
```

### Reset Just Docker

```bash
# Stop Docker
sudo systemctl stop docker

# Reset completely (warning: deletes ALL containers/images)
sudo rm -rf /var/lib/docker/*

# Start Docker
sudo systemctl start docker

# Re-pull images
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml build --no-cache
```

### Reset Just Packages

```bash
# Python
cd ~/deer-flow/backend
rm -rf .venv
uv sync --upgrade

# Node
cd ~/deer-flow/frontend
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

---

## DIAGNOSTIC COMMAND: Generate Full Debug Report

**Run this and save the output:**

```bash
#!/bin/bash
echo "=== DeerFlow Debug Report ===" > debug-report.txt
date >> debug-report.txt

echo -e "\n=== System Info ===" >> debug-report.txt
uname -a >> debug-report.txt
df -h >> debug-report.txt
free -h >> debug-report.txt

echo -e "\n=== Tools Versions ===" >> debug-report.txt
python3.12 --version >> debug-report.txt 2>&1
uv --version >> debug-report.txt 2>&1
node --version >> debug-report.txt 2>&1
pnpm --version >> debug-report.txt 2>&1
docker --version >> debug-report.txt 2>&1
docker-compose --version >> debug-report.txt 2>&1
git --version >> debug-report.txt 2>&1
make --version >> debug-report.txt 2>&1

echo -e "\n=== Project Structure ===" >> debug-report.txt
cd ~/deer-flow
git status >> debug-report.txt 2>&1
ls -la >> debug-report.txt

echo -e "\n=== Backend Status ===" >> debug-report.txt
test -d backend/.venv && echo "✓ .venv exists" >> debug-report.txt || echo "✗ .venv missing" >> debug-report.txt

echo -e "\n=== Frontend Status ===" >> debug-report.txt
test -d frontend/node_modules && echo "✓ node_modules exists" >> debug-report.txt || echo "✗ node_modules missing" >> debug-report.txt

echo -e "\n=== Docker Status ===" >> debug-report.txt
docker ps -a >> debug-report.txt
docker images >> debug-report.txt

echo -e "\n=== Ports ===" >> debug-report.txt
sudo lsof -i -P -n >> debug-report.txt 2>&1 | grep -E "COMMAND|3000|8001|2024|2026"

echo -e "\n=== Logs ===" >> debug-report.txt
docker logs $(docker ps -qa) 2>&1 | tail -100 >> debug-report.txt

cat debug-report.txt
```

**Save and share for support:**
```bash
cp debug-report.txt ~/debug-report-$(date +%Y%m%d-%H%M%S).txt
```

---

## When All Else Fails

**If none of the above solutions work:**

1. **Check Docker/Linux Logs:**
   ```bash
   # Docker daemon
   sudo journalctl -u docker.service -n 50
   
   # System
   journalctl -n 50
   ```

2. **Check if issue is Windows-specific:**
   - Does it work on local Linux machine?
   - Try on Docker Desktop (Windows)?
   - Try on actual Linux machine?

3. **Create Minimal Test Case:**
   ```bash
   # Test just Python
   python3.12 -c "import sys; print(sys.version)"
   
   # Test just Node
   node -e "console.log(process.version)"
   
   # Test just Docker
   docker run hello-world
   ```

4. **Collect Debug Info & Seek Support:**
   - Run the diagnostic report above
   - Share with team/community
   - Include specific error messages
   - Include `docker-compose logs` output

---

**Last Updated:** 2024-12-20
**Version:** 1.0
