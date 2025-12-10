#!/bin/bash

# JBuild CLI with Migration Support
# This script integrates the jbuild-migrate functionality into the main JBuild CLI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATE_JAR="$SCRIPT_DIR/jbuild-migrate/target/jars/jbuild-migrate-1.1.0-executable.jar"

# Check if we're running a migrate command
if [[ "$1" == "migrate" ]]; then
    if [ ! -f "$MIGRATE_JAR" ]; then
        echo "❌ JBuild Migrator not found at: $MIGRATE_JAR"
        echo "🔧 Please compile the migrate module first:"
        echo "   cd jbuild-migrate && bash compile.sh"
        exit 1
    fi
    
    echo "🚀 Starting JBuild Migrator..."
    java -jar "$MIGRATE_JAR" migrate "${@:2}"
    exit $?
fi

# If not a migrate command, fall back to the original JBuild CLI
if [ -f "$SCRIPT_DIR/jbuild_cli.py" ]; then
    python3 "$SCRIPT_DIR/jbuild_cli.py" "$@"
elif [ -f "$SCRIPT_DIR/jbuild.bat" ]; then
    "$SCRIPT_DIR/jbuild.bat" "$@"
else
    echo "JBuild CLI not found. Please ensure jbuild_cli.py or jbuild.bat exists."
    echo ""
    echo "Usage:"
    echo "  jbuild migrate --help          # Show migration help"
    echo "  jbuild migrate --pom <file>    # Migrate a Maven project"
    echo "  jbuild <other-commands>        # Use regular JBuild commands"
fi