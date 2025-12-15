package com.jbuild.core.dsl.type_safe;

import java.util.Map;

/**
 * Configuración de build con configuración type-safe
 */
public interface BuildConfig {
    
    /**
     * Configuración de propiedades del proyecto
     */
    BuildConfig property(String key, String value);
    BuildConfig properties(Map<String, String> properties);
    
    /**
     * Configuración de perfiles (profiles)
     */
    BuildConfig profile(String profileName);
    BuildConfig profile(String profileName, boolean active);
    BuildConfig activeProfile(String profileName);
    BuildConfig defaultProfile(String profileName);
    
    /**
     * Configuración de módulos para proyectos multi-módulo
     */
    BuildConfig module(String modulePath);
    BuildConfig modules(String... modulePaths);
    
    /**
     * Configuración de packaging
     */
    BuildConfig packaging(String packaging);
    BuildConfig jar();
    BuildConfig war();
    BuildConfig ear();
    BuildConfig pom();
    
    /**
     * Configuración de versionado
     */
    BuildConfig version(String version);
    BuildConfig artifactId(String artifactId);
    BuildConfig groupId(String groupId);
    
    /**
     * Configuración de recursos
     */
    BuildConfig resource(String directory);
    BuildConfig resources(String... directories);
    BuildConfig testResource(String directory);
    BuildConfig testResources(String... directories);
    
    /**
     * Configuración de inclusion/exclusion de archivos
     */
    BuildConfig include(String pattern);
    BuildConfig includes(String... patterns);
    BuildConfig exclude(String pattern);
    BuildConfig excludes(String... patterns);
    
    /**
     * Configuración de filtrado
     */
    BuildConfig filtering(boolean enable);
    BuildConfig filtering(String... filters);
    
    /**
     * Configuración de compilación
     */
    BuildConfig sourceDirectory(String directory);
    BuildConfig testSourceDirectory(String directory);
    BuildConfig outputDirectory(String directory);
    BuildConfig testOutputDirectory(String directory);
    
    /**
     * Configuración de skip de fases
     */
    BuildConfig skipTests(boolean skip);
    BuildConfig skipITs(boolean skip);
    BuildConfig skipDocumentation(boolean skip);
    
    /**
     * Configuración de offline mode
     */
    BuildConfig offline(boolean offline);
    
    /**
     * Configuración de fail fast
     */
    BuildConfig failFast(boolean failFast);
    BuildConfig failNever(boolean failNever);
    
    /**
     * Configuración de parallel execution
     */
    BuildConfig parallel(boolean parallel);
    BuildConfig threads(int threads);
    
    /**
     * Configuración de reportes
     */
    BuildConfig siteDirectory(String directory);
    BuildConfig reportDirectory(String directory);
    
    /**
     * Configuración de local repository
     */
    BuildConfig localRepository(String path);
    
    /**
     * Configuración de remote repositories
     */
    BuildConfig remoteRepository(String id, String url);
    BuildConfig remoteRepository(String id, String url, boolean snapshots);
    
    /**
     * Configuración de plugin repositories
     */
    BuildConfig pluginRepository(String id, String url);
    BuildConfig pluginRepository(String id, String url, boolean snapshots);
    
    /**
     * Configuración de checksum policies
     */
    BuildConfig checksumPolicy(String policy); // warn, fail, ignore
    BuildConfig updatePolicy(String policy); // always, daily, interval:XXX, never
    
    /**
     * Configuración de release
     */
    BuildConfig release(boolean release);
    BuildConfig snapshot(boolean snapshot);
    
    /**
     * Métodos de configuración predefinida
     */
    BuildConfig withDefaults();
    BuildConfig forLibrary();
    BuildConfig forApplication();
    BuildConfig forWebApp();
    BuildConfig forMultiModule();
    BuildConfig minimal();
    
    /**
     * Métodos de utilidad
     */
    Map<String, String> getProperties();
    boolean isEmpty();
    BuildConfig clear();
    
    /**
     * Finalizar configuración
     */
    BuildProject build();
    
    // Getters
    String getVersion();
    String getArtifactId();
    String getGroupId();
    String getPackaging();
    String getSourceDirectory();
    String getTestSourceDirectory();
    String getOutputDirectory();
    String getTestOutputDirectory();
    String getLocalRepository();
    Map<String, String> getRemoteRepositories();
    Map<String, String> getPluginRepositories();
    String getChecksumPolicy();
    String getUpdatePolicy();
    boolean isRelease();
    boolean isSnapshot();
    boolean isOffline();
    boolean isFailFast();
    boolean isFailNever();
    boolean isParallel();
    int getThreads();
    boolean isSkipTests();
    boolean isSkipITs();
    boolean isSkipDocumentation();
    boolean isFiltering();
    String getSiteDirectory();
    String getReportDirectory();
}