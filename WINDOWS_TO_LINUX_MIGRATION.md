# DeerFlow: Windows to Linux Migration Guide

Complete step-by-step guide for migrating your DeerFlow project from Windows 11 to Debian Linux (Raspberry Pi 5 or any Linux system).

---

## Prerequisites

### On Your Windows Machine (Before Starting)
- Docker Desktop installed (you already have this)
- Git installed
- Project synced to latest (`git status` shows nothing to commit)
- All `.env` and `config.yaml` files are in place

### On Your Linux Machine (Target)
- Debian 12 (Bookworm) or Ubuntu 22.04+ installed
- Internet connection
- SSH access to the machine (if remote), or direct terminal access
- Minimum 4GB RAM, 20GB disk space

---

## Phase 1: Prepare Your Windows Machine (30 minutes)

### Step 1: Open File Explorer
**Exact steps:**
1. Press `Win + E` (Windows key + E)
2. Navigate to `C:\Users\liamg\deer-flow`
3. Right-click in empty space → **Properties**
4. Verify the full path shows: `C:\Users\liamg\deer-flow`

### Step 2: Verify Git Status
**Exact steps:**
1. Press `Win + X` → Select **Windows Terminal** (or PowerShell)
2. Type: `cd C:\Users\liamg\deer-flow`
3. Press `Enter`
4. Type: `git status`
5. Press `Enter`
6. **Expected output:** `On branch [branch-name]` and `nothing to commit, working tree clean`
   - If there are uncommitted changes: Type `git add .` → `git commit -m "Pre-migration checkpoint"`

### Step 3: Check Docker Desktop Status
**Exact steps:**
1. Look at your system tray (bottom right of screen)
2. Click the Docker icon (whale 🐋)
3. Verify it says "Docker Desktop is running"
4. If not running: Click **Docker.exe** from your Applications or press `Win`, type `Docker Desktop`, press `Enter`
5. Wait 30 seconds for it to start

### Step 4: Verify All Services Stop Cleanly
**Exact steps:**
1. In Windows Terminal (still at `C:\Users\liamg\deer-flow`), type: `make clean`
2. Press `Enter`
3. Wait for the command to finish (shows ✓ Cleanup complete)
4. Type: `make stop`
5. Press `Enter`
6. Wait for: `✓ All services stopped`

### Step 5: Create a Backup Archive
**Exact steps:**
1. In File Explorer, navigate to `C:\Users\liamg\`
2. Right-click on the **deer-flow** folder
3. Select **Send to** → **Compressed (zipped) folder**
4. Wait 2-3 minutes for compression
5. You now have `deer-flow.zip` (backup file)
6. **Optional:** Move this to an external drive or cloud storage

### Step 6: Prepare Git Bundle (for offline transfer)
**If transferring via USB/offline:**
1. In Windows Terminal (at `C:\Users\liamg\deer-flow`), type: `git bundle create ../deer-flow.bundle --all`
2. Press `Enter`
3. Wait 30 seconds
4. Type: `dir ../deer-flow.bundle`
5. Verify the file exists and is >1MB

---

## Phase 2: Transfer Project to Linux Machine (Variable time, depends on transfer method)

### Option A: Via Git Clone (Recommended - requires internet)

**On Linux Machine:**

1. Open terminal (Ctrl + Alt + T on Ubuntu/Debian)
2. Type: `cd ~`
3. Press `Enter`
4. Type: `git clone https://github.com/[your-repo-url].git deer-flow`
   - Replace `[your-repo-url]` with your actual GitHub/GitLab URL
5. Press `Enter`
6. Wait for clone to complete (shows "Receiving objects: 100%")
7. Type: `cd deer-flow`
8. Press `Enter`

### Option B: Via SCP (if you have SSH access to Linux machine)

**On Windows Terminal:**

1. Type: `scp -r C:\Users\liamg\deer-flow [linux-user]@[linux-ip]:/home/[linux-user]/`
   - Replace:
     - `[linux-user]` with your Linux username (e.g., `pi` for Raspberry Pi)
     - `[linux-ip]` with your Linux machine's IP (e.g., `192.168.1.100`)
   - Example: `scp -r C:\Users\liamg\deer-flow pi@192.168.1.100:/home/pi/`
2. Press `Enter`
3. If prompted for password, type your Linux password
4. Wait 5-15 minutes depending on project size and network speed

**Then on Linux Terminal:**

1. Type: `cd /home/[linux-user]/deer-flow`
   - Example: `cd /home/pi/deer-flow`
2. Press `Enter`

### Option C: Via USB Drive

**On Windows:**

1. Insert USB drive
2. In File Explorer, drag entire `C:\Users\liamg\deer-flow` folder to USB drive
3. Wait for copy to complete
4. Right-click USB drive → **Eject**

**On Linux:**

1. Insert USB drive
2. Open file manager
3. The USB drive should auto-mount (usually to `/media/[username]/[drive-name]`)
4. Open terminal, type: `cd ~`
5. Press `Enter`
6. Type: `cp -r /media/[username]/[drive-name]/deer-flow ./`
   - Replace `[username]` and `[drive-name]` with actual values
