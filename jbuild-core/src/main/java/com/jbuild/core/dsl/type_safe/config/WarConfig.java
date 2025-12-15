package com.jbuild.core.dsl.type_safe.config;

/**
 * Configuración específica para WAR
 */
public class WarConfig {
    private boolean exploded = false;
    
    public WarConfig() {}
    
    public static WarConfig builder() {
        return new WarConfig();
    }
    
    public WarConfig exploded(boolean exploded) {
        this.exploded = exploded;
        return this;
    }
    
    public WarConfig exploded() {
        this.exploded = true;
        return this;
    }
    
    // Getters
    public boolean isExploded() { return exploded; }
}