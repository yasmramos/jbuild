#!/bin/bash

# JBuild Main Script for Linux/macOS
# Script principal nativo para usuarios finales de Unix
# Uso: ./jbuild.sh [comando] [opciones]

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="JBuild Multi-Module System"
VERSION="1.1.0"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para mostrar header
show_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                  JBuild Unix v${VERSION}                   ║${NC}"
    echo -e "${CYAN}║            Multi-Module Build System                         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Función para mostrar ayuda
show_help() {
    echo -e "${GREEN}🎯 Comandos disponibles:${NC}"
    echo ""
    echo -e "  ${BLUE}jbuild.sh compile${NC}        - Compilar el proyecto"
    echo -e "  ${BLUE}jbuild.sh compile [arch]${NC} - Compilar arquitectura específica"
    echo -e "  ${BLUE}jbuild.sh test${NC}           - Ejecutar tests"
    echo -e "  ${BLUE}jbuild.sh package${NC}        - Empaquetar en JAR"
    echo -e "  ${BLUE}jbuild.sh clean${NC}          - Limpiar archivos generados"
    echo -e "  ${BLUE}jbuild.sh info${NC}           - Mostrar información del proyecto"
    echo -e "  ${BLUE}jbuild.sh run${NC}            - Ejecutar aplicación compilada"
    echo -e "  ${BLUE}jbuild.sh examples${NC}       - Ejecutar ejemplos"
    echo -e "  ${BLUE}jbuild.sh help${NC}           - Mostrar esta ayuda"
    echo -e "  ${BLUE}jbuild.sh version${NC}        - Mostrar versión"
    echo ""
    echo -e "${GREEN}🔧 Opciones de compilación:${NC}"
    echo -e "  ${YELLOW}--fast${NC}        - Compilación rápida"
    echo -e "  ${YELLOW}--parallel${NC}    - Compilación paralela"
    echo -e "  ${YELLOW}--optimize${NC}    - Optimización ASM habilitada"
    echo -e "  ${YELLOW}--clean-first${NC} - Limpiar antes de compilar"
    echo ""
    echo -e "${GREEN}📁 Directorios:${NC}"
    echo -e "  ${PURPLE}Source:${NC}  src/main/java"
    echo -e "  ${PURPLE}Tests:${NC}   src/test/java"
    echo -e "  ${PURPLE}Output:${NC}  target/classes"
    echo ""
    echo -e "${GREEN}📋 Ejemplos:${NC}"
    echo -e "  ${CYAN}jbuild.sh compile${NC}"
    echo -e "  ${CYAN}jbuild.sh compile --parallel --optimize${NC}"
    echo -e "  ${CYAN}jbuild.sh package --fast${NC}"
    echo -e "  ${CYAN}jbuild.sh test --clean-first${NC}"
    echo ""
}

# Función para mostrar versión
show_version() {
    echo -e "${GREEN}📦 Información del Sistema:${NC}"
    echo -e "  ${BLUE}• Proyecto:${NC} $PROJECT_NAME"
    echo -e "  ${BLUE}• Versión:${NC} $VERSION"
    echo -e "  ${BLUE}• Plataforma:${NC} $(uname -s)"
    echo -e "  ${BLUE}• Directorio:${NC} $SCRIPT_DIR"
    
    # Verificar herramientas
    echo -e "  ${BLUE}• Python:${NC}"
    if command -v python3 &> /dev/null; then
        python3 --version 2>&1 | sed 's/^/    /'
    else
        echo -e "    ${RED}No encontrado${NC}"
    fi
    
    echo -e "  ${BLUE}• Java:${NC}"
    if command -v java &> /dev/null; then
        java -version 2>&1 | head -1 | sed 's/^/    /'
    else
        echo -e "    ${RED}No encontrado${NC}"
    fi
    
    echo ""
}

# Función para ejecutar ejemplos
run_examples() {
    echo -e "${GREEN}🎯 Ejecutando ejemplos...${NC}"
    echo ""
    
    if [ -d "examples/demo-project" ]; then
        echo -e "${BLUE}📁 Ejecutando demo desde examples/demo-project${NC}"
        cd examples/demo-project
        
        if [ -f "demo-jbuild-usage.sh" ]; then
            echo -e "${PURPLE}▶️  Ejecutando demo-jbuild-usage.sh${NC}"
            chmod +x demo-jbuild-usage.sh
            ./demo-jbuild-usage.sh
        elif [ -f "jbuild_cli.py" ]; then
            echo -e "${PURPLE}▶️  Ejecutando con CLI${NC}"
            python3 jbuild_cli.py compile
        else
            echo -e "${YELLOW}⚠️  No se encontró CLI de build en el ejemplo${NC}"
        fi
        cd - > /dev/null
    else
        echo -e "${YELLOW}⚠️  No se encontró directorio de ejemplos${NC}"
    fi
    echo ""
}

