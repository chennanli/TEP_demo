# 🎛️ TEP RCA System

**Tennessee Eastman Process (TEP) Root Cause Analysis with Multi-LLM Support**

A unified control system for TEP simulation, real-time anomaly detection, and AI-powered fault diagnosis using multiple Large Language Models (Claude, Gemini, LMStudio).

---

## 🚀 Quick Start

### **First Time Setup**

#### **Step 1: Clone the Repository**

```bash
git clone https://github.com/chennanli/TEP_demo.git
cd TEP_demo
```

#### **Step 2: Configure API Keys**

```bash
# Copy the template
cp .env.template .env

# Edit .env and add your API keys
# ANTHROPIC_API_KEY=sk-ant-xxxxx
# GEMINI_API_KEY=AIza-xxxxx
```

Get your API keys:
- **Claude**: https://console.anthropic.com/
- **Gemini**: https://aistudio.google.com/app/apikey

#### **Step 3: Run Setup**

```bash
./SETUP_FIRST_TIME.command
```

This will:
- ✅ Install Python dependencies
- ✅ Install Node.js dependencies
- ✅ Build frontend
- ✅ Verify configuration

**See [FIRST_TIME_SETUP.md](FIRST_TIME_SETUP.md) for detailed instructions.**

---

### **Running the System**

#### **Start Everything**

```bash
./START_ALL.command
```

This launches:
- **Unified Console** (Port 9002) - Main control panel
- **Backend API** (Port 8000) - FastAPI server
- **Frontend** (Port 5173) - React dashboard

**Access**: http://127.0.0.1:9002

#### **Stop Everything**

```bash
./STOP_ALL.command
```

---

## 🎯 Key Features

### **1. Multi-LLM Root Cause Analysis**
- Parallel execution across Claude, Gemini, and LMStudio
- Comparative analysis results
- Configurable model selection and parameters

### **2. Real-Time Process Monitoring**
- Tennessee Eastman Process simulation
- 52 sensor variables tracking
- Real-time anomaly detection

### **3. Unified Control Interface**
- Single-page application with integrated tabs
- Control Panel, Monitor, Multi-LLM Analysis
- Interactive RCA chat interface

### **4. RAG Knowledge Base**
- Retrieval-Augmented Generation for context-aware analysis
- Process documentation and fault patterns
- Automatic context extraction for LLM queries

---

## 📁 Project Structure

```
TEP_demo/
├── START_ALL.command          # 🚀 Start all services
├── STOP_ALL.command           # 🛑 Stop all services
├── SETUP_FIRST_TIME.command   # 🔧 First-time setup
├── unified_console.py         # 🎛️ Main Flask application
├── requirements.txt           # 📦 Python dependencies
├── .env.template              # 🔐 API key template
├── backend/                   # 🔧 FastAPI backend
│   ├── app.py                 # Main API server
│   ├── simulation/            # TEP simulation (Fortran modules)
│   ├── knowledge_manager.py   # RAG system
│   ├── multi_llm_client.py    # Multi-LLM integration
│   └── tep_bridge.py          # Simulation bridge
├── frontend/                  # ⚛️ React frontend
│   ├── src/
│   │   ├── App.tsx            # Main application
│   │   └── pages/             # Page components
│   ├── package.json
│   └── vite.config.ts
├── config/                    # ⚙️ Configuration
│   ├── config.template.json   # Model configuration template
│   └── network_config.py      # Network settings
├── static/                    # 🌐 Web assets
└── templates/                 # 📄 HTML templates
```

---

## ⚙️ Configuration

### **LLM Models** (`config/config.json`)

```json
{
  "models": {
    "anthropic": {
      "api_key": "${ANTHROPIC_API_KEY}",
      "model_name": "claude-3-5-sonnet-20241022",
      "enabled": false
    },
    "gemini": {
      "api_key": "${GEMINI_API_KEY}",
      "model_name": "gemini-2.5-flash",
      "enabled": true
    },
    "lmstudio": {
      "enabled": false,
      "base_url": "http://127.0.0.1:1234/v1"
    }
  }
}
```

### **System Parameters**

- `llm_min_interval_seconds`: Minimum time between LLM requests (default: 60s)
- `anomaly_threshold`: Anomaly score threshold (default: 0.055)
- `pca_window_size`: Window size for anomaly detection (default: 20)

---

## 🛠️ Development

### **Check Running Services**

```bash
lsof -i :9002  # Unified Console
lsof -i :8000  # Backend API
lsof -i :5173  # Frontend
```

### **Manual Service Control**

```bash
# Backend only
cd backend
python app.py

# Frontend only
cd frontend
npm run dev

# Unified Console only
python unified_console.py
```

---

## 🐛 Troubleshooting

### **Port Already in Use**

```bash
./STOP_ALL.command
# If stuck, force kill:
pkill -f "python.*app.py"
pkill -f "vite"
pkill -f "unified_console"
```

### **Virtual Environment Issues**

```bash
rm -rf .venv
./SETUP_FIRST_TIME.command
```

### **API Key Not Working**

1. Check `.env` file exists and has valid keys
2. Verify `config/config.json` uses `${ANTHROPIC_API_KEY}` syntax
3. Restart backend: `./STOP_ALL.command && ./START_ALL.command`

---

## 📋 Requirements

- **Python**: 3.12 or higher
- **Node.js**: 16 or higher
- **Operating System**: macOS (Darwin) or Linux
- **API Keys**: Anthropic Claude and/or Google Gemini

---

## 📄 License

See [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

This is a research project. For questions or issues, please contact the project maintainer.

---

**For detailed setup instructions, see [FIRST_TIME_SETUP.md](FIRST_TIME_SETUP.md)**
