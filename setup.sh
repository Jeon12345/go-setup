#!/bin/bash

# Exit on error
set -e

echo ">>> Starting Bug Bounty Go-Toolbox Installation..."

# 1. INSTALL LATEST GO (If not already installed)
if ! command -v go &> /dev/null; then
    echo ">>> Installing latest Go..."
    LATEST_GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
    ARCH="amd64" # Change to arm64 for Raspberry Pi/Mac M1
    DL_URL="https://go.dev/dl/${LATEST_GO_VERSION}.linux-${ARCH}.tar.gz"
    
    curl -LO "$DL_URL"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${LATEST_GO_VERSION}.linux-${ARCH}.tar.gz"
    rm "${LATEST_GO_VERSION}.linux-${ARCH}.tar.gz"
    
    # Set paths for current session
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    
    # Add to .bashrc for future sessions
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
    echo ">>> Go installed: $(go version)"
else
    echo ">>> Go is already installed: $(go version)"
fi

# 2. INSTALL SOME BUG BOUNTY TOOLS
echo ">>> Installing Go-based Security Tools..."

# --- RECON & SUBDOMAINS ---
echo "Installing Recon tools ....."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest

# --- FUZZING & PATH DISCOVERY ---
echo "Installing Fuzzing tool.........."
go install -v github.com/ffuf/ffuf/v2@latest

# --- VULNERABILITY SCANNING ---
echo "Installing Scanning tools ......."
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/hahwul/dalfox/v2@latest # XSS Scanner

# --- DATA PARSING & UTILITIES ---
echo "Installing Utilities ......."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/gf@latest

echo "--------------------------------------------------"
echo ">>> ALL TOOLS INSTALLED!"
echo ">>> IMPORTANT: Run 'source ~/.bashrc' to use them now."
echo "--------------------------------------------------"
