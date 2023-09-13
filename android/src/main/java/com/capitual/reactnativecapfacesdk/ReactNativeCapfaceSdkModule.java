package com.capitual.reactnativecapfacesdk;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.capitual.processors.helpers.ThemeUtils;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

import com.facebook.react.bridge.ReadableMap;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;

import okhttp3.Call;
import okhttp3.Callback;

import com.capitual.processors.*;

import static java.util.UUID.randomUUID;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facetec.sdk.*;

@ReactModule(name = ReactNativeCapfaceSdkModule.NAME)
public class ReactNativeCapfaceSdkModule extends ReactContextBaseJavaModule {
  private static final ThemeUtils capThemeUtils = new ThemeUtils();
  public static final String NAME = "ReactNativeCapfaceSdk";
  private final String initializationMessage = "CapFace SDK has not been initialized!";
  private final ReactApplicationContext reactContext;
  private boolean isInitialized = false;
  private boolean isSessionPreparingToLaunch = false;
  private String latestExternalDatabaseRefID = "";
  public Promise processorPromise;
  public Processor latestProcessor;
  public FaceTecSessionResult latestSessionResult;
  public FaceTecIDScanResult latestIDScanResult;

  public ReactNativeCapfaceSdkModule(ReactApplicationContext context) {
    super(context);
    reactContext = context;
    capThemeUtils.setReactContext(context);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  private boolean isDeveloperMode(Map params) {
    if (params.containsKey("isDeveloperMode")) {
      return params.get("isDeveloperMode").toString().equals("true");
    }
    return false;
  }

  private String generateUUID() {
    return "android_app_" + randomUUID();
  }

  private String getKeyValue(@NonNull Map object, String key) {
    if (object.containsKey(key)) {
      return object.get(key).toString();
    }
    return null;
  }

  private void handleCapFaceConfiguration(@NonNull Map params, ReadableMap headers) {
    try {
      Config.setDevice(getKeyValue(params, "device"));
      Config.setUrl(getKeyValue(params, "url"));
      Config.setKey(getKeyValue(params, "key"));
      Config.setProductionKeyText(getKeyValue(params, "productionKey"));
      Config.setHeaders(headers);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  @ReactMethod
  public void initializeSdk(ReadableMap params, ReadableMap headers, com.facebook.react.bridge.Callback callback) {
    if (params == null) {
      isInitialized = false;
      callback.invoke(false);
      return;
    }

    handleCapFaceConfiguration(params.toHashMap(), headers);

    if (Config.hasConfig()) {
      Config.initialize(reactContext, isDeveloperMode(params.toHashMap()), new FaceTecSDK.InitializeCallback() {
        @Override
        public void onCompletion(final boolean successful) {
          isInitialized = successful;
          callback.invoke(successful);
        }
      });
    } else {
      isInitialized = false;
      callback.invoke(false);
    }

    this.handleTheme(Config.Theme);
  }

  interface SessionTokenCallback {
    void onSessionTokenReceived(String sessionToken);
  }

  public void getSessionToken(final SessionTokenCallback sessionTokenCallback) {
    okhttp3.Request request = new okhttp3.Request.Builder()
        .headers(Config.getHeaders("GET"))
        .url(Config.BaseURL + "/session-token")
        .get()
        .build();

    NetworkingHelpers.getApiClient().newCall(request).enqueue(new Callback() {
      @Override
      public void onFailure(Call call, IOException e) {
        e.printStackTrace();
        if (processorPromise != null) {
          processorPromise.reject("Exception raised while attempting HTTPS call.", "HTTPSError");
        }
      }

      @Override
      public void onResponse(Call call, okhttp3.Response response) throws IOException {
        String responseString = response.body().string();
        response.body().close();
        try {
          JSONObject responseJSON = new JSONObject(responseString);
          if (responseJSON.has("sessionToken")) {
            sessionTokenCallback.onSessionTokenReceived(responseJSON.getString("sessionToken"));
          } else {
            final String errorMessage = responseJSON.has("errorMessage")
                ? responseJSON.getString("errorMessage")
                : "Response JSON is missing sessionToken.";
            if (processorPromise != null) {
              processorPromise.reject(errorMessage, "JSONError");
            }
          }
        } catch (JSONException e) {
          e.printStackTrace();
          if (processorPromise != null) {
            processorPromise.reject("Exception raised while attempting to parse JSON result.", "JSONError");
          }
        }
      }
    });
  }

  public void setLatestSessionResult(FaceTecSessionResult sessionResult) {
    this.latestSessionResult = sessionResult;
  }

  public void setLatestIDScanResult(FaceTecIDScanResult idScanResult) {
    this.latestIDScanResult = idScanResult;
  }

  public void resetLatestResults() {
    this.latestSessionResult = null;
    this.latestIDScanResult = null;
  }

  public void setLatestExternalDatabaseRefID(String externalDatabaseRefID) {
    this.latestExternalDatabaseRefID = externalDatabaseRefID;
  }

  public String getLatestExternalDatabaseRefID() {
    return this.latestExternalDatabaseRefID;
  }

  public void setProcessorPromise(Promise promise) {
    this.processorPromise = promise;
  }

  public void sendEvent(@NonNull String eventName, @Nullable Boolean eventValue) {
    reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, eventValue);
  }

  @ReactMethod
  public void addListener(String eventName) {
  }

  @ReactMethod
  public void removeListeners(Integer count) {
  }

  @ReactMethod
  public void handleFaceUser(ReadableMap config, Promise promise) {
    setProcessorPromise(promise);
    if (!isInitialized) {
      this.processorPromise.reject(this.initializationMessage, "CapFaceHasNotBeenInitialized");
      return;
    }

    if (config == null) {
      this.processorPromise.reject("No configurations provided!", "NoConfigurationsProvided");
      return;
    }

    isSessionPreparingToLaunch = true;

    getSessionToken(new SessionTokenCallback() {
      @Override
      public void onSessionTokenReceived(String sessionToken) {
        resetLatestResults();
        isSessionPreparingToLaunch = false;
        final FaceConfig faceConfig = new FaceConfig(config);
        if (faceConfig.isWhichFlow(KeyFaceProcessor.enrollMessage, faceConfig.getKey())) {
          setLatestExternalDatabaseRefID(generateUUID());
        }
        latestProcessor = new FaceProcessor(sessionToken, reactContext.getCurrentActivity(),
            ReactNativeCapfaceSdkModule.this, faceConfig);
      }
    });
  }

  @ReactMethod
  public void handlePhotoIDMatch(ReadableMap data, Promise promise) {
    setProcessorPromise(promise);
    if (!isInitialized) {
      this.processorPromise.reject(this.initializationMessage, "CapFaceHasNotBeenInitialized");
      return;
    }

    isSessionPreparingToLaunch = true;

    getSessionToken(new SessionTokenCallback() {
      @Override
      public void onSessionTokenReceived(String sessionToken) {
        resetLatestResults();
        isSessionPreparingToLaunch = false;
        setLatestExternalDatabaseRefID(generateUUID());
        latestProcessor = new PhotoIDMatchProcessor(sessionToken, reactContext.getCurrentActivity(),
            ReactNativeCapfaceSdkModule.this, data);
      }
    });
  }

  @ReactMethod
  public void handlePhotoIDScan(ReadableMap data, Promise promise) {
    setProcessorPromise(promise);
    if (!isInitialized) {
      this.processorPromise.reject(this.initializationMessage, "CapFaceHasNotBeenInitialized");
      return;
    }

    isSessionPreparingToLaunch = true;

    getSessionToken(new SessionTokenCallback() {
      @Override
      public void onSessionTokenReceived(String sessionToken) {
        resetLatestResults();
        isSessionPreparingToLaunch = false;
        latestProcessor = new PhotoIDScanProcessor(sessionToken, reactContext.getCurrentActivity(),
            ReactNativeCapfaceSdkModule.this, data);
      }
    });
  }

  @ReactMethod
  public void handleTheme(ReadableMap options) {
    ThemeHelpers.setAppTheme(options);
  }
}
