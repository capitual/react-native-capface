//
//  ThemeUtils.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import Foundation
import FaceTecSDK

public class ThemeUtils {
    private func themeAndKeyDoesNotExists(_ key: String) -> Bool {
        return Config.Theme == nil || Config.Theme?[key] == nil;
    }
    
    private func parseUIColor(_ key: String, defaultColor: UIColor) -> UIColor {
        let color = (Config.Theme?[key] as? String) ?? "";
        if (color.isEmpty) {
            return defaultColor;
        }
        return UIColor(hexString: color);
    }
    
    private func convertHexColorsToUIColors(_ hexColors: [String?]) -> [UIColor] {
        var colors = [UIColor]();
        if hexColors.isEmpty {
            return colors;
        }
        
        for hexColor in hexColors {
            if (hexColor != nil && hexColor != "") {
                colors.append(UIColor(hexString: hexColor!));
            }
        }
        
        if (colors.count == 1) {
            colors.append(colors[0]);
        }
        return colors;
    }
    
    private func convertHexColorsToCGColors(_ hexColors: [String?]) -> [CGColor] {
        var colors = [CGColor]();
        let defaultColor = UIColor(hexString: "#026ff4").cgColor;
        let defaultColors = [defaultColor, defaultColor];
        if (hexColors.isEmpty) {
            return defaultColors;
        }
        
        for hexColor in hexColors {
            if (hexColor != nil && hexColor != "") {
                let cgColor = UIColor(hexString: hexColor!).cgColor;
                colors.append(cgColor);
            }
        }
        
        if (colors.count == 1) {
            colors.append(colors[0]);
        }
        return colors;
    }
    
    private func handleLocationGradient(_ locations: [Int?]) -> [NSNumber] {
        let defaultLocations: [NSNumber] = [0, 1];
        if (locations.count != 2) {
            return defaultLocations;
        }
        
        for location in locations {
            if (location == nil || (location! < 0 || location! > 1)) {
                return defaultLocations;
            }
        }
        return locations as! [NSNumber];
    }
    
    private func handleCGPoints(_ points: NSDictionary?, defaultPoints: CGPoint) -> CGPoint {
        if (points == nil) {
            return defaultPoints;
        }
        let xPoint = points?["x"] as? Double ?? defaultPoints.x;
        let yPoint = points?["y"] as? Double ?? defaultPoints.y;
        return CGPoint.init(x: xPoint, y: yPoint);
    }
    
    private func handleCAGradientProperties(_ acGradient: NSDictionary) -> CAGradientLayer {
        let gradiant = CAGradientLayer.init();
        let properties = ["colors", "locations", "startPoint", "endPoint"];
        for property in properties {
            if (acGradient[property] != nil) {
                switch property {
                case "colors": do {
                    gradiant.colors = self.convertHexColorsToCGColors((acGradient[property] as? [String?] ?? []));
                    break;
                }
                case "locations": do {
                    gradiant.locations = self.handleLocationGradient((acGradient[property] as? [Int?] ?? []));
                    break;
                }
                case "startPoint": do {
                    gradiant.startPoint = self.handleCGPoints((acGradient[property] as? NSDictionary), defaultPoints: CGPoint.init(x: 0, y: 0));
                    break;
                }
                case "endPoint": do {
                    gradiant.endPoint = self.handleCGPoints((acGradient[property] as? NSDictionary), defaultPoints: CGPoint.init(x: 1, y: 0));
                    break;
                }
                default: do {
                    break;
                }
                }
            }
        }
        return gradiant;
    }
    
    public func handleBorderRadius(_ key: String) -> Int32 {
        let defaultBorderRadius: Int32 = 10;
        if (self.themeAndKeyDoesNotExists(key)) {
            return defaultBorderRadius;
        }
        
        let borderRadius = (Config.Theme?[key] as? Int32) ?? defaultBorderRadius
        return borderRadius < 0 ? defaultBorderRadius : borderRadius;
    }
    
    public func handleColor(_ key: String) -> UIColor {
        let defaultColor = UIColor(hexString: "#ffffff");
        if (self.themeAndKeyDoesNotExists(key)) {
            return defaultColor;
        }
        return self.parseUIColor(key, defaultColor: defaultColor);
    }
    
