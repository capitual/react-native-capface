package com.capitual.processors;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.RequestBody;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import com.capitual.processors.helpers.ThemeUtils;
import com.capitual.reactnativecapfacesdk.ReactNativeCapfaceSdkModule;
import com.facebook.react.bridge.ReadableMap;
import com.facetec.sdk.*;

public class AuthenticateProcessor extends Processor implements FaceTecFaceScanProcessor {
  private boolean success = false;
  private final String principalKey = "authenticateMessage";
  private final ReactNativeCapfaceSdkModule capFaceModule;
  private final ReadableMap data;
  private final ThemeUtils capThemeUtils = new ThemeUtils();

  public AuthenticateProcessor(String sessionToken, Context context, ReactNativeCapfaceSdkModule capFaceModule,
      ReadableMap data) {
    this.capFaceModule = capFaceModule;
    this.data = data;

    capFaceModule.sendEvent("onCloseModal", true);
    FaceTecSessionActivity.createAndLaunchSession(context, AuthenticateProcessor.this, sessionToken);
  }

  public void processSessionWhileFaceTecSDKWaits(final FaceTecSessionResult sessionResult,
      final FaceTecFaceScanResultCallback faceScanResultCallback) {
    capFaceModule.setLatestSessionResult(sessionResult);

    if (sessionResult.getStatus() != FaceTecSessionStatus.SESSION_COMPLETED_SUCCESSFULLY) {
      NetworkingHelpers.cancelPendingRequests();
      faceScanResultCallback.cancel();
      capFaceModule.sendEvent("onCloseModal", false);
      capFaceModule.processorPromise.reject("The session status has not been completed!", "CapFaceDifferentStatus");
      return;
    }

    JSONObject parameters = new JSONObject();
    try {
      if (this.data != null) {
        parameters.put("data", new JSONObject(this.data.toHashMap()));
      }
      parameters.put("faceScan", sessionResult.getFaceScanBase64());
      parameters.put("auditTrailImage", sessionResult.getAuditTrailCompressedBase64()[0]);
      parameters.put("lowQualityAuditTrailImage", sessionResult.getLowQualityAuditTrailCompressedBase64()[0]);
      parameters.put("externalDatabaseRefID", capFaceModule.getLatestExternalDatabaseRefID());
    } catch (JSONException e) {
      e.printStackTrace();
      Log.d("Capitual - JSON", "Exception raised while attempting to create JSON payload for upload.");
      capFaceModule.sendEvent("onCloseModal", false);
      capFaceModule.processorPromise.reject("Exception raised while attempting to create JSON payload for upload.",
          "JSONError");
    }

    okhttp3.Request request = new okhttp3.Request.Builder()
        .url(Config.BaseURL + "/match-3d-3d")
        .headers(Config.getHeaders("POST"))
        .post(new ProgressRequestBody(
            RequestBody.create(MediaType.parse("application/json; charset=utf-8"), parameters.toString()),
            new ProgressRequestBody.Listener() {
              @Override
              public void onUploadProgressChanged(long bytesWritten, long totalBytes) {
                final float uploadProgressPercent = ((float) bytesWritten) / ((float) totalBytes);
                faceScanResultCallback.uploadProgress(uploadProgressPercent);
              }
            }))
        .build();

    NetworkingHelpers.getApiClient().newCall(request).enqueue(new Callback() {
      @Override
      public void onResponse(@NonNull Call call, @NonNull okhttp3.Response response) throws IOException {
        String responseString = response.body().string();
        response.body().close();
        try {
          JSONObject responseJSON = new JSONObject(responseString);
          boolean wasProcessed = responseJSON.getBoolean("wasProcessed");
          String scanResultBlob = responseJSON.getString("scanResultBlob");

          if (wasProcessed) {
            FaceTecCustomization.overrideResultScreenSuccessMessage = capThemeUtils
                .handleMessage(principalKey, "successMessage", "Authenticated");
            success = faceScanResultCallback.proceedToNextStep(scanResultBlob);
            if (success) {
              capFaceModule.processorPromise.resolve(true);
            }
          } else {
            faceScanResultCallback.cancel();
            capFaceModule.sendEvent("onCloseModal", false);
            capFaceModule.processorPromise.reject("CapFace SDK values were not processed!",
                "CapFaceValuesWereNotProcessed");
          }
        } catch (JSONException e) {
          e.printStackTrace();
          Log.d("Capitual - JSON", "Exception raised while attempting to parse JSON result.");
          faceScanResultCallback.cancel();
          capFaceModule.sendEvent("onCloseModal", false);
          capFaceModule.processorPromise.reject("Exception raised while attempting to parse JSON result.",
              "JSONError");
        }
      }

      @Override
      public void onFailure(@NonNull Call call, IOException e) {
        Log.d("Capitual - HTTPS", "Exception raised while attempting HTTPS call.");
        faceScanResultCallback.cancel();
        capFaceModule.sendEvent("onCloseModal", false);
        capFaceModule.processorPromise.reject("Exception raised while attempting HTTPS call.", "HTTPSError");
      }
    });
  }

  public boolean isSuccess() {
    return this.success;
  }
}
