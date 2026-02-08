#!/bin/bash

# NVIDIA Driver Check Script
# Verifies NVIDIA drivers and GPU availability

set -e  # Exit on error

echo "=========================================="
echo "NVIDIA Driver Check"
echo "=========================================="
echo ""

# Check if nvidia-smi is available (indicates NVIDIA drivers are installed)
if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA drivers detected!"
    echo ""
    
    # Get GPU information
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
    GPU_COUNT=$(nvidia-smi --list-gpus | wc -l)
    
    echo "GPU Information:"
    echo "  Number of GPUs: $GPU_COUNT"
    echo "  Primary GPU: $GPU_NAME"
    echo ""
    
    # Show brief GPU status
    echo "GPU Status:"
    nvidia-smi --query-gpu=index,name,memory.total,driver_version --format=csv,noheader | while IFS=, read -r index name memory driver; do
        echo "  GPU $index: $name ($memory, Driver: $driver)"
    done
else
    echo "Warning: nvidia-smi not found."
    echo ""
    echo "This could mean:"
    echo "  - NVIDIA drivers are not installed"
    echo "  - NVIDIA drivers are not in PATH"
    echo "  - No NVIDIA GPU is present in the system"
    echo ""
    echo "GPU detection may not work without NVIDIA drivers."
    echo "Please install NVIDIA drivers if you have an NVIDIA GPU."
    echo ""
    exit 1
fi

echo ""
echo "NVIDIA driver check completed!"
echo ""

