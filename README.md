# @capitual/react-native-capface-sdk

Capface sdk adapter to react native. 📱

- [Installation](#installation)
- [Usage](#usage)
- [API](#api)
  - [`initialize(init: CapfaceSdk.Initialize)`](#initializeinit-capfacesdkinitialize)
  - [`faceMatch(type: CapfaceSdk.MatchType, data?: CapfaceSdk.MatchData)`](#facematchtype-capfacesdkmatchtype-data-capfacesdkmatchdata)
  - [`photoMatch(data?: Object)`](#photomatchdata-capfacesdkdata)
  - [`setTheme(options?: CapfaceSdk.Theme)`](#setthemeoptions-capfacesdktheme)
- [Types](#types)
  - [`CapfaceSdk.Params`](#capfacesdkparams)
  - [`CapfaceSdk.Headers`](#capfacesdkheaders)
  - [`CapfaceSdk.Theme`](#capfacesdktheme)
  - [`CapfaceSdk.ButtonLocation`](#capfacesdkbuttonlocation)
  - [`CapfaceSdk.StatusBarColor`](#capfacesdkstatusbarcolor-ios-only)
  - [`CapfaceSdk.FeedbackBackgroundColor`](#capfacesdkfeedbackbackgroundcolor-ios-only)
  - [`CapfaceSdk.Point`](#capfacesdkpoint-ios-only)
  - [`CapfaceSdk.DefaultMessage`](#capfacesdkdefaultmessage)
  - [`CapfaceSdk.DefaultScanMessage`](#capfacesdkdefaultscanmessage)
  - [`CapfaceSdk.Errors`](#capfacesdkerrors)
  - [`CapfaceSdk.MatchType`](#capfacesdkmatchtype)
  - [`CapfaceSdk.MatchData`](#capfacesdkmatchdata)
- [Native Events](#native-events)
  - [`Event Types`](#event-types)
- [How to add images in CapfaceSDK module?](#how-to-add-images-in-capfacesdk-module)
  - [How to add images in Android?](#how-to-add-images-in-android)
  - [How to add images in iOS?](#how-to-add-images-in-ios)
  - [Example with images added](#example-with-images-added)
- [Limitations and Features](#limitations-and-features)
- [Contributing](#contributing)
- [License](#license)

<hr/>

## Installation

```sh
npm install @capitual/react-native-capface-sdk
```

<hr/>

## Usage

```tsx
import * as React from 'react';

import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  ScrollView,
  NativeEventEmitter,
} from 'react-native';
import {
  CapfaceSdk,
  ReactNativeCapfaceSdk,
  initialize,
  faceMatch,
  photoMatch,
} from '@capitual/react-native-capface-sdk';

export default function App() {
  const init = async () => {
    /*
     * The SDK must be initialized first
     * so that the rest of the library
     * functions can work!
     *
     * */
    const headers = {
      'clientInfo': 'YUOR_CLIENT_INFO',
      'contentType': 'YOUR_CONTENT_TYPE',
      'device': 'YOUR_DEVICE',
      'deviceid': 'YOUR_DEVICE_ID',
      'deviceip': 'YOUR_DEVICE_IP',
      'locale': 'YOUR_LOCALE',
      'xForwardedFor': 'YOUR_X_FORWARDED_FOR',
      'user-agent': 'YOUR_USER_AGENT',
    };
    const params = {
      device: 'YOUR_DEVICE',
      url: 'YOUR_BASE_URL',
      key: 'YOUR_KEY',
      productionKey: 'YOUR_PRODUCTION_KEY',
    };

    const isInitialized = await initialize({
      params,
      headers,
    });

    console.log(isInitialized);
  };

  const emitter = new NativeEventEmitter(ReactNativeCapfaceSdk);
  emitter.addListener('onCloseModal', (event: boolean) =>
    console.log('onCloseModal', event)
  );

  const onPressPhotoMatch = async () => {
    try {
      const isSuccess = await photoMatch();
      console.log(isSuccess);
    } catch (error: any) {
      console.error(error.message);
    }
  };

  const onPressFaceMatch = async (
    type: CapfaceSdk.MatchType,
    data?: CapfaceSdk.MatchData
  ) => {
    try {
      const isSuccess = await faceMatch(type, data);
      console.log(isSuccess);
    } catch (error: any) {
      console.error(error.message);
    }
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.content}>
        <TouchableOpacity style={styles.button} onPress={init}>
          <Text style={styles.text}>Init Capface Module</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.button} onPress={onPressPhotoMatch}>
          <Text style={styles.text}>Open Photo Match</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.button}
          onPress={async () => await onPressFaceMatch('enroll')}
        >
          <Text style={styles.text}>Open Enroll</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.button}
          onPress={async () =>
            await onPressFaceMatch('authenticate', { id: '123456' })
          }
        >
          <Text style={styles.text}>Open Authenticate</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.button}
          onPress={async () => await onPressFaceMatch('liveness')}
        >
          <Text style={styles.text}>Open Liveness</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
  },
  content: {
    justifyContent: 'center',
    alignItems: 'center',
    marginVertical: 30,
  },
  button: {
    width: '100%',
    backgroundColor: '#4a68b3',
    padding: 20,
    borderRadius: 15,
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 20,
  },
  text: {
    color: 'white',
    fontWeight: '700',
    fontSize: 22,
  },
});
```

<hr/>

## API

| Methods                                                                                                                            | Return Type        | iOS | Android |
| ---------------------------------------------------------------------------------------------------------------------------------- | ------------------ | --- | ------- |
| [`initialize(init: CapfaceSdk.Initialize)`](#initializeinit-capfacesdkinitialize)                                                  | `Promise<boolean>` | ✅  | ✅      |
| [`faceMatch(type: CapfaceSdk.MatchType, data?: CapfaceSdk.MatchData`](#facematchtype-capfacesdkmatchtype-data-capfacesdkmatchdata) | `Promise<boolean>` | ✅  | ✅      |
| [`photoMatch(data?: Object)`](#photomatchdata-capfacesdkdata)                                                                      | `Promise<boolean>` | ✅  | ✅      |
| [`setTheme(options?: CapfaceSdk.Theme)`](#setthemeoptions-capfacesdktheme)                                                         | `void`             | ✅  | ✅      |

### `initialize(init: CapfaceSdk.Initialize)`

This is the **principal** method to be called, he must be **called first** to initialize the Capface SDK. If he doens't be called the other methods **don't works!**

| `CapfaceSdk.Initialize` | type                                       | Required | Default     |
| ----------------------- | ------------------------------------------ | -------- | ----------- |
| `params`                | [`CapfaceSdk.Params`](#capfacesdkparams)   | ✅       | -           |
| `headers`               | [`CapfaceSdk.Headers`](#capfacesdkheaders) | ❌       | `undefined` |

### `faceMatch(type: CapfaceSdk.MatchType, data?: CapfaceSdk.MatchData)`

This method is called to make enrollment, authenticate and liveness available. The type is required and it must provided to select which flow you are interested.

- **Enrollment**: This method makes a 3D reading of the user's face. But, you must use to **subscribe** user in Capface SDK or in your server.
- **Authenticate**: This method makes a 3D reading of the user's face. But, you must use to **authenticate** user in Capface SDK or in your server.
- **Liveness**: This method makes a 3D reading of the user's face.

| `Object` | type                                           | Required | Default     |
| -------- | ---------------------------------------------- | -------- | ----------- |
| `type`   | [`CapfaceSdk.MatchType`](#capfacesdkmatchtype) | ✅       | -           |
| `data`   | [`CapfaceSdk.MatchData`](#capfacesdkmatchdata) | ❌       | `undefined` |

### `photoMatch(data?: Object)`

This method make to read from face and documents for user, after comparate face and face documents from user to check veracity.

| `Object` | type     | Required | Default     |
| -------- | -------- | -------- | ----------- |
| `data`   | `Object` | ❌       | `undefined` |

### `setTheme(options?: CapfaceSdk.Theme)`

This method must be used to **set** the **theme** of the Capface SDK screen.

| `CapfaceSdk.Theme` | type                                   | Required | Default     |
| ------------------ | -------------------------------------- | -------- | ----------- |
| `options`          | [`CapfaceSdk.Theme`](#capfacesdktheme) | ❌       | `undefined` |

<hr/>

## Types

| `CapfaceSdk` - Types                                                                | iOS | Android |
| ----------------------------------------------------------------------------------- | --- | ------- |
| [`CapfaceSdk.Params`](#capfacesdkparams)                                            | ✅  | ✅      |
| [`CapfaceSdk.Headers`](#capfacesdkheaders)                                          | ✅  | ✅      |
| [`CapfaceSdk.Theme`](#capfacesdktheme)                                              | ✅  | ✅      |
| [`CapfaceSdk.ButtonLocation`](#capfacesdkbuttonlocation)                            | ✅  | ✅      |
| [`CapfaceSdk.StatusBarColor`](#capfacesdkstatusbarcolor-ios-only)                   | ✅  | ❌      |
| [`CapfaceSdk.FeedbackBackgroundColor`](#capfacesdkfeedbackbackgroundcolor-ios-only) | ✅  | ❌      |
| [`CapfaceSdk.Point`](#capfacesdkpoint-ios-only)                                     | ✅  | ❌      |
| [`CapfaceSdk.DefaultMessage`](#capfacesdkdefaultmessage)                            | ✅  | ✅      |
| [`CapfaceSdk.Errors`](#capfacesdkerrors)                                            | ✅  | ✅      |
| [`CapfaceSdk.MatchType`](#capfacesdkdefaultscanmessage)                             | ✅  | ✅      |
| [`CapfaceSdk.MatchData`](#capfacesdkdefaultscanmessage)                             | ✅  | ✅      |

### `CapfaceSdk.Params`

Here must be passed to initialize the Capface SDK! Case the parameters isn't provided the Capface SDK goes to be not initialized.

| `CapfaceSdk.Params` | type      | Required |
| ------------------- | --------- | -------- |
| `device`            | `string`  | ✅       |
| `url`               | `string`  | ✅       |
| `key`               | `string`  | ✅       |
| `productionKey`     | `string`  | ✅       |
| `isDeveloperMode`   | `boolean` | ❌       |

### `CapfaceSdk.Headers`

Here you can add your headers to send request when some method is called. Only values from type **string**, **null** or **undefined** are accepts!

| `CapfaceSdk.Headers` | type                            | Required | Default     |
| -------------------- | ------------------------------- | -------- | ----------- |
| `[key: string]`      | `string`, `null` or `undefined` | ❌       | `undefined` |

### `CapfaceSdk.Theme`

This is a list of theme properties that can be used to styling. Note, we recommend that you use **only** hexadecimal values to colors, between six and eight characters, because still we don't supported others color type.

| `CapfaceSdk.Theme`                             | type                                                                                                                          | iOS | Android | Required | Default                                                                                                 |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | --- | ------- | -------- | ------------------------------------------------------------------------------------------------------- |
| `logoImage`                                    | `string`                                                                                                                      | ✅  | ✅      | ❌       | `facetec_your_app_logo.png`                                                                             |
| `cancelImage`                                  | `string`                                                                                                                      | ✅  | ✅      | ❌       | `facetec_cancel.png`                                                                                    |
| `cancelButtonLocation`                         | [`CapfaceSdk.ButtonLocation`](#capfacesdkbuttonlocation)                                                                      | ✅  | ✅      | ❌       | `TOP_RIGHT`                                                                                             |
| `defaultStatusBarColorIos`                     | [`CapfaceSdk.StatusBarColor`](#capfacesdkstatusbarcolor-ios-only)                                                             | ✅  | ❌      | ❌       | `DARK_CONTENT`                                                                                          |
| `frameCornerRadius`                            | `number`                                                                                                                      | ✅  | ✅      | ❌       | `10` (iOS) and `20` (Android)                                                                           |
| `frameBackgroundColor`                         | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `frameBorderColor`                             | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `overlayBackgroundColor`                       | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `guidanceBackgroundColorsAndroid`              | `string`                                                                                                                      | ❌  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `guidanceBackgroundColorsIos`                  | `string[]`                                                                                                                    | ✅  | ❌      | ❌       | `["#FFFFFF", "#FFFFFF"]`                                                                                |
| `guidanceForegroundColor`                      | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#272937`                                                                                               |
| `guidanceButtonBackgroundNormalColor`          | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `guidanceButtonBackgroundDisabledColor`        | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#B3D4FC`                                                                                               |
| `guidanceButtonBackgroundHighlightColor`       | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#0264DC`                                                                                               |
| `guidanceButtonTextNormalColor`                | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `guidanceButtonTextDisabledColor`              | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `guidanceButtonTextHighlightColor`             | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `guidanceRetryScreenImageBorderColor`          | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `guidanceRetryScreenOvalStrokeColor`           | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `ovalStrokeColor`                              | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `ovalFirstProgressColor`                       | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#0264DC`                                                                                               |
| `ovalSecondProgressColor`                      | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#0264DC`                                                                                               |
| `feedbackBackgroundColorsAndroid`              | `string`                                                                                                                      | ❌  | ✅      | ❌       | `#026FF4`                                                                                               |
| `feedbackBackgroundColorsIos`                  | [`CapfaceSdk.FeedbackBackgroundColor` ](#capfacesdkfeedbackbackgroundcolor-ios-only)                                          | ✅  | ❌      | ❌       | [`FeedbackBackgroundColor` ](#capfacesdkfeedbackbackgroundcolor-ios-only)                               |
| `feedbackTextColor`                            | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `resultScreenBackgroundColorsAndroid`          | `string`                                                                                                                      | ❌  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `resultScreenBackgroundColorsIos`              | `string[]`                                                                                                                    | ✅  | ❌      | ❌       | `["#FFFFFF", "#FFFFFF"]`                                                                                |
| `resultScreenForegroundColor`                  | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#272937`                                                                                               |
| `resultScreenActivityIndicatorColor`           | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `resultScreenResultAnimationBackgroundColor`   | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `resultScreenResultAnimationForegroundColor`   | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `resultScreenUploadProgressFillColor`          | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `idScanSelectionScreenBackgroundColorsAndroid` | `string`                                                                                                                      | ❌  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanSelectionScreenBackgroundColorsIos`     | `string[]`                                                                                                                    | ✅  | ❌      | ❌       | `["#FFFFFF", "#FFFFFF"]`                                                                                |
| `idScanSelectionScreenForegroundColor`         | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#272937`                                                                                               |
| `idScanReviewScreenForegroundColor`            | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanReviewScreenTextBackgroundColor`        | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `idScanCaptureScreenForegroundColor`           | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanCaptureScreenTextBackgroundColor`       | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `idScanButtonBackgroundNormalColor`            | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#026FF4`                                                                                               |
| `idScanButtonBackgroundDisabledColor`          | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#B3D4FC`                                                                                               |
| `idScanButtonBackgroundHighlightColor`         | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#0264DC`                                                                                               |
| `idScanButtonTextNormalColor`                  | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanButtonTextDisabledColor`                | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanButtonTextHighlightColor`               | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanCaptureScreenBackgroundColor`           | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `idScanCaptureFrameStrokeColor`                | `string`                                                                                                                      | ✅  | ✅      | ❌       | `#FFFFFF`                                                                                               |
| `autheticanteMessage`                          | [`CapfaceSdk.DefaultMessage`](#capfacesdkdefaultmessage)                                                                      | ✅  | ✅      | ❌       | [`DefaultMessage`](#capfacesdkdefaultmessage)                                                           |
| `enrollMessage`                                | [`CapfaceSdk.DefaultMessage`](#capfacesdkdefaultmessage)                                                                      | ✅  | ✅      | ❌       | [`DefaultMessage`](#capfacesdkdefaultmessage)                                                           |
| `photoIdScanMessage`                           | [`CapfaceSdk.DefaultScanMessage`](#capfacesdkdefaultscanmessage)                                                              | ✅  | ✅      | ❌       | [`DefaultScanMessage`](#capfacesdkdefaultscanmessage)                                                   |
| `photoIdMatchMessage`                          | [`CapfaceSdk.DefaultScanMessage`](#capfacesdkdefaultscanmessage) and [`CapfaceSdk.DefaultMessage`](#capfacesdkdefaultmessage) | ✅  | ✅      | ❌       | [`DefaultScanMessage`](#capfacesdkdefaultscanmessage) and [`DefaultMessage`](#capfacesdkdefaultmessage) |

### `CapfaceSdk.ButtonLocation`

This type must be used to position of the cancel button on screen.

| `CapfaceSdk.ButtonLocation` | Description                                                     |
| --------------------------- | --------------------------------------------------------------- |
| `DISABLED`                  | Disable cancel button and doesn't show it.                      |
| `TOP_LEFT`                  | Position cancel button in top right.                            |
| `TOP_RIGHT`                 | Position cancel button in top right. It's **default** position. |

### `CapfaceSdk.StatusBarColor` (`iOS` only)

This type must be used to status bar color.

| `CapfaceSdk.StatusBarColor` | Description                                  |
| --------------------------- | -------------------------------------------- |
| `DARK_CONTENT`              | **Default** color to status bar.             |
| `DEFAULT`                   | Status bar color that's set from the device. |
| `LIGHT_CONTENT`             | Light color to status bar.                   |

### `CapfaceSdk.FeedbackBackgroundColor` (`iOS` only)

This type must be used to **set** the **theme** of the feedback box.

| `CapfaceSdk.FeedbackBackgroundColor` | Description                                                                                    | type                                 | Required | Default                  |
| ------------------------------------ | ---------------------------------------------------------------------------------------------- | ------------------------------------ | -------- | ------------------------ |
| `colors`                             | An array of colors defining the color of each gradient stop.                                   | `string[]`                           | ❌       | `["#026FF4", "#026FF4"]` |
| `locations`                          | It's accepts only two values between 0 and 1 that defining the location of each gradient stop. | `[number, number]`                   | ❌       | `[0, 1]`                 |
| `startPoint`                         | The start point of the gradient when drawn in the layer’s coordinate space.                    | [`Point`](#capfacesdkpoint-ios-only) | ❌       | `x: 0` and `y: 0`        |
| `endPoint`                           | The end point of the gradient when drawn in the layer’s coordinate space.                      | [`Point`](#capfacesdkpoint-ios-only) | ❌       | `x: 1` and `y: 0`        |

### `CapfaceSdk.Point` (`iOS` only)

This interface defines the drawn in the layer's coordinate space.

| `CapfaceSdk.Point` | type     | Required | Default     |
| ------------------ | -------- | -------- | ----------- |
| `x`                | `number` | ❌       | `undefined` |
| `y`                | `number` | ❌       | `undefined` |

### `CapfaceSdk.DefaultMessage`

This interface represents the success message and loading data message during to CapfaceSDK flow. It interface is used **more** by processors's [authenticate](#authenticatedata-capfacesdkdata) and [enroll](#enrolldata-capfacesdkdata) processors.

| `CapfaceSdk.DefaultMessage` | type     | iOS | Android | Required | Default                                                                 |
| --------------------------- | -------- | --- | ------- | -------- | ----------------------------------------------------------------------- |
| `successMessage`            | `string` | ✅  | ✅      | ❌       | `Liveness Confirmed` (Exception to authenticate method: `Autheticated`) |
| `uploadMessageIos`          | `string` | ✅  | ❌      | ❌       | `Still Uploading...`                                                    |

### `CapfaceSdk.DefaultScanMessage`

This interface represents the all scan messages during to CapfaceSDK flow. It interface is used by [photoMatch](#photomatchdata-capfacesdkdata) processors.

| `CapfaceSdk.DefaultScanMessage`                     | type     | iOS | Android | Required | Default                              |
| --------------------------------------------------- | -------- | --- | ------- | -------- | ------------------------------------ |
| `frontSideUploadStarted`                            | `string` | ✅  | ✅      | ❌       | `Uploading Encrypted ID Scan`        |
| `frontSideStillUploading`                           | `string` | ✅  | ✅      | ❌       | `Still Uploading... Slow Connection` |
| `frontSideUploadCompleteAwaitingResponse`           | `string` | ✅  | ✅      | ❌       | `Upload Complete`                    |
| `frontSideUploadCompleteAwaitingResponse`           | `string` | ✅  | ✅      | ❌       | `Processing ID Scan`                 |
| `backSideUploadStarted`                             | `string` | ✅  | ✅      | ❌       | `Uploading Encrypted Back of ID`     |
| `backSideStillUploading`                            | `string` | ✅  | ✅      | ❌       | `Still Uploading... Slow Connection` |
| `backSideUploadCompleteAwaitingResponse`            | `string` | ✅  | ✅      | ❌       | `Upload Complete`                    |
| `backSideUploadCompleteAwaitingProcessing`          | `string` | ✅  | ✅      | ❌       | `Processing Back of ID`              |
| `userConfirmedInfoUploadStarted`                    | `string` | ✅  | ✅      | ❌       | `Uploading Your Confirmed Info`      |
| `userConfirmedInfoStillUploading`                   | `string` | ✅  | ✅      | ❌       | `Still Uploading... Slow Connection` |
| `userConfirmedInfoUploadCompleteAwaitingResponse`   | `string` | ✅  | ✅      | ❌       | `Upload Complete`                    |
| `userConfirmedInfoUploadCompleteAwaitingProcessing` | `string` | ✅  | ✅      | ❌       | `Processing`                         |
| `nfcUploadStarted`                                  | `string` | ✅  | ✅      | ❌       | `Uploading Encrypted NFC Details`    |
| `nfcStillUploading`                                 | `string` | ✅  | ✅      | ❌       | `Still Uploading... Slow Connection` |
| `nfcUploadCompleteAwaitingResponse`                 | `string` | ✅  | ✅      | ❌       | `Upload Complete`                    |
| `nfcUploadCompleteAwaitingProcessing`               | `string` | ✅  | ✅      | ❌       | `Processing NFC Details`             |
| `skippedNFCUploadStarted`                           | `string` | ✅  | ✅      | ❌       | `Uploading Encrypted ID Details`     |
| `skippedNFCStillUploading`                          | `string` | ✅  | ✅      | ❌       | `Still Uploading... Slow Connection` |
| `skippedNFCUploadCompleteAwaitingResponse`          | `string` | ✅  | ✅      | ❌       | `Upload Complete`                    |
| `skippedNFCUploadCompleteAwaitingProcessing`        | `string` | ✅  | ✅      | ❌       | `Processing ID Details`              |
| `successFrontSide`                                  | `string` | ✅  | ✅      | ❌       | `ID Scan Complete`                   |
| `successFrontSideBackNext`                          | `string` | ✅  | ✅      | ❌       | `Front of ID Scanned`                |
| `successFrontSideNFCNext`                           | `string` | ✅  | ✅      | ❌       | `Front of ID Scanned`                |
| `successBackSide`                                   | `string` | ✅  | ✅      | ❌       | `ID Scan Complete`                   |
| `successBackSideNFCNext`                            | `string` | ✅  | ✅      | ❌       | `Back of ID Scanned`                 |
| `successPassport`                                   | `string` | ✅  | ✅      | ❌       | `Passport Scan Complete`             |
| `successPassportNFCNext`                            | `string` | ✅  | ✅      | ❌       | `Passport Scanned`                   |
| `successUserConfirmation`                           | `string` | ✅  | ✅      | ❌       | `Photo ID Scan Complete`             |
| `successNFC`                                        | `string` | ✅  | ✅      | ❌       | `ID Scan Complete`                   |
| `retryFaceDidNotMatch`                              | `string` | ✅  | ✅      | ❌       | `Face Didn’t Match Highly Enough`    |
| `retryIDNotFullyVisible`                            | `string` | ✅  | ✅      | ❌       | `ID Document Not Fully Visible`      |
| `retryOCRResultsNotGoodEnough`                      | `string` | ✅  | ✅      | ❌       | `ID Text Not Legible`                |
| `retryIDTypeNotSupported`                           | `string` | ✅  | ✅      | ❌       | `ID Type Mismatch Please Try Again`  |
| `skipOrErrorNFC`                                    | `string` | ✅  | ✅      | ❌       | `ID Details Uploaded`                |

### `CapfaceSdk.Errors`

This enum represents all errors that are encountered on the CapFace SDK.

| `CapfaceSdk.Errors`             | Description                                                                                                          | iOS | Android |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------- | --- | ------- |
| `CapFaceHasNotBeenInitialized`  | When some processors method is runned, but CapfaceSDK **has not been initialized**.                                  | ✅  | ✅      |
| `CapFaceValuesWereNotProcessed` | When the image sent to the processors cannot be processed due to inconsistency.                                      | ✅  | ✅      |
| `HTTPSError`                    | When exists some network error.                                                                                      | ✅  | ✅      |
| `NoConfigurationsProvided`      | When the configurations [`faceMatch`](#facematchtype-capfacesdkmatchtype-data-capfacesdkmatchdata) doesn't provided. | ✅  | ✅      |
| `JSONError`                     | When exists some problem in getting data in request of **base URL** information.                                     | ❌  | ✅      |
| `CapFaceInvalidSession`         | When session status is invalid.                                                                                      | ❌  | ✅      |
| `CapFaceLivenessWasntProcessed` | When the image user sent to the processors cannot be processed due to inconsistency.                                 | ❌  | ✅      |
| `CapFaceScanWasntProcessed`     | When the image ID sent to the processors cannot be processed due to inconsistency.                                   | ❌  | ✅      |

### `CapfaceSdk.MatchType`

This enum represents all the possible types of flow that can be used on the [`faceMatch`](#facematchtype-capfacesdkmatchtype-data-capfacesdkmatchdata) method.

| `CapfaceSdk.MatchType` | Description                              | iOS | Android |
| ---------------------- | ---------------------------------------- | --- | ------- |
| `authenticate`         | When you want to make authenticate flow. | ✅  | ✅      |
| `enroll`               | When you want to make enroll flow.       | ✅  | ✅      |
| `liveness`             | When you want to make liveness flow.     | ✅  | ✅      |

### `CapfaceSdk.MatchData`

The object with properties that will be sent to native modules to make the requests, change text labels and sent parameters via headers.

| `CapfaceSdk.MatchData` | type               | iOS | Android | Required | Default                                                                                 |
| ---------------------- | ------------------ | --- | ------- | -------- | --------------------------------------------------------------------------------------- |
| `endpoint`             | `string` or `null` | ✅  | ✅      | ❌       | `Authenticated` (authenticate) or `Liveness\nConfirmed` (enroll and liveness)           |
| `parameters`           | `string` or `null` | ✅  | ✅      | ❌       | `null`                                                                                  |
| `successMessage`       | `string` or `null` | ✅  | ✅      | ❌       | `/match-3d-3d` (authenticate) or `/enrollment-3d` (enroll) or `/liveness-3d` (liveness) |
| `uploadMessageIos`     | `string` or `null` | ✅  | ✅      | ❌       | `Still Uploading...`                                                                    |

<hr/>

## Native Events

| Methods                                                              | Return Type                                                                                               | iOS | Android |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --- | ------- |
| `addListener(eventType: string, callback: (event: boolean) => void)` | [`EmitterSubscription`](https://reactnative.dev/docs/native-modules-android#sending-events-to-javascript) | ✅  | ✅      |

### `Event Types`

This is a list of event types that can be used on `addListener`.

| `eventType`    | Return    | Description                                                                                                       |
| -------------- | --------- | ----------------------------------------------------------------------------------------------------------------- |
| `onCloseModal` | `boolean` | This event listener verify if Capface modal biometric is open. Return `true` if modal is open, `false` otherwise. |

<hr/>

## How to add images in CapfaceSDK module?

The `logoImage` and `cancelImage` properties represents your logo and icon of the button cancel. Does not possible to remove them from the module. Default are [Capitual](https://www.capitual.com/) images and `.png` format. By default in `Android` the logo image is shown, but on `iOS` it isn't shown, It's necessary to add manually.

### How to add images in Android?

To add your images in `Android`, you must go to your project's `android/src/main/res/drawable` directory. If in your project `drawable` folder doesn't exist, it create one. Inside the `drawable` folder, you must put your images and done!

### How to add images in iOS?

In `iOS`, open your XCode and go to your project's `ios/<YOUR_PROJECT_NAME>/Images.xcassets` directory. Open the `Images.xcassets` folder and only put your images inside there.

### Example with images added

Now, go back to where you want to apply the styles, import `setTheme` method and add only the image name, no extension format, in image property (`logoImage` or `cancelImage`). **Note**: If the image is not founded the default image will be showed. Check the code example below:

```tsx
import React, { useEffect } from 'react';
import { View, TouchableOpacity, Text } from 'react-native';
import {
  initialize,
  faceMatch,
  setTheme,
} from '@capitual/react-native-capface-sdk';

export default function App() {
  useEffect(() => {
    const params = {
      device: 'YOUR_DEVICE',
      url: 'YOUR_URL',
      key: 'YOUR_PUBLIC_KEY',
      productionKey: 'YOUR_PRODUCTION_KEY',
    };

    async function initialize() {
      await initialize({ params });
      setTheme({
        logoImage: 'yourLogoImage', // yourLogoImage.png
        cancelImage: 'yourCancelImage', // yourCancelImage.png
      });
    }

    initialize();
  }, []);

  return (
    <View
      style={{
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: 20,
      }}
    >
      <TouchableOpacity
        style={{
          width: '100%',
          height: 64,
          justifyContent: 'center',
          alignItems: 'center',
          backgroundColor: 'black',
        }}
        onPress={async () => {
          try {
            const isSuccess = await faceMatch('enroll');
            console.log(isSuccess);
          } catch (error: any) {
            console.error(error);
          }
        }}
      >
        <Text style={{ textAlign: 'center', fontSize: 24, color: 'white' }}>
          Open!
        </Text>
      </TouchableOpacity>
    </View>
  );
}
```

<hr/>

## Limitations, Features or Camera Problems

See the [native implementation](./NATIVE_IMPLEMENTATION.md) to learn more about the limitations and features that will need improving in the `react-native-capface-sdk`.

<hr/>

## Contributing

See the [contributing guide](./CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

<hr/>

## License

[MIT License](./LICENSE). 🙂

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob). 😊
