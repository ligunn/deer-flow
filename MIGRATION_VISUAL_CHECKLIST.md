# DeerFlow Windows→Linux Migration: Visual Step-by-Step

Complete visual checklist with expected screenshots/outputs at each stage.

---

## STAGE 1: WINDOWS - PRE-FLIGHT CHECK (30 min)

### ✓ Step 1.1: Open File Explorer
**Action:** Press `Win + E`

**Expected:** File Explorer opens to your current directory

**Next:** Navigate to `C:\Users\liamg\deer-flow`

**Expected State:**
```
Address Bar: C:\Users\liamg\deer-flow
Folders visible: .github, backend, frontend, docker, scripts, docs, skills, logs
Files visible: Makefile, README.md, config.yaml, .env, docker-compose.yml
```

---

### ✓ Step 1.2: Open Terminal
**Action:** Press `Win + X` → Select "Windows Terminal (Admin)"

**Expected:** PowerShell terminal opens with blue background

**Visible in terminal:**
```
PS C:\Users\[username]\...
```

---

### ✓ Step 1.3: Navigate to Project
**Action:** Type: `cd C:\Users\liamg\deer-flow`

**Press:** Enter

**Expected Output:**
```
PS C:\Users\liamg\deer-flow>
```

---

### ✓ Step 1.4: Check Git Status
**Action:** Type: `git status`

**Press:** Enter

**Expected Output:**
```
On branch [branch-name]
nothing to commit, working tree clean
```

**❌ If you see uncommitted changes:**
```
Type: git add .
Press: Enter
Type: git commit -m "Windows pre-migration checkpoint"
Press: Enter
```

---

### ✓ Step 1.5: Verify Docker Desktop Running
**Action:** Look at system tray (bottom-right of screen)

**Expected:** Whale icon 🐋 visible

**Action:** Click the whale icon

**Expected Popup:**
```
Docker Desktop is running
[Preference button] [Quit Docker Desktop button]
```

**❌ If it says "starting" or not visible:**
- Press `Win`, type `Docker`, press Enter
- Wait 30 seconds for it to start

---

### ✓ Step 1.6: Stop Services Gracefully
**Action:** Type: `make clean`

**Press:** Enter

**Expected Output (takes 20-30 seconds):**
```
Stopping all services...
✓ All services stopped
Cleaning up...
✓ Cleanup complete
```

---

### ✓ Step 1.7: Create Backup
**Action:** In File Explorer (from Step 1.1), right-click on `deer-flow` folder

**Select:** "Send to" → "Compressed (zipped) folder"

**Expected:** Zip icon appears, shows progress bar

**Wait:** 2-3 minutes for compression

