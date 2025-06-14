#!/bin/zsh

# Windsurf CLI Tool Installer
# This script installs the windsurf command-line utility

# Print with colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running from the correct directory
if [ ! -f "./windsurf" ]; then
    print_error "Windsurf script not found in current directory."
    print_error "Please run this installer from the directory containing the windsurf script."
    exit 1
fi

print_status "Installing Windsurf CLI Tool..."

# Create bin directory if it doesn't exist
if [ ! -d "$HOME/bin" ]; then
    print_status "Creating ~/bin directory..."
    mkdir -p "$HOME/bin"
    print_success "Created ~/bin directory"
fi

# Copy the script to bin directory
print_status "Copying windsurf script to ~/bin..."
cp "./windsurf" "$HOME/bin/"
chmod +x "$HOME/bin/windsurf"
print_success "Copied and made executable"

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    print_status "Adding ~/bin to your PATH in ~/.zshrc..."
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    print_success "Added ~/bin to PATH in ~/.zshrc"
    print_warning "You need to run 'source ~/.zshrc' or start a new terminal session for this to take effect"
else
    print_success "~/bin is already in your PATH"
fi

echo ""
print_success "Windsurf CLI Tool installed successfully!"
echo ""
echo "To use right away, run:"
echo "  source ~/.zshrc"
echo ""
echo "Usage examples:"
echo "  windsurf                     # Open Windsurf at current directory"
echo "  windsurf ~/projects/myapp    # Open Windsurf at specified path"
echo "  windsurf --help              # Show usage information"
echo ""
