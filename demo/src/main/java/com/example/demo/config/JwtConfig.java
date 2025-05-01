package com.example.demo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
 

@Component
public class JwtConfig {
  
  @Value("${jwt.expiration}")
  long expiration;

  @Value("${jwt.refresh-expiration}")
  long refreshExpiration;

  @Value("${jwt.secret}")
  String secret;
  
  public long getExpiration() {
    return expiration;
  }

  public long getRefreshExpiration() {
    return refreshExpiration;
  }

  public String getSecret() {
    return secret;
  }

}