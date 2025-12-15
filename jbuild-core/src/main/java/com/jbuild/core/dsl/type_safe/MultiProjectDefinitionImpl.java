package com.jbuild.core.dsl.type_safe;

import java.util.ArrayList;
import java.util.List;

/**
 * Implementación de MultiProjectDefinition
 */
class MultiProjectDefinitionImpl implements MultiProjectDefinition {
    private final String name;
    private final String version;
    private String groupId;
    private String artifactId;
    private String description;
    private final List<ModuleDefinition> modules = new ArrayList<>();
    
    public MultiProjectDefinitionImpl(String name, String version) {
        this.name = name;
        this.version = version;
        this.artifactId = name;
    }
    
    @Override
    public MultiProjectDefinition groupId(String groupId) {
        this.groupId = groupId;
        return this;
    }
    
    @Override
    public MultiProjectDefinition artifactId(String artifactId) {
        this.artifactId = artifactId;
        return this;
    }
    
    @Override
    public MultiProjectDefinition version(String version) {
        // Version is set in constructor, this is for fluent interface
        return this;
    }
    
    @Override
    public MultiProjectDefinition description(String description) {
        this.description = description;
        return this;
    }
    
    @Override
    public ModuleDefinition addModule(String name) {
        ModuleDefinitionImpl module = new ModuleDefinitionImpl(name, this);
        modules.add(module);
        return module;
    }
    
    @Override
    public MultiProjectDefinition modules(String... moduleNames) {
        for (String moduleName : moduleNames) {
            addModule(moduleName);
        }
        return this;
    }
    
    @Override
    public DependenciesDefinition dependencies() {
        return new DependenciesDefinitionImpl(this);
    }
    
    @Override
    public JavaConfigDefinition javaConfig() {
        return new JavaConfigDefinitionImpl(this);
    }
    
    @Override
    public PerformanceDefinition performance() {
        return new PerformanceDefinitionImpl(this);
    }
    
    @Override
    public PluginsDefinition plugins() {
        return new PluginsDefinitionImpl(this);
    }
    
    @Override
    public RepositoriesDefinition repositories() {
        return new RepositoriesDefinitionImpl(this);
    }
    
    @Override
    public MultiProjectDefinition configuredWith(java.util.function.Consumer<MultiProjectDefinition> configurer) {
        configurer.accept(this);
        return this;
    }
    
    public MultiProjectDefinition build() {
        // TODO: Implement when BuildProject is available
        return this;
    }
    
    @Override
    public MultiProjectDefinition javaVersion(int version) {
        // TODO: Implement when JavaConfigDefinition is available
        return this;
    }
    
    @Override
    public MultiProjectDefinition withDefaults() {
        return this
            .description("Proyecto multi-módulo generado con JBuild")
            .version(this.version);
    }
    
    public Object buildDefinition() {
        return new com.jbuild.core.dsl.type_safe.config.BuildDefinitionImpl(this);
    }
    
    // Getters
    public String getName() { return name; }
    public String getVersion() { return version; }
    public String getGroupId() { return groupId; }
    public String getArtifactId() { return artifactId; }
    public String getDescription() { return description; }
    public List<ModuleDefinition> getModules() { return new ArrayList<>(modules); }
}