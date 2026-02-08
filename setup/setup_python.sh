#!/bin/bash

# Python Dependencies Setup Script
# Installs Python packages required for GPU detection

set -e  # Exit on error

echo "=========================================="
echo "Python Dependencies Setup"
echo "=========================================="
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "Python version: $(python3 --version)"
echo ""

# Check if pip is installed
if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    echo "Error: pip is not installed. Please install pip first."
    exit 1
fi

# Use pip3 if available, otherwise pip
PIP_CMD="pip3"
if ! command -v pip3 &> /dev/null; then
    PIP_CMD="pip"
fi

echo "Using: $PIP_CMD"
echo ""

# Install Python dependencies
echo "Installing Python dependencies..."
echo ""

# Install nvidia-ml-py (lightweight GPU detection library)
echo "Installing nvidia-ml-py..."
$PIP_CMD install nvidia-ml-py --quiet

echo ""
echo "Python dependencies installed successfully!"
echo ""

