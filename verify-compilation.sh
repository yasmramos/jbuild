#!/bin/bash

echo "=== Verificación de Compilación JBuild-Core ==="

cd /workspace/jbuild/jbuild-core

# Crear directorio de clases si no existe
mkdir -p target/classes

echo "Compilando archivos Java..."
find src/main/java -name "*.java" -type f > /tmp/java_files.txt

# Compilar archivo por archivo para identificar errores específicos
errors=0
while IFS= read -r file; do
    echo "Compilando: $file"
    javac -d target/classes -cp target/classes "$file" 2>&1 | head -5
    if [ $? -ne 0 ]; then
        errors=$((errors + 1))
        echo "ERROR en: $file"
    fi
done < /tmp/java_files.txt

echo "=== Resumen ==="
echo "Total de archivos: $(wc -l < /tmp/java_files.txt)"
echo "Archivos con errores: $errors"
echo "Archivos compilados exitosamente: $(($(wc -l < /tmp/java_files.txt) - errors))"

# Limpiar
rm -f /tmp/java_files.txt

echo "=== Verificación Completada ==="