package com.jbuild.core.dsl.type_safe.config;

import java.util.List;

/**
 * Configuración de assembly
 */
public class AssemblyConfig {
    private AssemblyFormat format;
    private List<String> includes;
    private List<String> excludes;
    
    public AssemblyConfig() {}
    
    public static AssemblyConfig builder() {
        return new AssemblyConfig();
    }
    
    public AssemblyConfig format(AssemblyFormat format) {
        this.format = format;
        return this;
    }
    
    public AssemblyConfig includes(List<String> includes) {
        this.includes = includes;
        return this;
    }
    
    public AssemblyConfig excludes(List<String> excludes) {
        this.excludes = excludes;
        return this;
    }
    
    // Getters
    public AssemblyFormat getFormat() { return format; }
    public List<String> getIncludes() { return includes; }
    public List<String> getExcludes() { return excludes; }
    
    public enum AssemblyFormat {
        JAR, ZIP, TAR, TAR_GZ
    }
}