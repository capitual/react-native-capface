//
//  ReactNativeCapfaceSdk.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//


import Foundation
import FaceTecSDK
import LocalAuthentication

@objc(ReactNativeCapfaceSdk)
class ReactNativeCapfaceSdk: RCTEventEmitter, URLSessionDelegate {
    public static var emitter: RCTEventEmitter!
    var capFaceViewController: CapFaceViewController!
    var isInitialized: Bool = false;
    
    override init() {
        super.init();
        ReactNativeCapfaceSdk.emitter = self;
    }
    
    private func isDeveloperMode(_ params: NSDictionary) -> Bool {
        if let isDevMode = params["isDeveloperMode"] as? Bool {
            return isDevMode
        } else {
            return false
        }
    }
    
    private func handleCapFaceConfiguration(_ params: NSDictionary, headers: NSDictionary) {
        Config.setDevice(params.value(forKey: "device") as! String);
        Config.setUrl(params.value(forKey: "url") as! String);
        Config.setKey(params.value(forKey: "key") as! String);
        Config.setProductionKeyText(params.value(forKey: "productionKey") as! String);
        Config.setHeaders(headers);
    }
    
    @objc func initializeSdk(_ params: NSDictionary, headers: NSDictionary, callback: @escaping RCTResponseSenderBlock) -> Void {
        DispatchQueue.main.async {
            self.capFaceViewController = CapFaceViewController();
            self.handleTheme(Config.Theme);
            
            if params.count == 0 {
                self.isInitialized = false;
                callback([false]);
                print("No parameters provided!");
                return;
            }
            
            self.handleCapFaceConfiguration(params, headers: headers);
            
            if (Config.hasConfig()) {
                Config.initialize(self.isDeveloperMode(params), completion: { initializationSuccessful in
                    self.isInitialized = initializationSuccessful;
                    callback([initializationSuccessful]);
                })
            } else {
                self.isInitialized = false;
                callback([false]);
                print("CapFace SDK Configuration doesn't exists!");
            }
        }
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return true;
    }
    
    @objc override func constantsToExport() -> [AnyHashable : Any]! {
        return nil;
    }
    
    @objc override func startObserving() {}
    
    @objc override func stopObserving() {}
    
    @objc override func supportedEvents() -> [String]! {
        return ["onCloseModal"];
    }
    
    @objc func handleLivenessCheck(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if self.isInitialized {
            self.capFaceViewController.onLivenessCheck(data, resolve: resolve, reject: reject);
        } else {
            print("CapFace SDK has not been initialized!");
            return reject("CapFace SDK has not been initialized!", "CapFaceHasNotBeenInitialized", nil);
        }
    }
    
    @objc func handleEnrollUser(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if self.isInitialized {
            self.capFaceViewController.onEnrollUser(data, resolve: resolve, reject: reject);
        } else {
            print("CapFace SDK has not been initialized!");
            return reject("CapFace SDK has not been initialized!", "CapFaceHasNotBeenInitialized", nil);
        }
    }
    
    @objc func handleAuthenticateUser(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if self.isInitialized {
            self.capFaceViewController.onAuthenticateUser(data, resolve: resolve, reject: reject);
        } else {
            print("CapFace SDK has not been initialized!");
            return reject("CapFace SDK has not been initialized!", "CapFaceHasNotBeenInitialized", nil);
        }
    }
    
    @objc func handlePhotoIDMatch(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if self.isInitialized {
            self.capFaceViewController.onPhotoIDMatch(data, resolve: resolve, reject: reject);
        } else {
            print("CapFace SDK has not been initialized!");
            return reject("CapFace SDK has not been initialized!", "CapFaceHasNotBeenInitialized", nil);
        }
    }
    
    @objc func handlePhotoIDScan(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if self.isInitialized {
            self.capFaceViewController.onPhotoIDScan(data, resolve: resolve, reject: reject);
        } else {
            print("CapFace SDK has not been initialized!");
            return reject("CapFace SDK has not been initialized!", "CapFaceHasNotBeenInitialized", nil);
        }
    }
    
    @objc func handleTheme(_ options: NSDictionary?) {
        ThemeHelpers.setAppTheme(options);
    }
}
