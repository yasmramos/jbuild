package com.jbuild.core.dsl.type_safe;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Implementación de BuildConfig
 */
class BuildConfigImpl implements BuildConfig {
    
    // Configuración básica del proyecto
    private String version = "1.0.0";
    private String artifactId;
    private String groupId;
    private String packaging = "jar";
    
    // Directorios
    private String sourceDirectory = "src/main/java";
    private String testSourceDirectory = "src/test/java";
    private String outputDirectory = "target/classes";
    private String testOutputDirectory = "target/test-classes";
    private String siteDirectory = "target/site";
    private String reportDirectory = "target/reports";
    
    // Repositorios
    private String localRepository = "${user.home}/.m2/repository";
    private final Map<String, String> remoteRepositories = new HashMap<>();
    private final Map<String, String> pluginRepositories = new HashMap<>();
    
    // Propiedades y configuraciones
    private final Map<String, String> properties = new HashMap<>();
    private final List<String> profiles = new ArrayList<>();
    private final List<String> activeProfiles = new ArrayList<>();
    private String defaultProfile;
    
    // Módulos
    private final List<String> modules = new ArrayList<>();
    
    // Recursos
    private final List<String> resources = new ArrayList<>();
    private final List<String> testResources = new ArrayList<>();
    private final List<String> includes = new ArrayList<>();
    private final List<String> excludes = new ArrayList<>();
    private final List<String> filters = new ArrayList<>();
    private boolean filtering = false;
    
    // Configuración de ejecución
    private boolean skipTests = false;
    private boolean skipITs = false;
    private boolean skipDocumentation = false;
    private boolean offline = false;
    private boolean failFast = false;
    private boolean failNever = false;
    private boolean parallel = false;
    private int threads = Runtime.getRuntime().availableProcessors();
    
    // Configuración de release
    private boolean release = false;
    private boolean snapshot = true;
    
    // Configuración de políticas
    private String checksumPolicy = "warn";
    private String updatePolicy = "daily";
    
    public BuildConfigImpl() {
        // Constructor por defecto
    }
    
    @Override
    public BuildConfig property(String key, String value) {
        properties.put(key, value);
        return this;
    }
    
    @Override
    public BuildConfig properties(Map<String, String> properties) {
        this.properties.putAll(properties);
        return this;
    }
    
    @Override
    public BuildConfig profile(String profileName) {
        profiles.add(profileName);
        return this;
    }
    
    @Override
    public BuildConfig profile(String profileName, boolean active) {
        profiles.add(profileName);
        if (active) {
            activeProfiles.add(profileName);
        }
        return this;
    }
    
    @Override
    public BuildConfig activeProfile(String profileName) {
        activeProfiles.add(profileName);
        return this;
    }
    
    @Override
    public BuildConfig defaultProfile(String profileName) {
        this.defaultProfile = profileName;
        return this;
    }
    
    @Override
    public BuildConfig module(String modulePath) {
        modules.add(modulePath);
        return this;
    }
    
    @Override
    public BuildConfig modules(String... modulePaths) {
        for (String modulePath : modulePaths) {
            modules.add(modulePath);
        }
        return this;
    }
    
    @Override
    public BuildConfig packaging(String packaging) {
        this.packaging = packaging;
        return this;
    }
    
    @Override
    public BuildConfig jar() {
        return packaging("jar");
    }
    
    @Override
    public BuildConfig war() {
        return packaging("war");
    }
    
    @Override
    public BuildConfig ear() {
        return packaging("ear");
    }
    
    @Override
    public BuildConfig pom() {
        return packaging("pom");
    }
    
    @Override
    public BuildConfig version(String version) {
        this.version = version;
        return this;
    }
    
    @Override
    public BuildConfig artifactId(String artifactId) {
        this.artifactId = artifactId;
        return this;
    }
    
    @Override
    public BuildConfig groupId(String groupId) {
        this.groupId = groupId;
        return this;
    }
    
    @Override
    public BuildConfig resource(String directory) {
        resources.add(directory);
        return this;
    }
    
    @Override
    public BuildConfig resources(String... directories) {
        for (String directory : directories) {
            resources.add(directory);
        }
        return this;
    }
    
    @Override
    public BuildConfig testResource(String directory) {
        testResources.add(directory);
        return this;
    }
    
