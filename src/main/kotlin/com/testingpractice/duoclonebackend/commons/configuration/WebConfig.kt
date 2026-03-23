package com.testingpractice.duoclonebackend.commons.configuration

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.CorsRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
open class WebConfig(
    @Value("\${FRONTEND_ORIGINS}") private val frontendOrigins: String
) : WebMvcConfigurer {

    override fun addCorsMappings(registry: CorsRegistry) {
        val origins = frontendOrigins.split(",").map { it.trim().removeSuffix("/") }
        
        registry.addMapping("/**")
            .allowedOriginPatterns("https://*.judokapro.com.br", "https://judokapro.com.br", "http://localhost:*", *origins.toTypedArray())
            .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true)
    }
}