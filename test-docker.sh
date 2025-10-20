#!/bin/bash
# ==============================================================================
# TEP Docker Test Script
# ==============================================================================
# Purpose: Verify Docker setup is working correctly
# Usage: ./test-docker.sh
# ==============================================================================

set -e  # Exit on error

echo "🐳 TEP Docker Test Suite"
echo "========================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((TESTS_FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# ==============================================================================
# Test 1: Docker Installation
# ==============================================================================
echo "Test 1: Checking Docker installation..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    pass "Docker is installed: $DOCKER_VERSION"
else
    fail "Docker is not installed"
    echo "   Install from: https://docs.docker.com/desktop/"
    exit 1
fi

# ==============================================================================
# Test 2: Docker Compose Installation
# ==============================================================================
echo ""
echo "Test 2: Checking Docker Compose installation..."
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    pass "Docker Compose is installed: $COMPOSE_VERSION"
else
    fail "Docker Compose is not installed"
    exit 1
fi

# ==============================================================================
# Test 3: Docker Daemon Running
# ==============================================================================
echo ""
echo "Test 3: Checking if Docker daemon is running..."
if docker info &> /dev/null; then
    pass "Docker daemon is running"
else
    fail "Docker daemon is not running"
    echo "   Start Docker Desktop and try again"
    exit 1
fi

# ==============================================================================
# Test 4: Required Files Exist
# ==============================================================================
echo ""
echo "Test 4: Checking required files..."

FILES=(
    "docker-compose.yml"
    "Dockerfile.backend"
    "Dockerfile.console"
    "frontend/Dockerfile"
    ".dockerignore"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        pass "Found: $file"
    else
        fail "Missing: $file"
    fi
done

# ==============================================================================
# Test 5: Environment File
# ==============================================================================
echo ""
echo "Test 5: Checking environment configuration..."
if [ -f ".env" ]; then
    pass "Found .env file"
    
    # Check for required API keys
    if grep -q "ANTHROPIC_API_KEY=sk-ant-" .env 2>/dev/null; then
        pass "ANTHROPIC_API_KEY is configured"
    else
        warn "ANTHROPIC_API_KEY not configured in .env"
    fi
    
    if grep -q "GEMINI_API_KEY=AIza" .env 2>/dev/null; then
        pass "GEMINI_API_KEY is configured"
    else
        warn "GEMINI_API_KEY not configured in .env"
    fi
else
    warn ".env file not found (will use .env.template)"
    if [ -f ".env.template" ]; then
        pass "Found .env.template"
    else
        fail "Missing .env.template"
    fi
fi

# ==============================================================================
# Test 6: Build Docker Images (Optional)
# ==============================================================================
echo ""
echo "Test 6: Building Docker images (this may take a few minutes)..."
read -p "Do you want to build Docker images now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if docker-compose build; then
        pass "Docker images built successfully"
    else
        fail "Docker image build failed"
    fi
else
    warn "Skipped Docker image build"
fi

# ==============================================================================
# Test 7: Start Services (Optional)
# ==============================================================================
echo ""
echo "Test 7: Starting Docker services..."
read -p "Do you want to start the services now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Starting services with docker-compose up -d..."
    if docker-compose up -d; then
        pass "Services started successfully"
        
        # Wait for services to be ready
        echo "Waiting for services to be ready (30 seconds)..."
        sleep 30
        
        # Test endpoints
        echo ""
        echo "Testing service endpoints..."
        
        if curl -f http://localhost:8000/ &> /dev/null; then
            pass "Backend API is responding (http://localhost:8000)"
        else
            fail "Backend API is not responding"
        fi
        
        if curl -f http://localhost:5173/ &> /dev/null; then
            pass "Frontend is responding (http://localhost:5173)"
        else
            fail "Frontend is not responding"
        fi
        
        if curl -f http://localhost:9002/ &> /dev/null; then
            pass "Unified Console is responding (http://localhost:9002)"
        else
            fail "Unified Console is not responding"
        fi
        
        # Show running containers
        echo ""
        echo "Running containers:"
        docker-compose ps
        
    else
        fail "Failed to start services"
    fi
else
    warn "Skipped starting services"
fi

# ==============================================================================
# Summary
# ==============================================================================
echo ""
echo "========================"
echo "Test Summary"
echo "========================"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! Your Docker setup is ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Start services: docker-compose up -d"
    echo "2. View logs: docker-compose logs -f"
    echo "3. Access frontend: http://localhost:5173"
    echo "4. Access backend: http://localhost:8000"
    echo "5. Access console: http://localhost:9002"
    echo ""
    echo "To stop services: docker-compose down"
else
    echo -e "${RED}❌ Some tests failed. Please fix the issues above.${NC}"
    exit 1
fi

