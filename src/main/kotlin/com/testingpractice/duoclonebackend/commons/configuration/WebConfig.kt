package com.testingpractice.duoclonebackend.commons.configuration

import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.web.servlet.FilterRegistrationBean
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.Ordered
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.UrlBasedCorsConfigurationSource
import org.springframework.web.filter.CorsFilter

@Configuration
open class WebConfig(
    @Value("\${FRONTEND_ORIGINS}") private val frontendOrigins: String
) {

    @Bean
    open fun customCorsFilter(): FilterRegistrationBean<CorsFilter> {
        val configuration = CorsConfiguration()
        val origins = frontendOrigins.split(",").map { it.trim().removeSuffix("/") }.toTypedArray()
        
        configuration.allowedOriginPatterns = listOf("https://*.judokapro.com.br", "https://judokapro.com.br", "http://localhost:*", *origins)
        configuration.allowedMethods = listOf("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
        configuration.allowedHeaders = listOf("Authorization", "Cache-Control", "Content-Type", "Accept", "X-Requested-With", "Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers")
        configuration.allowCredentials = true

        val source = UrlBasedCorsConfigurationSource()
        source.registerCorsConfiguration("/**", configuration)
        
        val bean = FilterRegistrationBean(CorsFilter(source))
        bean.order = Ordered.HIGHEST_PRECEDENCE
        return bean
    }
}