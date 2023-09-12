//
//  FaceConfig.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 12/09/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

public class FaceConfig {
    private let config: NSDictionary

    init(config: NSDictionary) {
        self.config = config
    }

    private func hasProperty(key: String) -> Bool {
        if self.config.count == 0 {
            return false
        }

        return (self.config.value(forKey: key) != nil)
    }

    private func getValue(key: String) -> String? {
        return self.hasProperty(key: key) ? "\(self.config[key]!)" : nil
    }

    func getKey() -> String? {
        if let key = self.getValue(key: "key") {
            let isAuthenticate = key == KeyFaceProcessor.authenticateMessage.rawValue
            let isEnroll = key == KeyFaceProcessor.enrollMessage.rawValue
            let isLiveness = key == KeyFaceProcessor.livenessMessage.rawValue
            let isValidKey = isAuthenticate || isEnroll || isLiveness
            if isValidKey {
                return key
            }
        }
        return nil
    }

    func getEndpoint() -> String? {
        return self.hasProperty(key: "endpoint") ? self.getValue(key: "endpoint") : nil
    }

    func getSuccessMessage() -> String? {
        if let key = self.getKey() {
            let isAuthenticate = key == KeyFaceProcessor.authenticateMessage.rawValue
            let defaultMessage = isAuthenticate ? "Authenticated" : "Liveness\nConfirmed"
            if self.hasProperty(key: "successMessage") {
                return self.getValue(key: "successMessage")
            }
        }
        return nil
    }

    func getHasExternalDatabaseRefID() -> Bool {
        if let key = self.getKey() {
            let isLiveness = key == KeyFaceProcessor.livenessMessage.rawValue
            if isLiveness {
                return false
            }
            if let hasExternalDatabaseRefID = self.getValue(key: "hasExternalDatabaseRefID") {
                return hasExternalDatabaseRefID == "true"
            }
        }
        return false
    }

    func getParameters() -> [String: Any]? {
        return self.hasProperty(key: "parameters") ? self.config["parameters"] as? [String: Any] : nil
    }
}
