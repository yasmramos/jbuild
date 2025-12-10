#!/bin/bash
# Display detailed dependency tree

CLASSPATH="target/classes"

echo "═══════════════════════════════════════════════"
echo "   JBuild - Dependency Visualization"
echo "═══════════════════════════════════════════════"
echo ""

# Check if example was compiled
if [ ! -d "target/classes" ]; then
    echo "❌ Error: Project not compiled. Run ./compile.sh first"
    exit 1
fi

echo "Running dependency resolution with detailed output..."
echo ""

java -cp "$CLASSPATH" com.jbuild.example.ExampleBuild

echo ""
echo "═══════════════════════════════════════════════"
echo "Local Maven Repository Location:"
echo "  ~/.jbuild/repository/"
echo ""
echo "Downloaded artifacts are cached for future use."
echo "═══════════════════════════════════════════════"
