//
//  PhotoIDScanProcessor.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import UIKit
import Foundation
import FaceTecSDK

class PhotoIDScanProcessor: NSObject, Processor, FaceTecIDScanProcessorDelegate, URLSessionTaskDelegate {
    var success = false
    var data: NSDictionary!
    var latestNetworkRequest: URLSessionTask!
    var fromViewController: CapFaceViewController!
    var idScanResultCallback: FaceTecIDScanResultCallback!
    private let key = "photoIdScanMessage";
    private let CapThemeUtils: ThemeUtils! = ThemeUtils();

    init(sessionToken: String, fromViewController: CapFaceViewController, data: NSDictionary) {
        self.fromViewController = fromViewController
        self.data = data
        super.init()

        FaceTecCustomization.setIDScanUploadMessageOverrides(
            frontSideUploadStarted: self.CapThemeUtils.handleMessage(self.key, child: "frontSideUploadStarted", defaultMessage: "Uploading\nEncrypted\nID Scan"),                // Upload of ID front-side has started.
            frontSideStillUploading: self.CapThemeUtils.handleMessage(self.key, child: "frontSideStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),         // Upload of ID front-side is still uploading to Server after an extended period of time.
            frontSideUploadCompleteAwaitingResponse: self.CapThemeUtils.handleMessage(self.key, child: "frontSideUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),             // Upload of ID front-side to the Server is complete.
            frontSideUploadCompleteAwaitingProcessing: self.CapThemeUtils.handleMessage(self.key, child: "frontSideUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nID Scan"),       // Upload of ID front-side is complete and we are waiting for the Server to finish processing and respond.
            backSideUploadStarted: self.CapThemeUtils.handleMessage(self.key, child: "backSideUploadStarted", defaultMessage: "Uploading\nEncrypted\nBack of ID"),              // Upload of ID back-side has started.
            backSideStillUploading: self.CapThemeUtils.handleMessage(self.key, child: "backSideStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),          // Upload of ID back-side is still uploading to Server after an extended period of time.
            backSideUploadCompleteAwaitingResponse: self.CapThemeUtils.handleMessage(self.key, child: "backSideUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),              // Upload of ID back-side to Server is complete.
            backSideUploadCompleteAwaitingProcessing: self.CapThemeUtils.handleMessage(self.key, child: "backSideUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nBack of ID"),     // Upload of ID back-side is complete and we are waiting for the Server to finish processing and respond.
            userConfirmedInfoUploadStarted: self.CapThemeUtils.handleMessage(self.key, child: "userConfirmedInfoUploadStarted", defaultMessage: "Uploading\nYour Confirmed Info"),       // Upload of User Confirmed Info has started.
            userConfirmedInfoStillUploading: self.CapThemeUtils.handleMessage(self.key, child: "userConfirmedInfoStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"), // Upload of User Confirmed Info is still uploading to Server after an extended period of time.
            userConfirmedInfoUploadCompleteAwaitingResponse: self.CapThemeUtils.handleMessage(self.key, child: "userConfirmedInfoUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),     // Upload of User Confirmed Info to the Server is complete.
            userConfirmedInfoUploadCompleteAwaitingProcessing: self.CapThemeUtils.handleMessage(self.key, child: "userConfirmedInfoUploadCompleteAwaitingProcessing", defaultMessage: "Processing"),        // Upload of User Confirmed Info is complete and we are waiting for the Server to finish processing and respond.
            nfcUploadStarted: self.CapThemeUtils.handleMessage(self.key, child: "nfcUploadStarted", defaultMessage: "Uploading Encrypted\nNFC Details"),                   // Upload of NFC Details has started.
            nfcStillUploading: self.CapThemeUtils.handleMessage(self.key, child: "nfcStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),               // Upload of NFC Details is still uploading to Server after an extended period of time.
            nfcUploadCompleteAwaitingResponse: self.CapThemeUtils.handleMessage(self.key, child: "nfcUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),                   // Upload of NFC Details to the Server is complete.
            nfcUploadCompleteAwaitingProcessing: self.CapThemeUtils.handleMessage(self.key, child: "nfcUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nNFC Details"),         // Upload of NFC Details is complete and we are waiting for the Server to finish processing and respond.
            skippedNFCUploadStarted: self.CapThemeUtils.handleMessage(self.key, child: "skippedNFCUploadStarted", defaultMessage: "Uploading Encrypted\nID Details"),             // Upload of ID Details has started.
            skippedNFCStillUploading: self.CapThemeUtils.handleMessage(self.key, child: "skippedNFCStillUploading", defaultMessage: "Still Uploading...\nSlow Connection"),        // Upload of ID Details is still uploading to Server after an extended period of time.
            skippedNFCUploadCompleteAwaitingResponse: self.CapThemeUtils.handleMessage(self.key, child: "skippedNFCUploadCompleteAwaitingResponse", defaultMessage: "Upload Complete"),            // Upload of ID Details to the Server is complete.
            skippedNFCUploadCompleteAwaitingProcessing: self.CapThemeUtils.handleMessage(self.key, child: "skippedNFCUploadCompleteAwaitingProcessing", defaultMessage: "Processing\nID Details")    // Upload of ID Details is complete and we are waiting for the Server to finish processing and respond.
        );

        ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: true);

        let idScanViewController = FaceTec.sdk.createSessionVC(idScanProcessorDelegate: self, sessionToken: sessionToken)

        FaceTecUtilities.getTopMostViewController()?.present(idScanViewController, animated: true, completion: nil)
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

        var parameters: [String : Any] = [:]
        if (self.data != nil) {
            parameters["data"] = self.data
        }
        parameters["idScan"] = idScanResult.idScanBase64
        if idScanResult.frontImagesCompressedBase64?.isEmpty == false {
            parameters["idScanFrontImage"] = idScanResult.frontImagesCompressedBase64![0]
        }
        if idScanResult.backImagesCompressedBase64?.isEmpty == false {
            parameters["idScanBackImage"] = idScanResult.backImagesCompressedBase64![0]
        }

        var request = Config.makeRequest(url: "/idscan-only", httpMethod: "POST")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 299 {
                    print("Exception raised while attempting HTTPS call. Status code: \(httpResponse.statusCode)");
                    ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                    idScanResultCallback.onIDScanResultCancel()
                    return
                }
            }

            if let error = error {
                print("Exception raised while attempting HTTPS call.")
                ReactNativeCapfaceSdk.emitter.sendEvent(withName: "onCloseModal", body: false);
                idScanResultCallback.onIDScanResultCancel()
                return
            }

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
                    successFrontSide: self.CapThemeUtils.handleMessage(self.key, child: "successFrontSide", defaultMessage: "ID Scan Complete"),                           // Successful scan of ID front-side (ID Types with no back-side).
                    successFrontSideBackNext: self.CapThemeUtils.handleMessage(self.key, child: "successFrontSideBackNext", defaultMessage: "Front of ID\nScanned"),               // Successful scan of ID front-side (ID Types that do have a back-side).
                    successFrontSideNFCNext: self.CapThemeUtils.handleMessage(self.key, child: "successFrontSideNFCNext", defaultMessage: "Front of ID\nScanned"),                // Successful scan of ID front-side (ID Types that do have NFC but do not have a back-side).
                    successBackSide: self.CapThemeUtils.handleMessage(self.key, child: "successBackSide", defaultMessage: "ID Scan Complete"),                            // Successful scan of the ID back-side (ID Types that do not have NFC).
                    successBackSideNFCNext: self.CapThemeUtils.handleMessage(self.key, child: "successBackSideNFCNext", defaultMessage: "Back of ID\nScanned"),                  // Successful scan of the ID back-side (ID Types that do have NFC).
                    successPassport: self.CapThemeUtils.handleMessage(self.key, child: "successPassport", defaultMessage: "Passport Scan Complete"),                      // Successful scan of a Passport that does not have NFC.
                    successPassportNFCNext: self.CapThemeUtils.handleMessage(self.key, child: "successPassportNFCNext", defaultMessage: "Passport Scanned"),                     // Successful scan of a Passport that does have NFC.
                    successUserConfirmation: self.CapThemeUtils.handleMessage(self.key, child: "successUserConfirmation", defaultMessage: "Photo ID Scan\nComplete"),             // Successful upload of final IDScan containing User-Confirmed ID Text.
                    successNFC: self.CapThemeUtils.handleMessage(self.key, child: "successNFC", defaultMessage: "ID Scan Complete"),                                 // Successful upload of the scanned NFC chip information.
                    retryFaceDidNotMatch: self.CapThemeUtils.handleMessage(self.key, child: "retryFaceDidNotMatch", defaultMessage: "Face Didn’t Match\nHighly Enough"),       // Case where a Retry is needed because the Face on the Photo ID did not Match the User's Face highly enough.
                    retryIDNotFullyVisible: self.CapThemeUtils.handleMessage(self.key, child: "retryIDNotFullyVisible", defaultMessage: "ID Document\nNot Fully Visible"),       // Case where a Retry is needed because a Full ID was not detected with high enough confidence.
                    retryOCRResultsNotGoodEnough: self.CapThemeUtils.handleMessage(self.key, child: "retryOCRResultsNotGoodEnough", defaultMessage: "ID Text Not Legible"),            // Case where a Retry is needed because the OCR did not produce good enough results and the User should Retry with a better capture.
                    retryIDTypeNotSupported: self.CapThemeUtils.handleMessage(self.key, child: "retryIDTypeNotSupported", defaultMessage: "ID Type Mismatch\nPlease Try Again"),  // Case where there is likely no OCR Template installed for the document the User is attempting to scan.
                    skipOrErrorNFC: self.CapThemeUtils.handleMessage(self.key, child: "skipOrErrorNFC", defaultMessage: "ID Details\nUploaded")                          // Case where NFC Scan was skipped due to the user's interaction or an unexpected error.
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
        }
    }

    func onFaceTecSDKCompletelyDone() {
        self.fromViewController.onComplete()
    }

    func isSuccess() -> Bool {
        return success
    }
}
