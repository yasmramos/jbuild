@echo off
REM Script para compilar usando el CLI de JBuild después del build inicial

echo 🔧 Compilando con JBuild CLI...
call jbuild.bat compile

pause
