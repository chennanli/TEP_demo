# 🚀 TEP Demo - Docker Deployment Guide

**EVERYTHING IS READY! Follow these steps exactly.**

---

## ✅ **WHAT'S ALREADY DONE FOR YOU**

All Docker files have been created:
- ✅ `docker-compose.yml` - Production setup
- ✅ `docker-compose.dev.yml` - Development setup
- ✅ `Dockerfile.backend` - Backend container
- ✅ `Dockerfile.console` - Console container
- ✅ `frontend/Dockerfile` - Frontend container
- ✅ `frontend/Dockerfile.dev` - Frontend dev container
- ✅ `frontend/nginx.conf` - Web server config
- ✅ `.dockerignore` - Build optimization
- ✅ `test-docker.sh` - Automated testing
- ✅ Complete documentation (4 guides)

**You don't need to create anything. Just follow the steps below.**

---

## 📋 **STEP-BY-STEP INSTRUCTIONS**

### **PART 1: FOR YOU (Local Testing) - 15 Minutes**

#### **Step 1: Install Docker Desktop** (5 minutes)

**Mac (your machine):**
```bash
# Option 1: Using Homebrew (recommended)
brew install --cask docker

# Option 2: Manual download
# Go to: https://docs.docker.com/desktop/setup/install/mac-install/
# Download and install Docker.dmg
```

**After installation:**
1. Open Docker Desktop app
2. Wait for it to start (whale icon in menu bar)
3. Verify installation:
```bash
docker --version
docker-compose --version
```

Expected output:
```
Docker version 24.0.0 or higher
Docker Compose version 2.20.0 or higher
```

---

#### **Step 2: Verify Your .env File** (1 minute)

Your `.env` file already exists. Just verify it has your API keys:

```bash
cat .env
```

Should show:
```
ANTHROPIC_API_KEY=sk-ant-xxxxx
GEMINI_API_KEY=AIza-xxxxx
```

If missing, copy from template:
```bash
cp .env.template .env
nano .env  # Add your API keys
```

---

#### **Step 3: Test Docker Setup** (2 minutes)

Run the automated test:
```bash
./test-docker.sh
```

**What it checks:**
- ✅ Docker is installed
- ✅ Docker daemon is running
- ✅ All required files exist
- ✅ .env file is configured

**If test fails:** Read the error message and fix the issue before continuing.

---

#### **Step 4: Build Docker Images** (5 minutes)

This builds all containers (only needed once):

```bash
docker-compose build
```

**What happens:**
- Builds backend container (~3 minutes)
- Builds frontend container (~1 minute)
- Builds console container (~1 minute)

**Expected output:**
```
[+] Building 180.5s (45/45) FINISHED
 => [backend] ...
 => [frontend] ...
 => [console] ...
```

---

#### **Step 5: Start All Services** (1 minute)

```bash
docker-compose up -d
```

**What happens:**
- Starts backend container (Port 8000)
- Starts frontend container (Port 5173)
- Starts console container (Port 9002)

**Expected output:**
```
[+] Running 3/3
 ✔ Container tep-backend   Started
 ✔ Container tep-frontend  Started
 ✔ Container tep-console   Started
```

---

#### **Step 6: Verify Everything Works** (1 minute)

Check container status:
```bash
docker-compose ps
```

Expected output:
```
NAME            STATUS          PORTS
tep-backend     Up 30 seconds   0.0.0.0:8000->8000/tcp
tep-frontend    Up 30 seconds   0.0.0.0:5173->80/tcp
tep-console     Up 30 seconds   0.0.0.0:9002->9002/tcp
```

Test endpoints:
```bash
# Backend API
curl http://localhost:8000/

# Frontend
curl http://localhost:5173/

# Console
curl http://localhost:9002/
```

Open in browser:
```bash
open http://localhost:5173  # Frontend
open http://localhost:8000  # Backend API docs
open http://localhost:9002  # Console
```

---

#### **Step 7: View Logs (Optional)** (1 minute)

