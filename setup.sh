#!/bin/bash

# Exit on error
set -e

echo ">>> Starting Bug Bounty Go-Toolbox Installation..."

# 1. INSTALL GO 1.24.13 (if not already installed)
if ! command -v go &> /dev/null; then
    GO_VERSION="go1.24.13"
    ARCH="amd64"
    DL_URL="https://go.dev/dl/${GO_VERSION}.linux-${ARCH}.tar.gz"

    echo ">>> Installing Go ${GO_VERSION}..."
    
    # Download Go tarball
    curl -LO "$DL_URL"
    
    # Remove any existing Go installation and extract
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-${ARCH}.tar.gz"
    
    # Clean up tarball
    rm "${GO_VERSION}.linux-${ARCH}.tar.gz"

    # Set PATH for current session
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

    # Persist PATH for future sessions
    if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
    fi

    echo ">>> Go installed: $(go version)"
else
    echo ">>> Go is already installed: $(go version)"
fi

# 2. INSTALL GO-BASED BUG BOUNTY TOOLS
echo ">>> Installing Go-based Security Tools..."

# --- RECON & SUBDOMAINS ---
echo "Installing Recon tools..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# --- FUZZING & PATH DISCOVERY ---
echo "Installing Fuzzing tool..."
go install -v github.com/ffuf/ffuf/v2@latest

# --- VULNERABILITY SCANNING ---
echo "Installing Scanning tools..."
go install github.com/bitquark/shortscan/cmd/shortscan@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/hahwul/dalfox/v2@latest # XSS Scanner

# --- DATA PARSING & UTILITIES ---
echo "Installing Utilities..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/gf@latest

echo "--------------------------------------------------"
echo ">>> ALL TOOLS INSTALLED!"
echo ">>> IMPORTANT: Run 'source ~/.bashrc' to use them now."
echo "--------------------------------------------------"
