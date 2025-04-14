#!/bin/bash

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
