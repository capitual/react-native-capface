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
    public static var DeviceKeyIdentifier: String!
    public static var BaseURL: String!
    public static var PublicFaceScanEncryptionKey: String!
    public static var ProductionKeyText: String!
    public static var Headers: NSDictionary?
    public static var Theme: NSDictionary?
    private static let FaceThemeUtils: ThemeUtils! = ThemeUtils();
    
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
    
    static func initializeFaceTecSDKFromAutogeneratedConfig(_ isDeveloperMode: Bool, completion: @escaping (Bool)->()) {
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
        
        defaultCustomization.frameCustomization.cornerRadius = FaceThemeUtils.handleBorderRadius("frameCornerRadius");
        defaultCustomization.frameCustomization.backgroundColor = FaceThemeUtils.handleColor("frameBackgroundColor");
        defaultCustomization.frameCustomization.borderColor = FaceThemeUtils.handleColor("frameBorderColor");
        
        defaultCustomization.overlayCustomization.brandingImage = FaceThemeUtils.handleImage("logoImage", defaultImage: "FaceTec_your_app_logo");
        defaultCustomization.overlayCustomization.backgroundColor = FaceThemeUtils.handleColor("overlayBackgroundColor");
        
        defaultCustomization.guidanceCustomization.backgroundColors = FaceThemeUtils.handleSimpleLinearGradient("guidanceBackgroundColorsIos");
        defaultCustomization.guidanceCustomization.foregroundColor = FaceThemeUtils.handleColor("guidanceForegroundColor", defaultColor: "#272937");
        defaultCustomization.guidanceCustomization.buttonBackgroundNormalColor = FaceThemeUtils.handleColor("guidanceButtonBackgroundNormalColor", defaultColor: "#026ff4");
        defaultCustomization.guidanceCustomization.buttonBackgroundDisabledColor = FaceThemeUtils.handleColor("guidanceButtonBackgroundDisabledColor", defaultColor: "#b3d4fc");
        defaultCustomization.guidanceCustomization.buttonBackgroundHighlightColor = FaceThemeUtils.handleColor("guidanceButtonBackgroundHighlightColor", defaultColor: "#0264dc");
        defaultCustomization.guidanceCustomization.buttonTextNormalColor = FaceThemeUtils.handleColor("guidanceButtonTextNormalColor");
        defaultCustomization.guidanceCustomization.buttonTextDisabledColor = FaceThemeUtils.handleColor("guidanceButtonTextDisabledColor");
        defaultCustomization.guidanceCustomization.buttonTextHighlightColor = FaceThemeUtils.handleColor("guidanceButtonTextHighlightColor");
        defaultCustomization.guidanceCustomization.retryScreenImageBorderColor = FaceThemeUtils.handleColor("guidanceRetryScreenImageBorderColor");
        defaultCustomization.guidanceCustomization.retryScreenOvalStrokeColor = FaceThemeUtils.handleColor("guidanceRetryScreenOvalStrokeColor");
        
        defaultCustomization.ovalCustomization.strokeColor = FaceThemeUtils.handleColor("ovalStrokeColor", defaultColor: "#026ff4");
        defaultCustomization.ovalCustomization.progressColor1 = FaceThemeUtils.handleColor("ovalFirstProgressColor", defaultColor: "#0264dc");
        defaultCustomization.ovalCustomization.progressColor2 = FaceThemeUtils.handleColor("ovalSecondProgressColor", defaultColor: "#0264dc");
        
        defaultCustomization.feedbackCustomization.backgroundColor = FaceThemeUtils.handleCAGradient("feedbackBackgroundColorsIos");
        defaultCustomization.feedbackCustomization.textColor = FaceThemeUtils.handleColor("feedbackTextColor");
        
        defaultCustomization.cancelButtonCustomization.customImage = FaceThemeUtils.handleImage("cancelImage", defaultImage: "FaceTec_cancel");
        defaultCustomization.cancelButtonCustomization.location = FaceThemeUtils.handleButtonLocation("cancelButtonLocation");
        
        defaultCustomization.resultScreenCustomization.backgroundColors = FaceThemeUtils.handleSimpleLinearGradient("resultScreenBackgroundColorsIos");
        defaultCustomization.resultScreenCustomization.foregroundColor = FaceThemeUtils.handleColor("resultScreenForegroundColor", defaultColor: "#272937");
        defaultCustomization.resultScreenCustomization.activityIndicatorColor = FaceThemeUtils.handleColor("resultScreenActivityIndicatorColor", defaultColor: "#026ff4");
        defaultCustomization.resultScreenCustomization.resultAnimationBackgroundColor = FaceThemeUtils.handleColor("resultScreenResultAnimationBackgroundColor", defaultColor: "#026ff4");
        defaultCustomization.resultScreenCustomization.resultAnimationForegroundColor = FaceThemeUtils.handleColor("resultScreenResultAnimationForegroundColor");
        defaultCustomization.resultScreenCustomization.uploadProgressFillColor = FaceThemeUtils.handleColor("resultScreenUploadProgressFillColor", defaultColor: "#026ff4");
        
        defaultCustomization.securityWatermarkImage = securityWatermarkImage;
        
        defaultCustomization.idScanCustomization.selectionScreenBackgroundColors = FaceThemeUtils.handleSimpleLinearGradient("idScanSelectionScreenBackgroundColorsIos");
        defaultCustomization.idScanCustomization.selectionScreenForegroundColor = FaceThemeUtils.handleColor("idScanSelectionScreenForegroundColor", defaultColor: "#272937");
        defaultCustomization.idScanCustomization.reviewScreenForegroundColor = FaceThemeUtils.handleColor("idScanReviewScreenForegroundColor");
        defaultCustomization.idScanCustomization.reviewScreenTextBackgroundColor = FaceThemeUtils.handleColor("idScanReviewScreenTextBackgroundColor", defaultColor: "#026ff4");
        defaultCustomization.idScanCustomization.captureScreenForegroundColor = FaceThemeUtils.handleColor("idScanCaptureScreenForegroundColor");
        defaultCustomization.idScanCustomization.captureScreenTextBackgroundColor = FaceThemeUtils.handleColor("idScanCaptureScreenTextBackgroundColor", defaultColor: "#026ff4");
        defaultCustomization.idScanCustomization.buttonBackgroundNormalColor = FaceThemeUtils.handleColor("idScanButtonBackgroundNormalColor", defaultColor: "#026ff4");
        defaultCustomization.idScanCustomization.buttonBackgroundDisabledColor = FaceThemeUtils.handleColor("idScanButtonBackgroundDisabledColor", defaultColor: "#b3d4fc");
        defaultCustomization.idScanCustomization.buttonBackgroundHighlightColor = FaceThemeUtils.handleColor("idScanButtonBackgroundHighlightColor", defaultColor: "#0264dc");
        defaultCustomization.idScanCustomization.buttonTextNormalColor = FaceThemeUtils.handleColor("idScanButtonTextNormalColor");
        defaultCustomization.idScanCustomization.buttonTextDisabledColor = FaceThemeUtils.handleColor("idScanButtonTextDisabledColor");
        defaultCustomization.idScanCustomization.buttonTextHighlightColor = FaceThemeUtils.handleColor("idScanButtonTextHighlightColor");
        defaultCustomization.idScanCustomization.captureScreenBackgroundColor = FaceThemeUtils.handleColor("idScanCaptureScreenBackgroundColor");
        defaultCustomization.idScanCustomization.captureFrameStrokeColor = FaceThemeUtils.handleColor("idScanCaptureFrameStrokeColor");
        
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
