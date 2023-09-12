import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@capitual/react-native-capface-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

/**
 * @namespace
 *
 * @description The principal namespace of the Capface SDK.
 */
export declare namespace CapfaceSdk {
  /**
   * @type
   *
   * @description The type of button location.
   *
   * @default "TOP_RIGHT"
   */
  type ButtonLocation = 'DISABLED' | 'TOP_LEFT' | 'TOP_RIGHT';

  /**
   * @type
   *
   * @description The type of status bar color. Note: The status bar color is
   * `DEFAULT` if device is less than iOS 13.
   *
   * @default "DARK_CONTENT"
   */
  type StatusBarColor = 'DARK_CONTENT' | 'DEFAULT' | 'LIGHT_CONTENT';

  /**
   * @interface Point
   *
   * @description Defines the drawn in the layer's coordinate space with axis X
   * and Y.
   */
  interface Point {
    x?: number;
    y?: number;
  }

  /**
   * @interface FeedbackBackgroundColor
   *
   * @description This type must be used to set the theme of the feedback box.
   */
  interface FeedbackBackgroundColor {
    /**
     * @description An array of colors defining the color of each gradient stop.
     */
    colors?: string[];

    /**
     * @description It's accepts only two values between 0 and 1 that defining
     * the location of each gradient stop.
     */
    locations?: [number, number];

    /**
     * @description The start point of the gradient when drawn in the layer’s
     * coordinate space.
     */
    startPoint?: Point;

    /**
     * @description The end point of the gradient when drawn in the layer’s
     * coordinate space.
     */
    endPoint?: Point;
  }

  /**
   * @interface DefaultMessage
   *
   * @description Represents the success message and loading data message
   * during to CapfaceSDK flow. It interface is used **more** by processors's
   * `authenticate`, `enroll` and `liveness` processors.
   */
  interface DefaultMessage {
    /**
     * @description Success message when the process is completed successfully.
     *
     * @default "Liveness Confirmed"
     *
     * @description Exception to `authenticate` method.
     * @default "Autheticated"
     */
    successMessage?: string;

    /**
     * @description Success message when the process is completed successfully.
     * Only iOS.
     *
     * @default "Still Uploading..."
     */
    uploadMessageIos?: string;
  }

  /**
   * @interface DefaultScanMessage
   *
   * @description Represents the all scan messages during to CapfaceSDK flow.
   * It interface is used by processors's `photoScan` and `photoMatch` processors.
   */
  interface DefaultScanMessage {
    /**
     * @description Upload of ID front-side has started.
     *
     * @default "Uploading Encrypted ID Scan"
     */
    frontSideUploadStarted?: string;

    /**
     * @description Upload of ID front-side is still uploading to Server after
     * an extended period of time.
     *
     * @default "Still Uploading... Slow Connection"
     */
    frontSideStillUploading?: string;

    /**
     * @description Upload of ID front-side to the Server is complete.
     *
     * @default "Upload Complete"
     */
    frontSideUploadCompleteAwaitingResponse?: string;

    /**
     * @description Upload of ID front-side is complete and we are waiting for
     * the Server to finish processing and respond.
     *
     * @default "Processing ID Scan"
     */
    frontSideUploadCompleteAwaitingProcessing?: string;

    /**
     * @description Upload of ID back-side has started.
     *
     * @default "Uploading Encrypted ID Scan"
     */
    backSideUploadStarted?: string;

    /**
     * @description Upload of ID back-side is still uploading to Server after
     * an extended period of time.
     *
     * @default "Still Uploading... Slow Connection"
     */
    backSideStillUploading?: string;

    /**
     * @description Upload of ID back-side to the Server is complete.
     *
     * @default "Upload Complete"
     */
    backSideUploadCompleteAwaitingResponse?: string;

    /**
     * @description Upload of ID back-side is complete and we are waiting for
     * the Server to finish processing and respond.
     *
     * @default "Processing Back of ID"
     */
    backSideUploadCompleteAwaitingProcessing?: string;

    /**
     * @description Upload of User Confirmed Info has started.
     *
     * @default "Uploading Your Confirmed Info"
     */
    userConfirmedInfoUploadStarted?: string;

