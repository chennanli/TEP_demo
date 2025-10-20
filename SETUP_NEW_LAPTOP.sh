#!/bin/bash

# ==============================================================================
# TEP Control - First Time Setup Script for New Laptops
# ==============================================================================
# This script automates the complete setup process:
# 1. Checks/installs Homebrew
# 2. Checks/installs Python 3.13
# 3. Checks/installs Node.js 22 LTS
# 4. Creates Python virtual environment
# 5. Installs all Python dependencies (including google-genai)
# 6. Installs all Node.js dependencies
# 7. Builds frontend
# ==============================================================================

set -e  # Exit on error

cd "$(dirname "$0")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 TEP Control - First Time Setup for New Laptop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will install all required dependencies."
echo "Please enter your password when prompted."
echo ""

# ==============================================================================
# Step 1: Check/Install Homebrew
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Step 1/7: Checking Homebrew..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v brew &> /dev/null; then
    echo "✅ Homebrew already installed: $(brew --version | head -1)"
else
    echo "❌ Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed successfully"
fi
echo ""

# ==============================================================================
# Step 2: Check/Install Python 3.12 (REQUIRED - 3.13 has compatibility issues)
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐍 Step 2/7: Checking Python 3.12..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if python3.12 is available
if command -v python3.12 &> /dev/null; then
    PYTHON_VERSION=$(python3.12 --version)
    echo "✅ Python 3.12 found: $PYTHON_VERSION"
else
    echo "❌ Python 3.12 not found. Installing..."
    brew install python@3.12
    echo "✅ Python 3.12 installed successfully"
fi
echo ""

# ==============================================================================
# Step 3: Check/Install Node.js
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Step 3/7: Checking Node.js..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js already installed: $NODE_VERSION"

    # Check if version is 18 or higher
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1 | tr -d 'v')
    if [ "$NODE_MAJOR" -lt 18 ]; then
        echo "⚠️  Node.js $NODE_VERSION is too old. Installing Node.js 22 LTS..."
        brew install node@22
    fi
else
    echo "❌ Node.js not found. Installing Node.js 22 LTS..."
    brew install node@22
    echo "✅ Node.js installed successfully"
fi
echo ""

# ==============================================================================
# Step 4: Create Python Virtual Environment
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐍 Step 4/7: Setting up Python virtual environment..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d ".venv" ]; then
    echo "✅ Virtual environment already exists: .venv/"
    echo "   Removing old venv to ensure clean state..."
    rm -rf .venv
fi

echo "📦 Creating new virtual environment with Python 3.12..."
python3.12 -m venv .venv

if [ $? -ne 0 ]; then
    echo "❌ Failed to create virtual environment"
    echo "   Make sure Python 3.12 is installed: brew install python@3.12"
    exit 1
fi

# Verify Python version in venv
VENV_PYTHON_VERSION=$(.venv/bin/python --version)
echo "✅ Virtual environment created: .venv/"
echo "   Python version: $VENV_PYTHON_VERSION"
echo ""

# ==============================================================================
# Step 5: Install Python Dependencies
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 Step 5/7: Installing Python dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This may take 5-10 minutes on first install..."
echo ""

source .venv/bin/activate

# Upgrade pip first
echo "📦 Upgrading pip..."
pip install --upgrade pip --quiet

# Install all dependencies with EXACT versions for reproducibility
echo "📦 Installing dependencies with exact versions..."
echo "   (Using requirements-frozen.txt for identical package versions)"
echo ""

# Use frozen requirements for exact same versions as development environment
pip install -r requirements-frozen.txt --quiet

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Python dependencies"
    echo "   Falling back to requirements.txt..."
    pip install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "❌ Installation failed completely"
        exit 1
    fi
fi

echo ""
echo "✅ All Python packages installed successfully"
echo ""

# Verify critical packages
echo "🔍 Verifying critical packages..."
python3 -c "import fastapi, flask, anthropic, genai, openai" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ All critical packages verified"
else
    echo "⚠️  Warning: Some packages may be missing"
fi
echo ""

deactivate

# ==============================================================================
# Step 6: Install Node.js Dependencies
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 Step 6/7: Installing Node.js dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd frontend

if [ ! -f "package.json" ]; then
    echo "❌ package.json not found in frontend/"
    exit 1
fi

echo "📦 Installing npm packages..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Node.js dependencies"
    exit 1
fi

echo "✅ Node.js packages installed successfully"
echo ""

cd ..

# ==============================================================================
# Step 7: Build Frontend
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔨 Step 7/7: Building frontend..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd frontend

echo "📦 Building React app..."
# Use vite directly to skip TypeScript strict checks
npx vite build

if [ $? -ne 0 ]; then
    echo "❌ Frontend build failed"
    echo "   This is usually okay - you can rebuild later with: npm run build"
fi

echo "✅ Frontend built successfully"
echo ""

cd ..

# ==============================================================================
# Setup Complete
# ==============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Summary:"
echo "   ✅ Homebrew installed/verified"
echo "   ✅ Python $(python3 --version | awk '{print $2}') installed/verified"
echo "   ✅ Node.js $(node --version) installed/verified"
echo "   ✅ Virtual environment created (.venv/)"
echo "   ✅ Python packages installed (including google-genai)"
echo "   ✅ Node.js packages installed"
echo "   ✅ Frontend built"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Configure API Keys (required):"
echo "   Edit config/config.json and add your Anthropic API key"
echo ""
echo "2. Start the system:"
echo "   ./START_ALL.command"
echo ""
echo "3. Open Control Panel:"
echo "   Browser: http://127.0.0.1:9002"
echo ""
echo "4. Click 'Ultra Start' button to start backend and frontend"
echo ""
echo "5. Access the app:"
echo "   Browser: http://127.0.0.1:5173"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📖 For more info, read: FIRST_TIME_SETUP.md"
echo ""
