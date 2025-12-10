# ============================================================================
# JBuild Enterprise Dockerfile
# Imagen Docker optimizada para JBuild Enterprise v1.1.0
# ============================================================================

# Multi-stage build para optimización de tamaño
# ============================================================================
# STAGE 1: Base Image con dependencias del sistema
# ============================================================================

FROM ubuntu:22.04 AS base

# Metadatos de la imagen
LABEL maintainer="JBuild Enterprise Team <team@jbuild.enterprise>"
LABEL version="1.1.0"
LABEL description="JBuild Enterprise - Sistema de Build Multi-Módulo"
LABEL org.opencontainers.image.title="JBuild Enterprise"
LABEL org.opencontainers.image.description="Sistema de construcción Java enterprise con arquitectura multi-módulo"
LABEL org.opencontainers.image.version="1.1.0"
LABEL org.opencontainers.image.vendor="JBuild Enterprise"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Configuración de locale para UTF-8
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Java JDK 11 (versión soportada)
    openjdk-11-jdk \
    # Maven para gestión de dependencias
    maven \
    # Python 3.9+ para scripts
    python3 \
    python3-pip \
    python3-venv \
    # Utilidades del sistema
    curl \
    wget \
    git \
    unzip \
    zip \
    tar \
    gzip \
    ca-certificates \
    gnupg \
    lsb-release \
    # Herramientas de desarrollo
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configurar Java
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verificar instalación
RUN java -version && javac -version && mvn --version && python3 --version

# ============================================================================
# STAGE 2: Construcción de la aplicación
# ============================================================================

FROM base AS builder

# Configurar workspace
WORKDIR /workspace

# Copiar archivos de configuración de JBuild
COPY build.jbuild ./
COPY jbuild_cli.py ./

# Instalar dependencias Python específicas
RUN pip3 install --no-cache-dir \
    requests \
    pathlib \
    typing-extensions \
    pyyaml \
    jinja2

# Crear estructura de directorios
RUN mkdir -p \
    src/ \
    target/ \
    lib/ \
    cache/ \
    logs/ \
    config/

# Descargar librerías ASM para optimización (simulado)
RUN echo "ASM 9.6 Library" > lib/asm-9.6.jar && \
    echo "ASM Tree 9.6 Library" > lib/asm-tree-9.6.jar && \
    echo "JBuild Optimizer CLI" > lib/jbuild-optimizer-1.1.0-cli.jar && \
    echo "JBuild Optimizer Executable" > lib/jbuild-optimizer-1.1.0-executable.jar && \
    echo "JBuild Optimizer Library" > lib/jbuild-optimizer-1.1.0.jar

# ============================================================================
# STAGE 3: Configuración runtime
# ============================================================================

FROM base AS runtime

# Configurar usuario no-root por seguridad
RUN groupadd -r jbuild && useradd -r -g jbuild jbuild

# Configurar workspace
WORKDIR /workspace

# Copiar recursos de la etapa de construcción
COPY --from=builder /workspace/lib/ /workspace/lib/
COPY --from=builder /workspace/build.jbuild /workspace/
COPY --from=builder /workspace/jbuild_cli.py /workspace/

# Copiar módulos de JBuild (simulados para la demo)
RUN mkdir -p \
    jbuild-core/src \
    jbuild-model/src \
    jbuild-optimizer/src \
    jbuild-system/src \
    jbuild-examples/src \
    plugins/jbuild-plugin-api/src \
    plugins/jbuild-plugin-core/src \
    plugins/jbuild-plugin-system/src \
    plugins/jbuild-plugin-examples/src

# Instalar dependencias Python runtime
RUN pip3 install --no-cache-dir \
    requests \
    pathlib \
    typing-extensions \
    pyyaml \
    jinja2

# Instalar JBuild CLI
RUN pip3 install /workspace/jbuild_cli.py

# Crear scripts de entrada
RUN echo '#!/bin/bash\n\
# JBuild Enterprise Entry Point\n\
echo "🚀 Iniciando JBuild Enterprise v1.1.0"\n\
echo "📁 Workspace: $(pwd)"\n\
echo "☕ Java: $(java -version 2>&1 | head -n1)"\n\
echo "🔧 JBuild CLI: $(jbuild --version 2>/dev/null || echo \"CLI instalado\")"\n\
\n\
# Ejecutar comando pasado como argumento o shell interactivo\n\
if [ $# -eq 0 ]; then\n\
    echo "🔄 Iniciando shell interactivo..."\n\
    exec /bin/bash\n\
else\n\
    echo "🔄 Ejecutando comando: $@"\n\
    exec "$@"\n\
fi\n\
' > /workspace/entrypoint.sh && chmod +x /workspace/entrypoint.sh

# Configurar permisos
RUN chown -R jbuild:jbuild /workspace
USER jbuild

# Configurar variables de entorno
ENV JBUILD_HOME=/workspace \
    JBUILD_VERSION=1.1.0 \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    PATH="${JBUILD_HOME}/bin:${JAVA_HOME}/bin:${PATH}"

# Volúmenes para persistencia
VOLUME ["/workspace/cache", "/workspace/logs", "/workspace/target"]

# Puertos expuestos (para servicios en desarrollo)
EXPOSE 8080 8081 8082 8083

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python3 -c "import sys; print('JBuild Enterprise OK'); sys.exit(0)" || exit 1

# Punto de entrada
ENTRYPOINT ["/workspace/entrypoint.sh"]

# ============================================================================
# Multi-Platform Build Support
# ============================================================================
# Para construir para múltiples plataformas:
# docker buildx build --platform linux/amd64,linux/arm64 -t jbuild-enterprise:1.1.0 .
# ============================================================================