    /**
     * @description Upload of User Confirmed Info is still uploading to Server
     * after an extended period of time.
     *
     * @default "Still Uploading... Slow Connection"
     */
    userConfirmedInfoStillUploading?: string;

    /**
     * @description Upload of User Confirmed Info to the Server is complete.
     *
     * @default "Upload Complete"
     */
    userConfirmedInfoUploadCompleteAwaitingResponse?: string;

    /**
     * @description Upload of User Confirmed Info is complete and we are waiting
     * for the Server to finish processing and respond.
     *
     * @default "Processing"
     */
    userConfirmedInfoUploadCompleteAwaitingProcessing?: string;

    /**
     * @description Upload of NFC Details has started.
     *
     * @default "Uploading Encrypted NFC Details"
     */
    nfcUploadStarted?: string;

    /**
     * @description Upload of NFC Details is still uploading to Server after an
     * extended period of time.
     *
     * @default "Still Uploading... Slow Connection"
     */
    nfcStillUploading?: string;

    /**
     * @description Upload of NFC Details to the Server is complete.
     *
     * @default "Upload Complete"
     */
    nfcUploadCompleteAwaitingResponse?: string;

    /**
     * @description Upload of NFC Details is complete and we are waiting for the
     * Server to finish processing and respond.
     *
     * @default "Processing NFC Details"
     */
    nfcUploadCompleteAwaitingProcessing?: string;

    /**
     * @description Upload of ID Details has started.
     *
     * @default "Uploading Encrypted ID Details"
     */
    skippedNFCUploadStarted?: string;

    /**
     * @description Upload of ID Details is still uploading to Server after an
     * extended period of time.
     *
     * @default "Still Uploading... Slow Connection"
     */
    skippedNFCStillUploading?: string;

    /**
     * @description Upload of ID Details to the Server is complete.
     *
     * @default "Upload Complete"
     */
    skippedNFCUploadCompleteAwaitingResponse?: string;

    /**
     * @description Upload of ID Details is complete and we are waiting for the
     * Server to finish processing and respond.
     *
     * @default "Processing ID Details"
     */
    skippedNFCUploadCompleteAwaitingProcessing?: string;

    /**
     * @description Successful scan of ID front-side (ID Types with no
     * back-side).
     *
     * @default "ID Scan Complete"
     */
    successFrontSide?: string;

    /**
     * @description Successful scan of ID front-side (ID Types that do have a
     * back-side).
     *
     * @default "Front of ID Scanned"
     */
    successFrontSideBackNext?: string;

    /**
     * @description Successful scan of ID front-side (ID Types that do have NFC
     * but do not have a back-side).
     *
     * @default "Front of ID Scanned"
     */
    successFrontSideNFCNext?: string;

    /**
     * @description Successful scan of the ID back-side (ID Types that do not
     * have NFC).
     *
     * @default "ID Scan Complete"
     */
    successBackSide?: string;

    /**
     * @description Successful scan of the ID back-side (ID Types that do have
     * NFC).
     *
     * @default "Back of ID Scanned"
     */
    successBackSideNFCNext?: string;

    /**
     * @description Successful scan of a Passport that does not have NFC.
     *
     * @default "Passport Scan Complete"
     */
    successPassport?: string;

    /**
     * @description Successful scan of a Passport that does have NFC.
     *
     * @default "Passport Scanned"
     */
    successPassportNFCNext?: string;

    /**
     * @description Successful upload of final IDScan containing User-Confirmed
     * ID Text.
     *
     * @default "Photo ID Scan Complete"
     */
    successUserConfirmation?: string;

    /**
     * @description Successful upload of the scanned NFC chip information.
     *
     * @default "ID Scan Complete"
     */
    successNFC?: string;

    /**
     * @description Case where a Retry is needed because the Face on the Photo
     * ID did not Match the User's Face highly enough.
     *
     * @default "Face Didn’t Match Highly Enough"
     */
    retryFaceDidNotMatch?: string;

    /**
     * @description Case where a Retry is needed because a Full ID was not
     * detected with high enough confidence.
     *
     * @default "ID Document Not Fully Visible"
     */
    retryIDNotFullyVisible?: string;

