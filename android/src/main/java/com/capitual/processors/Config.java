package com.capitual.processors;

import android.content.Context;

import com.facebook.react.bridge.ReadableMap;
import com.facetec.sdk.*;
import com.capitual.processors.helpers.ThemeUtils;
import com.capitual.reactnativecapfacesdk.R;

import java.util.HashMap;
import java.util.Map;

import okhttp3.Headers;
import okhttp3.Request;

public class Config {
	private static final ThemeUtils CapThemeUtils = new ThemeUtils();
	public static String DeviceKeyIdentifier;
	public static String BaseURL;
	public static String PublicFaceScanEncryptionKey;
	public static String ProductionKeyText;
	public static ReadableMap Theme;
	public static ReadableMap RequestHeaders;

	private static Map<String, String> parseReadableMapToMap() {
		Map<String, String> headers = new HashMap<String, String>();

		if (RequestHeaders == null) {
			return headers;
		}

		for (Map.Entry<String, Object> entry : RequestHeaders.toHashMap().entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();
			headers.put(key, value == null ? "" : value.toString());
		}
		return headers;
	}

	private static Headers parseHeadersMapToHeaders(Map<String, String> headersMap, String httpMethod) {
		okhttp3.Request.Builder buildHeader = new Request.Builder()
				.header("X-Device-Key", DeviceKeyIdentifier)
				.header("X-User-Agent", FaceTecSDK.createFaceTecAPIUserAgentString(""));

		if (!httpMethod.equalsIgnoreCase("GET")) {
			buildHeader = buildHeader.header("Content-Type", "application/json");
		}

		for (Map.Entry<String, String> entry : headersMap.entrySet()) {
			buildHeader = buildHeader.header(entry.getKey(), entry.getValue());
		}

		okhttp3.Request requestHeader = buildHeader
				.url(Config.BaseURL)
				.build();

		return requestHeader.headers();
	}

	public static Headers getHeaders(String httpMethod) {
		Map<String, String> headersMap = parseReadableMapToMap();
		okhttp3.Headers headers = parseHeadersMapToHeaders(headersMap, httpMethod.toUpperCase());
		return headers;
	}

	public static void setTheme(ReadableMap theme) {
		Theme = theme;
	}

	public static void setDevice(String device) {
		DeviceKeyIdentifier = device;
	}

	public static void setUrl(String url) {
		BaseURL = url;
	}

	public static void setKey(String key) {
		PublicFaceScanEncryptionKey = key;
	}

	public static void setProductionKeyText(String keyText) {
		ProductionKeyText = keyText;
	}

	public static void setHeaders(ReadableMap headers) {
		RequestHeaders = headers;
	}

	public static boolean hasConfig() {
		return DeviceKeyIdentifier != null
				&& BaseURL != null
				&& PublicFaceScanEncryptionKey != null
				&& ProductionKeyText != null;
	}

	public static void initialize(Context context, boolean isDeveloperMode, FaceTecSDK.InitializeCallback callback) {
		if (isDeveloperMode) {
			FaceTecSDK.initializeInDevelopmentMode(
					context,
					DeviceKeyIdentifier,
					PublicFaceScanEncryptionKey,
					callback);
		} else {
			FaceTecSDK.initializeInProductionMode(
					context,
					ProductionKeyText,
					DeviceKeyIdentifier,
					PublicFaceScanEncryptionKey,
					callback);
		}
	}