7. Press `Enter`
8. Type: `cd deer-flow`
9. Press `Enter`

---

## Phase 3: Prepare Linux System (20 minutes)

**Exact terminal commands on your Linux machine:**

### Step 1: Update System Packages
```bash
sudo apt update
sudo apt upgrade -y
```
Wait for completion (shows "done").

### Step 2: Install Docker
```bash
sudo apt install -y docker.io docker-compose
```
Wait 3-5 minutes.

### Step 3: Add Your User to Docker Group
```bash
sudo usermod -aG docker $(whoami)
newgrp docker
```
No restart needed immediately.

### Step 4: Verify Docker Installation
```bash
docker --version
docker-compose --version
```
Expected output:
- `Docker version 24.x.x, build ...`
- `Docker Compose version 2.x.x`

### Step 5: Install Python 3.12+
```bash
sudo apt install -y python3.12 python3.12-venv python3-pip
```

### Step 6: Install UV Package Manager
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env
```

### Step 7: Install Node.js & pnpm
```bash
sudo apt install -y nodejs npm
npm install -g pnpm
```

### Step 8: Install Git (if not already installed)
```bash
sudo apt install -y git
```

### Step 9: Verify All Tools
```bash
python3.12 --version
uv --version
node --version
npm --version
pnpm --version
git --version
```

Expected output (approximate versions):
- `Python 3.12.x`
- `uv 0.x.x`
- `v20.x.x`
- `10.x.x`
- `pnpm@10.x.x`
- `git version 2.x.x`

---

## Phase 4: Configure DeerFlow on Linux (15 minutes)

### Step 1: Navigate to Project
```bash
cd ~/deer-flow
pwd
```
Expected: `/home/[username]/deer-flow` or `/root/deer-flow`

### Step 2: Copy Environment Files
```bash
cp .env.example .env
cp config.example.yaml config.yaml
```

### Step 3: Edit Configuration (if needed)
If you want to use specific API keys or settings:
```bash
nano config.yaml
```
- Use arrow keys to navigate
- Press `Ctrl + X` to exit
- Press `Y` to confirm save
- Press `Enter` to confirm filename

Or keep defaults for testing.

### Step 4: Set Permissions
```bash
chmod +x scripts/*.sh
chmod +x Makefile
```

### Step 5: Verify File Structure
```bash
ls -la
```
You should see: `.dockerignore`, `.env`, `config.yaml`, `backend/`, `frontend/`, `docker/`, etc.

---

## Phase 5: Install Dependencies (30-60 minutes)

**Run from `~/deer-flow` directory:**

### Step 1: Run Complete Installation
```bash
make install
```

This will:
1. Install Python backend dependencies (5-10 minutes)
2. Install frontend dependencies (10-15 minutes)
3. Show completion message: ✓ All dependencies installed

**If any step fails:**
- For Python errors: `cd backend && uv sync --upgrade`
- For Node errors: `cd frontend && pnpm install --force`
- Then retry: `make install`

### Step 2: Verify Installation
```bash
cd backend
uv --version
ls -la .venv/
cd ../frontend
pnpm list
cd ..
```

---

## Phase 6: Test Development Environment (20 minutes)

### Option A: Local Development (No Docker)

**Step 1: Start Backend**
```bash
make start
```
Wait 5 seconds for servers to start.

**Step 2: Open Another Terminal Tab**
Press `Ctrl + Alt + T` or in existing terminal, press `Ctrl + Shift + T`

**Step 3: Check Services**
```bash
cd ~/deer-flow
ps aux | grep langgraph
ps aux | grep uvicorn
ps aux | grep next
```
You should see processes running for each service.

**Step 4: Test in Browser**
- On the same Linux machine: Open Firefox/Chrome, go to `http://localhost:3000`
- If on Raspberry Pi (headless): Use laptop browser, go to `http://[pi-ip]:3000` (e.g., `http://192.168.1.100:3000`)

**Step 5: Stop Services**
```bash
make stop
```

### Option B: Docker Development (Recommended)

**Step 1: Pull Sandbox Image (Optional but recommended)**
```bash
make setup-sandbox
```
Wait 2-5 minutes.

**Step 2: Start Docker Services**
```bash
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml up --build
```
Wait 3-5 minutes. You'll see logs streaming:
- `nginx_1 | ... nginx started`
- `gateway_1 | Application startup complete`
- `langgraph_1 | ... listening on`
- `frontend_1 | ready - started server`

**Step 3: Test in Browser (New Tab/Window)**
- Same machine: `http://localhost:2026`
- Remote (Raspberry Pi): `http://[pi-ip]:2026`

Expected: DeerFlow web interface loads.

**Step 4: View Logs (in separate terminal)**
```bash
cd ~/deer-flow/docker
docker-compose -f docker-compose-dev.yaml logs -f frontend
```
Press `Ctrl + C` to stop viewing logs.

**Step 5: Stop Docker Services**
In the terminal running `docker-compose up`, press `Ctrl + C`.

Then type:
```bash
docker-compose -f docker-compose-dev.yaml down
```

---

## Phase 7: Production Deployment on Linux (Optional)

### Step 1: Set Required Environment Variable
```bash
export DEER_FLOW_REPO_ROOT=~/deer-flow
```

### Step 2: Generate BETTER_AUTH_SECRET
```bash
openssl rand -base64 32
```
Copy the output (32-character string).

### Step 3: Create Production .env File
```bash
nano ~/.env
```
Paste:
```
BETTER_AUTH_SECRET=[paste-the-string-you-copied]
TAVILY_API_KEY=your-key-here
JINA_API_KEY=your-key-here
```

### Step 4: Start Production Services
```bash
cd ~/deer-flow/docker
PORT=2026 docker-compose -f docker-compose.yaml up -d
```

This starts in background. Access at `http://[linux-ip]:2026`.

### Step 5: View Production Logs
```bash
docker-compose -f docker-compose.yaml logs -f
```

### Step 6: Stop Production Services
```bash
docker-compose -f docker-compose.yaml down
```

---

## Phase 8: Optimization for Raspberry Pi (If Applicable)

### If Running on Raspberry Pi 5 16GB:

**Step 1: Enable Swap (for compilation stability)**
```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

**Step 2: Increase Docker Memory Limits**
```bash
sudo nano /etc/docker/daemon.json
```
Add or modify:
```json
{
  "memory": "12000000000"
}
```
Save (`Ctrl + X`, `Y`, `Enter`).

Restart Docker:
```bash
sudo systemctl restart docker
```

**Step 3: Pre-pull Alpine/Debian Base Images**
```bash
docker pull debian:bookworm-slim
docker pull node:20-alpine
docker pull python:3.12-slim
```

---

## Phase 9: Troubleshooting

### Issue: "Command not found: make"
**Solution:**
```bash
sudo apt install -y make
```

### Issue: "Docker socket permission denied"
**Solution:**
```bash
sudo usermod -aG docker $(whoami)
# Log out and back in, OR:
newgrp docker
```

### Issue: "Port 2026 already in use"
**Solution:**
```bash
# Find process using port 2026
sudo lsof -i :2026
# Kill it
sudo kill -9 [PID]
# Or use different port
PORT=3000 docker-compose -f docker-compose-dev.yaml up
```

### Issue: "Out of memory during build"
**Solution (on Raspberry Pi):**
```bash
# Increase swap
sudo fallocate -l 8G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Issue: "Git push/pull fails on Linux"
**Solution:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## Phase 10: Continuous Development Workflow on Linux

### Daily Start (Development Mode)
```bash
cd ~/deer-flow
docker-compose -f docker/docker-compose-dev.yaml up --build
# Access at http://localhost:2026
```

### Daily Stop
Press `Ctrl + C` in the terminal running docker-compose.

### Sync Changes from Windows
```bash
cd ~/deer-flow
git pull
make install  # if dependencies changed
```

### Restart Services After Code Change
```bash
docker-compose -f docker/docker-compose-dev.yaml restart gateway frontend langgraph
```

### View Specific Service Logs
```bash
docker-compose -f docker/docker-compose-dev.yaml logs -f gateway
```

---

## Summary: Key Differences Windows → Linux

| Aspect | Windows | Linux |
|--------|---------|-------|
| **Path Separator** | `\` | `/` |
| **Package Manager** | Chocolatey/Manual | apt/snap |
| **Python** | `python` | `python3.12` |
| **Bash Script** | Git Bash (from make) | Native bash |
| **Docker Socket** | `//./pipe/docker_engine` | `/var/run/docker.sock` |
| **Home Directory** | `C:\Users\[user]` | `/home/[user]` |
| **Permissions** | NTFS | Unix (chmod) |

---

## Rollback / Recovery

### If Something Goes Wrong:

**Option 1: Start Fresh**
```bash
cd ~
rm -rf deer-flow
# Re-transfer from Windows (Phase 2)
```

**Option 2: Reset Docker**
```bash
docker system prune -a
docker system df
```

**Option 3: Restore from Windows Backup**
- Copy `deer-flow.zip` from Windows backup
- On Linux: `unzip deer-flow.zip`
- Continue from Phase 4

---

## Success Checklist

- [ ] Project copied to Linux
- [ ] Docker installed and running
- [ ] Python 3.12+ installed
- [ ] Node.js + pnpm installed
- [ ] `make install` completed without errors
- [ ] `.env` and `config.yaml` files exist
- [ ] Dev environment starts: `make start` or `docker-compose up`
- [ ] Web interface accessible (localhost:3000 or :2026)
- [ ] Services stop cleanly: `make stop`
- [ ] All logs show no critical errors

---

## Support & Debugging

### Generate Debug Info
```bash
cd ~/deer-flow
echo "=== Docker Status ===" && docker ps -a
echo "=== System Info ===" && uname -a
echo "=== Disk Space ===" && df -h
echo "=== Memory ===" && free -h
echo "=== Python ===" && python3.12 --version
echo "=== Logs ===" && docker-compose -f docker/docker-compose-dev.yaml logs --tail 50
```

### Common Errors & Solutions
See **Phase 9: Troubleshooting** above.

---

**Document Version:** 1.0
**Created:** For DeerFlow migration
**Last Updated:** [Today]