**Expected Result:** New file `deer-flow.zip` appears in `C:\Users\liamg\`

**Size:** Should be 200MB-500MB depending on node_modules

---

### ✓ Step 1.8: Verify Project Ready
**Action:** Type: `dir`

**Press:** Enter

**Expected Output shows:**
```
Mode   LastWriteTime         Length  Name
----   ---------------         ------  ----
d----   [date/time]                    .github
d----   [date/time]                    backend
d----   [date/time]                    frontend
d----   [date/time]                    docker
...
-a---   [date/time]      [size]  .env
-a---   [date/time]      [size]  config.yaml
-a---   [date/time]      [size]  Makefile
```

**Status:** ✅ Windows side is ready

---

## STAGE 2: TRANSFER TO LINUX (5 min - 1 hour depending on method)

### Choose ONE transfer method:

---

## METHOD A: Git Clone (Recommended - 5-10 min if repo is online)

### ✓ Step 2A.1: Open Linux Terminal
**Action:** On Linux machine, press `Ctrl + Alt + T`

**Expected:** Dark terminal window opens

**Visible:**
```
username@hostname:~$
```

---

### ✓ Step 2A.2: Navigate to Home
**Action:** Type: `cd ~`

**Press:** Enter

**Expected:**
```
username@hostname:~$
```

---

### ✓ Step 2A.3: Clone Repository
**Action:** Type: `git clone [your-repository-url] deer-flow`

Replace `[your-repository-url]` with actual URL. Example:
```
git clone https://github.com/liamg/deer-flow.git deer-flow
```

**Press:** Enter

**Expected Output (takes 1-3 minutes):**
```
Cloning into 'deer-flow'...
remote: Counting objects: 1234, done.
remote: Receiving objects: 100% (1234/1234), done.
Receiving objects: 100% (5678/5678), 45.3 MiB | 2.5 MiB/s
Resolving deltas: 100% (2345/2345), done.
```

---

### ✓ Step 2A.4: Verify Clone
**Action:** Type: `cd deer-flow && ls -la`

**Press:** Enter

**Expected Output:**
```
total 234
drwxr-xr-x  13 user user  4096 Dec 20 14:22 .
drwxr-xr-x   5 user user  4096 Dec 20 14:22 ..
-rw-r--r--   1 user user  1234 Dec 20 14:22 .env
-rw-r--r--   1 user user  5678 Dec 20 14:22 config.yaml
drwxr-xr-x   3 user user  4096 Dec 20 14:22 backend
drwxr-xr-x   3 user user  4096 Dec 20 14:22 frontend
drwxr-xr-x   2 user user  4096 Dec 20 14:22 docker
drwxr-xr-x   2 user user  4096 Dec 20 14:22 scripts
```

**Status:** ✅ Project transferred

---

## METHOD B: SCP (If using SSH - 10-30 min depending on size)

### ✓ Step 2B.1: Open Windows Terminal (as Admin)
**Action:** Press `Win + X` → "Windows Terminal (Admin)"

---

### ✓ Step 2B.2: Run SCP Command
**Action:** Type:
```
scp -r C:\Users\liamg\deer-flow pi@192.168.1.100:/home/pi/
```

Replace:
- `pi` = your Linux username
- `192.168.1.100` = your Linux machine's IP

**Press:** Enter

**Prompt:** "Are you sure you want to continue connecting?"

**Action:** Type: `yes`

**Press:** Enter

**If prompted for password:** Type your Linux user's password

**Press:** Enter

**Expected (takes 10-30 minutes):**
```
Sending file modes...
... (many files) ...
100%  [===============>] 345 MB  2.5 MB/s  00:02:20
```

**When done:** Back to PowerShell prompt

---

### ✓ Step 2B.3: Verify on Linux
**Action:** Open Linux terminal

**Type:** `cd /home/pi/deer-flow && ls -la`

**Press:** Enter

**Expected:** Same as Step 2A.4 above

---

## STAGE 3: LINUX - SYSTEM SETUP (20-30 min)

### ✓ Step 3.1: Update Package Manager
**Location:** Linux terminal, in `~/deer-flow` directory

**Action:** Type: `sudo apt update`

**Press:** Enter

**Prompt:** (if first time as sudo) "Enter password:"

**Action:** Type your Linux password

**Press:** Enter

**Expected Output (takes 30-60 seconds):**
```
Get:1 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [119 kB]
...
Reading package lists... Done
Building dependency tree... Done
```

---

### ✓ Step 3.2: Upgrade System
**Action:** Type: `sudo apt upgrade -y`

**Press:** Enter

**Expected Output (takes 5-10 minutes):**
```
Reading package lists... Done
Building dependency tree... Done
...
Processing triggers for man-db (2.10.2-1) ...
Processing triggers for fontconfig (2.13.1-4.2ubuntu5) ...
```

**When done:** Returns to prompt

---

### ✓ Step 3.3: Install Docker
**Action:** Type: `sudo apt install -y docker.io docker-compose`

**Press:** Enter

**Expected Output (takes 3-5 minutes):**
```
Reading package lists... Done
Building dependency tree... Done
...
Processing triggers for systemd (249.11-0ubuntu3.6) ...
Processing triggers for man-db (2.10.2-1) ...
```

---

### ✓ Step 3.4: Add User to Docker Group
**Action:** Type: `sudo usermod -aG docker $(whoami)`

**Press:** Enter

**No output expected** (returns to prompt)

---

### ✓ Step 3.5: Activate Docker Group
**Action:** Type: `newgrp docker`

**Press:** Enter

**Expected:** Prompt may change slightly

---

### ✓ Step 3.6: Verify Docker
**Action:** Type: `docker --version`

**Press:** Enter

**Expected Output:**
```
Docker version 24.0.7, build afdd53b
```

---

### ✓ Step 3.7: Install Python 3.12
**Action:** Type: `sudo apt install -y python3.12 python3.12-venv python3-pip`

**Press:** Enter

**Expected Output (takes 3-5 minutes):**
```
Setting up python3.12 (3.12.1-1~22.04) ...
...
Processing triggers for man-db (2.10.2-1) ...
```

---

### ✓ Step 3.8: Install UV Package Manager
**Action:** Type: `curl -LsSf https://astral.sh/uv/install.sh | sh`

