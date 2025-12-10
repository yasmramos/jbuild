#!/bin/bash
# Start the JBuild Remote Cache Server

echo "╔════════════════════════════════════════════════════╗"
echo "║     Starting JBuild Remote Cache Server           ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Compile if needed
if [ ! -d "target/classes" ]; then
    echo "Compiling JBuild first..."
    ./compile.sh
    echo ""
fi

# Create storage directory
mkdir -p ~/.jbuild/remote-cache/storage

echo "Starting server on port 8080..."
echo "Press Ctrl+C to stop"
echo ""

java -cp target/classes com.jbuild.server.CacheServer
