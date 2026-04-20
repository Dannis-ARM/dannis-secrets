#!/bin/bash
set -euo pipefail

# 📝 Bitwarden Secret Manager (bws) Installation Script
# 🚀 Installs bws v2.0.0 to ~/.local/bin

# --------------------------
# 📦 Dependency Check
# --------------------------
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ Error: $1 is required but not installed."
        echo "💡 Please install $1 first using your package manager:"
        echo "   - Debian/Ubuntu: sudo apt install $1"
        echo "   - RHEL/CentOS: sudo yum install $1"
        echo "   - Fedora: sudo dnf install $1"
        exit 1
    fi
}

check_dependency "curl"
check_dependency "unzip"

# --------------------------
# 📂 Prepare directories
# --------------------------
BWS_BIN_DIR="$HOME/.local/bin"
mkdir -p "$BWS_BIN_DIR"
echo "✅ Created/verified installation directory: $BWS_BIN_DIR"

# --------------------------
# 📥 Download bws
# --------------------------
BWS_VERSION="2.0.0"
BWS_URL="https://github.com/bitwarden/sdk-sm/releases/download/bws-v${BWS_VERSION}/bws-x86_64-unknown-linux-gnu-${BWS_VERSION}.zip"
TMP_ZIP="/tmp/bws-${BWS_VERSION}.zip"

echo "📥 Downloading bws v${BWS_VERSION}..."
curl -fSL "$BWS_URL" -o "$TMP_ZIP"
echo "✅ Download completed: $TMP_ZIP"

# --------------------------
# 📤 Extract and install
# --------------------------
echo "📤 Extracting bws executable..."
unzip -o "$TMP_ZIP" -d /tmp
mv -f "/tmp/bws" "$BWS_BIN_DIR/"
chmod +x "$BWS_BIN_DIR/bws"
echo "✅ Installed bws to $BWS_BIN_DIR/bws"

# --------------------------
# 🧹 Cleanup
# --------------------------
rm -f "$TMP_ZIP"
echo "🧹 Cleaned up temporary files"

# --------------------------
# ✅ Verify installation
# --------------------------
echo ""
echo "🎉 Installation completed successfully!"
echo "ℹ️  bws version: $("$BWS_BIN_DIR/bws" --version)"
echo ""
echo "💡 To use bws, ensure $BWS_BIN_DIR is in your PATH:"
echo "   echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
echo "   source ~/.bashrc"