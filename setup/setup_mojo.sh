#!/bin/bash

# Mojo Setup Script using Pixi
# Installs and configures Mojo via pixi package manager

set -e  # Exit on error

echo "=========================================="
echo "Mojo Setup via Pixi"
echo "=========================================="
echo ""

# Check if pixi is installed
if ! command -v pixi &> /dev/null; then
    echo "Pixi is not installed. Installing pixi..."
    echo ""
    
    # Install pixi
    curl -fsSL https://pixi.sh/install.sh | bash
    
    # Add pixi to PATH for current session
    export PATH="$HOME/.pixi/bin:$PATH"
    
    # Verify installation
    if command -v pixi &> /dev/null; then
        echo "Pixi installed successfully: $(pixi --version)"
        echo ""
    else
        echo "Warning: Pixi installation completed, but not in PATH."
        echo "You may need to restart your terminal or run:"
        echo "  export PATH=\"\$HOME/.pixi/bin:\$PATH\""
        echo ""
        echo "Trying to use pixi from ~/.pixi/bin..."
        if [ -f "$HOME/.pixi/bin/pixi" ]; then
            export PATH="$HOME/.pixi/bin:$PATH"
        else
            echo "Error: Failed to find pixi after installation."
            exit 1
        fi
    fi
else
    echo "Pixi is already installed: $(pixi --version)"
    echo ""
fi

# Navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if pixi.toml exists, if not initialize pixi project
if [ ! -f "pixi.toml" ]; then
    echo "Initializing pixi project..."
    pixi init --no-workspace
    echo ""
fi

# Add Mojo if not already in dependencies
echo "Adding Mojo to pixi project..."
pixi add mojo

# Install/update dependencies
echo "Installing/updating dependencies..."
pixi install

echo ""
echo "Verifying Mojo installation..."
if pixi run mojo --version &> /dev/null; then
    echo "Mojo is available: $(pixi run mojo --version)"
else
    echo "Warning: Could not verify Mojo installation."
    echo "You may need to run 'pixi add mojo' and 'pixi install' manually."
fi

echo ""
echo "Mojo setup completed successfully!"
echo ""
echo "To activate the pixi environment, run:"
echo "  pixi shell"
echo ""
echo "Or use pixi run to execute commands:"
echo "  pixi run mojo --version"
echo ""