**Press:** Enter

**Expected Output (takes 30-60 seconds):**
```
installing uv...
Downloading uv...
Installing uv...
Installed binary to /root/.cargo/bin/uv
```

---

### ✓ Step 3.9: Activate UV in Path
**Action:** Type: `source $HOME/.cargo/env`

**Press:** Enter

**No output expected**

---

### ✓ Step 3.10: Install Node.js
**Action:** Type: `sudo apt install -y nodejs npm`

**Press:** Enter

**Expected Output (takes 2-3 minutes):**
```
Setting up nodejs (18.19.0-1nodesource1~22.04.1) ...
Setting up npm (10.2.4~ds-1) ...
```

---

### ✓ Step 3.11: Install pnpm
**Action:** Type: `npm install -g pnpm`

**Press:** Enter

**Expected Output:**
```
added 1 package in 5s
```

---

### ✓ Step 3.12: Verify All Installations
**Action:** Type (one by one):

```
python3.12 --version
```
**Expected:** `Python 3.12.1`

```
uv --version
```
**Expected:** `uv 0.4.x`

```
node --version
```
**Expected:** `v20.10.x`

```
pnpm --version
```
**Expected:** `10.2.x`

```
docker --version
```
**Expected:** `Docker version 24.x.x`

**Status:** ✅ All tools installed

---

## STAGE 4: DEERFLOW CONFIGURATION (15 min)

### ✓ Step 4.1: Navigate to Project
**Action:** Type: `cd ~/deer-flow`

**Press:** Enter

**Expected:**
```
username@hostname:~/deer-flow$
```

---

### ✓ Step 4.2: Copy Environment Template
**Action:** Type: `cp .env.example .env`

**Press:** Enter

**No output expected** (returns to prompt)

---

### ✓ Step 4.3: Copy Config Template
**Action:** Type: `cp config.example.yaml config.yaml`

**Press:** Enter

**No output expected**

---

### ✓ Step 4.4: Make Scripts Executable
**Action:** Type: `chmod +x scripts/*.sh`

**Press:** Enter

---

### ✓ Step 4.5: Verify Files Exist
**Action:** Type: `ls -la | grep -E "\.env|config\.yaml|Makefile"`

**Press:** Enter

**Expected Output:**
```
-rw-r--r--  1 user user    234 Dec 20 14:30 .env
-rw-r--r--  1 user user   5678 Dec 20 14:30 config.yaml
-rw-r--r--  1 user user   9012 Dec 20 14:30 Makefile
```

**Status:** ✅ Configuration ready

---

## STAGE 5: DEPENDENCY INSTALLATION (30-60 min)

### ✓ Step 5.1: Start Installation
**Location:** `~/deer-flow` directory

**Action:** Type: `make install`

**Press:** Enter

**Expected Output (LONG - takes 30-60 minutes):**

**Phase 1 - Python (5-10 min):**
```
Installing backend dependencies...
Resolved 47 packages in [time]
Downloaded 47 packages in [time]
Installed 47 packages in [time]
```

**Phase 2 - Node.js (10-15 min):**
```
Installing frontend dependencies...
Resolving dependencies...
Progress: [====================] 200/200
```

**Final Output:**
```
✓ All dependencies installed

==========================================
  Optional: Pre-pull Sandbox Image
==========================================

If you plan to use Docker/Container-based sandbox, you can pre-pull the image:
  make setup-sandbox
```

**Time to complete:** 30-60 minutes depending on internet speed

**Status:** ✅ Dependencies installed

---

## STAGE 6: VERIFICATION (5-10 min)

### ✓ Step 6.1: Check Backend
**Action:** Type: `cd backend && ls -la .venv/`