See what's happening:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f unified-console
```

Press `Ctrl+C` to stop viewing logs.

---

### **PART 2: FOR YOUR COWORKER (Deployment) - 30 Minutes**

#### **What to Send Your Coworker:**

1. **GitHub Repository Link**
   ```
   https://github.com/chennanli/TEP_demo
   ```

2. **This File**
   - Send them `START_HERE.md` (this file)

3. **API Keys** (if sharing)
   - Your `ANTHROPIC_API_KEY`
   - Your `GEMINI_API_KEY`
   - Or tell them to get their own (links below)

---

#### **Coworker's Steps:**

**Step 1: Install Docker Desktop** (10 minutes)

**Mac:**
```bash
brew install --cask docker
# Or download: https://docs.docker.com/desktop/setup/install/mac-install/
```

**Windows:**
```bash
# Download: https://docs.docker.com/desktop/setup/install/windows-install/
# Requires WSL2 (Windows Subsystem for Linux)
```

**Linux:**
```bash
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo systemctl start docker
sudo usermod -aG docker $USER  # Add user to docker group
# Log out and log back in
```

---

**Step 2: Clone Repository** (2 minutes)

```bash
git clone https://github.com/chennanli/TEP_demo.git
cd TEP_demo
```

---

**Step 3: Configure API Keys** (3 minutes)

```bash
# Copy template
cp .env.template .env

# Edit with your keys
nano .env
```

Add API keys:
```
ANTHROPIC_API_KEY=sk-ant-xxxxx
GEMINI_API_KEY=AIza-xxxxx
```

**Get API keys:**
- Claude: https://console.anthropic.com/
- Gemini: https://aistudio.google.com/app/apikey

---

**Step 4: Start System** (10 minutes)

```bash
# Build and start (first time only)
docker-compose up -d --build

# Or just start (if already built)
docker-compose up -d
```

Wait for containers to start (~2 minutes).

---

**Step 5: Access System** (1 minute)

Open in browser:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **Console**: http://localhost:9002

---

**Step 6: Verify It Works** (2 minutes)

1. Open frontend: http://localhost:5173
2. Check if TEP simulation is running
3. Try LLM analysis (if API keys configured)
4. Check data persistence

---

### **PART 3: COMMON COMMANDS**

#### **Daily Usage**

```bash
# Start system
docker-compose up -d

# Stop system
docker-compose down

# Restart system
docker-compose restart

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

---

#### **Development Mode (Hot Reload)**

```bash
# Start in development mode
docker-compose -f docker-compose.dev.yml up

# Changes auto-reload:
# - backend/*.py files
# - frontend/src/* files
# - templates/*.html files
```

---

#### **Troubleshooting**

```bash
# Rebuild everything
docker-compose down
docker-compose up -d --build

# Remove all containers and volumes
docker-compose down -v

# View specific service logs
docker-compose logs -f backend

# Access container shell
docker-compose exec backend bash
docker-compose exec frontend sh

# Check Docker status
docker info
docker-compose ps
```

---

#### **Updating Code**

```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

---

### **PART 4: TROUBLESHOOTING**

#### **Problem 1: Port Already in Use**

**Error:**
```
Error: bind: address already in use
```

**Solution:**
```bash
# Find process using port 8000
lsof -ti:8000 | xargs kill -9

# Or change port in docker-compose.yml
ports:
  - "8001:8000"  # Use 8001 instead
```

---

#### **Problem 2: Docker Daemon Not Running**

**Error:**
```
Cannot connect to the Docker daemon
```

**Solution:**
1. Open Docker Desktop app
2. Wait for it to start
3. Try again

---

#### **Problem 3: API Keys Not Working**

**Error:**
```
AuthenticationError: Invalid API key
```

**Solution:**
```bash
# Verify .env file
cat .env

# Restart services
docker-compose down
docker-compose up -d
```

---

#### **Problem 4: Frontend Not Loading**

**Error:**
```
Cannot GET /
```

**Solution:**
```bash
# Check frontend logs
docker-compose logs frontend