# Función para limpiar proyecto
clean_project() {
    echo -e "${GREEN}🧹 Limpiando archivos generados...${NC}"
    
    if [ -d "target" ]; then
        echo -e "${BLUE}   Eliminando directorio target/${NC}"
        rm -rf target
    fi
    
    if [ -f "*.log" ]; then
        echo -e "${BLUE}   Eliminando archivos .log${NC}"
        rm -f *.log 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ Limpieza completada${NC}"
    echo ""
}

# Función para compilar proyecto
compile_project() {
    echo -e "${GREEN}🔨 Compilando proyecto...${NC}"
    echo ""
    
    # Verificar si existe estructura de proyecto
    if [ ! -d "src/main/java" ]; then
        echo -e "${YELLOW}⚠️  No se encontró src/main/java${NC}"
        echo -e "${BLUE}   ¿Estás en el directorio correcto del proyecto?${NC}"
        echo -e "${BLUE}   Copiando estructura de ejemplo...${NC}"
        
        if [ -d "examples/demo-project/src" ]; then
            cp -r examples/demo-project/src . 2>/dev/null || true
            echo -e "${GREEN}✅ Estructura de ejemplo copiada${NC}"
        fi
    fi
    
    # Verificar herramientas
    echo -e "${BLUE}🔍 Verificando herramientas...${NC}"
    
    CLI_SCRIPT="$SCRIPT_DIR/bin/jbuild_cli.py"
    if [ -f "$CLI_SCRIPT" ]; then
        if python3 "$CLI_SCRIPT" --help > /dev/null 2>&1; then
            echo -e "${GREEN}✅ CLI de Python encontrado${NC}"
            
            echo -e "${PURPLE}▶️  Ejecutando compilación...${NC}"
            python3 "$CLI_SCRIPT" "$@"
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Compilación completada${NC}"
            else
                echo -e "${RED}❌ Error en la compilación${NC}"
                exit 1
            fi
        else
            echo -e "${YELLOW}⚠️  CLI de Python no disponible, usando métodos alternativos${NC}"
            compile_alternative
        fi
    else
        echo -e "${YELLOW}⚠️  CLI de Python no encontrado${NC}"
        compile_alternative
    fi
    echo ""
}

# Función de compilación alternativa
compile_alternative() {
    echo -e "${CYAN}🔄 Usando método de compilación alternativo...${NC}"
    
    if [ -d "src" ]; then
        echo -e "${BLUE}📁 Encontrados archivos fuente${NC}"
        
        # Contar archivos Java
        java_count=$(find src -name "*.java" -type f 2>/dev/null | wc -l)
        
        if [ "$java_count" -gt 0 ]; then
            echo -e "${BLUE}📝 Encontrados $java_count archivos Java${NC}"
            
            if command -v javac &> /dev/null; then
                echo -e "${PURPLE}▶️  Compilando con javac...${NC}"
                mkdir -p target/classes
                javac -d target/classes -cp "$(find lib -name '*.jar' 2>/dev/null | tr '\n' ':' || echo '')" src/**/*.java
                echo -e "${GREEN}✅ Compilación con javac completada${NC}"
            else
                echo -e "${YELLOW}⚠️  Java no encontrado - estructura creada para compilación posterior${NC}"
                echo -e "${BLUE}   Instala Java 11+ para compilación automática${NC}"
            fi
        else
            echo -e "${BLUE}ℹ️  No se encontraron archivos .java${NC}"
        fi
    else
        echo -e "${BLUE}ℹ️  No se encontró estructura src/ - copiar ejemplos primero${NC}"
    fi
    echo ""
}

# Función para empaquetar
package_project() {
    echo -e "${GREEN}📦 Empaquetando proyecto...${NC}"
    
    if [ ! -d "target/classes" ]; then
        echo -e "${YELLOW}⚠️  No existe target/classes - compilar primero${NC}"
        echo -e "${BLUE}   Ejecutando: jbuild.sh compile${NC}"
        compile_project "$@"
        
        if [ -d "target/classes" ]; then
            echo -e "${GREEN}✅ Compilación completada, continuando con packaging...${NC}"
        else
            echo -e "${RED}❌ No se pudo compilar${NC}"
            return 1
        fi
    fi
    
    # Crear JAR si hay clases compiladas
    class_count=$(find target/classes -name "*.class" -type f 2>/dev/null | wc -l)
    
    if [ "$class_count" -gt 0 ]; then
        echo -e "${BLUE}📝 Encontradas $class_count clases compiladas${NC}"
        
        if command -v jar &> /dev/null; then
            echo -e "${PURPLE}▶️  Creando JAR...${NC}"
            cd target/classes
            jar cvf ../../target/${PROJECT_NAME}.jar . > /dev/null 2>&1
            cd - > /dev/null
            echo -e "${GREEN}✅ JAR creado: target/${PROJECT_NAME}.jar${NC}"
        else
            echo -e "${YELLOW}⚠️  jar no encontrado - usar CLI de Python para packaging avanzado${NC}"
        fi
    else
        echo -e "${BLUE}ℹ️  No hay clases compiladas para empaquetar${NC}"
    fi
    echo ""
}

