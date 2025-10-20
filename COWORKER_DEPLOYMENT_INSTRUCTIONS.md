# 🚀 TEP Demo - Deployment Instructions for Coworkers

**Quick setup guide - Get running in 10 minutes!**

---

## 📋 What You Need

### 1. Install Docker Desktop (5 minutes)

**Mac:**
- Download: https://docs.docker.com/desktop/setup/install/mac-install/
- Install the .dmg file
- Open Docker Desktop application

**Windows:**
- Download: https://docs.docker.com/desktop/setup/install/windows-install/
- Run the installer
- Restart your computer

**Verify it works:**
```bash
docker --version
docker-compose --version
```

### 2. Get API Keys (2 minutes)

You need API keys for the LLM services:

- **Claude API**: https://console.anthropic.com/ (Sign up → Get API key)
- **Gemini API**: https://aistudio.google.com/app/apikey (Sign in → Create API key)

Copy these keys - you'll need them in Step 4!

---

## 🎯 Deployment Steps

### Step 1: Get the Code

**Option A - If you have the GitHub link:**
```bash
git clone <repository-url>
cd TEP_demo
```

**Option B - If you received a zip file:**
```bash
# Extract the zip file
unzip TEP_demo_docker.zip
cd TEP_demo
```

### Step 2: Configure API Keys

```bash
# Copy the template file
cp .env.template .env

# Edit the .env file with your favorite text editor
nano .env
# or
code .env
# or
open -a TextEdit .env
```

**Add your API keys:**
```bash
ANTHROPIC_API_KEY=sk-ant-xxxxx  # Your Claude API key here
GEMINI_API_KEY=AIza-xxxxx       # Your Gemini API key here
```

Save and close the file.

### Step 3: Start Everything

```bash
# One command starts everything!
docker-compose up -d
```

This will:
- ✅ Download required Docker images (first time only - may take 5-10 minutes)
- ✅ Build the application containers
- ✅ Start all services (Backend, Frontend, Console)

### Step 4: Access the System

Open your browser and go to:

| Service | URL |
|---------|-----|
| **Main UI** | http://localhost:5173 |
| **Control Panel** | http://localhost:9002 |
| **API Docs** | http://localhost:8000/docs |

**You're done!** 🎉

---

## 🛠️ Daily Usage

### Start the system:
```bash
docker-compose up -d
```

### Stop the system:
```bash
docker-compose down
```

### View logs (if something doesn't work):
```bash
docker-compose logs -f
```

### Check what's running:
```bash
docker-compose ps
```

---

## 🐛 Troubleshooting

### Problem: "Port already in use"

**Solution:**
```bash
# Stop any existing containers
docker-compose down

# Check if anything is using the ports
lsof -i :5173  # Frontend
lsof -i :8000  # Backend
lsof -i :9002  # Console

# Kill processes if needed
kill -9 <PID>
```

### Problem: "Cannot connect to Docker daemon"

**Solution:**
1. Make sure Docker Desktop is running
2. Look for the Docker whale icon in your system tray
3. If not running, open Docker Desktop application

### Problem: "API key not working"

**Solution:**
1. Check `.env` file has the correct format (no spaces, no quotes)
2. Verify API keys are valid at the provider websites
3. Restart the containers: `docker-compose restart`

### Problem: "Build failed" or "Container won't start"

**Solution:**
```bash
# Clean rebuild everything
docker-compose down
docker-compose up -d --build --force-recreate
```

---

## 📚 More Help

- **Detailed Guide**: Read [DOCKER_QUICK_START.md](DOCKER_QUICK_START.md)
- **Architecture Info**: Read [DOCKER_DEPLOYMENT_SUMMARY.md](DOCKER_DEPLOYMENT_SUMMARY.md)
- **Test Script**: Run `./test-docker.sh` to verify your setup

---

## 💬 Need Help?

If you run into issues:

1. **Check logs**: `docker-compose logs -f backend`
2. **Verify containers are running**: `docker-compose ps`
3. **Contact the developer** with the error message

---

## 🎓 What's Happening Under the Hood?

When you run `docker-compose up -d`, Docker:

1. **Builds 3 containers:**
   - Backend (FastAPI + TEP Simulation + LLM + RAG)
   - Frontend (React UI with Nginx)
   - Console (Flask control panel)

2. **Creates a network** for containers to communicate

3. **Mounts data volumes** for persistent storage:
   - `./data/` - TEP simulation data
   - `./RCA_Results/` - Analysis results
   - `./backend/diagnostics/` - Logs

4. **Starts all services** in the background

---

## ✅ Quick Checklist

- [ ] Docker Desktop installed and running
- [ ] API keys obtained (Claude + Gemini)
- [ ] Code downloaded (git clone or unzip)
- [ ] `.env` file created with API keys
- [ ] `docker-compose up -d` executed successfully
- [ ] Can access http://localhost:5173 in browser

---

**Estimated Time:** 10-15 minutes (first time)
**Difficulty:** Easy ⭐
**Required Knowledge:** Basic terminal usage

**Questions?** Ask the developer who shared this with you! 🤝
