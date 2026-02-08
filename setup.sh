#!/bin/bash

# Main Setup Script
# Orchestrates all setup components

set -e  # Exit on error

echo "=========================================="
echo "GPU Counter Mojo Project - Setup"
echo "=========================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$SCRIPT_DIR/setup"

# Make setup scripts executable
chmod +x "$SETUP_DIR"/*.sh

# Run individual setup scripts
echo "Running setup scripts..."
echo ""

# 1. Setup Mojo via Pixi
echo "[1/3] Setting up Mojo via Pixi..."
"$SETUP_DIR/setup_mojo.sh"
echo ""

# 2. Setup Python dependencies
echo "[2/3] Setting up Python dependencies..."
"$SETUP_DIR/setup_python.sh"
echo ""

# 3. Check NVIDIA drivers
echo "[3/3] Checking NVIDIA drivers..."
"$SETUP_DIR/setup_nvidia.sh" || {
    echo "Warning: NVIDIA driver check failed, but continuing..."
    echo ""
}

echo ""
echo "=========================================="
echo "Installation completed successfully!"
echo "=========================================="
echo ""
echo "To run the GPU counter:"
echo "  make run"
echo ""
echo "Or using pixi directly:"
echo "  pixi run mojo gpu_counter.mojo"
echo ""
echo "To activate the pixi environment:"
echo "  pixi shell"
echo ""
