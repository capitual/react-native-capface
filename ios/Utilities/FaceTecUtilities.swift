//
//  FaceTecUtilities.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import Foundation

class FaceTecUtilities: NSObject {
    private static let FaceThemeUtils: ThemeUtils! = ThemeUtils();
    public static let DefaultStatusBarStyle = UIStatusBarStyle.default;
    
    private static func preferredStatusBarStyle() -> UIStatusBarStyle {
        if #available(iOS 13, *) {
            let statusBarColor: UIStatusBarStyle = FaceThemeUtils.handleStatusBarStyle("defaultStatusBarColorIos")
            return statusBarColor;
        } else {
            return DefaultStatusBarStyle;
        }
    }
    
    public static func getTopMostViewController() -> UIViewController? {
        UIApplication.shared.statusBarStyle = preferredStatusBarStyle();
        
        var topMostViewController = UIApplication.shared.windows[0].rootViewController;
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController;
        }
        
        return topMostViewController;
    }
}
