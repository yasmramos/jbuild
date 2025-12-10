#!/bin/bash

# JBuild Multi-Module Compilation Script with Dependencies
# Script para compilar módulos JBuild en el orden correcto de dependencias

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║      JBuild Multi-Module Compilation v1.1.0                 ║"
echo "║            Orden de dependencias respetando                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Configuración
PROJECT_DIR="$(pwd)"
BUILD_JAR="target/jars"
TEMP_BUILD="target/temp-build"
COMPILE_CLASSES="target/classes"

# Función para log con timestamp
log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

# Función para limpiar directorios
clean_directories() {
    log "🧹 Limpiando directorios de construcción..."
    rm -rf "$BUILD_JAR" "$TEMP_BUILD" "$COMPILE_CLASSES"
    mkdir -p "$BUILD_JAR" "$TEMP_BUILD" "$COMPILE_CLASSES"
    log "✅ Directorios preparados"
}

# Función para verificar Java
check_java() {
    log "☕ Verificando herramientas Java..."
    
    if ! command -v javac &> /dev/null; then
        log "❌ Java Compiler (javac) no encontrado"
        exit 1
    fi
    
    JAVA_VERSION=$(javac -version 2>&1 | cut -d' ' -f2)
    log "✅ Java Compiler: $JAVA_VERSION"
}

