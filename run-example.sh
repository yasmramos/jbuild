#!/bin/bash
# Run the example build

CLASSPATH="target/classes"

echo "Running JBuild Example..."
echo ""

java -cp "$CLASSPATH" com.jbuild.example.ExampleBuild
