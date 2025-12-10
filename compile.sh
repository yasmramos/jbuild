#!/bin/bash
# Compile JBuild from source

set -e

echo "╔════════════════════════════════════════╗"
echo "║    Compiling JBuild Build System       ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Create output directories
mkdir -p target/classes
mkdir -p target/jbuild-model
mkdir -p target/jbuild-cache
mkdir -p target/jbuild-dependency
mkdir -p target/jbuild-compiler
mkdir -p target/jbuild-remote-cache
mkdir -p target/jbuild-cache-server
mkdir -p target/jbuild-parallel
mkdir -p target/jbuild-core
mkdir -p target/jbuild-cli
mkdir -p target/jbuild-examples

echo "[1/10] Compiling jbuild-model..."
javac -d target/jbuild-model \
    jbuild-model/src/main/java/com/jbuild/model/*.java

echo "[2/10] Compiling jbuild-cache..."
javac -cp target/jbuild-model \
    -d target/jbuild-cache \
    jbuild-cache/src/main/java/com/jbuild/cache/*.java

echo "[3/10] Compiling jbuild-dependency..."
javac -cp target/jbuild-model \
    -d target/jbuild-dependency \
    jbuild-dependency/src/main/java/com/jbuild/dependency/*.java

echo "[4/10] Compiling jbuild-compiler..."
javac -cp target/jbuild-model:target/jbuild-cache \
    -d target/jbuild-compiler \
    jbuild-compiler/src/main/java/com/jbuild/compiler/*.java

echo "[5/10] Compiling jbuild-remote-cache..."
javac -cp target/jbuild-model \
    -d target/jbuild-remote-cache \
    jbuild-remote-cache/src/main/java/com/jbuild/remote/*.java

echo "[6/10] Compiling jbuild-cache-server..."
javac -d target/jbuild-cache-server \
    jbuild-cache-server/src/main/java/com/jbuild/server/*.java

echo "[7/10] Compiling jbuild-parallel..."
javac -d target/jbuild-parallel \
    jbuild-parallel/src/main/java/com/jbuild/parallel/*.java

echo "[8/10] Compiling jbuild-core..."
javac -cp target/jbuild-model:target/jbuild-dependency:target/jbuild-cache:target/jbuild-compiler:target/jbuild-remote-cache:target/jbuild-parallel \
    -d target/jbuild-core \
    jbuild-core/src/main/java/com/jbuild/core/*.java

echo "[9/10] Compiling jbuild-cli..."
javac -cp target/jbuild-model:target/jbuild-dependency:target/jbuild-cache:target/jbuild-compiler:target/jbuild-remote-cache:target/jbuild-parallel:target/jbuild-core \
    -d target/jbuild-cli \
    jbuild-cli/src/main/java/com/jbuild/cli/*.java

echo "[10/10] Compiling jbuild-examples..."
javac -cp target/jbuild-model:target/jbuild-dependency:target/jbuild-cache:target/jbuild-compiler:target/jbuild-remote-cache:target/jbuild-parallel:target/jbuild-core \
    -d target/jbuild-examples \
    jbuild-examples/src/main/java/com/jbuild/example/*.java

# Combine all classes
echo ""
echo "Combining all classes..."
cp -r target/jbuild-model/* target/classes/
cp -r target/jbuild-cache/* target/classes/
cp -r target/jbuild-dependency/* target/classes/
cp -r target/jbuild-compiler/* target/classes/
cp -r target/jbuild-remote-cache/* target/classes/
cp -r target/jbuild-cache-server/* target/classes/
cp -r target/jbuild-parallel/* target/classes/
cp -r target/jbuild-core/* target/classes/
cp -r target/jbuild-cli/* target/classes/
cp -r target/jbuild-examples/* target/classes/

echo ""
echo "✓ Compilation successful!"
echo "  Output: target/classes/"
