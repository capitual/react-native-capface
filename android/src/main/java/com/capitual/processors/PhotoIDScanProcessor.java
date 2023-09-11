package com.capitual.processors;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.capitual.reactnativecapfacesdk.ReactNativeCapfaceSdkModule;
import com.facebook.react.bridge.ReadableMap;
import com.facetec.sdk.FaceTecCustomization;
import com.facetec.sdk.FaceTecIDScanProcessor;
import com.facetec.sdk.FaceTecIDScanResult;
import com.facetec.sdk.FaceTecIDScanResultCallback;
import com.facetec.sdk.FaceTecIDScanStatus;
import com.facetec.sdk.FaceTecSessionActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.RequestBody;

import com.capitual.processors.helpers.ThemeUtils;

public class PhotoIDScanProcessor extends Processor implements FaceTecIDScanProcessor {
	private boolean success = false;
	private final String principalKey = "photoIdScanMessage";
	private final ReadableMap data;
	private final ReactNativeCapfaceSdkModule capFaceModule;
	private final ThemeUtils capThemeUtils = new ThemeUtils();

	public PhotoIDScanProcessor(String sessionToken, Context context, ReactNativeCapfaceSdkModule capFaceModule,
			ReadableMap data) {
		this.capFaceModule = capFaceModule;
		this.data = data;

		FaceTecCustomization.setIDScanUploadMessageOverrides(
				// Upload of ID front-side has started.
				capThemeUtils.handleMessage(principalKey, "frontSideUploadStarted", "Uploading\nEncrypted\nID Scan"),
				// Upload of ID front-side is still uploading to Server after an extended period
				// of time.
				capThemeUtils.handleMessage(principalKey, "frontSideStillUploading",
						"Still Uploading...\nSlow Connection"),
				// Upload of ID front-side to the Server is complete.
				capThemeUtils.handleMessage(principalKey, "frontSideUploadCompleteAwaitingResponse",
						"Upload Complete"),
				// Upload of ID front-side is complete and we are waiting for the Server to
				// finish processing and respond.
				capThemeUtils.handleMessage(principalKey, "frontSideUploadCompleteAwaitingProcessing",
						"Processing ID Scan"),
				// Upload of ID back-side has started.
				capThemeUtils.handleMessage(principalKey, "backSideUploadStarted",
						"Uploading\nEncrypted\nBack of ID"),
				// Upload of ID back-side is still uploading to Server after an extended period
				// of time.
				capThemeUtils.handleMessage(principalKey, "backSideStillUploading",
						"Still Uploading...\nSlow Connection"),
				// Upload of ID back-side to Server is complete.
				capThemeUtils.handleMessage(principalKey, "backSideUploadCompleteAwaitingResponse",
						"Upload Complete"),
				// Upload of ID back-side is complete and we are waiting for the Server to
				// finish processing and respond.
				capThemeUtils.handleMessage(principalKey, "backSideUploadCompleteAwaitingProcessing",
						"Processing Back of ID"),
				// Upload of User Confirmed Info has started.
				capThemeUtils.handleMessage(principalKey, "userConfirmedInfoUploadStarted",
						"Uploading\nYour Confirmed Info"),
				// Upload of User Confirmed Info is still uploading to Server after an extended
				// period of time.
				capThemeUtils.handleMessage(principalKey, "userConfirmedInfoStillUploading",
						"Still Uploading...\nSlow Connection"),
				// Upload of User Confirmed Info to the Server is complete.
				capThemeUtils.handleMessage(principalKey, "userConfirmedInfoUploadCompleteAwaitingResponse",
						"Upload Complete"),
				// Upload of User Confirmed Info is complete and we are waiting for the Server
				// to finish processing and respond.
				capThemeUtils.handleMessage(principalKey, "userConfirmedInfoUploadCompleteAwaitingProcessing",
						"Processing"),
				// Upload of NFC Details has started.
				capThemeUtils.handleMessage(principalKey, "nfcUploadStarted",
						"Uploading Encrypted\nNFC Details"),
				// Upload of NFC Details is still uploading to Server after an extended period
				// of time.
				capThemeUtils.handleMessage(principalKey, "nfcStillUploading",
						"Still Uploading...\nSlow Connection"),
				// Upload of NFC Details to the Server is complete.
				capThemeUtils.handleMessage(principalKey, "nfcUploadCompleteAwaitingResponse",
						"Upload Complete"),
				// Upload of NFC Details is complete and we are waiting for the Server to finish
				// processing and respond.
				capThemeUtils.handleMessage(principalKey, "nfcUploadCompleteAwaitingProcessing",
						"Processing\nNFC Details"),
				// Upload of ID Details has started.
				capThemeUtils.handleMessage(principalKey, "skippedNFCUploadStarted",
						"Uploading Encrypted\nID Details"),
				// Upload of ID Details is still uploading to Server after an extended period of
				// time.
				capThemeUtils.handleMessage(principalKey, "skippedNFCStillUploading",
						"Still Uploading...\nSlow Connection"),
				// Upload of ID Details to the Server is complete.
				capThemeUtils.handleMessage(principalKey, "skippedNFCUploadCompleteAwaitingResponse",
						"Upload Complete"),
				// Upload of ID Details is complete and we are waiting for the Server to finish
				// processing and respond.
				capThemeUtils.handleMessage(principalKey, "skippedNFCUploadCompleteAwaitingProcessing",
						"Processing\nID Details"));

		capFaceModule.sendEvent("onCloseModal", true);
		FaceTecSessionActivity.createAndLaunchSession(context, PhotoIDScanProcessor.this, sessionToken);
	}