    @Override
    public BuildConfig testResources(String... directories) {
        for (String directory : directories) {
            testResources.add(directory);
        }
        return this;
    }
    
    @Override
    public BuildConfig include(String pattern) {
        includes.add(pattern);
        return this;
    }
    
    @Override
    public BuildConfig includes(String... patterns) {
        for (String pattern : patterns) {
            includes.add(pattern);
        }
        return this;
    }
    
    @Override
    public BuildConfig exclude(String pattern) {
        excludes.add(pattern);
        return this;
    }
    
    @Override
    public BuildConfig excludes(String... patterns) {
        for (String pattern : patterns) {
            excludes.add(pattern);
        }
        return this;
    }
    
    @Override
    public BuildConfig filtering(boolean enable) {
        this.filtering = enable;
        return this;
    }
    
    @Override
    public BuildConfig filtering(String... filters) {
        this.filtering = true;
        for (String filter : filters) {
            this.filters.add(filter);
        }
        return this;
    }
    
    @Override
    public BuildConfig sourceDirectory(String directory) {
        this.sourceDirectory = directory;
        return this;
    }
    
    @Override
    public BuildConfig testSourceDirectory(String directory) {
        this.testSourceDirectory = directory;
        return this;
    }
    
    @Override
    public BuildConfig outputDirectory(String directory) {
        this.outputDirectory = directory;
        return this;
    }
    
    @Override
    public BuildConfig testOutputDirectory(String directory) {
        this.testOutputDirectory = directory;
        return this;
    }
    
    @Override
    public BuildConfig skipTests(boolean skip) {
        this.skipTests = skip;
        return this;
    }
    
    @Override
    public BuildConfig skipITs(boolean skip) {
        this.skipITs = skip;
        return this;
    }
    
    @Override
    public BuildConfig skipDocumentation(boolean skip) {
        this.skipDocumentation = skip;
        return this;
    }
    
    @Override
    public BuildConfig offline(boolean offline) {
        this.offline = offline;
        return this;
    }
    
    @Override
    public BuildConfig failFast(boolean failFast) {
        this.failFast = failFast;
        return this;
    }
    
    @Override
    public BuildConfig failNever(boolean failNever) {
        this.failNever = failNever;
        return this;
    }
    
    @Override
    public BuildConfig parallel(boolean parallel) {
        this.parallel = parallel;
        return this;
    }
    
    @Override
    public BuildConfig threads(int threads) {
        this.threads = threads;
        return this;
    }
    
    @Override
    public BuildConfig siteDirectory(String directory) {
        this.siteDirectory = directory;
        return this;
    }
    
    @Override
    public BuildConfig reportDirectory(String directory) {
        this.reportDirectory = directory;
        return this;
    }
    
    @Override
    public BuildConfig localRepository(String path) {
        this.localRepository = path;
        return this;
    }
    
    @Override
    public BuildConfig remoteRepository(String id, String url) {
        remoteRepositories.put(id, url);
        return this;
    }
    
    @Override
    public BuildConfig remoteRepository(String id, String url, boolean snapshots) {
        String fullUrl = snapshots ? url + "/snapshots" : url;
        remoteRepositories.put(id, fullUrl);
        return this;
    }
    
    @Override
    public BuildConfig pluginRepository(String id, String url) {
        pluginRepositories.put(id, url);
        return this;
    }
    
    @Override
    public BuildConfig pluginRepository(String id, String url, boolean snapshots) {
        String fullUrl = snapshots ? url + "/snapshots" : url;
        pluginRepositories.put(id, fullUrl);
        return this;
    }
    
    @Override
    public BuildConfig checksumPolicy(String policy) {
        this.checksumPolicy = policy;
        return this;
    }
    
    @Override
    public BuildConfig updatePolicy(String policy) {
        this.updatePolicy = policy;
        return this;
    }
    
    @Override
    public BuildConfig release(boolean release) {
        this.release = release;
        this.snapshot = !release;
        return this;
    }
    
    @Override
    public BuildConfig snapshot(boolean snapshot) {
        this.snapshot = snapshot;
        this.release = !snapshot;
        return this;
    }
    
    @Override
    public BuildConfig withDefaults() {
        return this
            .jar()
            .version("1.0.0")
            .sourceDirectory("src/main/java")
            .testSourceDirectory("src/test/java")
            .parallel(true)
            .checksumPolicy("warn")
            .updatePolicy("daily");
    }
    
