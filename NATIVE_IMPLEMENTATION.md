# Native Implementation

> Here you will go to find discussions about limitations and features that will need improving.

<hr />

## Introduction

- [Enabling Camera](#enabling-camera-ios-only)
- [Contributing](#contributing)
- [License](#license)

<hr />

## Enabling Camera (iOS only)

If you want to enable the camera, you need to add the following instructions in your `Info.plist` file:

```plist
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) need access to your camera to take picture.</string>
```

> That's will be necessary to what iOS **works** correctly!

<hr />

## Contributing

See the [contributing guide](./CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

<hr/>

## License

[MIT License](./LICENSE). 🙂

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob). 😊
