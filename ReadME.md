# Python Project Template

This is a basic template for Python projects, set up with a virtual environment and dependency management. It works across Windows, Linux, and macOS systems. Uses uv (Ultra Fast) for dependency installation with modern Python packaging. Use the provided scripts to set up the virtual environment, install dependencies, and manage your project.

## Setup Instructions

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone <repo-url>
cd <repo-name>
```

### 2. Running the Setup

The repository includes a cross-platform script that automates the process of setting up your virtual environment, upgrading pip, and installing dependencies (using uv for ultra-fast installation).

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
- If a virtual environment already exists, it will be activated without recreation
- Uses uv pip with pyproject.toml for modern dependency management (10-100x faster than regular pip)

The script will automatically:
- Detect your operating system
- Create a virtual environment if it doesn't exist (or just activate it if it already exists)
- Activate the virtual environment
- Upgrade pip to the latest version
- Install uv (ultra-fast package installer)
- Create a pyproject.toml file if it doesn't exist
- Install all dependencies using `uv pip install -e .`

## Virtual Environment

If you want to manually create or recreate the virtual environment, you can do so with the following steps:

### Create a New Virtual Environment

Run this command to create a new virtual environment:

```bash
python -m venv venv
```

### Create Virtual Environment from Other Python Versions

If you want to use a specific version of Python that is not the default on your system (e.g., Python 3.11), follow these steps:

1. Download and install the version of Python you want to use (e.g., Python 3.11).
2. Use the following command to create a virtual environment from that specific Python version:

```bash
C:\Users\YOURCOMPUTERUSERNAME\AppData\Local\Programs\Python\Python311\python.exe -m venv venv
```

### Activate the Virtual Environment

On Windows (PowerShell):

```powershell
.\venv\Scripts\Activate.ps1
```

On Linux/macOS (Bash):

```bash
source venv/bin/activate
```

### Deactivate the Virtual Environment

To deactivate the virtual environment, simply run:

```bash
deactivate
```

### Remove and Recreate the Virtual Environment

If you need to delete and recreate the virtual environment, follow these steps:

1. Remove the existing venv directory:

```bash
Remove-Item -Recurse -Force venv  # Windows (PowerShell)
rm -rf venv                      # Linux/macOS (Bash)
```

2. Recreate the virtual environment:

```bash
python -m venv venv
```

## Managing Dependencies

### Project Dependencies with pyproject.toml

This template uses modern Python packaging with `pyproject.toml` for dependency management. The file is automatically created by the setup script with these default dependencies:

```toml
[project]
dependencies = [
    "numpy",
    "pandas",
    "python-dotenv",
    "ipykernel"
]
```

### Installing Dependencies

Once the virtual environment is activated, dependencies are installed using:

```bash
# Installing in development mode
uv pip install -e .
```

### Adding New Dependencies

To add a new package:

```bash
# Add a package directly
uv add package-name

# Or manually edit pyproject.toml and reinstall
uv pip install -e .
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

If you've already configured Git globally, this prompt will just show you the current values.

## Git Setup - Manually (if not already configured)

To configure Git for your project:

1. Install Git if you haven't already.
2. Set your global Git configuration:

```bash
git config --global user.name "Your GitHub Username"
git config --global user.email "Your GitHub Email"
```

3. Restart the terminal to apply the changes.

## PowerShell Execution Policy (Windows)

If you're using PowerShell on Windows, you may need to change the execution policy to allow scripts to run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

This allows local scripts to run but ensures that downloaded scripts are signed.

## Included Setup Scripts

The repository includes a script that handles the virtual environment setup on all systems with ultra-fast uv dependency installation.

### setup_env.sh (Cross-Platform)

This script:
- Handles virtual environment setup on all platforms
- Uses uv pip with pyproject.toml for modern dependency management
- Automatically configures Git if needed
- Can be run with `source setup_env.sh` on Unix or generates a PowerShell script on Windows

## Performance Note

This template includes support for uv, a Rust-based Python package installer that's:
- 10-100x faster than regular pip
- Compatible with modern Python packaging (pyproject.toml)
- Automatically used by the setup script

For manual usage after setup:

```bash
uv add <package>         # Add a package to your project
uv pip install -e .      # Reinstall your project in development mode
```

## Conclusion

This template provides a ready-to-go environment for your Python project with ultra-fast dependency installation and modern Python packaging, ensuring you don't need to repeat the setup process every time. Simply use the provided scripts and enjoy a streamlined development experience!

Feel free to modify the structure or add additional tools as needed for your project.
