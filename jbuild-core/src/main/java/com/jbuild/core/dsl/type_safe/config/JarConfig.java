package com.jbuild.core.dsl.type_safe.config;

/**
 * Configuración específica para JAR
 */
public class JarConfig {
    private String mainClass;
    private boolean executable = false;
    
    public JarConfig() {}
    
    public static JarConfig builder() {
        return new JarConfig();
    }
    
    public JarConfig mainClass(String mainClass) {
        this.mainClass = mainClass;
        return this;
    }
    
    public JarConfig executable(boolean executable) {
        this.executable = executable;
        return this;
    }
    
    public JarConfig executable() {
        this.executable = true;
        return this;
    }
    
    // Getters
    public String getMainClass() { return mainClass; }
    public boolean isExecutable() { return executable; }
}