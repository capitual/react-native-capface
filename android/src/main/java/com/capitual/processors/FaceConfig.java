package com.capitual.processors;

import com.capitual.processors.KeyFaceProcessor;

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

    return this.config.isEmpty() || this.config.containsKey(key);
  }

  private String getValue(String key) {
    return this.hasProperty(key) ? this.config.get(key).toString() : null;
  }

  public String getKey() {
    if (this.hasProperty("key")) {
      final String key = this.getValue("key");
      final boolean isAutheticate = key.equals(KeyFaceProcessor.authenticateMessage);
      final boolean isEnroll = key.equals(KeyFaceProcessor.enrollMessage);
      final boolean isLiveness = key.equals(KeyFaceProcessor.livenessMessage);
      final boolean isValidKey = isAutheticate || isEnroll || isLiveness;
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
      final boolean isAutheticate = key.equals(KeyFaceProcessor.authenticateMessage);
      final String defaultMessage = isAutheticate ? "Authenticated" : "Liveness\nConfirmed";
      if (this.hasProperty("successMessage")) {
        return this.getValue("successMessage");
      }
    }
    return null;
  }

  public boolean getHasExternalDatabaseRefID() {
    final String key = this.getKey();
    if (key != null) {
      final boolean isLiveness = key.equals(KeyFaceProcessor.livenessMessage);
      if (isLiveness) {
        return false;
      }
      if (this.hasProperty("hasExternalDatabaseRefID")) {
        return this.getValue("hasExternalDatabaseRefID").equals("true");
      }
    }
    return false;
  }

  public Map getParameters() {
    return hasProperty("parameters") ? (Map) this.config.get("parameters") : null;
  }
}
