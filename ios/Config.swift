//
//  Config.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import UIKit
import Foundation
import FaceTecSDK

public class Config {
    private static let CapThemeUtils: ThemeUtils! = ThemeUtils();
    public static var DeviceKeyIdentifier: String!
    public static var BaseURL: String!
    public static var PublicFaceScanEncryptionKey: String!
    public static var ProductionKeyText: String!
    public static var Headers: NSDictionary?
    public static var Theme: NSDictionary?

    public static func setDevice(_ device: String) {
        Config.DeviceKeyIdentifier = device;
    }

    public static func setUrl(_ url: String) {
        Config.BaseURL = url;
    }

    public static func setKey(_ key: String) {
        Config.PublicFaceScanEncryptionKey = key;
    }

    public static func setProductionKeyText(_ keyText: String) {
        Config.ProductionKeyText = keyText;
    }

    public static func setHeaders(_ headers: NSDictionary?) {
        Config.Headers = headers;
    }

    public static func setTheme(_ theme: NSDictionary?) {
        Config.Theme = theme;
    }

    public static func hasConfig() -> Bool {
        return Config.BaseURL != nil && Config.DeviceKeyIdentifier != nil && Config.ProductionKeyText != nil && Config.PublicFaceScanEncryptionKey != nil
    }

    public static func makeRequest(url: String, httpMethod: String) -> URLRequest {
        let endpoint = BaseURL + url;
        let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL)
        request.httpMethod = httpMethod;
        request.addValue(DeviceKeyIdentifier, forHTTPHeaderField: "X-Device-Key");
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString(""), forHTTPHeaderField: "X-User-Agent");

        if (httpMethod != "GET") {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if (Headers != nil) {
            for key in Headers!.allKeys {
                request.addValue(Headers![key] != nil ? Headers![key] as! String : "", forHTTPHeaderField: key as! String);
            }
        }

        return request as URLRequest;
    }

    static func initialize(_ isDeveloperMode: Bool, completion: @escaping (Bool)->()) {
        if (isDeveloperMode) {
            FaceTec.sdk.initializeInDevelopmentMode(deviceKeyIdentifier: DeviceKeyIdentifier, faceScanEncryptionKey: PublicFaceScanEncryptionKey, completion: { initializationSuccessful in
                completion(initializationSuccessful)
            })
        } else {
            FaceTec.sdk.initializeInProductionMode(productionKeyText: ProductionKeyText, deviceKeyIdentifier: DeviceKeyIdentifier, faceScanEncryptionKey: PublicFaceScanEncryptionKey, completion: { initializationSuccessful in
                completion(initializationSuccessful)
            })
        }
    }

    public static func retrieveConfigurationWizardCustomization() -> FaceTecCustomization {
        let securityWatermarkImage: FaceTecSecurityWatermarkImage = .faceTec;

        let defaultCustomization = FaceTecCustomization();

        defaultCustomization.frameCustomization.cornerRadius = CapThemeUtils.handleBorderRadius("frameCornerRadius");
        defaultCustomization.frameCustomization.backgroundColor = CapThemeUtils.handleColor("frameBackgroundColor");
        defaultCustomization.frameCustomization.borderColor = CapThemeUtils.handleColor("frameBorderColor");

        defaultCustomization.overlayCustomization.brandingImage = CapThemeUtils.handleImage("logoImage", defaultImage: "facetec_your_app_logo");
        defaultCustomization.overlayCustomization.backgroundColor = CapThemeUtils.handleColor("overlayBackgroundColor");

        defaultCustomization.guidanceCustomization.backgroundColors = CapThemeUtils.handleSimpleLinearGradient("guidanceBackgroundColorsIos");
        defaultCustomization.guidanceCustomization.foregroundColor = CapThemeUtils.handleColor("guidanceForegroundColor", defaultColor: "#272937");
        defaultCustomization.guidanceCustomization.buttonBackgroundNormalColor = CapThemeUtils.handleColor("guidanceButtonBackgroundNormalColor", defaultColor: "#026ff4");
        defaultCustomization.guidanceCustomization.buttonBackgroundDisabledColor = CapThemeUtils.handleColor("guidanceButtonBackgroundDisabledColor", defaultColor: "#b3d4fc");
        defaultCustomization.guidanceCustomization.buttonBackgroundHighlightColor = CapThemeUtils.handleColor("guidanceButtonBackgroundHighlightColor", defaultColor: "#0264dc");
        defaultCustomization.guidanceCustomization.buttonTextNormalColor = CapThemeUtils.handleColor("guidanceButtonTextNormalColor");
        defaultCustomization.guidanceCustomization.buttonTextDisabledColor = CapThemeUtils.handleColor("guidanceButtonTextDisabledColor");
        defaultCustomization.guidanceCustomization.buttonTextHighlightColor = CapThemeUtils.handleColor("guidanceButtonTextHighlightColor");
        defaultCustomization.guidanceCustomization.retryScreenImageBorderColor = CapThemeUtils.handleColor("guidanceRetryScreenImageBorderColor");
        defaultCustomization.guidanceCustomization.retryScreenOvalStrokeColor = CapThemeUtils.handleColor("guidanceRetryScreenOvalStrokeColor");

        defaultCustomization.ovalCustomization.strokeColor = CapThemeUtils.handleColor("ovalStrokeColor", defaultColor: "#026ff4");
        defaultCustomization.ovalCustomization.progressColor1 = CapThemeUtils.handleColor("ovalFirstProgressColor", defaultColor: "#0264dc");
        defaultCustomization.ovalCustomization.progressColor2 = CapThemeUtils.handleColor("ovalSecondProgressColor", defaultColor: "#0264dc");

        defaultCustomization.feedbackCustomization.backgroundColor = CapThemeUtils.handleCAGradient("feedbackBackgroundColorsIos");
        defaultCustomization.feedbackCustomization.textColor = CapThemeUtils.handleColor("feedbackTextColor");

        defaultCustomization.cancelButtonCustomization.customImage = CapThemeUtils.handleImage("cancelImage", defaultImage: "facetec_cancel");
        defaultCustomization.cancelButtonCustomization.location = CapThemeUtils.handleButtonLocation("cancelButtonLocation");

        defaultCustomization.resultScreenCustomization.backgroundColors = CapThemeUtils.handleSimpleLinearGradient("resultScreenBackgroundColorsIos");
        defaultCustomization.resultScreenCustomization.foregroundColor = CapThemeUtils.handleColor("resultScreenForegroundColor", defaultColor: "#272937");
        defaultCustomization.resultScreenCustomization.activityIndicatorColor = CapThemeUtils.handleColor("resultScreenActivityIndicatorColor", defaultColor: "#026ff4");
        defaultCustomization.resultScreenCustomization.resultAnimationBackgroundColor = CapThemeUtils.handleColor("resultScreenResultAnimationBackgroundColor", defaultColor: "#026ff4");
        defaultCustomization.resultScreenCustomization.resultAnimationForegroundColor = CapThemeUtils.handleColor("resultScreenResultAnimationForegroundColor");
        defaultCustomization.resultScreenCustomization.uploadProgressFillColor = CapThemeUtils.handleColor("resultScreenUploadProgressFillColor", defaultColor: "#026ff4");

        defaultCustomization.securityWatermarkImage = securityWatermarkImage;

        defaultCustomization.idScanCustomization.selectionScreenBackgroundColors = CapThemeUtils.handleSimpleLinearGradient("idScanSelectionScreenBackgroundColorsIos");
        defaultCustomization.idScanCustomization.selectionScreenForegroundColor = CapThemeUtils.handleColor("idScanSelectionScreenForegroundColor", defaultColor: "#272937");
        defaultCustomization.idScanCustomization.reviewScreenForegroundColor = CapThemeUtils.handleColor("idScanReviewScreenForegroundColor");
        defaultCustomization.idScanCustomization.reviewScreenTextBackgroundColor = CapThemeUtils.handleColor("idScanReviewScreenTextBackgroundColor", defaultColor: "#026ff4");
        defaultCustomization.idScanCustomization.captureScreenForegroundColor = CapThemeUtils.handleColor("idScanCaptureScreenForegroundColor");
        defaultCustomization.idScanCustomization.captureScreenTextBackgroundColor = CapThemeUtils.handleColor("idScanCaptureScreenTextBackgroundColor", defaultColor: "#026ff4");
        defaultCustomization.idScanCustomization.buttonBackgroundNormalColor = CapThemeUtils.handleColor("idScanButtonBackgroundNormalColor", defaultColor: "#026ff4");
        defaultCustomization.idScanCustomization.buttonBackgroundDisabledColor = CapThemeUtils.handleColor("idScanButtonBackgroundDisabledColor", defaultColor: "#b3d4fc");
        defaultCustomization.idScanCustomization.buttonBackgroundHighlightColor = CapThemeUtils.handleColor("idScanButtonBackgroundHighlightColor", defaultColor: "#0264dc");
        defaultCustomization.idScanCustomization.buttonTextNormalColor = CapThemeUtils.handleColor("idScanButtonTextNormalColor");
        defaultCustomization.idScanCustomization.buttonTextDisabledColor = CapThemeUtils.handleColor("idScanButtonTextDisabledColor");
        defaultCustomization.idScanCustomization.buttonTextHighlightColor = CapThemeUtils.handleColor("idScanButtonTextHighlightColor");
        defaultCustomization.idScanCustomization.captureScreenBackgroundColor = CapThemeUtils.handleColor("idScanCaptureScreenBackgroundColor");
        defaultCustomization.idScanCustomization.captureFrameStrokeColor = CapThemeUtils.handleColor("idScanCaptureFrameStrokeColor");

        return defaultCustomization;
    }

    public static func retrieveLowLightConfigurationWizardCustomization() -> FaceTecCustomization {
        return retrieveConfigurationWizardCustomization();
    }


    public static func retrieveDynamicDimmingConfigurationWizardCustomization() -> FaceTecCustomization {
        return retrieveConfigurationWizardCustomization();
    }

    static var currentCustomization: FaceTecCustomization = retrieveConfigurationWizardCustomization();
    static var currentLowLightCustomization: FaceTecCustomization = retrieveLowLightConfigurationWizardCustomization();
    static var currentDynamicDimmingCustomization: FaceTecCustomization = retrieveDynamicDimmingConfigurationWizardCustomization();
}
