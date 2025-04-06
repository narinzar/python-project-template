#!/bin/bash

# Detect OS
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows detected - create PowerShell script
    cat > setup_venv.ps1 << 'EOF'
# Detect the OS
$OS = $env:OS
# Check if venv exists, if not, create it
if (!(Test-Path "venv")) {
    python -m venv venv
}
# Windows Setup
if ($OS -match "Windows") {
    # Activate virtual environment
    .\venv\Scripts\Activate
    # Upgrade pip
    python.exe -m pip install --upgrade pip
    # Install dependencies
    pip install -r requirements.txt
}
Write-Output "✅ Virtual environment setup complete!"
EOF
    
    # Execute the PowerShell script
    echo "Windows detected. Running PowerShell script..."
    powershell -ExecutionPolicy Bypass -File setup_venv.ps1
    
else
    # Unix/Linux/macOS detected
    echo "Unix-like OS detected. Setting up virtual environment..."
    
    # Install prerequisites if needed
    if command -v apt-get &> /dev/null; then
        echo "Installing prerequisites..."
        apt-get update && apt-get install -y python3-pip
    fi
    
    # Check if venv exists, if not, create it
    if [ ! -d "venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv --without-pip || python3 -m venv venv
        
        # Check if pip needs to be installed manually
        if [ ! -f "venv/bin/pip" ] && [ ! -f "venv/bin/pip3" ]; then
            echo "Setting up pip manually..."
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            venv/bin/python3 get-pip.py
            rm get-pip.py
        fi
    fi
    
    # Check if being sourced
    (return 0 2>/dev/null) && SOURCED=1 || SOURCED=0
    
    if [ "$SOURCED" -eq 1 ]; then
        # Script is sourced, can activate directly
        echo "Activating virtual environment..."
        source venv/bin/activate
        pip install --upgrade pip
        pip install -r requirements.txt
        echo "✅ Virtual environment is now ACTIVE"
    else
        # Script is executed directly
        echo "Setting up packages..."
        ./venv/bin/pip install --upgrade pip
        ./venv/bin/pip install -r requirements.txt
        echo "✅ Virtual environment setup complete!"
        
        # Execute a new shell with the virtual environment activated
        echo "Activating virtual environment..."
        exec bash --rcfile <(echo '. ~/.bashrc; source "$(dirname "$0")/venv/bin/activate"; echo "Virtual environment activated! Type exit to return to normal shell."')
    fi
fi
