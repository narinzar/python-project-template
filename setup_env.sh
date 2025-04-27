#!/bin/bash

# === [ Line ending fix for Unix-like OS ] ===
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "win32" && "$OSTYPE" != "cygwin" ]]; then
    if file "$0" | grep -q CRLF; then
        echo "🔧 Fixing CRLF line endings in-place..."
        sed -i.bak 's/\r$//' "$0"
        echo "🔁 Restarting script after cleanup..."
        exec bash "$0"
        exit 0
    fi
fi

# === [ Windows (PowerShell) Setup ] ===
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    # Create a setup PowerShell script that can be run directly
    cat > setup_venv.ps1 << 'EOF'
# Make this script modify the current session
$ErrorActionPreference = "Stop"

if (Test-Path "venv") {
    Write-Output "Virtual environment exists. Activating..."
    # Just activate without reinstalling
    & .\venv\Scripts\Activate.ps1
} else {
    Write-Output "Creating new virtual environment..."
    python -m venv venv
    
    Write-Output "Activating virtual environment..."
    & .\venv\Scripts\Activate.ps1

    Write-Output "Upgrading pip..."
    python -m pip install --upgrade pip

    Write-Output "Installing uv..."
    python -m pip install uv

    # Create pyproject.toml if it doesn't exist
    if (-not (Test-Path "pyproject.toml")) {
        Write-Output "Creating pyproject.toml for UV compatibility..."
        @"
[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

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

[tool.uv]
exclude = ["dev-dependencies"]
"@ | Out-File -FilePath "pyproject.toml" -Encoding UTF8
    }

    Write-Output "Installing dependencies with uv..."
    uv pip install -e .

    Write-Output ""
    Write-Output "[*] Let's configure your Git identity."

    $userName = Read-Host "Enter your Git user.name"
    $userEmail = Read-Host "Enter your Git user.email"

    git config --global user.name "$userName"
    git config --global user.email "$userEmail"

    Write-Output "`n[OK] Git global config updated:"
    git config --global user.name
    git config --global user.email
}

Write-Output "`n[OK] Virtual environment is now ACTIVE in this window!"
EOF

    echo "Windows detected. PowerShell setup script created."
    echo ""
    echo "=============================================="
    echo "To set up and activate your environment, run this command in PowerShell:"
    echo ""
    echo "    . .\setup_venv.ps1"
    echo ""
    echo "The dot at the beginning is important - it ensures the script runs in the current session"
    echo "=============================================="
    exit 0
fi

# === [ Unix/Linux/macOS Setup ] ===
echo "Unix-like OS detected."

(return 0 2>/dev/null)
SOURCED=$?

if [ $SOURCED -ne 0 ]; then
    echo "❌ Please run this script using:"
    echo ""
    echo "    source setup_env.sh"
    echo ""
    exit 1
fi

# Create pyproject.toml if it doesn't exist
if [ ! -f "pyproject.toml" ]; then
    echo "Creating pyproject.toml for UV compatibility..."
    cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

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

[tool.uv]
exclude = ["dev-dependencies"]
EOF
fi

if [ -d "venv" ]; then
    echo "Virtual environment exists. Activating..."
    source venv/bin/activate
    echo "✅ Virtual environment is now ACTIVE"
else
    echo "Creating new virtual environment..."

    if command -v apt-get &> /dev/null; then
        echo "Installing prerequisites..."
        sudo apt-get update && sudo apt-get install -y python3-pip
    fi

    python3 -m venv venv --without-pip || python3 -m venv venv

    if [ ! -f "venv/bin/pip" ] && [ ! -f "venv/bin/pip3" ]; then
        echo "Setting up pip manually..."
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        venv/bin/python3 get-pip.py
        rm get-pip.py
    fi

    echo "Activating virtual environment..."
    source venv/bin/activate
    pip install --upgrade pip
    pip install uv
    
    echo "Installing dependencies with uv..."
    uv pip install -e .
    echo "✅ Virtual environment is now ACTIVE"

    # === [ Git config prompt for Unix-like systems ] ===
    echo ""
    echo "🔧 Let's configure your Git identity."

    read -p "Enter your Git user.name: " git_user
    read -p "Enter your Git user.email: " git_email

    git config --global user.name "$git_user"
    git config --global user.email "$git_email"

    echo "✅ Git global config updated:"
    git config --global user.name
    git config --global user.email
fi
