# 📥 Download from GitHub as ZIP - Quick Guide

**For deploying on your other Mac laptop**

---

## 🎯 **STEP-BY-STEP INSTRUCTIONS**

### **Step 1: Download ZIP from GitHub** (2 minutes)

1. **Go to GitHub repository:**
   ```
   https://github.com/chennanli/TEP_demo
   ```

2. **Click the green "Code" button**

3. **Click "Download ZIP"**

4. **Save to Downloads folder**

---

### **Step 2: Extract ZIP** (1 minute)

1. **Open Finder**

2. **Go to Downloads folder**

3. **Double-click** `TEP_demo-main.zip`

4. **Move extracted folder** to Desktop:
   ```bash
   mv ~/Downloads/TEP_demo-main ~/Desktop/TEP_demo
   ```

   Or just drag it to Desktop in Finder

---

### **Step 3: Open Terminal and Navigate** (1 minute)

```bash
cd ~/Desktop/TEP_demo
```

---

### **Step 4: Configure API Keys** (3 minutes)

```bash
# Copy template
cp .env.template .env

# Edit with your API keys
nano .env
```

**Add your API keys:**
```
ANTHROPIC_API_KEY=sk-ant-xxxxx
GEMINI_API_KEY=AIza-xxxxx
```

**Save and exit:**
- Press `Ctrl+O` to save
- Press `Enter` to confirm
- Press `Ctrl+X` to exit

**Get API keys if you don't have them:**
- Claude: https://console.anthropic.com/
- Gemini: https://aistudio.google.com/app/apikey

---

### **Step 5: Install Docker Desktop** (5 minutes)

**If you already have Docker Desktop:**
```bash
docker --version
```

If it shows a version, skip to Step 6.

**If you need to install:**

**Option 1: Using Homebrew (recommended)**
```bash
brew install --cask docker
```

**Option 2: Manual download**
1. Go to: https://docs.docker.com/desktop/setup/install/mac-install/
2. Download Docker.dmg
3. Drag Docker.app to Applications
4. Open Docker Desktop from Applications

**Wait for Docker to start:**
- Look for whale icon in menu bar
- Wait until it says "Docker Desktop is running"

---

### **Step 6: Start the System** (10 minutes)

```bash
# Build and start all containers
docker-compose up -d --build
```

**What happens:**
- Downloads base images (~2 minutes)
- Builds backend container (~5 minutes)
- Builds frontend container (~2 minutes)
- Builds console container (~1 minute)
- Starts all services

**Expected output:**
```
[+] Building 180.5s (45/45) FINISHED
[+] Running 3/3
 ✔ Container tep-backend   Started
 ✔ Container tep-frontend  Started
 ✔ Container tep-console   Started
```

---

### **Step 7: Verify Everything Works** (2 minutes)

```bash
# Check container status
docker-compose ps
```

**Expected output:**
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

**Or manually open:**
- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- Console: http://localhost:9002

---

### **Step 8: Test the System** (3 minutes)

1. **Frontend should load** - React interface visible
2. **TEP simulation should run** - Data updating
3. **Try LLM analysis** - If API keys configured
4. **Check data persistence** - Restart and verify data remains

---

## ✅ **COMPLETE COMMAND SUMMARY**

**Copy-paste these commands in order:**

```bash
# 1. Navigate to extracted folder
cd ~/Desktop/TEP_demo

# 2. Configure API keys
cp .env.template .env
nano .env  # Add your API keys, then Ctrl+O, Enter, Ctrl+X

# 3. Verify Docker is installed
docker --version

# 4. Start the system
docker-compose up -d --build

# 5. Check status
docker-compose ps

# 6. Open in browser
open http://localhost:5173
```

**Total time:** ~25 minutes

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

### **Restart the system:**
```bash
docker-compose restart
```

---

## 🆘 **TROUBLESHOOTING**

### **Problem: "docker: command not found"**

**Solution:**
```bash
# Install Docker Desktop
brew install --cask docker

# Or download manually from:
# https://docs.docker.com/desktop/setup/install/mac-install/
```

---

### **Problem: "Cannot connect to Docker daemon"**

**Solution:**
1. Open Docker Desktop app
2. Wait for whale icon in menu bar
3. Try again

---

### **Problem: "Port already in use"**

**Solution:**
```bash
# Kill process using port 8000
lsof -ti:8000 | xargs kill -9

# Or change port in docker-compose.yml
```

---

### **Problem: "API keys not working"**

**Solution:**
```bash
# Verify .env file
cat .env

# Make sure keys are correct
# Restart services
docker-compose down
docker-compose up -d
```

---

### **Problem: "Frontend not loading"**

**Solution:**
```bash
# Check logs
docker-compose logs frontend

# Rebuild frontend
docker-compose up -d --build frontend
```

---

### **Nuclear Option: Reset Everything**

```bash
# Stop and remove everything
docker-compose down -v

# Rebuild and start fresh
docker-compose up -d --build
```

---

## 📊 **WHAT YOU HAVE**

### **3 Docker Containers:**
- **Backend** (Port 8000) - FastAPI + TEP + LLM + RAG
- **Frontend** (Port 5173) - React + Nginx
- **Console** (Port 9002) - Flask control panel

### **Data Persistence:**
These folders persist across restarts:
- `./data/` - TEP simulation data
- `./RCA_Results/` - Analysis results
- `./backend/diagnostics/` - System diagnostics
- `./backend/LLM_RCA_Results/` - LLM analysis
- `./RAG/converted_markdown/` - Knowledge base

---

## 📚 **DOCUMENTATION**

**Quick guides:**
- `EXECUTE_NOW.md` - Copy-paste commands
- `START_HERE.md` - Detailed step-by-step
- `CHECKLIST.md` - Progress tracker

**Detailed docs:**
- `DOCKER_QUICK_START.md` - Deployment guide
- `DOCKER_STRATEGY.md` - Architecture decisions
- `README_DOCKER.md` - Quick reference

---

## ✅ **CHECKLIST**

**Before Starting:**
- [ ] Downloaded ZIP from GitHub
- [ ] Extracted to Desktop
- [ ] Opened Terminal
- [ ] Navigated to TEP_demo folder

**Setup:**
- [ ] Created .env file
- [ ] Added API keys
- [ ] Docker Desktop installed
- [ ] Docker is running

**Deployment:**
- [ ] Ran `docker-compose up -d --build`
- [ ] All containers started
- [ ] Checked `docker-compose ps`

**Verification:**
- [ ] Frontend accessible (http://localhost:5173)
- [ ] Backend accessible (http://localhost:8000)
- [ ] Console accessible (http://localhost:9002)
- [ ] TEP simulation works
- [ ] LLM analysis works

---

## 🎉 **YOU'RE DONE!**

**Your system is now running!**

**Access points:**
- **Frontend**: http://localhost:5173
- **Backend**: http://localhost:8000
- **Console**: http://localhost:9002

**Daily commands:**
```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# Logs
docker-compose logs -f
```

---

## 📞 **NEED HELP?**

**Check these files:**
1. `START_HERE.md` - Main guide
2. `EXECUTE_NOW.md` - Quick commands
3. `CHECKLIST.md` - Progress tracker
4. `docker-compose logs -f` - Error logs

---

## 🚀 **NEXT STEPS**

**After successful deployment:**
1. ✅ Test all features
2. ✅ Verify data persistence
3. ✅ Try LLM analysis
4. ✅ Explore the system

**If you want to update:**
1. Download new ZIP from GitHub
2. Extract and replace old folder
3. Run `docker-compose up -d --build`

---

**Good luck! 🎉**

