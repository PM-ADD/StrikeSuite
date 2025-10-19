#!/usr/bin/env bash
# StrikeSuite v1.0 Run Script - bash version
# Converts original PowerShell behavior to a Linux-friendly script.

set -euo pipefail

# --- Colors (simple ANSI) ---
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
GRAY="\033[0;90m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${GREEN}StrikeSuite v1.0 - Advanced Penetration Testing Toolkit${RESET}"
printf "%0.s=" {1..60}
echo

# --- Locate Python ---
if command -v python3 >/dev/null 2>&1; then
    PYTHON=python3
elif command -v python >/dev/null 2>&1; then
    PYTHON=python
else
    echo -e "${RED}No python or python3 executable found in PATH. Install Python first.${RESET}"
    exit 1
fi

# --- Activate virtual environment if present ---
echo -e "${YELLOW}Activating virtual environment...${RESET}"
VENV_DIR="strikesuite_env"
if [ -f "${VENV_DIR}/bin/activate" ]; then
    # typical venv/virtualenv on Linux
    # shellcheck disable=SC1091
    source "${VENV_DIR}/bin/activate"
    echo -e "${GREEN}Activated virtualenv: ${VENV_DIR}${RESET}"
else
    echo -e "${YELLOW}Virtual environment not found at ${VENV_DIR}/bin/activate${RESET}"
    echo -e "${YELLOW}If you want to use a virtualenv, create one or adjust VENV_DIR variable.${RESET}"
fi

# --- Test installation ---
echo -e "${YELLOW}Testing installation...${RESET}"
if [ -f "test_installation.py" ]; then
    "$PYTHON" test_installation.py || echo -e "${RED}test_installation.py returned non-zero exit status.${RESET}"
else
    echo -e "${GRAY}test_installation.py not found. Skipping test.${RESET}"
fi

echo
echo -e "${CYAN}Choose an option:${RESET}"
echo -e "${WHITE}1. Run GUI version (requires PyQt5)${RESET}"
echo -e "${WHITE}2. Run CLI version${RESET}"
echo -e "${WHITE}3. Install PyQt5 for GUI${RESET}"
echo -e "${WHITE}4. Run example scan${RESET}"
echo

read -r -p "Enter your choice (1-4): " choice

case "$choice" in
    1)
        echo -e "${GREEN}Running GUI version...${RESET}"
        if [ -f "strikesuite.py" ]; then
            "$PYTHON" strikesuite.py
        else
            echo -e "${RED}strikesuite.py not found.${RESET}"
            exit 1
        fi
        ;;
    2)
        echo -e "${GREEN}Running CLI version...${RESET}"
        echo
        echo -e "${YELLOW}Example usage:${RESET}"
        echo -e "${GRAY}${PYTHON} strikesuite_cli.py --target 192.168.1.1 --ports 22,80,443${RESET}"
        echo
        if [ -f "strikesuite_cli.py" ]; then
            "$PYTHON" strikesuite_cli.py --help
        else
            echo -e "${RED}strikesuite_cli.py not found.${RESET}"
            exit 1
        fi
        ;;
    3)
        echo -e "${YELLOW}Installing PyQt5...${RESET}"
        # Attempt install using same python's pip
        if "$PYTHON" -m pip --version >/dev/null 2>&1; then
            "$PYTHON" -m pip install PyQt5
        else
            if command -v pip3 >/dev/null 2>&1; then
                pip3 install PyQt5
            elif command -v pip >/dev/null 2>&1; then
                pip install PyQt5
            else
                echo -e "${RED}pip not found. Install pip or ensure python -m pip is available.${RESET}"
                exit 1
            fi
        fi
        echo -e "${GREEN}PyQt5 installed. You can now run the GUI version.${RESET}"
        ;;
    4)
        echo -e "${GREEN}Running example scan on localhost...${RESET}"
        if [ -f "strikesuite_cli.py" ]; then
            "$PYTHON" strikesuite_cli.py --target 127.0.0.1 --ports 22,80,443,8080 --scan-type port
        else
            echo -e "${RED}strikesuite_cli.py not found.${RESET}"
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice. Showing CLI help...${RESET}"
        if [ -f "strikesuite_cli.py" ]; then
            "$PYTHON" strikesuite_cli.py --help
        else
            echo -e "${GRAY}strikesuite_cli.py not found.${RESET}"
        fi
        ;;
esac

echo
echo -e "${GRAY}Press any key to continue...${RESET}"
# Wait for single keypress without echo
# -n1 read one char, -s silent
read -n1 -s
echo
