//
//  PhotoIDMatchProcessor.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import UIKit
import Foundation
import FaceTecSDK

class PhotoIDMatchProcessor: NSObject, Processor, FaceTecFaceScanProcessorDelegate, FaceTecIDScanProcessorDelegate, URLSessionTaskDelegate {
    var success = false
    var faceScanWasSuccessful = false
    var latestExternalDatabaseRefID: String!
    var data: NSDictionary!
    var latestNetworkRequest: URLSessionTask!
    var fromViewController: FaceTecViewController!
    var faceScanResultCallback: FaceTecFaceScanResultCallback!
    var idScanResultCallback: FaceTecIDScanResultCallback!
    private let principalKey = "photoIdMatchMessage";
    private let FaceThemeUtils: ThemeUtils! = ThemeUtils();
    
    
    init(sessionToken: String, fromViewController: FaceTecViewController, data: NSDictionary) {
        self.fromViewController = fromViewController
        self.latestExternalDatabaseRefID = self.fromViewController.getLatestExternalDatabaseRefID()
        self.data = data
        super.init()
        
        FaceTecCustomization.setIDScanUploadMessageOverrides(
            frontSideUploadStarted: self.FaceThemeUtils.handleMessage(self.principalKey, child: "frontSideUploadStarted", defaultMessage: "Uploading\nEncrypted\nID Scan"),                // Upload of ID front-side has started.
            frontSideStillUploading: self.FaceThemeUtils.handleMessage(self.principalKey, child: "frontSideStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),         // Upload of ID front-side is still uploading to Server after an extended period of time.
            frontSideUploadCompleteAwaitingResponse: self.FaceThemeUtils.handleMessage(self.principalKey, child: "frontSideUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),             // Upload of ID front-side to the Server is complete.
            frontSideUploadCompleteAwaitingProcessing: self.FaceThemeUtils.handleMessage(self.principalKey, child: "frontSideUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nID Scan"),       // Upload of ID front-side is complete and we are waiting for the Server to finish processing and respond.
            backSideUploadStarted: self.FaceThemeUtils.handleMessage(self.principalKey, child: "backSideUploadStarted", defaultMessage: "Uploading\nEncrypted\nBack of ID"),              // Upload of ID back-side has started.
            backSideStillUploading: self.FaceThemeUtils.handleMessage(self.principalKey, child: "backSideStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),          // Upload of ID back-side is still uploading to Server after an extended period of time.
            backSideUploadCompleteAwaitingResponse: self.FaceThemeUtils.handleMessage(self.principalKey, child: "backSideUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),              // Upload of ID back-side to Server is complete.
            backSideUploadCompleteAwaitingProcessing: self.FaceThemeUtils.handleMessage(self.principalKey, child: "backSideUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nBack of ID"),     // Upload of ID back-side is complete and we are waiting for the Server to finish processing and respond.
            userConfirmedInfoUploadStarted: self.FaceThemeUtils.handleMessage(self.principalKey, child: "userConfirmedInfoUploadStarted", defaultMessage: "Uploading\nYour Confirmed Info"),       // Upload of User Confirmed Info has started.
            userConfirmedInfoStillUploading: self.FaceThemeUtils.handleMessage(self.principalKey, child: "userConfirmedInfoStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"), // Upload of User Confirmed Info is still uploading to Server after an extended period of time.
            userConfirmedInfoUploadCompleteAwaitingResponse: self.FaceThemeUtils.handleMessage(self.principalKey, child: "userConfirmedInfoUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),     // Upload of User Confirmed Info to the Server is complete.
            userConfirmedInfoUploadCompleteAwaitingProcessing: self.FaceThemeUtils.handleMessage(self.principalKey, child: "userConfirmedInfoUploadCompleteAwaitingProcessing", defaultMessage: "Processing"),        // Upload of User Confirmed Info is complete and we are waiting for the Server to finish processing and respond.
            nfcUploadStarted: self.FaceThemeUtils.handleMessage(self.principalKey, child: "nfcUploadStarted", defaultMessage: "Uploading Encrypted\nNFC Details"),                   // Upload of NFC Details has started.
            nfcStillUploading: self.FaceThemeUtils.handleMessage(self.principalKey, child: "nfcStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),               // Upload of NFC Details is still uploading to Server after an extended period of time.
            nfcUploadCompleteAwaitingResponse: self.FaceThemeUtils.handleMessage(self.principalKey, child: "nfcUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),                   // Upload of NFC Details to the Server is complete.
            nfcUploadCompleteAwaitingProcessing: self.FaceThemeUtils.handleMessage(self.principalKey, child: "nfcUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nNFC Details"),         // Upload of NFC Details is complete and we are waiting for the Server to finish processing and respond.
            skippedNFCUploadStarted: self.FaceThemeUtils.handleMessage(self.principalKey, child: "skippedNFCUploadStarted", defaultMessage: "Uploading Encrypted\nID Details"),             // Upload of ID Details has started.
            skippedNFCStillUploading: self.FaceThemeUtils.handleMessage(self.principalKey, child: "skippedNFCStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),        // Upload of ID Details is still uploading to Server after an extended period of time.
            skippedNFCUploadCompleteAwaitingResponse: self.FaceThemeUtils.handleMessage(self.principalKey, child: "skippedNFCUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),            // Upload of ID Details to the Server is complete.
            skippedNFCUploadCompleteAwaitingProcessing: self.FaceThemeUtils.handleMessage(self.principalKey, child: "skippedNFCUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nID Details")    // Upload of ID Details is complete and we are waiting for the Server to finish processing and respond.
        );
        
        ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: true);
        
        let idScanViewController = FaceTec.sdk.createSessionVC(faceScanProcessorDelegate: self, idScanProcessorDelegate: self, sessionToken: sessionToken)
        
        FaceTecUtilities.getTopMostViewController()?.present(idScanViewController, animated: true, completion: nil)
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
        parameters["externalDatabaseRefID"] = self.latestExternalDatabaseRefID
        
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
                
                self.faceScanWasSuccessful = faceScanResultCallback.onFaceScanGoToNextStep(scanResultBlob: scanResultBlob);
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
    
    func processIDScanWhileFaceTecSDKWaits(idScanResult: FaceTecIDScanResult, idScanResultCallback: FaceTecIDScanResultCallback) {
        fromViewController.setLatestIDScanResult(idScanResult: idScanResult)
        
        self.idScanResultCallback = idScanResultCallback
        
        if idScanResult.status != FaceTecIDScanStatus.success {
            if latestNetworkRequest != nil {
                latestNetworkRequest.cancel()
            }
            
            ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
            idScanResultCallback.onIDScanResultCancel()
            return
        }
        
        let minMatchLevel = 3
        
        var parameters: [String : Any] = [:]
        parameters["idScan"] = idScanResult.idScanBase64
        if idScanResult.frontImagesCompressedBase64?.isEmpty == false {
            parameters["idScanFrontImage"] = idScanResult.frontImagesCompressedBase64![0]
        }
        if idScanResult.backImagesCompressedBase64?.isEmpty == false {
            parameters["idScanBackImage"] = idScanResult.backImagesCompressedBase64![0]
        }
        parameters["minMatchLevel"] = minMatchLevel
        parameters["externalDatabaseRefID"] = self.latestExternalDatabaseRefID
        
        var request = Config.makeRequest(url: "/match-3d-2d-idscan", httpMethod: "POST")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                idScanResultCallback.onIDScanResultCancel()
                return
            }
            
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                idScanResultCallback.onIDScanResultCancel()
                return
            }
            
            guard let scanResultBlob = responseJSON["scanResultBlob"] as? String,
                  let wasProcessed = responseJSON["wasProcessed"] as? Bool else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                idScanResultCallback.onIDScanResultCancel()
                return
            }
            
            if wasProcessed == true {
                FaceTecCustomization.setIDScanResultScreenMessageOverrides(
                    successFrontSide: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successFrontSide", defaultMessage: "ID Scan Complete"),                           // Successful scan of ID front-side (ID Types with no back-side).
                    successFrontSideBackNext: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successFrontSideBackNext", defaultMessage: "Front of ID\nScanned"),               // Successful scan of ID front-side (ID Types that do have a back-side).
                    successFrontSideNFCNext: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successFrontSideNFCNext", defaultMessage: "Front of ID\nScanned"),                // Successful scan of ID front-side (ID Types that do have NFC but do not have a back-side).
                    successBackSide: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successBackSide", defaultMessage: "ID Scan Complete"),                            // Successful scan of the ID back-side (ID Types that do not have NFC).
                    successBackSideNFCNext: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successBackSideNFCNext", defaultMessage: "Back of ID\nScanned"),                  // Successful scan of the ID back-side (ID Types that do have NFC).
                    successPassport: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successPassport", defaultMessage: "Passport Scan Complete"),                      // Successful scan of a Passport that does not have NFC.
                    successPassportNFCNext: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successPassportNFCNext", defaultMessage: "Passport Scanned"),                     // Successful scan of a Passport that does have NFC.
                    successUserConfirmation: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successUserConfirmation", defaultMessage: "Photo ID Scan\nComplete"),             // Successful upload of final IDScan containing User-Confirmed ID Text.
                    successNFC: self.FaceThemeUtils.handleMessage(self.principalKey, child: "successNFC", defaultMessage: "ID Scan Complete"),                                 // Successful upload of the scanned NFC chip information.
                    retryFaceDidNotMatch: self.FaceThemeUtils.handleMessage(self.principalKey, child: "retryFaceDidNotMatch", defaultMessage: "Face Didn’t Match\nHighly Enough"),       // Case where a Retry is needed because the Face on the Photo ID did not Match the User's Face highly enough.
                    retryIDNotFullyVisible: self.FaceThemeUtils.handleMessage(self.principalKey, child: "retryIDNotFullyVisible", defaultMessage: "ID Document\nNot Fully Visible"),       // Case where a Retry is needed because a Full ID was not detected with high enough confidence.
                    retryOCRResultsNotGoodEnough: self.FaceThemeUtils.handleMessage(self.principalKey, child: "retryOCRResultsNotGoodEnough", defaultMessage: "ID Text Not Legible"),            // Case where a Retry is needed because the OCR did not produce good enough results and the User should Retry with a better capture.
                    retryIDTypeNotSupported: self.FaceThemeUtils.handleMessage(self.principalKey, child: "retryIDTypeNotSupported", defaultMessage: "ID Type Mismatch\nPlease Try Again"),  // Case where there is likely no OCR Template installed for the document the User is attempting to scan.
                    skipOrErrorNFC: self.FaceThemeUtils.handleMessage(self.principalKey, child: "skipOrErrorNFC", defaultMessage: "ID Details\nUploaded")                          // Case where NFC Scan was skipped due to the user's interaction or an unexpected error.
                )
                
                self.success = idScanResultCallback.onIDScanResultProceedToNextStep(scanResultBlob: scanResultBlob)
            } else {
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                idScanResultCallback.onIDScanResultCancel()
            }
        })
        
        latestNetworkRequest.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        if idScanResultCallback != nil {
            idScanResultCallback.onIDScanUploadProgress(uploadedPercent: uploadProgress)
        } else {
            faceScanResultCallback.onFaceScanUploadProgress(uploadedPercent: uploadProgress)
        }
    }
    
    func onFaceTecSDKCompletelyDone() {
        self.fromViewController.onComplete()
    }
    
    func isSuccess() -> Bool {
        return success
    }
}

