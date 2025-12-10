#!/bin/bash

# JBuild CLI Wrapper - Ejecuta comandos estilo Maven
# Uso: jbuild [comando]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_SCRIPT="$SCRIPT_DIR/jbuild_cli.py"

# Verificar si el script CLI existe
if [[ ! -f "$CLI_SCRIPT" ]]; then
    echo "❌ Error: jbuild_cli.py no encontrado en $SCRIPT_DIR"
    echo "Asegúrate de que el CLI esté en el mismo directorio que este script."
    exit 1
fi

# Ejecutar el CLI con Python
python3 "$CLI_SCRIPT" "$@"