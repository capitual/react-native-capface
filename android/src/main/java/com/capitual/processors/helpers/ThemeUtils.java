package com.capitual.processors.helpers;

import com.facebook.react.bridge.ReactApplicationContext;

import com.facetec.sdk.*;

import android.graphics.Color;
import android.util.Log;

import com.capitual.processors.Config;

import org.json.JSONObject;

public class ThemeUtils {
  private static ReactApplicationContext reactContext;

  private Boolean themeAndKeyIsntExists(String key) {
    return Config.Theme == null || !Config.Theme.hasKey(key) || Config.Theme.isNull(key);
  }

  private int parseColor(String key, int defaultColor) {
    final String color = Config.Theme.getString(key);
    return color.isEmpty() ? defaultColor : Color.parseColor(color);
  }

  public void setReactContext(ReactApplicationContext context) {
    reactContext = context;
  }

  public String handleMessage(String key, String child, String defaultMessage) {
    try {
      if (this.themeAndKeyIsntExists(key)) {
        return defaultMessage;
      }
      final JSONObject rootObject = new JSONObject(Config.Theme.toHashMap());
      final JSONObject message = rootObject.getJSONObject(key);
      final Boolean childIsntExists = !message.has(child) || message.isNull(child);
      return childIsntExists ? defaultMessage : message.getString(child);
    } catch (Exception error) {
      return defaultMessage;
    }
  }

  public int handleColor(String key) {
    final int defaultColor = Color.parseColor("#ffffff");
    if (this.themeAndKeyIsntExists(key)) {
      return defaultColor;
    }
    return this.parseColor(key, defaultColor);
  }

  public int handleColor(String key, String defaultColor) {
    if (this.themeAndKeyIsntExists(key)) {
      return Color.parseColor(defaultColor);
    }
    return this.parseColor(key, Color.parseColor(defaultColor));
  }

  public int handleBorderRadius(String key) {
    final int defaultBorderRadius = 20;
    if (this.themeAndKeyIsntExists(key)) {
      return defaultBorderRadius;
    }
    final int borderRadius = Config.Theme.getInt(key);
    return borderRadius < 0 ? defaultBorderRadius : borderRadius;
  }

  public int handleImage(String key, int defaultImage) {
    if (this.themeAndKeyIsntExists(key) || reactContext == null) {
      return defaultImage;
    }
    final String imageName = Config.Theme.getString(key);
    if (imageName.isEmpty()) {
      return defaultImage;
    }
    final String packageName = reactContext.getPackageName();
    final int resourceId = reactContext.getResources().getIdentifier(imageName, "drawable", packageName);
    return resourceId == 0 ? defaultImage : resourceId;
  }

  public FaceTecCancelButtonCustomization.ButtonLocation handleButtonLocation(String key) {
    final FaceTecCancelButtonCustomization.ButtonLocation defaultLocation = FaceTecCancelButtonCustomization.ButtonLocation.TOP_RIGHT;
    if (this.themeAndKeyIsntExists(key)) {
      return defaultLocation;
    }
    final String buttonLocation = Config.Theme.getString(key);
    if (buttonLocation.isEmpty()) {
      return defaultLocation;
    }

    switch (buttonLocation) {
      case "TOP_RIGHT":
        return FaceTecCancelButtonCustomization.ButtonLocation.TOP_RIGHT;
      case "TOP_LEFT":
        return FaceTecCancelButtonCustomization.ButtonLocation.TOP_LEFT;
      case "DISABLED":
        return FaceTecCancelButtonCustomization.ButtonLocation.DISABLED;
      default:
        return defaultLocation;
    }
  }
}
