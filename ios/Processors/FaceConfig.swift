//
//  FaceConfig.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 12/09/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

public class FaceConfig {
    private var config: NSDictionary = NSDictionary()

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

    func isWhichFlow(_ keyFlow: KeyFaceProcessor, key: String) -> Bool {
        return key == keyFlow.rawValue
    }

    func getKey() -> String? {
        if let key = self.getValue(key: "key") {
            let isAuthenticate = self.isWhichFlow(KeyFaceProcessor.authenticateMessage, key)
            let isEnroll = self.isWhichFlow(KeyFaceProcessor.enrollMessage, key)
            let isLiveness = self.isWhichFlow(KeyFaceProcessor.livenessMessage, key)
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
            let isAuthenticate = self.isWhichFlow(KeyFaceProcessor.authenticateMessage, key)
            let defaultMessage = isAuthenticate ? "Authenticated" : "Liveness\nConfirmed"
            if self.hasProperty(key: "successMessage") {
                return self.getValue(key: "successMessage")
            }
            return defaultMessage
        }
        return nil
    }

    func getHasExternalDatabaseRefID() -> Bool {
        if let key = self.getKey() {
            let isLiveness = self.isWhichFlow(KeyFaceProcessor.livenessMessage, key)
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