    /**
     * @description Case where a Retry is needed because the OCR did not produce
     * good enough results and the User should Retry with a better capture.
     *
     * @default "ID Text Not Legible"
     */
    retryOCRResultsNotGoodEnough?: string;

    /**
     * @description Case where there is likely no OCR Template installed for the
     * document the User is attempting to scan.
     *
     * @default "ID Type Mismatch Please Try Again"
     */
    retryIDTypeNotSupported?: string;

    /**
     * @description Case where NFC Scan was skipped due to the user's
     * interaction or an unexpected error.
     *
     * @default "ID Details Uploaded"
     */
    skipOrErrorNFC?: string;
  }

  /**
   * @interface Theme
   *
   * @description An object with all the properties to will be used to set the
   * theme. All properties are optional.
   */
  interface Theme {
    /**
     * @description The logo image to will be used in Capface SDK screen.
     * **Note**: The image name must be to inserted with no extension format.
     *
     * @default "capface_your_app_logo.png" (Android)
     * @default "capface_your_app_logo.png" (iOS)
     */
    logoImage?: string;

    /**
     * @description The icon cancel button to will be used in Capface SDK screen.
     * The image name must be to inserted with no extension format.
     *
     * @default "capface_cancel.png" (Android)
     * @default "capface_cancel.png" (iOS)
     */
    cancelImage?: string;

    /**
     * @description The button location in Capface SDK screen.
     *
     * @default "TOP_RIGHT"
     */
    cancelButtonLocation?: ButtonLocation;

    /**
     * @description The status bar color style of the device during the Capface
     * SDK flow. Specific for the iOS.
     *
     * @default "DARK_CONTENT"
     */
    defaultStatusBarColorIos?: StatusBarColor;

    /**
     * @description Represents the border radius style of the frame view.
     */
    frameCornerRadius?: number;

    /**
     * @description Represents the background color style of the frame view
     * during to check face or scan ID of the user.
     */
    frameBackgroundColor?: string;

    /**
     * @description Represents the border color style of the frame view.
     */
    frameBorderColor?: string;

    /**
     * @description Represents the background color style of the main view.
     */
    overlayBackgroundColor?: string;

    /**
     * @description Represents the background color style of the guidance view.
     * The guidance view is above the frame view and it's showed to before check
     * face or scan ID of the user. Specific for the Android.
     */
    guidanceBackgroundColorsAndroid?: string;

    /**
     * @description Represents the background color style of the guidance view.
     * The guidance view is above the frame view and it's showed to before check
     * face or scan ID of the user. Specific for the iOS.
     */
    guidanceBackgroundColorsIos?: string[];

    /**
     * @description Represents the foreground color style of the guidance text.
     */
    guidanceForegroundColor?: string;

    /**
     * @description Represents the background color style of the guidance button.
     */
    guidanceButtonBackgroundNormalColor?: string;

    /**
     * @description Represents the background color style of the guidance button
     * when it's disabled.
     */
    guidanceButtonBackgroundDisabledColor?: string;

    /**
     * @description Represents the background color style of the guidance button
     * when it's on press effect.
     */
    guidanceButtonBackgroundHighlightColor?: string;

    /**
     * @description Represents the color style of the guidance button text.
     */
    guidanceButtonTextNormalColor?: string;

    /**
     * @description Represents the color style of the guidance button text when
     * it's disabled
     */
    guidanceButtonTextDisabledColor?: string;

    /**
     * @description Represents the color style of the guidance button text when
     * it's on press effect.
     */
    guidanceButtonTextHighlightColor?: string;

    /**
     * @description Represents the border color style of the guidance retry
     * screen.
     */
    guidanceRetryScreenImageBorderColor?: string;

    /**
     * @description Represents the border color style of the oval view row of
     * the guidance retry.
     */
    guidanceRetryScreenOvalStrokeColor?: string;

    /**
     * @description Represents the border color style of the oval view border.
     */
    ovalStrokeColor?: string;

    /**
     * @description Represents the first progress row color during the check
     * face or scan ID of the user. It's localize inside over view when the user
     * is making check face or scan ID.
     */
    ovalFirstProgressColor?: string;

