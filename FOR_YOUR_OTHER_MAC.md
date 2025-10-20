# 🎯 INSTRUCTIONS FOR YOUR OTHER MAC

**Everything is committed to GitHub. Here's what to do on your other Mac laptop.**

---

## ✅ **WHAT'S READY**

All Docker files are now on GitHub:
- ✅ 20 files committed
- ✅ Pushed to: https://github.com/chennanli/TEP_demo
- ✅ Ready to download as ZIP
- ✅ Complete documentation included

---

## 📥 **DOWNLOAD & SETUP (25 Minutes Total)**

### **Quick Version - Copy These Commands:**

```bash
# 1. Download ZIP from GitHub
# Go to: https://github.com/chennanli/TEP_demo
# Click green "Code" button → "Download ZIP"

# 2. Extract and move to Desktop
mv ~/Downloads/TEP_demo-main ~/Desktop/TEP_demo
cd ~/Desktop/TEP_demo

# 3. Configure API keys
cp .env.template .env
nano .env  # Add your API keys

# 4. Start Docker Desktop (if not running)
open -a Docker

# 5. Build and start everything
docker-compose up -d --build

# 6. Open in browser
open http://localhost:5173
```

**Done!** ✅

---

## 📋 **DETAILED STEP-BY-STEP**

### **Step 1: Download from GitHub** (2 minutes)

**Option A: Download ZIP (Recommended for you)**
1. Go to: https://github.com/chennanli/TEP_demo
2. Click green **"Code"** button
3. Click **"Download ZIP"**
4. Save to Downloads

**Option B: Git Clone (Alternative)**
```bash
git clone https://github.com/chennanli/TEP_demo.git
cd TEP_demo
```

---

### **Step 2: Extract and Navigate** (1 minute)

**If you downloaded ZIP:**
```bash
# Extract (double-click in Finder, or use command)
unzip ~/Downloads/TEP_demo-main.zip

# Move to Desktop
mv ~/Downloads/TEP_demo-main ~/Desktop/TEP_demo

# Navigate
cd ~/Desktop/TEP_demo
```

**If you used git clone:**
```bash
cd TEP_demo
```

---

### **Step 3: Configure API Keys** (3 minutes)

```bash
# Copy template
cp .env.template .env

# Edit with nano
nano .env
```

**Add your API keys:**
```
ANTHROPIC_API_KEY=sk-ant-xxxxx
GEMINI_API_KEY=AIza-xxxxx
```

**Save and exit:**
- Press `Ctrl+O` (save)
- Press `Enter` (confirm)
- Press `Ctrl+X` (exit)

**If you need API keys:**
- Claude: https://console.anthropic.com/
- Gemini: https://aistudio.google.com/app/apikey

---

### **Step 4: Verify Docker Desktop** (2 minutes)

**Check if Docker is installed:**
```bash
docker --version
```

**If installed:**
- You should see: `Docker version 24.0.0` or higher
- Make sure Docker Desktop is running (whale icon in menu bar)

**If NOT installed:**
```bash
# Install using Homebrew
brew install --cask docker

# Or download manually:
# https://docs.docker.com/desktop/setup/install/mac-install/
```

**Start Docker Desktop:**
```bash
open -a Docker
```

Wait for whale icon to appear in menu bar.

---

### **Step 5: Build and Start** (15 minutes)

```bash
# Build all containers and start
docker-compose up -d --build
```

**What happens:**
- Downloads base images (~2 min)
- Builds backend container (~5 min)
- Builds frontend container (~2 min)
- Builds console container (~1 min)
- Starts all services (~1 min)

**Expected output:**
```
[+] Building 180.5s (45/45) FINISHED
[+] Running 3/3
 ✔ Container tep-backend   Started
 ✔ Container tep-frontend  Started
 ✔ Container tep-console   Started
```

---

### **Step 6: Verify It Works** (2 minutes)

```bash
# Check container status
docker-compose ps
```

**Expected:**
```
NAME            STATUS          PORTS
tep-backend     Up 30 seconds   0.0.0.0:8000->8000/tcp
tep-frontend    Up 30 seconds   0.0.0.0:5173->80/tcp
tep-console     Up 30 seconds   0.0.0.0:9002->9002/tcp
```

**Open in browser:**
```bash
open http://localhost:5173
```

**Or manually visit:**
- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- Console: http://localhost:9002

---

## ✅ **VERIFICATION CHECKLIST**

