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
    # Create PowerShell setup script
    cat > setup_venv.ps1 << 'EOF'
# Detect the OS
$OS = $env:OS
# Check if venv exists
if (Test-Path "venv") {
    Write-Output "Virtual environment exists. Activating..."
    .\venv\Scripts\Activate
} else {
    Write-Output "Creating new virtual environment..."
    python -m venv venv
    if ($OS -match "Windows") {
        .\venv\Scripts\Activate
        python.exe -m pip install --upgrade pip
        pip install -r requirements.txt
    }
}
Write-Output "✅ Virtual environment is now ACTIVE!"

# === [ Git config prompt for Windows PowerShell ] ===
Write-Output ""
Write-Output "🔧 Let's configure your Git identity."

$userName = Read-Host "Enter your Git user.name"
$userEmail = Read-Host "Enter your Git user.email"

git config --global user.name "$userName"
git config --global user.email "$userEmail"

Write-Output "`n✅ Git global config updated:"
git config --global user.name
git config --global user.email
EOF

    echo "Windows detected. Running PowerShell script..."
    powershell -ExecutionPolicy Bypass -File setup_venv.ps1
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

if [ -d "venv" ]; then
    echo "Virtual environment exists. No need to recreate."
    echo "Activating virtual environment..."
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
    pip install -r requirements.txt
    echo "✅ Virtual environment is now ACTIVE"
fi

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

# sed -i 's/\r$//' setup_env.sh
# source setup_env.sh
# & "C:\Program Files\Git\bin\bash.exe" -c "./setup_env.sh"
