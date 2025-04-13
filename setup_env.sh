#!/bin/bash

# Detect OS
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows detected - create PowerShell script
    cat > setup_venv.ps1 << 'EOF'
# Detect the OS
$OS = $env:OS
# Check if venv exists
if (Test-Path "venv") {
    # Just activate existing environment
    Write-Output "Virtual environment exists. Activating..."
    .\venv\Scripts\Activate
} else {
    # Create new environment
    Write-Output "Creating new virtual environment..."
    python -m venv venv
    # Windows Setup
    if ($OS -match "Windows") {
        # Activate virtual environment
        .\venv\Scripts\Activate
        # Upgrade pip
        python.exe -m pip install --upgrade pip
        # Install dependencies
        pip install -r requirements.txt
    }
}
Write-Output "✅ Virtual environment is now ACTIVE!"
EOF

    # Execute the PowerShell script
    echo "Windows detected. Running PowerShell script..."
    powershell -ExecutionPolicy Bypass -File setup_venv.ps1

else
    # Unix/Linux/macOS detected
    echo "Unix-like OS detected."

    # Check if the script is being sourced
    (return 0 2>/dev/null)
    SOURCED=$?

    if [ $SOURCED -ne 0 ]; then
        echo "❌ Please run this script using:"
        echo ""
        echo "    source setup_env.sh"
        echo ""
        echo "So that the virtual environment is activated in your current shell."
        exit 1
    fi

    # Check if venv exists
    if [ -d "venv" ]; then
        echo "Virtual environment exists. No need to recreate."

        if [ $SOURCED -eq 0 ]; then
            # Script is sourced, can activate directly
            echo "Activating virtual environment..."
            source venv/bin/activate
            echo "✅ Virtual environment is now ACTIVE"
        else
            # Should not happen due to early sourced check, but safe fallback
            echo "Activating virtual environment..."
            exec bash --rcfile <(echo '. ~/.bashrc; source "$(dirname "$0")/venv/bin/activate"; echo "Virtual environment activated! Type exit to return to normal shell."')
        fi
    else
        # Need to create virtual environment
        echo "Creating new virtual environment..."

        # Install prerequisites if needed
        if command -v apt-get &> /dev/null; then
            echo "Installing prerequisites..."
            sudo apt-get update && sudo apt-get install -y python3-pip
        fi

        # Create venv
        python3 -m venv venv --without-pip || python3 -m venv venv

        # Check if pip needs to be installed manually
        if [ ! -f "venv/bin/pip" ] && [ ! -f "venv/bin/pip3" ]; then
            echo "Setting up pip manually..."
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            venv/bin/python3 get-pip.py
            rm get-pip.py
        fi

        if [ $SOURCED -eq 0 ]; then
            # Script is sourced, can activate directly
            echo "Activating virtual environment..."
            source venv/bin/activate
            pip install --upgrade pip
            pip install -r requirements.txt
            echo "✅ Virtual environment is now ACTIVE"
        else
            # Should not happen due to early sourced check
            echo "Setting up packages..."
            ./venv/bin/pip install --upgrade pip
            ./venv/bin/pip install -r requirements.txt
            echo "✅ Virtual environment setup complete!"

            # Execute a new shell with the virtual environment activated
            echo "Activating virtual environment..."
            exec bash --rcfile <(echo '. ~/.bashrc; source "$(dirname "$0")/venv/bin/activate"; echo "Virtual environment activated! Type exit to return to normal shell."')
        fi
    fi
fi
