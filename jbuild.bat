@echo off
REM JBuild Main Script for Windows
REM Script principal nativo para usuarios finales de Windows
REM Uso: jbuild.bat [comando] [opciones]

setlocal enabledelayedexpansion

REM Configuración
set SCRIPT_DIR=%~dp0
set PROJECT_NAME=JBuild Multi-Module System
set VERSION=1.1.0

REM Detectar sistema operativo
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  JBuild Windows v%VERSION%                   ║
echo ║            Multi-Module Build System                         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Función para mostrar ayuda
:show_help
echo 🎯 Comandos disponibles:
echo.
echo   jbuild.bat compile        - Compilar el proyecto
echo   jbuild.bat compile [arch] - Compilar arquitectura específica
echo   jbuild.bat test           - Ejecutar tests
echo   jbuild.bat package        - Empaquetar en JAR
echo   jbuild.bat clean          - Limpiar archivos generados
echo   jbuild.bat info           - Mostrar información del proyecto
echo   jbuild.bat run            - Ejecutar aplicación compilada
echo   jbuild.bat help           - Mostrar esta ayuda
echo   jbuild.bat version        - Mostrar versión
echo   jbuild.bat examples       - Ejecutar ejemplos
echo.
echo 🔧 Opciones de compilación:
echo   --fast        - Compilación rápida
echo   --parallel    - Compilación paralela
echo   --optimize    - Optimización ASM habilitada
echo   --clean-first - Limpiar antes de compilar
echo.
echo 📁 Directorios:
echo   Source:  src\main\java
echo   Tests:   src\test\java
echo   Output:  target\classes
echo.
echo 📋 Ejemplos:
echo   jbuild.bat compile
echo   jbuild.bat compile --parallel --optimize
echo   jbuild.bat package --fast
echo   jbuild.bat test --clean-first
echo.
goto :end

REM Función para mostrar versión
:show_version
echo 📦 Información del Sistema:
echo   • Proyecto: %PROJECT_NAME%
echo   • Versión: %VERSION%
echo   • Plataforma: Windows
echo   • Directorio: %SCRIPT_DIR%
echo   • Python: Verificando...
python --version 2>nul || echo     No encontrado
echo   • Java: Verificando...
java -version 2>nul || echo     No encontrado
echo.
goto :end

REM Función para ejecutar ejemplos
:run_examples
echo 🎯 Ejecutando ejemplos...
echo.
if exist "examples\demo-project" (
    echo 📁 Ejecutando demo desde examples\demo-project
    cd examples\demo-project
    if exist "demo-jbuild-usage.bat" (
        echo ▶️  Ejecutando demo-jbuild-usage.bat
        call demo-jbuild-usage.bat
    ) else if exist "jbuild_cli.py" (
        echo ▶️  Ejecutando con CLI
        python jbuild_cli.py compile
    ) else (
        echo ⚠️  No se encontró CLI de build en el ejemplo
    )
    cd ..\..
) else (
    echo ⚠️  No se encontró directorio de ejemplos
)
echo.
goto :end

REM Función para limpiar proyecto
:clean_project
echo 🧹 Limpiando archivos generados...
if exist "target" (
    echo   Eliminando directorio target\
    rmdir /s /q target
)
if exist "*.log" (
    echo   Eliminando archivos .log
    del /q *.log 2>nul
)
echo ✅ Limpieza completada
echo.
goto :end

REM Función para compilar proyecto
:compile_project
echo 🔨 Compilando proyecto...
echo.

REM Verificar si existe estructura de proyecto
if not exist "src\main\java" (
    echo ⚠️  No se encontró src\main\java
    echo    ¿Estás en el directorio correcto del proyecto?
    echo    Copiando estructura de ejemplo...
    
    if exist "examples\demo-project\src" (
        xcopy "examples\demo-project\src" "src\" /e /i /y
        echo ✅ Estructura de ejemplo copiada
    )
)

REM Verificar Java
echo 🔍 Verificando herramientas...
python "%SCRIPT_DIR%bin\jbuild_cli.py" %* >nul 2>&1
if errorlevel 1 (
    echo ⚠️  CLI de Python no disponible, usando métodos alternativos
    goto :compile_alternative
) else (
    echo ✅ CLI de Python encontrado
)

echo ▶️  Ejecutando compilación...
python "%SCRIPT_DIR%bin\jbuild_cli.py" compile
if errorlevel 1 (
    echo ❌ Error en la compilación
    goto :end
)
echo ✅ Compilación completada
goto :end

:compile_alternative
echo 🔄 Usando método de compilación alternativo...
if exist "src\main\java" (
    echo 📁 Encontrados archivos fuente
    
    REM Contar archivos Java
    set /a java_count=0
    for /f %%i in ('dir /s /b "src\*.java" 2^>nul') do set /a java_count+=1
    
    if !java_count! gtr 0 (
        echo 📝 Encontrados !java_count! archivos Java
        echo ⚠️  Java no encontrado - estructura creada para compilación posterior
        echo    Instala Java 11+ para compilación automática
    ) else (
        echo ℹ️  No se encontraron archivos .java
    )
) else (
    echo ℹ️  No se encontró estructura src\ - copiar ejemplos primero
)

