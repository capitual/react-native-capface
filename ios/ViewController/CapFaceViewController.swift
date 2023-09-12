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
    
    func onFaceUser(_ config: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        setProcessorPromise(resolve, rejecter: reject);

        getSessionToken() { sessionToken in
            self.resetLatestResults()
            self.latestProcessor = FaceProcessor(sessionToken: sessionToken, fromViewController: self, config: config)
        }
    }

    func onPhotoIDMatch(_ data: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        setProcessorPromise(resolve, rejecter: reject);

        getSessionToken() { sessionToken in
            self.resetLatestResults()
            self.latestExternalDatabaseRefID = "ios_app_" + UUID().uuidString
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
        UIApplication.shared.statusBarStyle = FaceTecUtilities.DefaultStatusBarStyle;

        if self.latestProcessor != nil {
            self.isSuccess = self.latestProcessor.isSuccess();
        }

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
                    print("Exception raised while attempting HTTPS call. Status code: \(httpResponse.statusCode)");
                    if self.processorRejecter != nil {
                        self.processorRejecter("Exception raised while attempting HTTPS call.", "HTTPSError", nil);
                    }
                    return
                }
            }

            if let error = error {
                print("Exception raised while attempting HTTPS call.")
                if self.processorRejecter != nil {
                    self.processorRejecter("Exception raised while attempting HTTPS call.", "HTTPSError", nil);
                }
                return
            }

            guard let data = data else {
                print("Exception raised while attempting HTTPS call.")
                if self.processorRejecter != nil {
                    self.processorRejecter("Exception raised while attempting HTTPS call.", "HTTPSError", nil);
                }
                return
            }

            if let responseJSONObj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                if((responseJSONObj["sessionToken"] as? String) != nil) {
                    sessionTokenCallback(responseJSONObj["sessionToken"] as! String)
                    return
                } else {
                    print("Exception raised while attempting HTTPS call.")
                    if self.processorRejecter != nil {
                        self.processorRejecter("Exception raised while attempting HTTPS call.", "HTTPSError", nil);
                    }
                }
            }
        })

        task.resume();
    }
}
