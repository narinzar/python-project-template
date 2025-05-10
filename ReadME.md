# Python Project Template

This is a modern Python project template using UV (Ultra Fast) for project and dependency management. It provides a streamlined setup process that works across Windows, Linux, and macOS systems. UV offers 10-100x faster package installation compared to pip while maintaining full compatibility with the Python ecosystem.

## Setup Instructions

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone <repo-url>
cd <repo-name>
```

### 2. Running the Setup

The repository includes a cross-platform script that automates the process of setting up your project with UV.

#### For Windows (PowerShell)

Run the following command in PowerShell:
## 1. Below command will create a ps1 file
``` 
& "C:\Program Files\Git\bin\bash.exe" -c "./setup_env.sh"
```
## 2. Executing the ps1 file created in step 1
```
. .\setup_venv.ps1  # Note the dot at the beginning - this is important!
```

#### For Linux/macOS (Bash)

Run the following command to create (if not exist) and/or activate in your current shell:

```bash
sed -i 's/\r$//' setup_env.sh
source setup_env.sh
```

**Note:** The script automatically detects if it's being sourced or executed directly:
- If UV isn't installed, it will be installed automatically
- Creates a virtual environment using UV
- Initializes the UV project
- Activates the virtual environment
- Installs all dependencies from pyproject.toml

The script will automatically:
- Detect your operating system
- Install UV if not already present
- Create a virtual environment in `.venv`
- Initialize a UV project with `uv init`
- Install all dependencies using `uv pip install -e .`
- Configure Git identity if needed

## UV Commands and Usage

### Basic UV Commands

```bash
# Initialize a new UV project
uv init

# Create a virtual environment
uv venv

# Add a dependency
uv add package-name

# Add development dependency
uv add --dev package-name

# Install dependencies from pyproject.toml
uv pip install -e .

# Show installed packages
uv pip freeze

# Run a command in the project environment
uv run python script.py

# Lock dependencies
uv lock

# Sync environment with lock file
uv sync
```

### Virtual Environment Management with UV

UV creates virtual environments in `.venv` by default:

```bash
# Create a new virtual environment
uv venv

# Create with specific Python version
uv venv --python 3.11

# Remove virtual environment
rm -rf .venv  # Unix/macOS
Remove-Item -Recurse -Force .venv  # Windows PowerShell
```

### Activate the Virtual Environment

On Windows (PowerShell):

```powershell
.\.venv\Scripts\Activate.ps1
```

On Linux/macOS (Bash):

```bash
source .venv/bin/activate
```

### Deactivate the Virtual Environment

To deactivate the virtual environment, simply run:

```bash
deactivate
```

## Managing Dependencies with UV

### Project Dependencies with pyproject.toml

UV uses `pyproject.toml` for dependency management. The setup script creates a default configuration:

```toml
[project]
name = "python-project"
version = "0.1.0"
description = "Python project template"
requires-python = ">=3.8"
dependencies = [
    "numpy",
    "pandas",
    "python-dotenv",
    "ipykernel"
]

[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

[tool.uv]
dev-dependencies = []
```

### Installing Dependencies

```bash
# Install project dependencies
uv pip install -e .

# Install all dependencies including dev
uv sync

# Install from requirements file (if needed)
uv pip install -r requirements.txt
```

### Adding New Dependencies

```bash
# Add a runtime dependency
uv add requests

# Add multiple dependencies
uv add flask sqlalchemy

# Add development dependency
uv add --dev pytest black

# Add with version constraints
uv add "django>=4.0"
```

### Freezing Dependencies

```bash
# Show installed packages
uv pip freeze

# Export to requirements.txt
uv pip freeze > requirements.txt

# Create a lockfile
uv lock
```

### Running Commands with UV

```bash
# Run Python scripts
uv run python script.py

# Run module
uv run -m pytest

# Run with specific Python version
uv run --python 3.11 python script.py
```

## Advanced UV Features

### UV Tool Management

```bash
# Install a tool globally
uv tool install ruff

# Run a tool
uv tool run ruff check .

# Update tools
uv tool update ruff
```

### UV Cache Management

```bash
# Clear UV cache
uv cache clean

# Show cache info
uv cache dir
```

## Fallback: Using pip (if UV is unavailable)

If UV is not available or you need to use pip:

### Create Virtual Environment with pip

```bash
# Create virtual environment
python -m venv .venv

# Activate (Windows PowerShell)
.\.venv\Scripts\Activate.ps1

# Activate (Unix/macOS)
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
# or
pip install -e .
```

### Managing Dependencies with pip

```bash
# Install package
pip install package-name

# Install from pyproject.toml
pip install -e .

# Freeze dependencies
pip freeze > requirements.txt

# Install from requirements
pip install -r requirements.txt
```

## Git Setup (Prompted Automatically)

As part of the automated setup script, you will be prompted to provide your Git identity if not already configured.

When running setup_env.sh, you will be asked to enter:
- user.name: your Git username
- user.email: your Git email

These values will be saved globally using:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## PowerShell Execution Policy (Windows)

If you're using PowerShell on Windows, you may need to change the execution policy to allow scripts to run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

This allows local scripts to run but ensures that downloaded scripts are signed.

## Performance Benefits of UV

UV provides significant performance improvements:
- 10-100x faster package installation than pip
- Parallel downloads and dependency resolution
- Built-in caching system
- Compatible with PyPI and all Python packages
- Supports modern Python packaging standards

## Common UV Workflows

### Starting a New Project

```bash
# Initialize project
uv init

# Add common dependencies
uv add numpy pandas

# Add dev tools
uv add --dev pytest black ruff

# Install everything
uv sync
```

### Updating Dependencies

```bash
# Update specific package
uv add package-name@latest

# Update all dependencies
uv lock --update
uv sync
```

### Working with Multiple Python Versions

```bash
# Create venv with specific Python
uv venv --python 3.11

# Run with specific version
uv run --python 3.11 python script.py
```

## Conclusion

This template provides a modern Python development environment leveraging UV's speed and efficiency. UV offers a significantly faster alternative to pip while maintaining full compatibility with the Python ecosystem. The automated setup scripts ensure a consistent development environment across all platforms.

For more UV commands and features, refer to the [official UV documentation](https://github.com/astral-sh/uv).