echo.
goto :end

REM Función para empaquetar
:package_project
echo 📦 Empaquetando proyecto...
if not exist "target\classes" (
    echo ⚠️  No existe target\classes - compilar primero
    echo    Ejecutando: jbuild.bat compile
    call :compile_project
    if exist "target\classes" (
        echo ✅ Compilación completada, continuando con packaging...
    ) else (
        echo ❌ No se pudo compilar
        goto :end
    )
)

REM Crear JAR si hay clases compiladas
set /a class_count=0
for /f %%i in ('dir /s /b "target\classes\*.class" 2^>nul') do set /a class_count+=1

if !class_count! gtr 0 (
    echo 📝 Encontradas !class_count! clases compiladas
    echo ⚠️  JAR creado manualmente sería básico
    echo    Usar CLI de Python para packaging avanzado
) else (
    echo ℹ️  No hay clases compiladas para empaquetar
)

goto :end

REM Función para ejecutar tests
:run_tests
echo 🧪 Ejecutando tests...
if exist "src\test\java" (
    echo ✅ Directorio de tests encontrado
    python "%SCRIPT_DIR%bin\jbuild_cli.py" test
) else (
    echo ℹ️  No se encontró src\test\java
)
goto :end

REM Función para mostrar información
:show_info
echo 📋 Información del Proyecto:
echo.
echo 📁 Estructura:
if exist "src\main\java" (echo   ✅ Source:  src\main\java) else (echo   ❌ Source:  No encontrado)
if exist "src\test\java" (echo   ✅ Tests:   src\test\java) else (echo   ❌ Tests:   No encontrado)
if exist "target\classes" (echo   ✅ Output:  target\classes) else (echo   ❌ Output:  No encontrado)
if exist "build.jbuild" (echo   ✅ Config:  build.jbuild) else (echo   ❌ Config:  No encontrado)
if exist "examples" (echo   ✅ Examples: examples\) else (echo   ❌ Examples: No encontrado)
echo.

echo 📊 Archivos:
set /a src_files=0
set /a test_files=0

if exist "src\main\java" (
    for /f %%i in ('dir /s /b "src\main\java\*.java" 2^>nul') do set /a src_files+=1
)
if exist "src\test\java" (
    for /f %%i in ('dir /s /b "src\test\java\*.java" 2^>nul') do set /a test_files+=1
)

echo   📄 Source files: !src_files!
echo   🧪 Test files:   !test_files!

echo.
goto :end

REM Función para ejecutar aplicación
:run_application
echo ▶️  Ejecutando aplicación...
if exist "target\classes" (
    if exist "target\classes\Main.class" (
        echo 🚀 Ejecutando Main.class
        java -cp "target\classes;lib\*" Main
    ) else (
        echo ℹ️  No se encontró Main.class
        echo    Archivos disponibles en target\classes:
        dir /b "target\classes\*.class" 2>nul
    )
) else (
    echo ⚠️  No existe target\classes - compilar primero
    echo    Ejecutar: jbuild.bat compile
)
goto :end

REM ========== PROCESAMIENTO DE COMANDOS ==========

REM Verificar si se proporcionó un comando
if "%~1"=="" (
    echo 💡 Tip: Usa 'jbuild.bat help' para ver comandos disponibles
    echo.
    call :show_info
    goto :end
)

REM Procesar comando
set COMMAND=%~1
set OPTIONS=%*

REM Remover el primer parámetro de las opciones
for /f "tokens=2*" %%a in ("%OPTIONS%") do set OPTIONS=%%b

echo 💬 Ejecutando: jbuild %COMMAND% %OPTIONS%
echo.

REM Ejecutar comando correspondiente
if /i "%COMMAND%"=="help" goto :show_help
if /i "%COMMAND%"=="--help" goto :show_help
if /i "%COMMAND%"=="-h" goto :show_help

if /i "%COMMAND%"=="version" goto :show_version
if /i "%COMMAND%"=="--version" goto :show_version
if /i "%COMMAND%"=="-v" goto :show_version

if /i "%COMMAND%"=="compile" goto :compile_project
if /i "%COMMAND%"=="clean" goto :clean_project
if /i "%COMMAND%"=="package" goto :package_project
if /i "%COMMAND%"=="test" goto :run_tests
if /i "%COMMAND%"=="info" goto :show_info
if /i "%COMMAND%"=="run" goto :run_application
if /i "%COMMAND%"=="examples" goto :run_examples

REM Comando desconocido
echo ❌ Comando desconocido: %COMMAND%
echo 💡 Usa 'jbuild.bat help' para ver comandos disponibles
echo.

:end
echo 📋 Para más información, ejecuta: jbuild.bat help
echo 🌐 Documentación: docs\ o README.md
echo.
pause