	public void processIDScanWhileFaceTecSDKWaits(final FaceTecIDScanResult idScanResult,
			final FaceTecIDScanResultCallback idScanResultCallback) {
		capFaceModule.setLatestIDScanResult(idScanResult);

		if (idScanResult.getStatus() != FaceTecIDScanStatus.SUCCESS) {
			NetworkingHelpers.cancelPendingRequests();
			idScanResultCallback.cancel();
			capFaceModule.sendEvent("onCloseModal", false);
			capFaceModule.processorPromise.reject("The scan status has not been completed!", "CapFaceInvalidSession");
			return;
		}

		JSONObject parameters = new JSONObject();
		try {
			if (this.data != null) {
				parameters.put("data", new JSONObject(this.data.toHashMap()));
			}
			parameters.put("idScan", idScanResult.getIDScanBase64());

			ArrayList<String> frontImagesCompressedBase64 = idScanResult.getFrontImagesCompressedBase64();
			ArrayList<String> backImagesCompressedBase64 = idScanResult.getBackImagesCompressedBase64();
			if (frontImagesCompressedBase64.size() > 0) {
				parameters.put("idScanFrontImage", frontImagesCompressedBase64.get(0));
			}
			if (backImagesCompressedBase64.size() > 0) {
				parameters.put("idScanBackImage", backImagesCompressedBase64.get(0));
			}
		} catch (JSONException e) {
			e.printStackTrace();
			Log.d("Capitual - JSON", "Exception raised while attempting to create JSON payload for upload.");
			capFaceModule.sendEvent("onCloseModal", false);
			capFaceModule.processorPromise.reject("Exception raised while attempting to create JSON payload for upload.",
					"JSONError");
		}

		okhttp3.Request request = new okhttp3.Request.Builder()
				.url(Config.BaseURL + "/idscan-only")
				.headers(Config.getHeaders("POST"))
				.post(new ProgressRequestBody(
						RequestBody.create(MediaType.parse("application/json; charset=utf-8"), parameters.toString()),
						new ProgressRequestBody.Listener() {
							@Override
							public void onUploadProgressChanged(long bytesWritten, long totalBytes) {
								final float uploadProgressPercent = ((float) bytesWritten) / ((float) totalBytes);
								idScanResultCallback.uploadProgress(uploadProgressPercent);
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
						FaceTecCustomization.setIDScanResultScreenMessageOverrides(
								// Successful scan of ID front-side (ID Types with no back-side).
								capThemeUtils.handleMessage(principalKey, "successFrontSide",
										"ID Scan Complete"),
								// Successful scan of ID front-side (ID Types that have a back-side).
								capThemeUtils.handleMessage(principalKey, "successFrontSideBackNext",
										"Front of ID\nScanned"),
								// Successful scan of ID front-side (ID Types that do have NFC but do not have a
								// back-side).
								capThemeUtils.handleMessage(principalKey, "successFrontSideNFCNext",
										"Front of ID\nScanned"),
								// Successful scan of the ID back-side (ID Types that do not have NFC).
								capThemeUtils.handleMessage(principalKey, "successBackSide",
										"ID Scan Complete"),
								// Successful scan of the ID back-side (ID Types that do have NFC).
								capThemeUtils.handleMessage(principalKey, "successBackSideNFCNext",
										"Back of ID\nScanned"),
								// Successful scan of a Passport that does not have NFC.
								capThemeUtils.handleMessage(principalKey, "successPassport",
										"Passport Scan Complete"),
								// Successful scan of a Passport that does have NFC.
								capThemeUtils.handleMessage(principalKey, "successPassportNFCNext",
										"Passport Scanned"),
								// Successful upload of final IDScan containing User-Confirmed ID Text.
								capThemeUtils.handleMessage(principalKey, "successUserConfirmation",
										"Photo ID Scan\nComplete"),
								// Successful upload of the scanned NFC chip information.
								capThemeUtils.handleMessage(principalKey, "successNFC",
										"ID Scan Complete"),
								// Case where a Retry is needed because the Face on the Photo ID did not Match
								// the User's Face highly enough.
								capThemeUtils.handleMessage(principalKey, "retryFaceDidNotMatch",
										"Face Didn't Match\nHighly Enough"),
								// Case where a Retry is needed because a Full ID was not detected with high
								// enough confidence.
								capThemeUtils.handleMessage(principalKey, "retryIDNotFullyVisible",
										"ID Document\nNot Fully Visible"),
								// Case where a Retry is needed because the OCR did not produce good enough
								// results and the User should Retry with a better capture.
								capThemeUtils.handleMessage(principalKey, "retryOCRResultsNotGoodEnough",
										"ID Text Not Legible"),
								// Case where there is likely no OCR Template installed for the document the
								// User is attempting to scan.
								capThemeUtils.handleMessage(principalKey, "retryIDTypeNotSupported",
										"ID Type Mismatch\nPlease Try Again"),
								// Case where NFC Scan was skipped due to the user's interaction or an
								// unexpected error.
								capThemeUtils.handleMessage(principalKey, "skipOrErrorNFC",
										"ID Details\nUploaded"));

						success = idScanResultCallback.proceedToNextStep(scanResultBlob);
						if (success) {
							capFaceModule.sendEvent("onCloseModal", false);
							capFaceModule.processorPromise.resolve(true);
						}
					} else {
						idScanResultCallback.cancel();
						capFaceModule.sendEvent("onCloseModal", false);
						capFaceModule.processorPromise.reject("CapFace SDK values were not processed!",
								"CapFaceValuesWereNotProcessed");
					}
				} catch (JSONException e) {
					e.printStackTrace();
					Log.d("Capitual - JSON", "Exception raised while attempting to parse JSON result.");
					idScanResultCallback.cancel();
					capFaceModule.sendEvent("onCloseModal", false);
					capFaceModule.processorPromise.reject("Exception raised while attempting to parse JSON result.",
							"JSONError");
				}
			}

			@Override
			public void onFailure(@NonNull Call call, @NonNull IOException e) {
				Log.d("Capitual - HTTPS", "Exception raised while attempting HTTPS call.");
				idScanResultCallback.cancel();
				capFaceModule.sendEvent("onCloseModal", false);
				capFaceModule.processorPromise.reject("Exception raised while attempting HTTPS call.", "HTTPSError");
			}
		});
	}

	public boolean isSuccess() {
		return this.success;
	}
}
