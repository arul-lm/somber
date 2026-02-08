.PHONY: help install setup run hello clean test

# Configurable parameters for vector_add.mojo
VECTOR_SIZE ?= 6912
BLOCK_SIZE ?= 64

# Default target
help:
	@echo "GPU Vector Addition Mojo Project - Makefile"
	@echo "==========================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make setup     - Run installation script to install dependencies"
	@echo "  make install   - Alias for setup"
	@echo "  make run       - Run the vector addition script"
	@echo "  make hello     - Run the hello world script"
	@echo "  make test      - Run both hello and vector_add"
	@echo "  make clean     - Clean up generated files"
	@echo "  make help      - Show this help message"
	@echo ""
	@echo "Configurable parameters (override with VAR=value):"
	@echo "  VECTOR_SIZE    - Size of vectors (default: 7000)"
	@echo "  BLOCK_SIZE     - GPU block size (default: 64)"
	@echo ""
	@echo "Example: make run VECTOR_SIZE=10000 BLOCK_SIZE=128"
	@echo ""

# Install dependencies
setup install:
	@echo "Running setup script..."
	@chmod +x setup.sh
	@./setup.sh

# Run vector addition using pixi with configurable parameters
vector_add:
	@echo "Running Vector Addition..."
	@echo "  VECTOR_SIZE=$(VECTOR_SIZE)"
	@echo "  BLOCK_SIZE=$(BLOCK_SIZE)"
	@pixi run mojo -DVECTOR_SIZE=$(VECTOR_SIZE) -DBLOCK_SIZE=$(BLOCK_SIZE) vector_add.mojo

# Run hello world using pixi
hello:
	@echo "Running Hello World..."
	@pixi run mojo hello_world.mojo

# Run both scripts using pixi
test:
	@echo "Running Hello World..."
	@pixi run mojo hello_world.mojo
	@echo ""
	@echo "Running Vector Addition..."
	@pixi run mojo -Dvector_size=$(VECTOR_SIZE) -D BLOCK_SIZE=$(BLOCK_SIZE) vector_add.mojo

# Clean up
clean:
	@echo "Cleaning up..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@echo "Cleanup complete."

