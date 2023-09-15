import { NativeModules, Platform } from 'react-native';

import { NATIVE_CONSTANTS } from './constants';
import { CapfaceSdkProps } from './types';

import type { NativeModule } from 'react-native';
import { convertToHexColor } from './helpers';

const LINKING_ERROR =
  `The package '@capitual/react-native-capface-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

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
const CapfaceSdk = NativeModules.ReactNativeCapfaceSdk
  ? NativeModules.ReactNativeCapfaceSdk
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default CapfaceSdk as NativeModule;

/**
 * @description This is the **principal** method to be called, he must be
 * **called first** to initialize the Capface SDK. If he doens't be called the
 * other methods **don't works!**
 *
 * @param {CapfaceSdkProps.Initialize} initialize - Initialize the Capface SDK with
 * especific parameters and an optional headers.
 *
 * @return {Promise<boolean>} Represents if Capface SDK initialized with
 * successful.
 */
export function initialize({
  params,
  headers,
}: CapfaceSdkProps.Initialize): Promise<boolean> {
  return new Promise((resolve, reject) => {
    CapfaceSdk.initializeSdk(params, headers, (successful: boolean) => {
      if (successful) resolve(true);
      else reject(false);
    });
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
 * @param {CapfaceSdkProps.MatchType} type - The type of flow to be called.
 * @param {CapfaceSdkProps.MatchData|undefined} data - The object with properties
 * that will be sent to native modules to make the requests, change text labels
 * and sent parameters via headers.
 *
 * @return {Promise<boolean>} Represents if flow was a successful.
 * @throws If was a unsuccessful or occurred some interference.
 */
export async function faceMatch(
  type: CapfaceSdkProps.MatchType,
  data?: CapfaceSdkProps.MatchData
): Promise<boolean> {
  return await CapfaceSdk.handleFaceUser(NATIVE_CONSTANTS(data)[type])
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
  return await CapfaceSdk.handlePhotoIDMatch(data)
    .then((successful: boolean) => successful)
    .catch((error: Error) => {
      throw new Error(error.message);
    });
}

/**
 * @description This method must be used to **set** the **theme** of the Capface
 * SDK screen.
 *
 * @param {CapfaceSdkProps.Theme|undefined} options - The object theme options.
 * All options are optional.
 *
 * @return {void}
 */
export function setTheme(options?: CapfaceSdkProps.Theme): void {
  if (options) {
    if (options?.feedbackBackgroundColorsIos) {
      if (Array.isArray(options.feedbackBackgroundColorsIos?.colors)) {
        const colors = options.feedbackBackgroundColorsIos.colors.map(
          (color) => convertToHexColor(color) || ''
        );
        const everyColorsExists = colors.every((color) => !!color);
        options.feedbackBackgroundColorsIos.colors = everyColorsExists
          ? colors
          : undefined;
      }
    }

    for (const property in options) {
      const option = property as keyof CapfaceSdkProps.Theme;
      if (typeof options[option] === 'string') {
        const color = convertToHexColor(options[option] as string);
        options = Object.assign(options, { [option]: color || undefined });
      }
      if (Array.isArray(options[option])) {
        const hexColors: string[] = (options[option] as string[]).map(
          (color) => convertToHexColor(color) || ''
        );
        const everyColorsExists = hexColors.every((color) => !!color);
        options = Object.assign(options, {
          [option]: everyColorsExists ? hexColors : undefined,
        });
      }
    }
  }

  CapfaceSdk.handleTheme(options);
}

export * from './types';