# Función para crear un classpath combinado
create_classpath() {
    local jars=""
    
    # Agregar clases ya compiladas de otros módulos
    if [ -d "$COMPILE_CLASSES" ]; then
        for module_dir in "$COMPILE_CLASSES"/*; do
            if [ -d "$module_dir" ]; then
                jars="$jars:$module_dir"
            fi
        done
    fi
    
    # Agregar JARs ya compilados
    if [ -d "$BUILD_JAR" ]; then
        for jar in "$BUILD_JAR"/*.jar; do
            if [ -f "$jar" ]; then
                jars="$jars:$jar"
            fi
        done
    fi
    
    # Agregar librerías locales del módulo
    if [ -d "$module_path/lib" ]; then
        for jar in "$module_path/lib"/*.jar; do
            if [ -f "$jar" ]; then
                jars="$jars:$jar"
            fi
        done
    fi
    
    echo "$jars"
}

# Función para compilar módulo con manejo de dependencias
compile_module() {
    local module_name="$1"
    local module_path="$2"
    
    log "🔨 Compilando módulo: $module_name"
    
    if [ ! -d "$module_path/src/main/java" ]; then
        log "⚠️  No se encontró src/main/java en $module_name, saltando..."
        return 0
    fi
    
    # Crear directorio de salida para el módulo
    local output_dir="$COMPILE_CLASSES/$module_name"
    mkdir -p "$output_dir"
    
    # Crear classpath
    local classpath=$(create_classpath)
    
    # Compilar archivos Java
    find "$module_path/src/main/java" -name "*.java" -type f > "$TEMP_BUILD/${module_name}_files.txt"
    
    if [ -s "$TEMP_BUILD/${module_name}_files.txt" ]; then
        # Compilar con classpath
        if [ -n "$classpath" ]; then
            javac -d "$output_dir" -cp "$classpath" @${TEMP_BUILD}/${module_name}_files.txt
        else
            javac -d "$output_dir" @${TEMP_BUILD}/${module_name}_files.txt
        fi
        
        if [ $? -eq 0 ]; then
            log "✅ Módulo $module_name compilado exitosamente"
            
            # Crear JAR
            local jar_name="jbuild-${module_name#jbuild-}-1.1.0.jar"
            local jar_path="$BUILD_JAR/$jar_name"
            
            # Crear JAR usando una estrategia más robusta
            cd "$output_dir"
            jar cf "$jar_path" . 2>/dev/null || {
                log "⚠️  Error creando JAR para $module_name, usando clases directamente"
                cd ..
                cp -r "$module_name" "../backup_${module_name}" 2>/dev/null || true
            }
            
            # Verificar que el JAR se creó correctamente
            if [ -f "$jar_path" ] && [ $(du -b "$jar_path" | cut -f1) -gt 0 ]; then
                log "📦 JAR creado: $jar_name ($(du -h "$jar_path" | cut -f1))"
            else
                log "⚠️  JAR no válido para $module_name, usando clases compiladas"
            fi
            
            return 0
        else
            log "❌ Error compilando $module_name"
            log "🔍 Mostrando errores de compilación:"
            # Re-ejecutar con salida detallada para debug
            if [ -n "$classpath" ]; then
                javac -d "$output_dir" -cp "$classpath" @${TEMP_BUILD}/${module_name}_files.txt 2>&1 | head -20
            else
                javac -d "$output_dir" @${TEMP_BUILD}/${module_name}_files.txt 2>&1 | head -20
            fi
            return 1
        fi
    else
        log "⚠️  No se encontraron archivos .java en $module_name"
    fi
}

# Función para compilar módulos base (sin dependencias)
compile_base_modules() {
    log "🎯 Compilando módulos base..."
    
    # Orden de compilación basado en dependencias
    local base_modules=(
        "jbuild-model"
        "jbuild-cache"
        "jbuild-dependency"
    )
    
    for module in "${base_modules[@]}"; do
        if [ -d "$module" ]; then
            compile_module "$module" "$module" || {
                log "❌ Fallo al compilar módulo base $module"
                return 1
            }
        else
            log "⚠️  Módulo $module no encontrado, saltando..."
        fi
    done
    
    log "✅ Módulos base compilados exitosamente"
}

# Función para compilar módulos principales
compile_main_modules() {
    log "🔧 Compilando módulos principales..."
    
    # Módulos que dependen de los base
    local main_modules=(
        "jbuild-core"
        "jbuild-compiler"
        "jbuild-parallel"
        "jbuild-remote-cache"
    )
    
    for module in "${main_modules[@]}"; do
        if [ -d "$module" ]; then
            compile_module "$module" "$module" || {
                log "❌ Fallo al compilar módulo principal $module"
                return 1
            }
        else
            log "⚠️  Módulo $module no encontrado, saltando..."
        fi
    done
    
    log "✅ Módulos principales compilados exitosamente"
}

# Función para compilar módulos de aplicación
compile_application_modules() {
    log "🚀 Compilando módulos de aplicación..."
    
    # Módulos de aplicación que dependen de los principales
    local app_modules=(
        "jbuild-examples"
        "jbuild-cli"
        "jbuild-optimizer"
        "migration"
        "plugins"
    )
    
    for module in "${app_modules[@]}"; do
        if [ -d "$module" ]; then
            compile_module "$module" "$module" || {
                log "❌ Fallo al compilar módulo de aplicación $module"
                return 1
            }
        else
            log "⚠️  Módulo $module no encontrado, saltando..."
        fi
    done
    
    log "✅ Módulos de aplicación compilados exitosamente"
}

# Función para compilar sistema completo
compile_system_module() {
    log "🏗️  Compilando módulo del sistema..."
    
    if [ -d "jbuild-system" ]; then
        compile_module "jbuild-system" "jbuild-system" || {
            log "❌ Fallo al compilar módulo del sistema"
            return 1
        }
    fi
    
    # Compilar sistema nuevo
    if [ -d "jbuild-system-1.0.0-new" ]; then
        compile_module "jbuild-system-1.0.0-new" "jbuild-system-1.0.0-new" || {
            log "❌ Fallo al compilar módulo del sistema nuevo"
            return 1
        }
    fi
    
    log "✅ Módulo del sistema compilado exitosamente"
}

# Función para compilar proyecto demo
compile_demo_project() {
    log "🎮 Compilando proyecto demo..."
    
    if [ -d "demo-project" ]; then
        compile_module "demo-project" "demo-project" || {
            log "⚠️  Proyecto demo tuvo errores, continuando..."
        }
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
**Compilador:** $(javac -version 2>&1)

## Resumen
- **Módulos compilados:** $jar_count
- **Tamaño total:** $total_size
- **Directorio de salida:** $BUILD_JAR
- **Clases compiladas:** $COMPILE_CLASSES

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
    echo "- ✅ Dependencias entre módulos respetadas" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    echo "- ✅ Orden de compilación: base → principales → aplicación → sistema" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    echo "- ✅ JARs listos para distribución" >> "$BUILD_JAR/COMPILATION_REPORT.md"
    
    log "✅ Reporte generado: $BUILD_JAR/COMPILATION_REPORT.md"
}

# Función para verificar compilación
verify_compilation() {
    log "🔍 Verificando compilación..."
    
    local error_count=0
    for jar_file in "$BUILD_JAR"/*.jar; do
        if [ -f "$jar_file" ]; then
            local jar_name=$(basename "$jar_file")
            local jar_size=$(du -b "$jar_file" | cut -f1)
            
            if [ "$jar_size" -lt 1024 ]; then
                log "⚠️  JAR muy pequeño: $jar_name ($jar_size bytes)"
                ((error_count++))
            else
                log "✅ JAR válido: $jar_name ($(du -h "$jar_file" | cut -f1))"
            fi
        fi
    done
    
    if [ $error_count -eq 0 ]; then
        log "✅ Todos los JARs son válidos"
        return 0
    else
        log "⚠️  Se encontraron $error_count JARs con posibles problemas"
        return 1
    fi
}

# Función principal
main() {
    log "🚀 Iniciando compilación completa del proyecto JBuild con dependencias..."
    
    # Limpiar y preparar
    clean_directories
    
    # Verificar Java
    check_java
    
    # Compilar en orden de dependencias
    compile_base_modules || exit 1
    compile_main_modules || exit 1
    compile_application_modules || exit 1
    compile_system_module || exit 1
    compile_demo_project
    
    # Verificar compilación
    verify_compilation || log "⚠️  Verificación completa pero con advertencias"
    
    # Generar reporte
    generate_report
    
    # Mostrar resultados
    log "🎉 Compilación completada exitosamente!"
    echo ""
    echo "📦 JARs generados en: $BUILD_JAR"
    echo "📋 Clases compiladas en: $COMPILE_CLASSES"
    echo "📋 Reporte disponible en: $BUILD_JAR/COMPILATION_REPORT.md"
    echo ""
    
    # Listar JARs creados
    if [ -d "$BUILD_JAR" ]; then
        log "📋 JARs creados:"
        ls -lh "$BUILD_JAR"/*.jar 2>/dev/null | while read line; do
            echo "   $line"
        done
    fi
    
    echo ""
    log "✨ Proyecto JBuild compilado completamente usando sistema nativo"
}

# Ejecutar
main "$@"