**Press:** Enter

**Expected Output:**
```
total 32
drwxr-xr-x  7 user user 4096 Dec 20 15:45 .venv
-rw-r--r--  1 user user  184 Dec 20 15:45 .venv/pyvenv.cfg
drwxr-xr-x  2 user user 4096 Dec 20 15:45 .venv/bin
drwxr-xr-x  2 user user 4096 Dec 20 15:45 .venv/lib
```

---

### ✓ Step 6.2: Check Frontend
**Action:** Type: `cd ../frontend && ls -la node_modules/ | head -20`

**Press:** Enter

**Expected Output (first 20 lines):**
```
total 456
drwxr-xr-x  200 user user 12288 Dec 20 15:50 .
drwxr-xr-x   15 user user  4096 Dec 20 15:50 ..
drwxr-xr-x    4 user user  4096 Dec 20 15:50 .bin
drwxr-xr-x    3 user user  4096 Dec 20 15:50 @codemirror
drwxr-xr-x    3 user user  4096 Dec 20 15:50 @langchain
...
```

**Status:** ✅ Everything installed

---

## STAGE 7: TESTING - LOCAL DEVELOPMENT (20 min)

### ✓ Step 7.1: Return to Project Root
**Action:** Type: `cd ~/deer-flow`

**Press:** Enter

---

### ✓ Step 7.2: Start Services (Local)
**Action:** Type: `make start`

**Press:** Enter

**Expected Output (over 10-15 seconds):**
```
DeerFlow Development Environment
Starting services...

2024-12-20 15:52:34 - Starting LangGraph development server...
2024-12-20 15:52:40 - [INFO] uvicorn server started on 0.0.0.0:8001
2024-12-20 15:52:45 - [INFO] next dev server ready on 0.0.0.0:3000

✓ All services started
```

---

### ✓ Step 7.3: Open Another Terminal Tab
**Action:** Press `Ctrl + Shift + T`

**Expected:** New terminal tab opens

---

### ✓ Step 7.4: Check Running Processes
**Location:** New terminal tab

**Action:** Type: `ps aux | grep -E "langgraph|uvicorn|next" | grep -v grep`

**Press:** Enter

**Expected Output:**
```
user     12345  2.5  1.2 234567 98765 ?  Sl   15:52   0:05 python3.12 -m langgraph dev...
user     12346  3.1  1.5 245678 112345 ?  Sl   15:52   0:07 /usr/bin/python3.12 -m uvicorn...
user     12347  4.2  2.1 356789 156789 ?  Sl   15:52   0:12 node .next/standalone/server.js...
```

**Status:** ✅ Services running

---

### ✓ Step 7.5: Test Web Interface
**Action:** Open web browser (Firefox, Chrome, etc.)

**Navigate to:**
- **Same machine:** `http://localhost:3000`
- **Raspberry Pi (remote):** `http://192.168.1.100:3000` (replace IP)

**Expected:** DeerFlow web interface loads

**Visual:** You should see:
- Header with "DeerFlow" logo
- Chat interface
- Model selector dropdown
- Settings panel

---

### ✓ Step 7.6: Stop Services
**Location:** Terminal 1 (where `make start` is running)

**Action:** Press `Ctrl + C`

**Expected Output:**
```
Shutting down services...
✓ All services stopped
```

---

### ✓ Step 7.7: Verify Services Stopped
**Location:** Terminal 2

**Action:** Type: `ps aux | grep -E "langgraph|uvicorn|next" | grep -v grep`

**Press:** Enter

**Expected:** No output (processes are gone)

**Status:** ✅ Local dev test passed

---

## STAGE 8: TESTING - DOCKER DEVELOPMENT (15 min)

### ✓ Step 8.1: Navigate to Docker Directory
**Action:** Type: `cd ~/deer-flow/docker`

**Press:** Enter

---

### ✓ Step 8.2: Start Docker Services
**Action:** Type: `docker-compose -f docker-compose-dev.yaml up --build`

**Press:** Enter

**Expected Output (LONG - 3-5 minutes to build and start):**

