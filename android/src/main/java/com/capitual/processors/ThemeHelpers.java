package com.capitual.processors;

import com.capitual.reactnativecapfacesdk.R;

import com.facebook.react.bridge.ReadableMap;

import com.facetec.sdk.FaceTecCustomization;
import com.facetec.sdk.FaceTecSDK;

public class ThemeHelpers {
	public static void setAppTheme(ReadableMap options) {
		Config.setTheme(options);
		Config.currentCustomization = getCustomizationForTheme();
		Config.currentLowLightCustomization = getLowLightCustomizationForTheme();
		Config.currentDynamicDimmingCustomization = getDynamicDimmingCustomizationForTheme();

		FaceTecSDK.setCustomization(Config.currentCustomization);
		FaceTecSDK.setLowLightCustomization(Config.currentLowLightCustomization);
		FaceTecSDK.setDynamicDimmingCustomization(Config.currentDynamicDimmingCustomization);
	}

	public static FaceTecCustomization getCustomizationForTheme() {
		FaceTecCustomization currentCustomization = new FaceTecCustomization();
		currentCustomization = Config.retrieveConfigurationWizardCustomization();
		currentCustomization
				.getIdScanCustomization().customNFCStartingAnimation = R.drawable.facetec_nfc_starting_animation;
		currentCustomization
				.getIdScanCustomization().customNFCScanningAnimation = R.drawable.facetec_nfc_scanning_animation;
		currentCustomization
				.getIdScanCustomization().customNFCCardStartingAnimation = R.drawable.facetec_nfc_card_starting_animation;
		currentCustomization
				.getIdScanCustomization().customNFCCardScanningAnimation = R.drawable.facetec_nfc_card_scanning_animation;

		return currentCustomization;
	}

	static FaceTecCustomization getLowLightCustomizationForTheme() {
		FaceTecCustomization currentLowLightCustomization = getCustomizationForTheme();
		currentLowLightCustomization = Config.retrieveLowLightConfigurationWizardCustomization();

		return currentLowLightCustomization;
	}

	static FaceTecCustomization getDynamicDimmingCustomizationForTheme() {
		FaceTecCustomization currentDynamicDimmingCustomization = getCustomizationForTheme();
		currentDynamicDimmingCustomization = Config.retrieveDynamicDimmingConfigurationWizardCustomization();

		return currentDynamicDimmingCustomization;
	}
}
