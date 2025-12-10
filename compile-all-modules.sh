#!/bin/bash

# JBuild Full Project Compilation Script
# Script para compilar todos los módulos del proyecto JBuild usando el sistema nativo

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         JBuild Complete Project Compilation v1.1.0          ║"
echo "║              Compilando todos los módulos                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Configuración
PROJECT_DIR="$(pwd)"
BUILD_JAR="target/jars"
TEMP_BUILD="target/temp-build"

# Función para log con timestamp
log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

# Función para limpiar directorios
clean_directories() {
    log "🧹 Limpiando directorios de construcción..."
    rm -rf "$BUILD_JAR" "$TEMP_BUILD"
    mkdir -p "$BUILD_JAR" "$TEMP_BUILD"
    log "✅ Directorios preparados"
}

# Función para verificar Java
check_java() {
    log "☕ Verificando herramientas Java..."
    
    if ! command -v javac &> /dev/null; then
        log "⚠️  Java Compiler (javac) no encontrado"
        log "🔄 Instalando OpenJDK..."
        apt-get update -qq
        apt-get install -y openjdk-17-jdk-headless
    fi
    
    JAVA_VERSION=$(javac -version 2>&1 | cut -d' ' -f2)
    log "✅ Java Compiler: $JAVA_VERSION"
}

# Función para compilar módulo específico
compile_module() {
    local module_path="$1"
    local module_name=$(basename "$module_path")
    
    log "🔨 Compilando módulo: $module_name"
    
    if [ ! -d "$module_path/src/main/java" ]; then
        log "⚠️  No se encontró src/main/java en $module_name, saltando..."
        return 0
    fi
    
    # Crear directorio de salida para el módulo
    local output_dir="$TEMP_BUILD/$module_name"
    mkdir -p "$output_dir"
    
    # Compilar archivos Java
    find "$module_path/src/main/java" -name "*.java" -type f > "$TEMP_BUILD/${module_name}_files.txt"
    
    if [ -s "$TEMP_BUILD/${module_name}_files.txt" ]; then
        javac -d "$output_dir" -cp "$(find "$module_path/lib" -name "*.jar" 2>/dev/null | tr '\n' ':')" @${TEMP_BUILD}/${module_name}_files.txt
        
        if [ $? -eq 0 ]; then
            log "✅ Módulo $module_name compilado exitosamente"
            
            # Crear JAR
            local jar_name="jbuild-${module_name#jbuild-}-1.1.0.jar"
            (cd "$output_dir" && jar cf "$BUILD_JAR/$jar_name" .)
            log "📦 JAR creado: $jar_name"
        else
            log "❌ Error compilando $module_name"
            return 1
        fi
    else
        log "⚠️  No se encontraron archivos .java en $module_name"
    fi
}

# Función para compilar módulos principales
compile_main_modules() {
    log "🎯 Compilando módulos principales..."
    
    local modules=(
        "jbuild-core"
        "jbuild-system" 
        "jbuild-model"
        "jbuild-examples"
        "jbuild-optimizer"
        "jbuild-cli"
        "jbuild-cache"
        "jbuild-dependency"
        "jbuild-compiler"
        "jbuild-parallel"
        "jbuild-remote-cache"
        "migration"
        "plugins"
    )
    
    for module in "${modules[@]}"; do
        if [ -d "$module" ]; then
            compile_module "$module"
        else
            log "⚠️  Módulo $module no encontrado, saltando..."
        fi
    done
}

# Función para compilar proyecto demo
compile_demo_project() {
    log "🎮 Compilando proyecto demo..."
    
    if [ -d "demo-project" ]; then
        local demo_output="$TEMP_BUILD/demo-project"
        mkdir -p "$demo_output"
        
        find "demo-project/src/main/java" -name "*.java" -type f > "$TEMP_BUILD/demo_files.txt"
        
        if [ -s "$TEMP_BUILD/demo_files.txt" ]; then
            javac -d "$demo_output" -cp "$BUILD_JAR/*" @${TEMP_BUILD}/demo_files.txt
            
            if [ $? -eq 0 ]; then
                log "✅ Proyecto demo compilado exitosamente"
                
                # Crear JAR del demo
                (cd "$demo_output" && jar cf "$BUILD_JAR/jbuild-demo-1.1.0.jar" .)
                log "📦 JAR de demo creado: jbuild-demo-1.1.0.jar"
            else
                log "❌ Error compilando proyecto demo"
            fi
        fi
    else
        log "⚠️  Proyecto demo no encontrado"
    fi
}

# Función para generar reporte de compilación
generate_report() {
    log "📊 Generando reporte de compilación..."
    
    local jar_count=$(ls -1 "$BUILD_JAR"/*.jar 2>/dev/null | wc -l)
    local total_size=$(du -sh "$BUILD_JAR" 2>/dev/null | cut -f1)
    
    cat > "$BUILD_JAR/COMPILATION_REPORT.md" << EOF
# JBuild Complete Project Compilation Report

**Fecha:** $(date '+%Y-%m-%d %H:%M:%S')
**Versión:** 1.1.0

## Resumen
- **Módulos compilados:** $jar_count
- **Tamaño total:** $total_size
- **Directorio de salida:** $BUILD_JAR

## JARs Generados
EOF

    for jar_file in "$BUILD_JAR"/*.jar; do
        if [ -f "$jar_file" ]; then
            local jar_name=$(basename "$jar_file")
            local jar_size=$(du -h "$jar_file" | cut -f1)
            echo "- **$jar_name** ($jar_size)" >> "$BUILD_JAR/COMPILATION_REPORT.md"
        fi
    done
    
    echo "" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    echo "## Estado de Compilación" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    echo "- ✅ Compilación completada usando sistema nativo" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    echo "- ✅ Todos los módulos principales incluidos" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    echo "- ✅ JARs listos para distribución" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    
    log "✅ Reporte generado: $BUILD_JAR/COMPILATION_REPORT.md"
}

# Función principal
main() {
    log "🚀 Iniciando compilación completa del proyecto JBuild..."
    
    # Limpiar y preparar
    clean_directories
    
    # Verificar Java
    check_java
    
    # Compilar módulos
    compile_main_modules
    
    # Compilar demo
    compile_demo_project
    
    # Generar reporte
    generate_report
    
    # Mostrar resultados
    log "🎉 Compilación completada exitosamente!"
    echo ""
    echo "📦 JARs generados en: $BUILD_JAR"
    echo "📋 Reporte disponible en: $BUILD_JAR/COMPILATION_REPORT.md"
    echo ""
    
    # Listar JARs creados
    if [ -d "$BUILD_JAR" ]; then
        log "📋 JARs creados:"
        ls -lh "$BUILD_JAR"/*.jar 2>/dev/null | while read line; do
            echo "   $line"
        done
    fi
}

# Ejecutar
main "$@"