    /**
     * @description Represents the second progress row color during the check
     * face or scan ID of the user. It's localize inside over view when the user
     * is making check face or scan ID
     */
    ovalSecondProgressColor?: string;

    /**
     * @description Represents the background color style of the feedback view.
     * Specific for the Android.
     */
    feedbackBackgroundColorsAndroid?: string;

    /**
     * @description Represents the background color style of the feedback view.
     * Specific for the iOS.
     */
    feedbackBackgroundColorsIos?: FeedbackBackgroundColor;

    /**
     * @description Represents the color style of the feedback box text.
     */
    feedbackTextColor?: string;

    /**
     * @description Represents the background color style of the feedback view
     * that's shown on the finish to check face or scan ID. Specific for the
     * Android.
     */
    resultScreenBackgroundColorsAndroid?: string;

    /**
     * @description Represents the background color style of the feedback view
     * that's shown on the finish to check face or scan ID. Specific for the iOS.
     */
    resultScreenBackgroundColorsIos?: string[];

    /**
     * @description Represents the foreground color style of the result screen
     * text.
     */
    resultScreenForegroundColor?: string;

    /**
     * @description Represents the indicator background color style of the
     * result screen during loading.
     */
    resultScreenActivityIndicatorColor?: string;

    /**
     * @description Represents the indicator background color style of the
     * result screen on finishing of the loading.
     */
    resultScreenResultAnimationBackgroundColor?: string;

    /**
     * @description Represents the icon color style of the check icon on the
     * result screen.
     */
    resultScreenResultAnimationForegroundColor?: string;

    /**
     * @description Represents the progress bar fill color style of the result
     * screen during loading.
     */
    resultScreenUploadProgressFillColor?: string;

    /**
     * @description Represents the background color style of the ID scan
     * selection view. Specific for the Android.
     */
    idScanSelectionScreenBackgroundColorsAndroid?: string;

    /**
     * @description Represents the background color style of the ID scan
     * selection view. Specific for the iOS.
     */
    idScanSelectionScreenBackgroundColorsIos?: string[];

    /**
     * @description Represents the color style of the ID scan selection text.
     */
    idScanSelectionScreenForegroundColor?: string;

    /**
     * @description Represents the color style of the ID scan review text.
     */
    idScanReviewScreenForegroundColor?: string;

    /**
     * @description Represents the background color style of the ID scan review
     * label.
     */
    idScanReviewScreenTextBackgroundColor?: string;

    /**
     * @description Represents the foreground color style of the ID scan capture
     * text.
     */
    idScanCaptureScreenForegroundColor?: string;

    /**
     * @description Represents the background color style of the ID scan capture
     * view.
     */
    idScanCaptureScreenTextBackgroundColor?: string;

    /**
     * @description Represents the background color style of the ID scan capture
     * button.
     */
    idScanButtonBackgroundNormalColor?: string;

    /**
     * @description Represents the background color style of the ID scan capture
     * button when it's disabled.
     */
    idScanButtonBackgroundDisabledColor?: string;

    /**
     * @description Represents the background color style of the ID scan capture
     * button when it's on press effect.
     */
    idScanButtonBackgroundHighlightColor?: string;

    /**
     * @description Represents the color style of the ID scan capture text.
     */
    idScanButtonTextNormalColor?: string;

    /**
     * @description Represents the color style of the ID scan capture text when
     * it's disabled.
     */
    idScanButtonTextDisabledColor?: string;

    /**
     * @description Represents the color style of the ID scan capture text when
     * it's on press effect.
     */
    idScanButtonTextHighlightColor?: string;

    /**
     * @description Represents the background color style of the ID scan capture
     * view.
     */
    idScanCaptureScreenBackgroundColor?: string;

    /**
     * @description Represents the border color style of the ID scan capture
     * camera.
     */
    idScanCaptureFrameStrokeColor?: string;

    /**
     * @description An object with all messages to will be used the during the
     * authentication flow.
     */
    authenticateMessage?: DefaultMessage;

    /**
     * @description An object with all messages to will be used the during the
     * enrollment flow.
     */
    enrollMessage?: DefaultMessage;

