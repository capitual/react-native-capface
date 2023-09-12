import { NATIVE_CONSTANTS } from './constants';
import { CapfaceSdk, ReactNativeCapfaceSdk } from './types';

/**
 * @description This is the **principal** method to be called, he must be
 * **called first** to initialize the Capface SDK. If he doens't be called the
 * other methods **don't works!**
 *
 * @param {CapfaceSdk.Initialize} initialize - Initialize the Capface SDK with
 * especific parameters and an optional headers.
 *
 * @return {Promise<boolean>} Represents if Capface SDK initialized with
 * successful.
 */
export function initialize({
  params,
  headers,
}: CapfaceSdk.Initialize): Promise<boolean> {
  return new Promise((resolve, reject) => {
    ReactNativeCapfaceSdk.initializeSdk(
      params,
      headers,
      (successful: boolean) => {
        if (successful) resolve(true);
        else reject(false);
      }
    );
  });
}

/**
 * @description This method is called to make enrollment, authenticate and
 * liveness available. The **enrollment method** makes a 3D reading of the
 * user's face. But, you must use to **subscribe** user in Capface SDK or in
 * your server. The **authenticate method** makes a 3D reading of the user's
 * face. But, you must use to **authenticate** user in Capface SDK or in
 * your server. Finally, the **liveness** method makes a 3D reading of the
 * user's face.
 *
 * @param {CapfaceSdk.MatchType} type - The type of flow to be called.
 * @param {CapfaceSdk.MatchData|undefined} data - The object with properties
 * that will be sent to native modules to make the requests, change text labels
 * and sent parameters via headers.
 *
 * @return {Promise<boolean>} Represents if flow was a successful.
 * @throws If was a unsuccessful or occurred some interference.
 */
export async function faceMatch(
  type: CapfaceSdk.MatchType,
  data?: CapfaceSdk.MatchData
): Promise<boolean> {
  return await ReactNativeCapfaceSdk.handleFaceUser(
    NATIVE_CONSTANTS(data)[type]
  )
    .then((successful: boolean) => successful)
    .catch((error: Error) => {
      throw new Error(error.message);
    });
}

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
export async function photoMatch(data?: Object): Promise<boolean> {
  return await ReactNativeCapfaceSdk.handlePhotoIDMatch(data)
    .then((successful: boolean) => successful)
    .catch((error: Error) => {
      throw new Error(error.message);
    });
}

/**
 * @description This method must be used to **set** the **theme** of the Capface
 * SDK screen.
 *
 * @param {CapfaceSdk.Theme|undefined} options - The object theme options. All
 * options are optional.
 *
 * @return {void}
 */
export function setTheme(options?: CapfaceSdk.Theme): void {
  ReactNativeCapfaceSdk.handleTheme(options);
}

export * from './types';
