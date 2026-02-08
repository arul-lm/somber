# GPU Counter - Mojo Project

A Mojo language project that detects and counts the number of GPUs and their cores.

## Features

- Detects the number of available GPUs
- Counts CUDA cores for each GPU
- Displays GPU information including:
  - GPU name
  - Total memory
  - Number of multiprocessors
  - Compute capability
  - Total CUDA cores

## Requirements

The project uses Python interop to access GPU information via pynvml (lightweight NVIDIA Management Library):

- **pynvml**: `pip install nvidia-ml-py`

## Installation

The project uses **pixi** for managing Mojo and dependencies. Run the setup script to install everything:

```bash
make setup
```

Or manually:

```bash
./setup.sh
```

This will:
- Install **pixi** (package manager) if not present
- Set up **Mojo** via pixi with proper channels
- Install `nvidia-ml-py` (pynvml) for GPU detection
- Verify NVIDIA drivers

### Setup Scripts

The setup is split into modular scripts in the `setup/` directory:
- `setup/setup_mojo.sh` - Installs pixi and configures Mojo
- `setup/setup_python.sh` - Installs Python dependencies
- `setup/setup_nvidia.sh` - Verifies NVIDIA drivers
- `setup.sh` - Main orchestrator script

## Usage

### Using Makefile (Recommended)

```bash
# Install dependencies
make setup

# Run GPU counter
make run

# Run hello world
make hello

# Run both scripts
make test

# Show help
make help
```

### Using Pixi Directly

You can also use pixi commands directly:

```bash
# Activate pixi environment
pixi shell

# Then run commands normally
mojo gpu_counter.mojo
mojo hello_world.mojo

# Or use pixi run (no need to activate shell)
pixi run mojo gpu_counter.mojo
pixi run mojo hello_world.mojo

# Use predefined tasks from pixi.toml
pixi run hello
pixi run run
pixi run test
```

## How It Works

The script uses Python interop to:
1. Import pynvml (lightweight NVIDIA Management Library) for GPU detection
2. Query GPU properties including compute capability
3. Calculate CUDA cores based on compute capability and multiprocessor count

## Project Structure

```
.
├── gpu_counter.mojo       # Main GPU detection script
├── hello_world.mojo       # Simple hello world example
├── pixi.toml              # Pixi configuration (Mojo + dependencies)
├── setup.sh               # Main installation orchestrator
├── setup/                 # Modular setup scripts
│   ├── setup_mojo.sh      # Mojo setup via pixi
│   ├── setup_python.sh    # Python dependencies
│   └── setup_nvidia.sh    # NVIDIA driver check
├── Makefile               # Build and run commands
├── requirements.txt       # Python dependencies
└── README.md              # This file
```

## Output Example

```
GPU Detection System
==================================================

Using pynvml for GPU detection...

Number of GPUs detected: 1

GPU Details:
--------------------------------------------------

GPU 0:
  Name: NVIDIA GeForce RTX 3090
  Total Memory: 24.00 GB
  Compute Capability: 8.6
  Multiprocessors: 82
  CUDA Cores: 10496
```

## Notes

- Uses **pixi** for dependency management (no manual Mojo installation needed)
- Uses lightweight `pynvml` library (no heavy dependencies like PyTorch)
- CUDA core calculation is based on NVIDIA's compute capability specifications
- The script works with NVIDIA GPUs that support CUDA
- Requires NVIDIA drivers and nvidia-smi to be installed

## Pixi Environment

The project uses pixi to manage the Mojo environment. The `pixi.toml` file defines:
- Mojo installation from Modular's conda channel
- Predefined tasks for running scripts
- Cross-platform support (Linux, macOS, Windows)

To manage the pixi environment:
```bash
# Install dependencies
pixi install

# Update dependencies
pixi update

# Remove environment
pixi clean
```

