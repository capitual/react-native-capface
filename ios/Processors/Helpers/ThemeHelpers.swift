//
//  ThemeHelpers.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import Foundation
import UIKit
import FaceTecSDK

public class ThemeHelpers {
    @available(iOS 8.2, *)
    public class func setAppTheme(_ options: NSDictionary?) {
        Config.setTheme(options);
        Config.currentCustomization = getCustomizationForTheme()
        Config.currentLowLightCustomization = getLowLightCustomizationForTheme()
        Config.currentDynamicDimmingCustomization = getDynamicDimmingCustomizationForTheme()
        
        FaceTec.sdk.setCustomization(Config.currentCustomization)
        FaceTec.sdk.setLowLightCustomization(Config.currentLowLightCustomization)
        FaceTec.sdk.setDynamicDimmingCustomization(Config.currentDynamicDimmingCustomization)
    }
    
    @available(iOS 8.2, *)
    class func getCustomizationForTheme() -> FaceTecCustomization {
        var currentCustomization = FaceTecCustomization()
        currentCustomization = Config.retrieveConfigurationWizardCustomization()
        
        return currentCustomization
    }
    
    // Configure UX Color Scheme For Low Light Mode
    @available(iOS 8.2, *)
    class func getLowLightCustomizationForTheme() -> FaceTecCustomization {
        var currentLowLightCustomization: FaceTecCustomization = getCustomizationForTheme()
        currentLowLightCustomization = Config.retrieveLowLightConfigurationWizardCustomization()
        
        return currentLowLightCustomization
    }
    
    // Configure UX Color Scheme For Low Light Mode
    @available(iOS 8.2, *)
    class func getDynamicDimmingCustomizationForTheme() -> FaceTecCustomization {
        var currentDynamicDimmingCustomization: FaceTecCustomization = getCustomizationForTheme()
        currentDynamicDimmingCustomization = Config.retrieveDynamicDimmingConfigurationWizardCustomization()
        
        return currentDynamicDimmingCustomization
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