# Rebuild frontend
docker-compose up -d --build frontend
```

---

#### **Problem 5: Fortran Module Not Found**

**Error:**
```
ModuleNotFoundError: No module named 'temain_mod'
```

**Solution:**
```bash
# Check if .so files exist
docker-compose exec backend ls -la /app/backend/simulation/

# Rebuild backend
docker-compose up -d --build backend
```

---

### **PART 5: WHAT TO DO NEXT**

#### **After Successful Deployment:**

1. ✅ **Test all features**
   - TEP simulation
   - Anomaly detection
   - LLM analysis
   - Data persistence

2. ✅ **Gather feedback**
   - What works well?
   - What's confusing?
   - Any errors?

3. ✅ **Iterate**
   - Fix issues
   - Improve documentation
   - Optimize performance

---

#### **Future Improvements (Optional):**

1. **Add CI/CD** (Week 2-3)
   - GitHub Actions for automated builds
   - Auto-deploy on push

2. **Add Monitoring** (Week 3-4)
   - Prometheus for metrics
   - Grafana for dashboards

3. **Microservices Refactoring** (Month 2+)
   - Extract TEP simulator
   - Extract LLM service
   - Extract RAG service

---

### **PART 6: QUICK REFERENCE**

#### **File Structure**

```
TEP_demo/
├── docker-compose.yml          # Production setup
├── docker-compose.dev.yml      # Development setup
├── Dockerfile.backend          # Backend container
├── Dockerfile.console          # Console container
├── .dockerignore               # Build optimization
├── .env                        # API keys (DO NOT COMMIT)
├── .env.template               # API key template
├── test-docker.sh              # Automated testing
│
├── frontend/
│   ├── Dockerfile              # Frontend production
│   ├── Dockerfile.dev          # Frontend development
│   └── nginx.conf              # Web server config
│
├── backend/                    # Backend code
├── templates/                  # Flask templates
├── static/                     # Static files
├── data/                       # TEP data (persistent)
├── RCA_Results/                # Analysis results (persistent)
└── RAG/                        # Knowledge base
```

---

#### **Port Mapping**

| Service | Port | URL |
|---------|------|-----|
| Frontend | 5173 | http://localhost:5173 |
| Backend | 8000 | http://localhost:8000 |
| Console | 9002 | http://localhost:9002 |

---

#### **Data Persistence**

These directories persist across container restarts:
- `./data/` - TEP simulation CSV files
- `./RCA_Results/` - Root cause analysis reports
- `./backend/diagnostics/` - System diagnostics
- `./backend/LLM_RCA_Results/` - LLM analysis results
- `./RAG/converted_markdown/` - Knowledge base

---

### **PART 7: SUMMARY CHECKLIST**

#### **For You (Local Testing):**
- [ ] Install Docker Desktop
- [ ] Verify .env file has API keys
- [ ] Run `./test-docker.sh`
- [ ] Run `docker-compose build`
- [ ] Run `docker-compose up -d`
- [ ] Open http://localhost:5173
- [ ] Verify everything works
- [ ] Test TEP simulation
- [ ] Test LLM analysis

#### **For Your Coworker:**
- [ ] Send GitHub repository link
- [ ] Send this file (`START_HERE.md`)
- [ ] Send API keys (or tell them to get their own)
- [ ] Be available for questions
- [ ] Help troubleshoot if needed

---

## 🎉 **YOU'RE DONE!**

Everything is ready. Just follow the steps above.

**Questions?** Check the troubleshooting section or ask for help.

**Need more details?** See these files:
- `DOCKER_QUICK_START.md` - Detailed deployment guide
- `DOCKER_STRATEGY.md` - Architecture and learning path
- `DOCKER_DEPLOYMENT_SUMMARY.md` - Technical overview
- `README_DOCKER.md` - Quick reference

---

**Good luck! 🚀**