# Función para ejecutar tests
run_tests() {
    echo -e "${GREEN}🧪 Ejecutando tests...${NC}"
    
    if [ -d "src/test/java" ]; then
        echo -e "${GREEN}✅ Directorio de tests encontrado${NC}"
        
        CLI_SCRIPT="$SCRIPT_DIR/bin/jbuild_cli.py"
        if [ -f "$CLI_SCRIPT" ]; then
            python3 "$CLI_SCRIPT" test
        else
            echo -e "${YELLOW}⚠️  CLI no disponible para tests${NC}"
        fi
    else
        echo -e "${BLUE}ℹ️  No se encontró src/test/java${NC}"
    fi
    echo ""
}

# Función para mostrar información
show_info() {
    echo -e "${GREEN}📋 Información del Proyecto:${NC}"
    echo ""
    
    echo -e "${GREEN}📁 Estructura:${NC}"
    if [ -d "src/main/java" ]; then
        echo -e "  ${GREEN}✅ Source:${NC}  src/main/java"
    else
        echo -e "  ${RED}❌ Source:${NC}  No encontrado"
    fi
    
    if [ -d "src/test/java" ]; then
        echo -e "  ${GREEN}✅ Tests:${NC}   src/test/java"
    else
        echo -e "  ${RED}❌ Tests:${NC}   No encontrado"
    fi
    
    if [ -d "target/classes" ]; then
        echo -e "  ${GREEN}✅ Output:${NC}  target/classes"
    else
        echo -e "  ${RED}❌ Output:${NC}  No encontrado"
    fi
    
    if [ -f "build.jbuild" ]; then
        echo -e "  ${GREEN}✅ Config:${NC}  build.jbuild"
    else
        echo -e "  ${RED}❌ Config:${NC}  No encontrado"
    fi
    
    if [ -d "examples" ]; then
        echo -e "  ${GREEN}✅ Examples:${NC} examples/"
    else
        echo -e "  ${RED}❌ Examples:${NC} No encontrado"
    fi
    
    echo ""
    echo -e "${GREEN}📊 Archivos:${NC}"
    
    src_files=0
    test_files=0
    
    if [ -d "src/main/java" ]; then
        src_files=$(find src/main/java -name "*.java" -type f 2>/dev/null | wc -l)
    fi
    
    if [ -d "src/test/java" ]; then
        test_files=$(find src/test/java -name "*.java" -type f 2>/dev/null | wc -l)
    fi
    
    echo -e "  ${BLUE}📄 Source files:${NC} $src_files"
    echo -e "  ${BLUE}🧪 Test files:${NC}   $test_files"
    echo ""
}

# Función para ejecutar aplicación
run_application() {
    echo -e "${GREEN}▶️  Ejecutando aplicación...${NC}"
    
    if [ -d "target/classes" ]; then
        if [ -f "target/classes/Main.class" ]; then
            echo -e "${PURPLE}🚀 Ejecutando Main.class${NC}"
            java -cp "target/classes:$(find lib -name '*.jar' 2>/dev/null | tr '\n' ':' || echo '')" Main
        else
            echo -e "${BLUE}ℹ️  No se encontró Main.class${NC}"
            echo -e "${BLUE}   Archivos disponibles en target/classes:${NC}"
            ls -1 target/classes/*.class 2>/dev/null || echo "   No hay archivos .class"
        fi
    else
        echo -e "${YELLOW}⚠️  No existe target/classes - compilar primero${NC}"
        echo -e "${BLUE}   Ejecutar: jbuild.sh compile${NC}"
    fi
    echo ""
}

# ========== PROCESAMIENTO DE COMANDOS ==========

# Mostrar header
show_header

# Verificar si se proporcionó un comando
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}💡 Tip: Usa 'jbuild.sh help' para ver comandos disponibles${NC}"
    echo ""
    show_info
    echo ""
    echo -e "${BLUE}📋 Para más información, ejecuta: jbuild.sh help${NC}"
    echo -e "${BLUE}🌐 Documentación: docs/ o README.md${NC}"
    echo ""
    exit 0
fi

COMMAND="$1"
shift

echo -e "${CYAN}💬 Ejecutando: jbuild $COMMAND $*${NC}"
echo ""

# Ejecutar comando correspondiente
case "$COMMAND" in
    help|--help|-h)
        show_help
        ;;
    version|--version|-v)
        show_version
        ;;
    compile)
        compile_project "$@"
        ;;
    clean)
        clean_project
        ;;
    package)
        package_project "$@"
        ;;
    test)
        run_tests
        ;;
    info)
        show_info
        ;;
    run)
        run_application
        ;;
    examples)
        run_examples
        ;;
    *)
        echo -e "${RED}❌ Comando desconocido: $COMMAND${NC}"
        echo -e "${YELLOW}💡 Usa 'jbuild.sh help' para ver comandos disponibles${NC}"
        echo ""
        exit 1
        ;;
esac

echo -e "${BLUE}📋 Para más información, ejecuta: jbuild.sh help${NC}"
echo -e "${BLUE}🌐 Documentación: docs/ o README.md${NC}"
echo ""