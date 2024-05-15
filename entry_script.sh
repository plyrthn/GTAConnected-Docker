#!/bin/sh

# Determine OS and architecture
OS="Linux"
ARCH=$(uname -m)

# Convert architecture from uname output to expected format
case "$ARCH" in
    x86_64)
        ARCH_TYPE="AMD64"
        ;;
    aarch64)
        ARCH_TYPE="ARM64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "OS: $OS, ARCH_TYPE: $ARCH_TYPE"

# Run the Python script to get the download link
URL=$(python3 /app/download_script.py "$OS" "$ARCH_TYPE")
if [ $? -ne 0 ] || [ -z "$URL" ]; then
    echo "Failed to get download link"
    exit 1
fi

echo "Download URL: $URL"

# Download the server package
wget -O server.tar.gz "$URL"
if [ $? -ne 0 ] || [ ! -f server.tar.gz ]; then
    echo "Failed to download server package"
    exit 1
fi

# Ensure the directory exists
mkdir -p /app/GTAC-Server

# Extract the server package
tar xvzf server.tar.gz -C /app/GTAC-Server/
if [ $? -ne 0 ]; then
    echo "Failed to extract server package"
    exit 1
fi

# Find the directory inside /app/GTAC-Server and move the Server executable
SUBDIR=$(ls /app/GTAC-Server)
mv "/app/GTAC-Server/$SUBDIR/Server" /app/GTAC-Server/Server
if [ ! -f /app/GTAC-Server/Server ]; then
    echo "Server executable not found after moving."
    exit 1
fi

chmod +x /app/GTAC-Server/Server
