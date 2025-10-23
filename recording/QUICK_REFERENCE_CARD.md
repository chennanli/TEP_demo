# 🎥 Video Recording Quick Reference Card

**Print this page and keep it beside you during recording**

---

## ⏱️ **Timeline (7-minute version)**

| Time | Segment | Key Actions | Core Message |
|------|---------|-------------|--------------|
| 0:00-0:30 | Opening | Double-click `start_all.command` | One-command system startup |
| 0:30-1:15 | Console | Click "Ultra Start 50x" | Unified control panel |
| 1:15-2:15 | DCS Interface | Show data panel, anomaly detection | 52 real-time signals |
| 2:15-3:00 | TEP Explanation | Switch to Plot page | Industry standard benchmark |
| 3:00-4:00 | Knowledge Base | Upload PDF, build KB | RAG system |
| 4:00-5:00 | Trigger Fault | Set IDV disturbance | Anomaly detection response |
| 5:00-6:00 | LLM Analysis | Show multi-model results | Real-time root cause analysis |
| 6:00-6:45 | Interactive Chat | Enter Chat interface | In-depth diagnosis |
| 6:45-7:30 | Summary | Return to main interface | 5 capabilities + voice vision |

---

## 🎯 **Core Talking Points (Memorize)**

### **Opening (30 seconds)**
> "Today I'll demonstrate the **TEP Intelligent Fault Diagnosis System**, a real-time fault analysis platform based on industrial process simulation, integrating multiple large language models and knowledge retrieval technology."

### **DCS Interface (1 minute)**
> "On the left are real-time values of 52 process variables. Upper right is anomaly detection status based on PCA T² statistic. Below is the multi-LLM analysis panel."

### **TEP Explanation (45 seconds)**
> "TEP is not a toy model. It's a widely recognized standard chemical process benchmark in industry. We use a Fortran-compiled physics simulation engine. All signals are calculated in real-time."

### **Knowledge Base (1 minute)**
> "The system supports uploading PDF documents, automatically converting to Markdown and vectorizing. When a fault occurs, the LLM retrieves relevant knowledge, combines with real-time data, and generates precise root cause analysis."

### **LLM Analysis (1 minute)**
> "We use three models simultaneously: Claude, Gemini, and LMStudio, working in parallel. Each model receives system prompts, real-time sensor data, and knowledge base retrieval results, generating detailed root cause analysis reports."

### **Interactive Chat (1 minute)**
> "Operators can ask in-depth questions about the fault. The LLM provides professional answers based on fault context and knowledge base. This allows operators to deeply understand the fault mechanism."

### **Voice Vision (45 seconds)**
> "Future integration of voice recognition and synthesis modules for hands-free operation. Operators can directly say 'System, analyze current anomaly' without touching the screen, improving on-site safety and efficiency."

### **Summary (30 seconds)**
> "Five core capabilities: industrial-grade simulation, real-time anomaly detection, multi-LLM root cause analysis, interactive dialogue, and future voice integration."

---

## 🖱️ **Operation Steps Quick Reference**

### **1. Start System**
```
Double-click start_all.command
Wait for terminal window to appear
```

### **2. Open Console**
```
Browser auto-opens http://127.0.0.1:9002
Or manually open
```

### **3. Ultra Start**
```
Click "🚀 ULTRA START (50x)" button
Wait for success message
```

### **4. Open Frontend**
```
Click "Open Fault Analysis Frontend"
Or visit http://localhost:5173
```

### **5. View Plot**
```
Click "Plot" tab at top
Show real-time trend charts
```

### **6. Knowledge Base Management**
```
Click "Assistant" tab at top
Scroll to "Knowledge Base Management"
Click "Rebuild Knowledge Base"
```

### **7. Trigger Fault**
```
Return to console http://127.0.0.1:9002
Scroll to "Disturbance Variables (IDV)"
Select IDV(1) - A/C Feed Ratio
Step Type: "Step"
Step Time: current time + 1 minute
Click "Set IDV"
```

### **8. View LLM Analysis**
```
Switch back to frontend page
Wait for T² statistic to turn red
Wait for LLM analysis to complete (30-60 sec)
Scroll to view results from three models
```

### **9. Interactive Chat**
```
Click "History" tab at top
Select latest analysis record
Click "Chat" button
Type question: "What caused the temperature spike?"
Click send
Show LLM response
```

---

## ⚠️ **Important Notes**

### **Before Recording**
- [ ] Close all unnecessary apps
- [ ] Clean up desktop
- [ ] Test complete workflow once
- [ ] Confirm API keys configured

### **During Recording**
- [ ] Smooth mouse movement
- [ ] Wait for loading to complete
- [ ] Moderate speaking pace, clear pronunciation
- [ ] Avoid filler words like "um", "uh"

### **After Recording**
- [ ] Check audio clarity
- [ ] Check screen smoothness
- [ ] Check duration (5-7 minutes)
- [ ] Check no sensitive info exposed

---

## 🎬 **3-Minute Condensed Version**

If time is tight, record only these:

1. **Startup** (20 sec) - `start_all.command` → Ultra Start
2. **DCS** (40 sec) - Data panel + anomaly detection
3. **Fault** (30 sec) - Trigger IDV + anomaly appears
4. **LLM** (40 sec) - Multi-model analysis results
5. **Chat** (30 sec) - Quick chat demo
6. **Summary** (20 sec) - 5 capabilities + voice

---

## 📊 **Key Data Points**

- **52 real-time signals** - TEP process variables
- **3 LLM models** - Claude, Gemini, LMStudio
- **T² statistic** - Anomaly detection metric
- **50x speed** - Accelerated simulation
- **Fortran engine** - Physics simulation
- **RAG system** - Knowledge base retrieval
- **Hands-free** - Future voice integration

---

## 🎯 **Avoid Mentioning These Details**

❌ **Don't explain in detail**:
- Specific algorithm implementations
- Code structure
- API key configuration
- Database design
- Model training details
- System architecture diagrams

✅ **Only demonstrate**:
- Functionality
- User interface
- Operation workflow
- Result display
- Application value

---

## 💡 **Handling Issues**

**If system lags**:
> "The system is processing large amounts of real-time data, please wait a moment..."

**If LLM responds slowly**:
> "The LLM is performing deep analysis of fault data and knowledge base, typically takes 30-60 seconds..."

**If errors occur**:
> "This is a demo environment, occasional network fluctuations may occur. Actual deployment will be more stable..."

---

## 📞 **Contact Information (Optional for closing)**

```
Project Name: TEP Intelligent Fault Diagnosis System
Tech Stack: Python + React + Multi-LLM + RAG
Application: Chemical processes, energy, manufacturing
Contact: [Your email]
```

---

**Good luck with your recording! 🎉**