**Building phase:**
```
Building gateway
...
Step 1/15 : FROM python:3.12-slim
 ---> [image-id]
Step 2/15 : WORKDIR /app
 ---> Running in [container-id]
...
Successfully built [image-id]
Successfully tagged deer-flow-gateway:latest
```

**Starting phase:**
```
Creating deer-flow-nginx   ... done
Creating deer-flow-frontend ... done
Creating deer-flow-gateway  ... done
Creating deer-flow-langgraph ... done

deer-flow-nginx   | nginx: [notice] signal process started
deer-flow-frontend | 2024-12-20T15:58:34.123Z ready - started server on 0.0.0.0:3000
deer-flow-gateway  | Uvicorn running on http://0.0.0.0:8001 (Press CTRL+C to quit)
deer-flow-langgraph | Uvicorn running on http://0.0.0.0:2024 (Press CTRL+C to quit)
```

---

### ✓ Step 8.3: Open New Terminal Tab (for browser testing)
**Action:** Press `Ctrl + Shift + T`

**Expected:** New tab opens

---

### ✓ Step 8.4: Test Docker Web Interface
**Action:** Open browser

**Navigate to:**
- **Same machine:** `http://localhost:2026`
- **Raspberry Pi:** `http://192.168.1.100:2026`

**Expected:** DeerFlow interface loads (through nginx)

**Note:** May take 10 seconds longer than local mode (goes through nginx reverse proxy)

---

### ✓ Step 8.5: View Logs (Optional)
**Location:** New terminal tab

**Action:** Type: `cd ~/deer-flow/docker && docker-compose -f docker-compose-dev.yaml logs -f frontend`

**Press:** Enter

**Expected Output (streaming real-time logs):**
```
deer-flow-frontend  | 2024-12-20T15:58:34.123Z [INFO] GET /api/models - 200 (234ms)
deer-flow-frontend  | 2024-12-20T15:58:35.456Z [INFO] POST /api/chat - 200 (567ms)
...
```

**To exit log view:** Press `Ctrl + C`

---

### ✓ Step 8.6: Stop Docker Services
**Location:** Terminal 1 (where docker-compose is running)

**Action:** Press `Ctrl + C`

**Expected Output:**
```
^C
Aborting on container exit.
Removing deer-flow-langgraph ... done
Removing deer-flow-gateway   ... done
Removing deer-flow-frontend  ... done
Removing deer-flow-nginx     ... done

Removed 4 containers
```

---

### ✓ Step 8.7: Verify Containers Stopped
**Location:** Terminal 2

**Action:** Type: `docker ps -a`

**Press:** Enter

**Expected Output:**
```
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
(empty - no containers)
```

---

### ✓ Step 8.8: Final Cleanup
**Action:** Type: `docker-compose -f docker-compose-dev.yaml down`

**Press:** Enter

**Expected Output:**
```
Removing network docker_deer-flow-dev
```

**Status:** ✅ Docker dev test passed

---

## FINAL STATUS CHECK

### ✓ Completion Verification
Run this command:
```bash
cd ~/deer-flow
echo "✓ Git clean: $(git status --porcelain | wc -l) changes"
echo "✓ Backend ready: $(test -d backend/.venv && echo 'YES' || echo 'NO')"
echo "✓ Frontend ready: $(test -d frontend/node_modules && echo 'YES' || echo 'NO')"
echo "✓ Docker ready: $(docker ps -a | wc -l) containers available"
echo "✓ Config files: $(test -f .env && test -f config.yaml && echo 'YES' || echo 'NO')"
```

**Expected Output:**
```
✓ Git clean: 0 changes
✓ Backend ready: YES
✓ Frontend ready: YES
✓ Docker ready: 0 containers available
✓ Config files: YES
```

---

## SUCCESS! 🎉

Your DeerFlow project is now fully migrated and running on Linux.

**Next Steps:**
1. Configure API keys in `.env` (Tavily, Jina, etc.)
2. Customize `config.yaml` for your use case
3. Read `LINUX_QUICK_REFERENCE.md` for daily workflow

**Bookmark these for future reference:**
- `WINDOWS_TO_LINUX_MIGRATION.md` - Full detailed guide
- `LINUX_QUICK_REFERENCE.md` - Quick commands
- Project root: `~/deer-flow`
