package com.capitual.processors;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReadableMap;

import java.util.Map;

public class FaceConfig {
  private final Map config;

  public FaceConfig(ReadableMap config) {
    this.config = config.toHashMap();
  }

  private boolean hasProperty(String key) {
    if (this.config == null) {
      return false;
    }

    return !this.config.isEmpty() || this.config.containsKey(key);
  }

  private String getValue(String key) {
    return this.hasProperty(key) ? this.config.get(key).toString() : null;
  }

  public boolean isWhichFlow(@NonNull KeyFaceProcessor keyFlow, String key) {
    return keyFlow.toString().equalsIgnoreCase(key);
  }

  public String getKey() {
    if (this.hasProperty("key")) {
      final String key = this.getValue("key");
      final boolean isAuthenticate = this.isWhichFlow(KeyFaceProcessor.authenticateMessage, key);
      final boolean isEnroll = this.isWhichFlow(KeyFaceProcessor.enrollMessage, key);
      final boolean isLiveness = this.isWhichFlow(KeyFaceProcessor.livenessMessage, key);
      final boolean isValidKey = isAuthenticate || isEnroll || isLiveness;
      if (isValidKey) {
        return key;
      }
    }
    return null;
  }

  public String getEndpoint() {
    return this.hasProperty("endpoint") ? this.getValue("endpoint") : null;
  }

  public String getSuccessMessage() {
    final String key = this.getKey();
    if (key != null) {
      final boolean isAuthenticate = this.isWhichFlow(KeyFaceProcessor.authenticateMessage, key);
      final String defaultMessage = isAuthenticate ? "Authenticated" : "Liveness\nConfirmed";
      if (this.hasProperty("successMessage")) {
        return this.getValue("successMessage");
      }
      return defaultMessage;
    }
    return null;
  }

  public boolean getHasExternalDatabaseRefID() {
    final String key = this.getKey();
    if (key != null) {
      final boolean isLiveness = this.isWhichFlow(KeyFaceProcessor.livenessMessage, key);
      if (isLiveness) {
        return false;
      }
      if (this.hasProperty("hasExternalDatabaseRefID")) {
        return this.getValue("hasExternalDatabaseRefID").equalsIgnoreCase("true");
      }
    }
    return false;
  }

  public Map getParameters() {
    return hasProperty("parameters") ? (Map) this.config.get("parameters") : null;
  }
}
