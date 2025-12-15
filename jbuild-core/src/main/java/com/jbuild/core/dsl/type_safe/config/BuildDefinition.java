package com.jbuild.core.dsl.type_safe.config;

/**
 * Definición de build que permite configurar aspectos finales del proceso de construcción
 */
public interface BuildDefinition {
    
    /**
     * Configuración de manifest
     */
    BuildDefinition manifest(Object manifest);
    
    /**
     * Configuración de JAR
     */
    BuildDefinition jar(Object jar);
    
    /**
     * Configuración de WAR
     */
    BuildDefinition war(Object war);
    
    /**
     * Configuración de assembly
     */
    BuildDefinition assembly(Object assembly);
    
    /**
     * Configuración de perfiles
     */
    BuildDefinition profiles(Object profiles);
}