    public func handleColor(_ key: String, defaultColor: String) -> UIColor {
        if (self.themeAndKeyDoesNotExists(key)) {
            return UIColor(hexString: defaultColor);
        }
        return self.parseUIColor(key, defaultColor: UIColor(hexString: defaultColor));
    }
    
    public func handleSimpleLinearGradient(_ key: String) -> [UIColor] {
        let color = UIColor(hexString: "#ffffff");
        let defaultColors = [color, color];
        if (self.themeAndKeyDoesNotExists(key)) {
            return defaultColors;
        }
        let hexColors = Config.Theme?[key] as? [String?] ?? [];
        let colors = self.convertHexColorsToUIColors(hexColors);
        if (colors.isEmpty) {
            return defaultColors;
        }
        return colors;
    }
    
    public func handleCAGradient(_ key: String) -> CAGradientLayer {
        let defaultColor = UIColor(hexString: "#026ff4").cgColor;
        let caGradient = CAGradientLayer.init();
        caGradient.colors = [defaultColor, defaultColor];
        caGradient.locations = [0, 1];
        caGradient.startPoint = CGPoint.init(x: 0, y: 0);
        caGradient.endPoint = CGPoint.init(x: 1, y: 0);
        
        if (self.themeAndKeyDoesNotExists(key)) {
            return caGradient;
        }
        
        let gradiant = Config.Theme?[key] as? NSDictionary;
        if (gradiant != nil) {
            return self.handleCAGradientProperties(gradiant!);
        }
        return caGradient;
    }
    
    public func handleMessage(_ key: String, child: String, defaultMessage: String) -> String {
        if (self.themeAndKeyDoesNotExists(key)) {
            return defaultMessage;
        }
        let rootObject = Config.Theme?[key] as? NSDictionary;
        return rootObject?[child] as? String ?? defaultMessage;
    }
    
    public func handleImage(_ key: String, defaultImage: String) -> UIImage? {
        if (self.themeAndKeyDoesNotExists(key)) {
            return UIImage(named: defaultImage);
        }
        
        let imageName = (Config.Theme?[key] as? String) ?? "";
        if (imageName.isEmpty) {
            return UIImage(named: defaultImage);
        }

        return UIImage(named: imageName);
    }
    
    public func handleButtonLocation(_ key: String) -> FaceTecCancelButtonLocation {
        let defaultLocation = FaceTecCancelButtonLocation.topRight;
        if (self.themeAndKeyDoesNotExists(key)) {
            return defaultLocation;
        }
        let buttonLocation = (Config.Theme?[key] as? String) ?? "";
        if (buttonLocation.isEmpty) {
            return defaultLocation;
        }
        
        switch (buttonLocation) {
        case "TOP_RIGHT": do {
            return FaceTecCancelButtonLocation.topRight;
        }
        case "TOP_LEFT": do {
            return FaceTecCancelButtonLocation.topLeft;
        }
        case "DISABLED": do {
            return FaceTecCancelButtonLocation.disabled;
        }
        default: do {
            return defaultLocation;
        }
        }
    }
    
    public func handleStatusBarStyle(_ key: String) -> UIStatusBarStyle {
        var defaultStatusBar = UIStatusBarStyle.default;
        if #available(iOS 13, *) {
            defaultStatusBar = UIStatusBarStyle.darkContent;
        }
        
        if (self.themeAndKeyDoesNotExists(key)) {
            return defaultStatusBar;
        }
        let statusBarColor = (Config.Theme?[key] as? String) ?? "";
        if (statusBarColor.isEmpty) {
            return defaultStatusBar;
        }
        
        if #available(iOS 13, *) {
            switch (statusBarColor) {
            case "DARK_CONTENT": do {
                return defaultStatusBar;
            }
            case "LIGHT_CONTENT": do {
                return UIStatusBarStyle.lightContent;
            }
            case "DEFAULT": do {
                return UIStatusBarStyle.default;
            }
            default: do {
                return defaultStatusBar;
            }
            }
        }
        
        return defaultStatusBar;
    }
}
