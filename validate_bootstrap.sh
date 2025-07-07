#!/bin/bash

# 🔍 Bootstrap Project Validation Script
# This script validates that the project_bootstrap.sh script would run successfully
# Usage: ./validate_bootstrap.sh

set -e

# Helper functions for error handling
error_exit() {
    echo "❌ Error: $1" >&2
    exit 1
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        error_exit "$1 could not be found"
    fi
}

check_write_permissions() {
    if [ ! -w "." ]; then
        error_exit "No write permissions in current directory"
    fi
}

echo "🔍 Validating Bootstrap Project Requirements..."
echo "==============================================="

# Check if we're in a git repository
if [ -d ".git" ]; then
    echo "✅ Git repository detected"
else
    echo "❌ Not in a git repository"
    echo "💡 Run 'git init' to initialize a git repository"
    exit 1
fi

# Check Python installation
if command -v python3 &> /dev/null; then
    echo "✅ Python 3 found: $(python3 --version)"
    
    # Validate Python version
    PYTHON_VERSION=$(python3 -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")
    if python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)"; then
        echo "✅ Python $PYTHON_VERSION meets minimum requirement (3.11+)"
    else
        echo "❌ Python $PYTHON_VERSION is below minimum requirement (3.11+)"
        exit 1
    fi
else
    echo "❌ Python 3 not found"
    echo "💡 Install Python 3.11+ from https://python.org"
    exit 1
fi

# Check if pip is available
check_command pip3
echo "✅ pip3 is available"

# Check if make is available
check_command make
echo "✅ make is available"

# Check if we have write permissions
check_write_permissions
echo "✅ Write permissions in current directory"

# Check available disk space (at least 1GB)
if command -v df &> /dev/null; then
    AVAILABLE_KB=$(df . | tail -1 | awk '{print $4}')
    if [ "$AVAILABLE_KB" -gt 1048576 ]; then
        echo "✅ Sufficient disk space available"
    else
        echo "⚠️  Low disk space (less than 1GB available)"
    fi
else
    echo "⚠️  Could not check disk space"
fi

# Check if project_bootstrap.sh exists
if [ -f "project_bootstrap.sh" ]; then
    echo "✅ project_bootstrap.sh found"
    if [ -x "project_bootstrap.sh" ]; then
        echo "✅ project_bootstrap.sh is executable"
    else
        echo "⚠️  project_bootstrap.sh is not executable"
        echo "💡 Run 'chmod +x project_bootstrap.sh' to make it executable"
    fi
else
    echo "❌ project_bootstrap.sh not found in current directory"
    exit 1
fi

echo ""
echo "🎉 Validation Complete!"
echo "======================="
echo "✅ All requirements met for running project_bootstrap.sh"
echo ""
echo "🚀 To run the bootstrap script:"
echo "   ./project_bootstrap.sh [project_name]"
echo ""
echo "📋 What the script will do:"
echo "   1. Create a comprehensive Makefile"
echo "   2. Set up Python virtual environment with uv"
echo "   3. Initialize project structure"
echo "   4. Create documentation templates"
echo "   5. Install development tools"
echo "   6. Run tests to validate setup"
echo ""
echo "⚠️  Note: The script will modify files in the current directory"
echo "   Make sure you're in the right location before running it!"