    /**
     * @description An object with all messages to will be used the during the
     * liveness flow.
     */
    livenessMessage?: DefaultMessage;

    /**
     * @description An object with all messages to will be used the during the
     * photo ID scan flow.
     */
    photoIdScanMessage?: DefaultScanMessage;

    /**
     * @description An object with all messages to will be used the during the
     * photo ID match flow.
     */
    photoIdMatchMessage?: DefaultScanMessage & DefaultMessage;
  }

  /**
   * @interface Headers
   *
   * @description Headers your requests, to each request it's sent.
   */
  interface Headers {
    [key: string]: string | null | undefined;
  }

  /**
   * @interface Initialize
   *
   * @description This is the parameters to initialize the Capface SDK. Only
   * params property is required.
   */
  interface Initialize {
    /**
     * @description This is the parameters to initialize the Capface SDK.
     */
    params: Params;

    /**
     * @description Headers your requests, to each request it's sent.
     */
    headers?: Headers;
  }

  /**
   * @interface Params
   *
   * @description This is the parameters to initialize the Capface SDK.
   */
  interface Params {
    /**
     * @description Your device to will be used to initialize CapfaceSDK.
     * Available in your Capface account.
     */
    device: string;

    /**
     * @description Your base URL to will be used to sent data.
     */
    url: string;

    /**
     * @description Your public key to will be used to initialize CapfaceSDK.
     * Available in your Capface account.
     */
    key: string;

    /**
     * @description Your production key to will be used to initialize CapfaceSDK.
     * Available in your Capface account.
     */
    productionKey: string;

    /**
     * @description Option to select production or developement mode for initialize CapfaceSDK.
     */
    isDeveloperMode?: boolean;
  }

  /**
   * @enum
   *
   * @description This is the enum Errors that can be throws by Capface SDK.
   */
  enum Errors {
    /**
     * @description When some processors method is runned, but CapfaceSDK
     * **has not been initialized!**.
     */
    CapFaceHasNotBeenInitialized = 'CapFaceHasNotBeenInitialized',

    /**
     * @description When the image sent to the processors cannot be processed
     * due to inconsistency.
     */
    CapFaceValuesWereNotProcessed = 'CapFaceValuesWereNotProcessed',

    /**
     * @description When exists some network error.
     */
    HTTPSError = 'HTTPSError',

    /**
     * @description When exists some problem in getting data in request of
     * **base URL** information. Only Android.
     */
    JSONError = 'JSONError',

    /**
     * @description When session status is invalid. Only Android.
     */
    CapFaceInvalidSession = 'CapFaceInvalidSession',

    /**
     * @description When the image user sent to the processors cannot be
     * processed due to inconsistency. Only Android.
     */
    CapfaceLivenessWasntProcessed = 'CapfaceLivenessWasntProcessed',

    /**
     * @description When the image ID sent to the processors cannot be processed
     * due to inconsistency. Only Android.
     */
    CapfaceScanWasntProcessed = 'CapfaceScanWasntProcessed',
  }

  /**
   * @type
   *
   * @description This is the type of face match.
   */
  type MatchType = 'enroll' | 'liveness' | 'authenticate';

  /**
   * @type
   *
   * @description This is the type of face key.
   */
  type MatchKey = 'enrollMessage' | 'livenessMessage' | 'authenticateMessage';

  /**
   * @interface MatchConfig
   *
   * @description There are all configurations from face match.
   */
  interface MatchConfig {
    /**
     * @description The key to will be used to like identificator of the face match.
     */
    key: MatchKey;

    /**
     * @description If the face match has external database reference ID.
     * It's optional.
     */
    hasExternalDatabaseRefID: boolean;

    /**
     * @description The endpoint to will be used to make requests. It's optional.
     */
    endpoint?: string | null;

    /**
     * @description The success message to will be used to show to user on the
     * flow end. It's optional.
     */
    successMessage?: string | null;

    /**
     * @description The upload message to will be used to show to user on loading
     * flow. It's optional.
     */
    uploadMessageIos?: string | null;

