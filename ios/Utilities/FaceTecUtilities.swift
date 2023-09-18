//
//  FaceTecUtilities.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import Foundation

class FaceTecUtilities: NSObject {
    private static let CapThemeUtils: ThemeUtils! = ThemeUtils();
    public static let DefaultStatusBarStyle = UIStatusBarStyle.default;

    private static func preferredStatusBarStyle() -> UIStatusBarStyle {
        if #available(iOS 13, *) {
            return CapThemeUtils.handleStatusBarStyle("defaultStatusBarColorIos")
        } else {
            return DefaultStatusBarStyle
        }
    }

    public static func getTopMostViewController() -> UIViewController? {
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            var topMostViewController = topViewController

            while let presentedViewController = topMostViewController.presentedViewController {
                topMostViewController = presentedViewController
            }

            topMostViewController.setNeedsStatusBarAppearanceUpdate()

            return topMostViewController
        }

        return nil
    }
}
