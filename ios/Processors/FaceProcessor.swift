//
//  LivenessCheckProcessor.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 12/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import UIKit
import Foundation
import FaceTecSDK

class FaceProcessor: NSObject, Processor, FaceTecFaceScanProcessorDelegate, URLSessionTaskDelegate {
    var success = false
    var config: NSDictionary!
    var latestNetworkRequest: URLSessionTask!
    var fromViewController: CapFaceViewController!
    var faceScanResultCallback: FaceTecFaceScanResultCallback!
    private let key: String!
    private let faceConfig: FaceConfig!
    private let CapThemeUtils: ThemeUtils! = ThemeUtils();

    init(sessionToken: String, fromViewController: CapFaceViewController, config: NSDictionary) {
        self.fromViewController = fromViewController
        self.config = config
        self.faceConfig = FaceConfig(config: config)
        self.key = faceConfig.getKey()
        super.init()

        ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: true);

        let faceViewController = FaceTec.sdk.createSessionVC(faceScanProcessorDelegate: self, sessionToken: sessionToken)

        FaceTecUtilities.getTopMostViewController()?.present(faceViewController, animated: true, completion: nil)
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
        if (self.config != nil) {
            parameters["data"] = self.config
        }
        parameters["faceScan"] = sessionResult.faceScanBase64
        parameters["auditTrailImage"] = sessionResult.auditTrailCompressedBase64![0]
        parameters["lowQualityAuditTrailImage"] = sessionResult.lowQualityAuditTrailCompressedBase64![0]

        var request: URLRequest

        switch key {
            case "enrollMessage":
                request = Config.makeRequest(url: "/enrollment-3d", httpMethod: "POST")
            case "authenticateMessage":
                request = Config.makeRequest(url: "/match-3d-3d", httpMethod: "POST")
            case "livenessMessage":
                request = Config.makeRequest(url: "/liveness-3d", httpMethod: "POST")
            default:
                request = Config.makeRequest(url: "/enrollment-3d", httpMethod: "POST")
        }

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 299 {
                    print("Exception raised while attempting HTTPS call. Status code: \(httpResponse.statusCode)");
                    ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                    faceScanResultCallback.onFaceScanResultCancel()
                    return
                }
            }

            if let error = error {
                print("Exception raised while attempting HTTPS call.")
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                faceScanResultCallback.onFaceScanResultCancel()
                return
            }

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
                let message = self.CapThemeUtils.handleMessage(self.key, child: "successMessage", defaultMessage: "Liveness\nConfirmed");
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

            let message = self.CapThemeUtils.handleMessage(self.key, child: "uploadMessageIos", defaultMessage: "Still Uploading...");
            let uploadMessage: NSMutableAttributedString = NSMutableAttributedString.init(string: message);
            faceScanResultCallback.onFaceScanUploadMessageOverride(uploadMessageOverride: uploadMessage);
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        faceScanResultCallback.onFaceScanUploadProgress(uploadedPercent: uploadProgress)
    }

    func onFaceTecSDKCompletelyDone() {
        self.fromViewController.onComplete();
    }

    func isSuccess() -> Bool {
        return success
    }
}