	public static FaceTecCustomization retrieveConfigurationWizardCustomization() {
		FaceTecCancelButtonCustomization.ButtonLocation cancelButtonLocation = CapThemeUtils
				.handleButtonLocation("cancelButtonLocation");

		FaceTecSecurityWatermarkImage securityWatermarkImage = FaceTecSecurityWatermarkImage.FACETEC;

		FaceTecCustomization defaultCustomization = new FaceTecCustomization();

		defaultCustomization.getFrameCustomization().cornerRadius = CapThemeUtils.handleBorderRadius("frameCornerRadius");
		defaultCustomization.getFrameCustomization().backgroundColor = CapThemeUtils.handleColor("frameBackgroundColor");
		defaultCustomization.getFrameCustomization().borderColor = CapThemeUtils.handleColor("frameBorderColor");

		defaultCustomization.getOverlayCustomization().brandingImage = CapThemeUtils.handleImage("logoImage",
				R.drawable.facetec_your_app_logo);
		defaultCustomization.getOverlayCustomization().backgroundColor = CapThemeUtils
				.handleColor("overlayBackgroundColor");

		defaultCustomization.getGuidanceCustomization().backgroundColors = CapThemeUtils.handleColor(
				"guidanceBackgroundColorsAndroid");
		defaultCustomization.getGuidanceCustomization().foregroundColor = CapThemeUtils.handleColor(
				"guidanceForegroundColor",
				"#272937");
		defaultCustomization.getGuidanceCustomization().buttonBackgroundNormalColor = CapThemeUtils.handleColor(
				"guidanceButtonBackgroundNormalColor", "#026ff4");
		defaultCustomization.getGuidanceCustomization().buttonBackgroundDisabledColor = CapThemeUtils.handleColor(
				"guidanceButtonBackgroundDisabledColor", "#b3d4fc");
		defaultCustomization.getGuidanceCustomization().buttonBackgroundHighlightColor = CapThemeUtils.handleColor(
				"guidanceButtonBackgroundHighlightColor", "#0264dc");
		defaultCustomization.getGuidanceCustomization().buttonTextNormalColor = CapThemeUtils.handleColor(
				"guidanceButtonTextNormalColor");
		defaultCustomization.getGuidanceCustomization().buttonTextDisabledColor = CapThemeUtils.handleColor(
				"guidanceButtonTextDisabledColor");
		defaultCustomization.getGuidanceCustomization().buttonTextHighlightColor = CapThemeUtils.handleColor(
				"guidanceButtonTextHighlightColor");
		defaultCustomization.getGuidanceCustomization().retryScreenImageBorderColor = CapThemeUtils.handleColor(
				"guidanceRetryScreenImageBorderColor");
		defaultCustomization.getGuidanceCustomization().retryScreenOvalStrokeColor = CapThemeUtils.handleColor(
				"guidanceRetryScreenOvalStrokeColor");

		defaultCustomization.getOvalCustomization().strokeColor = CapThemeUtils.handleColor("ovalStrokeColor", "#026ff4");
		defaultCustomization.getOvalCustomization().progressColor1 = CapThemeUtils.handleColor("ovalFirstProgressColor",
				"#0264dc");
		defaultCustomization.getOvalCustomization().progressColor2 = CapThemeUtils.handleColor("ovalSecondProgressColor",
				"#0264dc");

		defaultCustomization.getFeedbackCustomization().backgroundColors = CapThemeUtils.handleColor(
				"feedbackBackgroundColorsAndroid",
				"#026ff4");
		defaultCustomization.getFeedbackCustomization().textColor = CapThemeUtils.handleColor("feedbackTextColor");

		defaultCustomization.getCancelButtonCustomization().customImage = CapThemeUtils.handleImage("cancelImage",
				R.drawable.facetec_cancel);
		defaultCustomization.getCancelButtonCustomization().setLocation(cancelButtonLocation);

		defaultCustomization.getResultScreenCustomization().backgroundColors = CapThemeUtils.handleColor(
				"resultScreenBackgroundColorsAndroid");
		defaultCustomization.getResultScreenCustomization().foregroundColor = CapThemeUtils.handleColor(
				"resultScreenForegroundColor",
				"#272937");
		defaultCustomization.getResultScreenCustomization().activityIndicatorColor = CapThemeUtils.handleColor(
				"resultScreenActivityIndicatorColor", "#026ff4");
		defaultCustomization.getResultScreenCustomization().resultAnimationBackgroundColor = CapThemeUtils.handleColor(
				"resultScreenResultAnimationBackgroundColor", "#026ff4");
		defaultCustomization.getResultScreenCustomization().resultAnimationForegroundColor = CapThemeUtils.handleColor(
				"resultScreenResultAnimationForegroundColor");
		defaultCustomization.getResultScreenCustomization().uploadProgressFillColor = CapThemeUtils.handleColor(
				"resultScreenUploadProgressFillColor", "#026ff4");

		defaultCustomization.securityWatermarkImage = securityWatermarkImage;

		defaultCustomization.getIdScanCustomization().selectionScreenBackgroundColors = CapThemeUtils.handleColor(
				"idScanSelectionScreenBackgroundColorsAndroid");
		defaultCustomization.getIdScanCustomization().selectionScreenForegroundColor = CapThemeUtils.handleColor(
				"idScanSelectionScreenForegroundColor", "#272937");
		defaultCustomization.getIdScanCustomization().reviewScreenForegroundColor = CapThemeUtils.handleColor(
				"idScanReviewScreenForegroundColor");
		defaultCustomization.getIdScanCustomization().reviewScreenTextBackgroundColor = CapThemeUtils.handleColor(
				"idScanReviewScreenTextBackgroundColor", "#026ff4");
		defaultCustomization.getIdScanCustomization().captureScreenForegroundColor = CapThemeUtils.handleColor(
				"idScanCaptureScreenForegroundColor");
		defaultCustomization.getIdScanCustomization().captureScreenTextBackgroundColor = CapThemeUtils.handleColor(
				"idScanCaptureScreenTextBackgroundColor", "#026ff4");
		defaultCustomization.getIdScanCustomization().buttonBackgroundNormalColor = CapThemeUtils.handleColor(
				"idScanButtonBackgroundNormalColor", "#026ff4");
		defaultCustomization.getIdScanCustomization().buttonBackgroundDisabledColor = CapThemeUtils.handleColor(
				"idScanButtonBackgroundDisabledColor", "#b3d4fc");
		defaultCustomization.getIdScanCustomization().buttonBackgroundHighlightColor = CapThemeUtils.handleColor(
				"idScanButtonBackgroundHighlightColor", "#0264dc");
		defaultCustomization.getIdScanCustomization().buttonTextNormalColor = CapThemeUtils.handleColor(
				"idScanButtonTextNormalColor");
		defaultCustomization.getIdScanCustomization().buttonTextDisabledColor = CapThemeUtils.handleColor(
				"idScanButtonTextDisabledColor");
		defaultCustomization.getIdScanCustomization().buttonTextHighlightColor = CapThemeUtils.handleColor(
				"idScanButtonTextHighlightColor");
		defaultCustomization.getIdScanCustomization().captureScreenBackgroundColor = CapThemeUtils.handleColor(
				"idScanCaptureScreenBackgroundColor");
		defaultCustomization.getIdScanCustomization().captureFrameStrokeColor = CapThemeUtils.handleColor(
				"idScanCaptureFrameStrokeColor");

		return defaultCustomization;
	}

	public static FaceTecCustomization retrieveLowLightConfigurationWizardCustomization() {
		return retrieveConfigurationWizardCustomization();
	}

	public static FaceTecCustomization retrieveDynamicDimmingConfigurationWizardCustomization() {
		return retrieveConfigurationWizardCustomization();
	}

	public static FaceTecCustomization currentCustomization = retrieveConfigurationWizardCustomization();
	public static FaceTecCustomization currentLowLightCustomization = retrieveLowLightConfigurationWizardCustomization();
	public static FaceTecCustomization currentDynamicDimmingCustomization = retrieveDynamicDimmingConfigurationWizardCustomization();
}
