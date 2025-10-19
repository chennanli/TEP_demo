#!/bin/bash
# First-Time Setup Script for TEP RCA System
# Run this once after cloning the repository

echo "🚀 TEP RCA System - First Time Setup"
echo "===================================="
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on Mac
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only"
    exit 1
fi

print_status "Running on macOS"

# Step 1: Check Python
echo ""
echo "Step 1: Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_status "Python found: $PYTHON_VERSION"
else
    print_error "Python 3 not found"
    echo "Please install Python 3:"
    echo "  brew install python@3.13"
    exit 1
fi

# Step 2: Check/Install Node.js
echo ""
echo "Step 2: Checking Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_status "Node.js found: $NODE_VERSION"
else
    print_warning "Node.js not found. Installing..."
    if command -v brew &> /dev/null; then
        brew install node
        print_status "Node.js installed"
    else
        print_error "Homebrew not found. Please install Node.js manually:"
        echo "  Visit: https://nodejs.org/"
        exit 1
    fi
fi

# Step 3: Install Python dependencies
echo ""
echo "Step 3: Installing Python dependencies..."
echo "This may take 5-10 minutes..."

if pip3 install -r requirements.txt --break-system-packages; then
    print_status "Python dependencies installed"
else
    print_error "Failed to install Python dependencies"
    echo "Try manually: pip3 install -r requirements.txt --break-system-packages"
    exit 1
fi

# Step 4: Install frontend dependencies
echo ""
echo "Step 4: Installing frontend dependencies..."
echo "This may take 3-5 minutes..."

cd frontend

if npm install; then
    print_status "Frontend dependencies installed"
else
    print_error "Failed to install frontend dependencies"
    echo "Try manually: cd frontend && npm install"
    exit 1
fi

cd ..

# Step 5: Create necessary directories
echo ""
echo "Step 5: Creating directories..."

mkdir -p backend/diagnostics
mkdir -p backend/diagnostics/analysis_history
mkdir -p backend/data
mkdir -p backend/logs

print_status "Directories created"

# Step 6: Setup .env file for API keys
echo ""
echo "Step 6: Setting up API keys..."

if [ -f ".env" ]; then
    print_status ".env file already exists"
else
    if [ -f ".env.template" ]; then
        print_warning ".env file not found, creating from template..."
        cp .env.template .env
        print_status "Created .env from template"
        echo ""
        echo "⚠️  IMPORTANT: Edit .env file and add your API keys:"
        echo "  1. Open .env in a text editor"
        echo "  2. Replace 'sk-ant-xxxxx-your-key-here' with your actual Anthropic API key"
        echo "  3. Replace 'AIzaSyXXXXX-your-key-here' with your actual Google Gemini API key"
        echo ""
        echo "  Get API keys from:"
        echo "  - Anthropic Claude: https://console.anthropic.com/settings/keys"
        echo "  - Google Gemini: https://aistudio.google.com/apikey"
        echo ""
    else
        print_error ".env.template not found!"
        echo "Please create .env manually with your API keys"
    fi
fi

# Step 7: Verify installation
echo ""
echo "Step 7: Verifying installation..."

# Check reportlab
if python3 -c "import reportlab" 2>/dev/null; then
    print_status "reportlab installed (PDF generation)"
else
    print_warning "reportlab not found, installing..."
    pip3 install reportlab --break-system-packages
fi

# Check Flask
if python3 -c "import flask" 2>/dev/null; then
    print_status "Flask installed"
else
    print_error "Flask not found"
fi

# Check FastAPI
if python3 -c "import fastapi" 2>/dev/null; then
    print_status "FastAPI installed"
else
    print_error "FastAPI not found"
fi

# Summary
echo ""
echo "========================================"
echo "✅ Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. ⚠️  IMPORTANT: Edit .env file and add your API keys (see above)"
echo "2. Double-click START_ALL.command to start the system"
echo "3. Open browser: http://127.0.0.1:9002"
echo "4. Click '🚀 Ultra Start' button to start all services"
echo ""
echo "For help, see:"
echo "  - README.md (Quick start guide)"
echo "  - docs/ (Detailed documentation)"
echo ""

# Make startup scripts executable
chmod +x START_ALL.command
chmod +x STOP_ALL.command
chmod +x scripts/*.command scripts/*.sh 2>/dev/null

print_status "Startup scripts are now executable"

echo ""
echo "Press any key to close..."
read -n 1 -s