- [ ] Downloaded ZIP from GitHub
- [ ] Extracted to Desktop
- [ ] Created .env file with API keys
- [ ] Docker Desktop is running
- [ ] Ran `docker-compose up -d --build`
- [ ] All 3 containers are running
- [ ] Frontend loads at http://localhost:5173
- [ ] TEP simulation is working
- [ ] LLM analysis works (if API keys configured)

---

## 🔄 **DAILY USAGE**

### **Start the system:**
```bash
cd ~/Desktop/TEP_demo
docker-compose up -d
```

### **Stop the system:**
```bash
docker-compose down
```

### **View logs:**
```bash
docker-compose logs -f
```

### **Restart:**
```bash
docker-compose restart
```

---

## 🆘 **TROUBLESHOOTING**

### **Problem: "docker: command not found"**
```bash
# Install Docker Desktop
brew install --cask docker
# Then open Docker Desktop app
```

### **Problem: "Cannot connect to Docker daemon"**
```bash
# Start Docker Desktop
open -a Docker
# Wait for whale icon in menu bar
```

### **Problem: "Port already in use"**
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9
```

### **Problem: "API keys not working"**
```bash
# Verify .env file
cat .env
# Restart services
docker-compose down && docker-compose up -d
```

### **Nuclear Option: Reset Everything**
```bash
docker-compose down -v
docker-compose up -d --build
```

---

## 📚 **DOCUMENTATION FILES**

**Quick Start:**
- `DOWNLOAD_FROM_GITHUB.md` - **This guide (detailed version)**
- `EXECUTE_NOW.md` - Copy-paste commands
- `START_HERE.md` - Complete step-by-step

**Reference:**
- `CHECKLIST.md` - Progress tracker
- `README_DOCKER.md` - Quick reference
- `DOCKER_QUICK_START.md` - Deployment guide

**Advanced:**
- `DOCKER_STRATEGY.md` - Architecture decisions
- `DOCKER_DEPLOYMENT_SUMMARY.md` - Technical details

---

## 🎯 **WHAT YOU GET**

### **3 Services Running:**
- **Backend** (Port 8000) - FastAPI + TEP simulation + LLM + RAG
- **Frontend** (Port 5173) - React interface
- **Console** (Port 9002) - Flask control panel

### **Data Persistence:**
All data persists across restarts:
- `./data/` - TEP simulation data
- `./RCA_Results/` - Analysis results
- `./backend/diagnostics/` - Diagnostics
- `./backend/LLM_RCA_Results/` - LLM results
- `./RAG/converted_markdown/` - Knowledge base

---

## 📊 **COMPARISON**

### **Old Way (Without Docker):**
- ❌ Install Python 3.12
- ❌ Create virtual environment
- ❌ Install pip dependencies
- ❌ Install Node.js
- ❌ Install npm dependencies
- ❌ Build frontend
- ❌ Configure paths
- ❌ Start backend manually
- ❌ Start frontend manually
- ❌ Start console manually
- ❌ **Total: 30-60 minutes**

### **New Way (With Docker):**
- ✅ Download ZIP
- ✅ Configure .env
- ✅ Run `docker-compose up -d --build`
- ✅ **Total: 25 minutes (mostly waiting for build)**

---

## 🎉 **SUCCESS!**

**When you see this, you're done:**

1. ✅ All 3 containers running
2. ✅ Frontend loads at http://localhost:5173
3. ✅ TEP simulation is running
4. ✅ Data updates in real-time
5. ✅ LLM analysis works

**No Python installation needed.**  
**No Node.js installation needed.**  
**No virtual environment needed.**  
**Just Docker.**

---

## 📞 **NEED HELP?**

**If something doesn't work:**

1. Check `docker-compose logs -f` for errors
2. Read `DOWNLOAD_FROM_GITHUB.md` (detailed guide)
3. Read `START_HERE.md` (complete guide)
4. Try the nuclear option: `docker-compose down -v && docker-compose up -d --build`

---

## 🚀 **FINAL COMMANDS SUMMARY**

**Copy-paste these in order:**

```bash
# 1. Navigate to extracted folder
cd ~/Desktop/TEP_demo

# 2. Configure API keys
cp .env.template .env
nano .env  # Add keys, Ctrl+O, Enter, Ctrl+X

# 3. Start Docker Desktop (if needed)
open -a Docker

# 4. Build and start
docker-compose up -d --build

# 5. Check status
docker-compose ps

# 6. Open browser
open http://localhost:5173
```

**That's it!** 🎉

---

**Good luck on your other Mac! 🚀**

