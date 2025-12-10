# JBuild - Guía de Uso Completa

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Instalación](#instalación)
3. [Conceptos Básicos](#conceptos-básicos)
4. [Ejemplos](#ejemplos)
5. [API Referencia](#api-referencia)
6. [Arquitectura](#arquitectura)

## Introducción

**JBuild** es un sistema de compilación de nueva generación para Java que mejora sobre Maven con características innovadoras mientras mantiene compatibilidad con repositorios Maven.

### Ventajas Clave

✅ **DSL Fluido en Java** - Type-safe, autocompletado en IDE  
✅ **Resolución Inteligente** - Dependencias transitivas automáticas  
✅ **Caché Eficiente** - Evita descargas duplicadas  
✅ **Detección de Conflictos** - Identifica versiones conflictivas  
✅ **Multi-Repositorio** - Soporte para múltiples repos Maven  
✅ **Sin XML** - Adiós a archivos POM verbosos  

## Instalación

### Compilar JBuild

```bash
cd jbuild
./compile.sh
```

### Verificar Instalación

```bash
./run-example.sh
```

## Conceptos Básicos

### Estructura de un Build

Todo build de JBuild extiende `BuildConfig` e implementa `configure()`:

```java
import com.jbuild.core.BuildConfig;

public class Build extends BuildConfig {
    @Override
    public void configure() {
        // Configuración aquí
    }
}
```

### Componentes Principales

1. **Project**: Configuración del proyecto
2. **Dependencies**: Gestión de dependencias
3. **Build**: Opciones de compilación

## Ejemplos

### Ejemplo 1: Aplicación Simple

```java
public class SimpleBuild extends BuildConfig {
    @Override
    public void configure() {
        project("my-app", "1.0.0")
            .group("com.mycompany")
            .javaVersion(17);

        dependencies()
            .compile("com.google.code.gson:gson:2.10.1");
    }
}
```

**Ejecutar:**
```bash
javac -cp target/classes SimpleBuild.java
java -cp .:target/classes SimpleBuild
```

### Ejemplo 2: Múltiples Dependencias

```java
public class ExampleBuild extends BuildConfig {
    @Override
    public void configure() {
        project("example-app", "1.0.0")
            .group("com.example")
            .javaVersion(17);

        dependencies()
            .compile("com.google.guava:guava:32.1.3-jre")
            .compile("org.apache.commons:commons-lang3:3.14.0")
            .test("junit:junit:4.13.2");
    }
}
```

### Ejemplo 3: Spring Boot Application

```java
public class SpringBootBuild extends BuildConfig {
    @Override
    public void configure() {
        project("spring-app", "2.0.0")
            .group("com.example.springapp")
            .javaVersion(17);

        dependencies()
            .compile("org.springframework.boot:spring-boot-starter-web:3.2.0")
            .compile("org.springframework.boot:spring-boot-starter-data-jpa:3.2.0")
            .test("org.springframework.boot:spring-boot-starter-test:3.2.0");

        build()
            .enableIncrementalCompilation()
            .enableCache();
    }
}
```

## API Referencia

### Project Configuration

```java
project(String artifactId, String version)
    .group(String groupId)           // Grupo del proyecto
    .javaVersion(int version)        // Versión de Java
    .sourceDir(String path)          // Directorio de código fuente
    .outputDir(String path)          // Directorio de salida
```

### Dependencies

```java
dependencies()
    .compile(String coordinate)      // Dependencia de compilación
    .test(String coordinate)         // Dependencia de test
    .runtime(String coordinate)      // Dependencia de runtime
    .add(Dependency dep)            // Añadir dependencia custom
```

**Formato de Coordenadas:**
```
groupId:artifactId:version[:scope]

Ejemplos:
- "com.google.guava:guava:32.1.3-jre"
- "junit:junit:4.13.2:test"
```

### Build Options

```java
build()
    .enableIncrementalCompilation()  // Compilación incremental (futuro)
    .enableCache()                   // Caché de builds (futuro)
    .parallelModules(boolean)        // Compilación paralela (futuro)
    .outputDir(String path)          // Directorio de salida
```

## Arquitectura

### Módulos

```
jbuild/
├── jbuild-model/          # Modelos de datos
│   ├── Dependency         # Representación de dependencia
│   ├── Project            # Configuración de proyecto
│   └── ResolvedDependency # Dependencia resuelta
│
├── jbuild-dependency/     # Gestión de dependencias
│   ├── MavenRepository    # Interacción con repos Maven
│   ├── PomParser          # Parser de archivos POM
│   └── DependencyResolver # Resolución de dependencias
│
├── jbuild-core/           # Motor principal
│   ├── BuildConfig        # API de configuración
│   └── BuildExecutor      # Ejecución de builds
│
├── jbuild-cli/            # CLI (en desarrollo)
└── jbuild-examples/       # Ejemplos
```

### Flujo de Ejecución

```
1. Usuario define BuildConfig
2. configure() establece proyecto y dependencias
3. BuildExecutor procesa la configuración
4. DependencyResolver descarga desde repos Maven
5. PomParser analiza dependencias transitivas
6. Cache local almacena artefactos
7. Classpath generado para compilación
```

### Cache Local

Los artefactos se almacenan en:
```
~/.jbuild/repository/
  └── groupId/
      └── artifactId/
          └── version/
              ├── artifactId-version.jar
              └── artifactId-version.pom
```

## Características Avanzadas

### Resolución Transitiva

JBuild automáticamente resuelve dependencias transitivas:

```
guava:32.1.3-jre
├── failureaccess:1.0.1
└── listenablefuture:9999.0-empty-to-avoid-conflict-with-guava
```

### Detección de Conflictos

Identifica cuando múltiples versiones del mismo artefacto son requeridas:

```
=== Version Conflicts Detected ===
  com.example:library -> using Multiple versions detected
```

### Multi-Repositorio

Soporta múltiples repositorios Maven:

```java
project.addRepository("https://repo.maven.apache.org/maven2");
project.addRepository("https://jcenter.bintray.com");
```

## Roadmap

### ✅ Fase 1 - Completada
- Gestión de dependencias Maven
- Resolución transitiva
- Caché local
- Detección de conflictos

### 🔄 Próximas Fases

**Fase 2**: Compilación Incremental
- Hash-based change detection
- Análisis de dependencias entre clases

**Fase 3**: Caché Distribuido
- Compartir builds entre desarrolladores
- Reducción de tiempos hasta 80%

**Fase 4**: Paralelización
- Compilación paralela de módulos
- Uso óptimo de CPU

**Fase 5**: Sistema de Plugins
- API extensible
- Hot-reload de plugins

**Fase 6**: Análisis Avanzado
- Dependencias no utilizadas
- Optimización de tamaño

## Comparación con Maven

| Característica | Maven | JBuild |
|----------------|-------|--------|
| Formato Config | XML (pom.xml) | Java DSL |
| Type Safety | ❌ | ✅ |
| IDE Support | Limitado | Autocompletado completo |
| Repositorios | Maven Central | Maven + Custom |
| Caché | Básico | Inteligente + Distribuido |
| Compilación | Secuencial | Paralela (próximo) |
| Incremental | Básico | Hash-based (próximo) |
| Plugins | Complejo | Simple (próximo) |

## Soporte y Contribución

### Reportar Issues

Si encuentras problemas o tienes sugerencias, por favor crea un issue.

### Contribuir

Las contribuciones son bienvenidas! Areas de interés:
- Compilación incremental
- Caché distribuido
- Sistema de plugins
- Análisis de dependencias

## Licencia

MIT License

---

**Creado por**: MiniMax Agent  
**Versión**: 1.0.0 (Fase 1)
