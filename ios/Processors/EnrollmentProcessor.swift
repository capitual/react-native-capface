//
//  EnrollmentProcessor.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import UIKit
import Foundation
import FaceTecSDK

class EnrollmentProcessor: NSObject, Processor, FaceTecFaceScanProcessorDelegate, URLSessionTaskDelegate {
    var success = false
    var data: NSDictionary!
    var latestNetworkRequest: URLSessionTask!
    var fromViewController: FaceTecViewController!
    var faceScanResultCallback: FaceTecFaceScanResultCallback!
    private let principalKey = "enrollMessage";
    private let FaceThemeUtils: ThemeUtils! = ThemeUtils();
    
    init(sessionToken: String, fromViewController: FaceTecViewController, data: NSDictionary) {
        self.fromViewController = fromViewController
        self.data = data
        super.init()
        
        ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: true);
        
        let enrollmentViewController = FaceTec.sdk.createSessionVC(faceScanProcessorDelegate: self, sessionToken: sessionToken)
        
        FaceTecUtilities.getTopMostViewController()?.present(enrollmentViewController, animated: true, completion: nil)
    }
    
    func processSessionWhileFaceTecSDKWaits(sessionResult: FaceTecSessionResult, faceScanResultCallback: FaceTecFaceScanResultCallback) {
        
        fromViewController.setLatestSessionResult(sessionResult: sessionResult)
        
        self.faceScanResultCallback = faceScanResultCallback
        
        if sessionResult.status != FaceTecSessionStatus.sessionCompletedSuccessfully {
            if latestNetworkRequest != nil {
                latestNetworkRequest.cancel()
            }
            
            ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
            faceScanResultCallback.onFaceScanResultCancel()
            return
        }
        
        var parameters: [String : Any] = [:]
        if (self.data != nil) {
            parameters["data"] = self.data
        }
        parameters["faceScan"] = sessionResult.faceScanBase64
        parameters["auditTrailImage"] = sessionResult.auditTrailCompressedBase64![0]
        parameters["lowQualityAuditTrailImage"] = sessionResult.lowQualityAuditTrailCompressedBase64![0]
        parameters["externalDatabaseRefID"] = fromViewController.getLatestExternalDatabaseRefID()
        
        var request = Config.makeRequest(url: "/enrollment-3d", httpMethod: "POST")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                faceScanResultCallback.onFaceScanResultCancel()
                return
            }
            
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                faceScanResultCallback.onFaceScanResultCancel()
                return
            }
            
            guard let scanResultBlob = responseJSON["scanResultBlob"] as? String,
                  let wasProcessed = responseJSON["wasProcessed"] as? Bool else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                faceScanResultCallback.onFaceScanResultCancel()
                return;
            }
            
            if wasProcessed == true {
                let message = self.FaceThemeUtils.handleMessage(self.principalKey, child: "successMessage", defaultMessage: "Liveness\nConfirmed");
                FaceTecCustomization.setOverrideResultScreenSuccessMessage(message);
                
                self.success = faceScanResultCallback.onFaceScanGoToNextStep(scanResultBlob: scanResultBlob);
            } else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                faceScanResultCallback.onFaceScanResultCancel()
                return;
            }
        })
        
        latestNetworkRequest.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if self.latestNetworkRequest.state == .completed { return }
            
            let message = self.FaceThemeUtils.handleMessage(self.principalKey, child: "uploadMessageIos", defaultMessage: "Still Uploading...");
            let uploadMessage:NSMutableAttributedString = NSMutableAttributedString.init(string: message);
            faceScanResultCallback.onFaceScanUploadMessageOverride(uploadMessageOverride: uploadMessage);
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        faceScanResultCallback.onFaceScanUploadProgress(uploadedPercent: uploadProgress)
    }
    
    func onFaceTecSDKCompletelyDone() {
        self.fromViewController.onComplete()
    }
    
    func isSuccess() -> Bool {
        return success
    }
}
