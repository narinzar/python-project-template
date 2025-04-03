# Python Project Template

This is a basic template for Python projects, set up with a virtual environment and dependency management. It works across **Windows**, **Linux**, and **macOS** systems. Use the provided scripts to set up the virtual environment, install dependencies, and manage your project.

## Setup Instructions

### 1. Clone the Repository

First, clone this repository to your local machine:
```bash
git clone <repo-url>
cd <repo-name>
```

### 2. Running the Setup

The repository includes a cross-platform script that automates the process of setting up your virtual environment, upgrading `pip`, and installing dependencies.

#### For Windows (PowerShell)
- Run the following command in PowerShell:
  ```powershell
  & "C:\Program Files\Git\bin\bash.exe" -c "./setup_env.sh"
  ```

#### For Linux/macOS (Bash)
- Run the following command in your terminal:
  ```bash
  source setup_env.sh
  ```
  
> **Important**: On Unix systems, you must use `source` to run the script to activate the environment in your current shell.

The script will automatically:
- Detect your operating system
- Create a virtual environment if it doesn't exist
- Activate the virtual environment
- Upgrade pip to the latest version
- Install all dependencies from requirements.txt

---

## Virtual Environment

If you want to **manually create** or **recreate** the virtual environment, you can do so with the following steps:

### Create a New Virtual Environment

1. Run this command to create a new virtual environment:
   ```bash
   python -m venv venv
   ```

### Create Virtual Environment from Other Python Versions

If you want to use a specific version of Python that is not the default on your system (e.g., Python 3.11), follow these steps:

1. **Download and install the version of Python** you want to use (e.g., Python 3.11).
2. Use the following command to create a virtual environment from that specific Python version:
   ```bash
   C:\Users\YOURCOMPUTERUSERNAME\AppData\Local\Programs\Python\Python311\python.exe -m venv venv
   ```

### Activate the Virtual Environment

- On **Windows (PowerShell)**:
  ```powershell
  .\venv\Scripts\Activate.ps1
  ```

- On **Linux/macOS (Bash)**:
  ```bash
  source venv/bin/activate
  ```

### Deactivate the Virtual Environment

To deactivate the virtual environment, simply run:
```bash
deactivate
```

### Remove and Recreate the Virtual Environment

If you need to **delete** and **recreate** the virtual environment, follow these steps:

1. Remove the existing `venv` directory:
   ```bash
   Remove-Item -Recurse -Force venv  # Windows (PowerShell)
   rm -rf venv                      # Linux/macOS (Bash)
   ```
2. Recreate the virtual environment:
   ```bash
   python -m venv venv
   ```

---

## Managing Dependencies

### Installing Dependencies

Once the virtual environment is activated, install the dependencies listed in `requirements.txt`:
```bash
pip install -r requirements.txt
```

### Freezing Dependencies

If you install new packages or update existing ones, remember to update `requirements.txt`:
```bash
pip freeze > requirements.txt
```

---

## Git Setup (if not already configured)

To configure Git for your project:

1. Install [Git](https://git-scm.com/downloads) if you haven't already.
2. Set your global Git configuration:
   ```bash
   git config --global user.name "Your GitHub Username"
   git config --global user.email "Your GitHub Email"
   ```
3. Restart the terminal to apply the changes.

---

## PowerShell Execution Policy (Windows)

If you're using PowerShell on Windows, you may need to change the execution policy to allow scripts to run:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
This allows local scripts to run but ensures that downloaded scripts are signed.

---

## Included Setup Scripts

The repository includes the following setup scripts:

### `setup_env.ps1` (Windows PowerShell)

This script handles the virtual environment setup on Windows systems.

### `setup_env.sh` (Linux/macOS)

This script handles the virtual environment setup on Unix-like systems. Remember to run it with `source setup_env.sh` to activate the environment in your current shell.

---

## Conclusion

This template provides a ready-to-go environment for your Python project, ensuring you don't need to repeat the setup process every time. Simply use the provided scripts and enjoy a streamlined development experience!

Feel free to modify the structure or add additional tools as needed for your project.
