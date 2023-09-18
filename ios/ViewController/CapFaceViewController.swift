//
//  FaceTecViewController.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import UIKit
import FaceTecSDK
import LocalAuthentication

class CapFaceViewController: UIViewController, URLSessionDelegate {
    private let exceptionHttpMessage = "Exception raised while attempting HTTPS call."
    var isSuccess: Bool! = false
    var latestExternalDatabaseRefID: String = ""
    var latestSessionResult: FaceTecSessionResult!
    var latestIDScanResult: FaceTecIDScanResult!
    var processorRevolver: RCTPromiseResolveBlock!;
    var processorRejecter: RCTPromiseRejectBlock!;
    var latestProcessor: Processor!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func generateUUID() -> String {
        return "ios_app_" + UUID().uuidString
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return FaceTecUtilities.DefaultStatusBarStyle
    }
    
    func onFaceUser(_ config: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        setProcessorPromise(resolve, rejecter: reject);

        getSessionToken() { sessionToken in
            self.resetLatestResults()
            let faceConfig = FaceConfig(config: config)
            if (faceConfig.isWhichFlow(KeyFaceProcessor.enrollMessage, key: faceConfig.getKey() ?? "")) {
                self.latestExternalDatabaseRefID = self.generateUUID()
            }
            self.latestProcessor = FaceProcessor(sessionToken: sessionToken, fromViewController: self, faceConfig: faceConfig)
        }
    }

    func onPhotoIDMatch(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        setProcessorPromise(resolve, rejecter: reject);

        getSessionToken() { sessionToken in
            self.resetLatestResults()
            self.latestExternalDatabaseRefID = self.generateUUID()
            self.latestProcessor = PhotoIDMatchProcessor(sessionToken: sessionToken, fromViewController: self, data: data)
        }
    }

    func onPhotoIDScan(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        setProcessorPromise(resolve, rejecter: reject);

        getSessionToken() { sessionToken in
            self.resetLatestResults()
            self.latestProcessor = PhotoIDScanProcessor(sessionToken: sessionToken, fromViewController: self, data: data)
        }
    }

    func onComplete() {
        if self.latestProcessor != nil {
            self.isSuccess = self.latestProcessor.isSuccess();
        }
        
        setNeedsStatusBarAppearanceUpdate()

        ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);

        if !self.isSuccess {
            self.latestExternalDatabaseRefID = "";
            self.processorRejecter("CapFace SDK values were not processed!", "CapFaceValuesWereNotProcessed", nil);
        } else {
            self.processorRevolver(self.isSuccess);
        }
    }

    func setLatestSessionResult(sessionResult: FaceTecSessionResult) {
        latestSessionResult = sessionResult
    }

    func setLatestIDScanResult(idScanResult: FaceTecIDScanResult) {
        latestIDScanResult = idScanResult
    }

    func resetLatestResults() {
        latestSessionResult = nil
        latestIDScanResult = nil
    }

    func getLatestExternalDatabaseRefID() -> String {
        return latestExternalDatabaseRefID;
    }

    func setProcessorPromise(_ resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        self.processorRevolver = resolver;
        self.processorRejecter = rejecter;
    }

    func getSessionToken(sessionTokenCallback: @escaping (String) -> ()) {
        let request = Config.makeRequest(url: "/session-token", httpMethod: "GET");

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 299 {
                    if self.processorRejecter != nil {
                        self.processorRejecter("Exception raised while attempting to parse JSON result.", "JSONError", nil);
                    }
                    return
                }
            }

            if let error = error {
                if self.processorRejecter != nil {
                    self.processorRejecter(self.exceptionHttpMessage, "HTTPSError", nil);
                }
                return
            }

            guard let data = data else {
                if self.processorRejecter != nil {
                    self.processorRejecter(self.exceptionHttpMessage, "HTTPSError", nil);
                }
                return
            }

            if let responseJSONObj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                if((responseJSONObj["sessionToken"] as? String) != nil) {
                    sessionTokenCallback(responseJSONObj["sessionToken"] as! String)
                    return
                } else {
                    var errorMessage: String!
                    if ((responseJSONObj["errorMessage"] as? String) != nil) {
                        errorMessage = responseJSONObj["errorMessage"] as! String
                    } else {
                        errorMessage = "Response JSON is missing sessionToken."
                    }
                    if self.processorRejecter != nil {
                        self.processorRejecter(errorMessage, "JSONError", nil);
                    }
                }
            }
        })

        task.resume();
    }
}
