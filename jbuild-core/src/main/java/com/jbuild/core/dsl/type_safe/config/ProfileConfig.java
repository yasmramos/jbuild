package com.jbuild.core.dsl.type_safe.config;

import java.util.List;

/**
 * Configuración de perfiles
 */
public class ProfileConfig {
    private String name;
    private String activateIf;
    private List<String> properties;
    
    public ProfileConfig() {}
    
    public static ProfileConfig builder() {
        return new ProfileConfig();
    }
    
    public ProfileConfig name(String name) {
        this.name = name;
        return this;
    }
    
    public ProfileConfig activateIf(String activateIf) {
        this.activateIf = activateIf;
        return this;
    }
    
    public ProfileConfig properties(List<String> properties) {
        this.properties = properties;
        return this;
    }
    
    // Getters
    public String getName() { return name; }
    public String getActivateIf() { return activateIf; }
    public List<String> getProperties() { return properties; }
}