    @Override
    public BuildConfig forLibrary() {
        return this
            .jar()
            .skipITs(true)
            .skipDocumentation(false)
            .failFast(true);
    }
    
    @Override
    public BuildConfig forApplication() {
        return this
            .jar()
            .skipTests(false)
            .parallel(true)
            .failFast(true);
    }
    
    @Override
    public BuildConfig forWebApp() {
        return this
            .war()
            .skipTests(false)
            .skipDocumentation(false)
            .parallel(true);
    }
    
    @Override
    public BuildConfig forMultiModule() {
        return this
            .pom()
            .skipTests(true)
            .skipITs(true)
            .skipDocumentation(false)
            .parallel(true);
    }
    
    @Override
    public BuildConfig minimal() {
        return this
            .jar()
            .skipTests(true)
            .skipITs(true)
            .skipDocumentation(true)
            .parallel(false)
            .offline(true);
    }
    
    @Override
    public Map<String, String> getProperties() {
        return new HashMap<>(properties);
    }
    
    @Override
    public boolean isEmpty() {
        return properties.isEmpty() && 
               profiles.isEmpty() && 
               modules.isEmpty() && 
               resources.isEmpty() && 
               testResources.isEmpty();
    }
    
    @Override
    public BuildConfig clear() {
        properties.clear();
        profiles.clear();
        modules.clear();
        resources.clear();
        testResources.clear();
        includes.clear();
        excludes.clear();
        filters.clear();
        return this;
    }
    
    @Override
    public BuildProject build() {
        return new BuildProject(this);
    }
    
    // Getters
    @Override
    public String getVersion() { return version; }
    
    @Override
    public String getArtifactId() { return artifactId; }
    
    @Override
    public String getGroupId() { return groupId; }
    
    @Override
    public String getPackaging() { return packaging; }
    
    @Override
    public String getSourceDirectory() { return sourceDirectory; }
    
    @Override
    public String getTestSourceDirectory() { return testSourceDirectory; }
    
    @Override
    public String getOutputDirectory() { return outputDirectory; }
    
    @Override
    public String getTestOutputDirectory() { return testOutputDirectory; }
    
    @Override
    public String getLocalRepository() { return localRepository; }
    
    @Override
    public Map<String, String> getRemoteRepositories() { return new HashMap<>(remoteRepositories); }
    
    @Override
    public Map<String, String> getPluginRepositories() { return new HashMap<>(pluginRepositories); }
    
    @Override
    public String getChecksumPolicy() { return checksumPolicy; }
    
    @Override
    public String getUpdatePolicy() { return updatePolicy; }
    
    @Override
    public boolean isRelease() { return release; }
    
    @Override
    public boolean isSnapshot() { return snapshot; }
    
    @Override
    public boolean isOffline() { return offline; }
    
    @Override
    public boolean isFailFast() { return failFast; }
    
    @Override
    public boolean isFailNever() { return failNever; }
    
    @Override
    public boolean isParallel() { return parallel; }
    
    @Override
    public int getThreads() { return threads; }
    
    @Override
    public boolean isSkipTests() { return skipTests; }
    
    @Override
    public boolean isSkipITs() { return skipITs; }
    
    @Override
    public boolean isSkipDocumentation() { return skipDocumentation; }
    
    @Override
    public boolean isFiltering() { return filtering; }
    
    @Override
    public String getSiteDirectory() { return siteDirectory; }
    
    @Override
    public String getReportDirectory() { return reportDirectory; }
    
    // Getters adicionales
    public List<String> getProfiles() { return new ArrayList<>(profiles); }
    public List<String> getActiveProfiles() { return new ArrayList<>(activeProfiles); }
    public String getDefaultProfile() { return defaultProfile; }
    public List<String> getModules() { return new ArrayList<>(modules); }
    public List<String> getResources() { return new ArrayList<>(resources); }
    public List<String> getTestResources() { return new ArrayList<>(testResources); }
    public List<String> getIncludes() { return new ArrayList<>(includes); }
    public List<String> getExcludes() { return new ArrayList<>(excludes); }
    public List<String> getFilters() { return new ArrayList<>(filters); }
    
    @Override
    public BuildProject build() {
        return new BuildProject(this);
    }
}