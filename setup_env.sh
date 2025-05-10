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

if (Test-Path ".venv") {
    Write-Output "Virtual environment exists. Activating..."
    # Just activate without reinstalling
    & .\.venv\Scripts\Activate.ps1
} else {
    Write-Output "Creating new virtual environment..."
    uv venv
    
    Write-Output "Activating virtual environment..."
    & .\.venv\Scripts\Activate.ps1

    # Initialize uv project
    Write-Output "Initializing uv project..."
    uv init --no-workspace

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

# Clean up the PowerShell script
if (Test-Path "setup_venv.ps1") {
    Remove-Item "setup_venv.ps1"
    Write-Output "[OK] PowerShell setup script removed."
}
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

if [ -d ".venv" ]; then
    echo "Virtual environment exists. Activating..."
    source .venv/bin/activate
    echo "✅ Virtual environment is now ACTIVE"
else
    echo "Creating new virtual environment..."

    # Check if uv is already installed globally
    if ! command -v uv &> /dev/null; then
        echo "Installing uv..."
        if command -v curl &> /dev/null; then
            curl -LsSf https://astral.sh/uv/install.sh | sh
        elif command -v wget &> /dev/null; then
            wget -qO- https://astral.sh/uv/install.sh | sh
        else
            echo "Neither curl nor wget found. Please install uv manually."
            exit 1
        fi
    fi

    echo "Creating virtual environment with uv..."
    uv venv

    echo "Activating virtual environment..."
    source .venv/bin/activate
    
    echo "Initializing uv project..."
    uv init --no-workspace
    
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


# & "C:\Program Files\Git\bin\bash.exe" -c "./setup_env.sh"
# sed -i 's/\r$//' setup_env.sh source setup_env.sh