    /**
     * @description The parameters to will be used to sent data by headers.
     * It's optional.
     */
    parameters?: Object | null;
  }

  /**
   * @interface Methods
   *
   * @description This is the available methods in Capface SDK.
   */
  interface Methods {
    /**
     * @description This is the **principal** method to be called, he must be
     * **called first** to initialize the Capface SDK. If he doens't be called
     * the other methods **don't works!**
     *
     * @param {CapfaceSdk.Params} params - Initialization SDK parameters.
     * @param {CapfaceSdk.Headers} headers - Headers your requests, to each
     * request it's sent. The headers is optional.
     * @param {Function} callback - Callback function to be called after with
     * the response of the successfully. The callback is optional.
     *
     * @return {Promise<boolean>} Represents if initialization was a successful.
     */
    initializeSdk(
      params: Params,
      headers?: Headers,
      callback?: Function
    ): Promise<boolean>;

    /**
     * @description This method make to read from face and documents for user,
     * after comparate face and face documents from user to check veracity.
     *
     * @param {Object|undefined} data - The object with data to be will send on
     * photo ID match. The data is optional.
     *
     * @return {Promise<boolean>} Represents if photo match was a successful.
     * @throws If photo ID match was a unsuccessful or occurred some interference.
     */
    handlePhotoIDMatch(data?: Object): Promise<boolean>;

    /**
     * @description This method makes a 3D reading of the user's face. But, you
     * must use to **subscribe** user in Capface SDK or in your server.
     *
     * @param {Object|undefined} data - The object with data to be will send on
     * enrollment. The data is optional.
     *
     * @return {Promise<boolean>} Represents if enrollment was a successful.
     * @throws If enrollment was a unsuccessful or occurred some interference.
     */
    handleEnrollUser(data?: Object): Promise<boolean>;

    /**
     * @description This method makes a 3D reading of the user's face. But, you
     * must use to **authenticate** user in Capface SDK or in your server.
     *
     * @param {Object|undefined} data - The object with data to be will send on
     * authentication. The data is optional.
     *
     * @return {Promise<boolean>} Represents if authentication was a successful.
     * @throws If authenticate was a unsuccessful or occurred some interference.
     */
    handleAuthenticateUser(data?: Object): Promise<boolean>;

    /**
     * @description This method is called to make enrollment, authenticate and
     * liveness available.
     *
     * @description This method makes a 3D reading of the user's face. But, you
     * must use to **subscribe** user in Capface SDK or in your server.
     *
     * @description This method makes a 3D reading of the user's face. But, you
     * must use to **authenticate** user in Capface SDK or in your server.
     *
     * @description This method makes a 3D reading of the user's face.
     *
     * @param {Omit<CapfaceSdk.MatchConfig, 'key' | 'hasExternalDatabaseRefID'>|undefined} data -
     * The object with data to be will send by headers on the requests. The data
     * is optional.
     *
     * @return {Promise<boolean>} Represents if flow was a successful.
     * @throws If was a unsuccessful or occurred some interference.
     */
    handleFaceUser(
      data?:
        | Omit<CapfaceSdk.MatchConfig, 'key' | 'hasExternalDatabaseRefID'>
        | undefined
    ): Promise<boolean>;

    /**
     * @description This method must be used to **set** the **theme** of the
     * Capface SDK screen.
     *
     * @param {CapfaceSdk.Theme|undefined} options - The object theme options.
     * All options are optional.
     *
     * @return {void}
     */
    handleTheme(options?: Theme): void;
  }
}

/**
 * @description Native module CapfaceSDK, it's recommended use it with event
 * types.
 *
 * @example
 * import { NativeEventEmitter } from 'react-native';
 * import ReactNativeCapfaceSdk from '@capitual/react-native-capface-sdk';
 *
 * const emitter = new NativeEventEmitter(ReactNativeCapfaceSdk);
 * emitter.addListener('onCloseModal', (event: boolean) => console.log('onCloseModal', event));
 */
export const ReactNativeCapfaceSdk: CapfaceSdk.Methods =
  NativeModules.ReactNativeCapfaceSdk
    ? NativeModules.ReactNativeCapfaceSdk
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        }
      );
