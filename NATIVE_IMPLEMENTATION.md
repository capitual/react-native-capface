# Native Implementation

> Here you will go to find discussions about limitations and features that will need improving.

<hr />

## Introduction

- [Let's go talk about colors](#lets-go-talk-about-colors-🧑‍🎨)
- [Contributing](#contributing)
- [License](#license)

<hr />

## Let's go talk about colors 🧑‍🎨

Our SDK has support for some format of the hexadecimal colors and some colors name, but not all.

- **Android**: Support for some hexadecimal colors between **six** and **eight** characters and some colors name. We have support only these colors because we use `parseColor` method in our native module Java. It doesn't support others colors types like RGB, RGBA, HSL and HSLA, [click here to learn more about `parseColor`](<https://developer.android.com/reference/android/graphics/Color.html#parseColor(java.lang.String)>). If you have some suggestions to improve it, thank you very much.

- **iOS**: Support for hexadecimal colors only. We have support for this color because we use `UIColor` method in our native module Swift, when we call it in your constructor we provided only hexadecimal `strings`. We didn't find another way per hour to support others colors. If you have some suggestions to improve it, thank you very much.

<hr />

## Contributing

See the [contributing guide](./CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

<hr/>

## License

[MIT License](./LICENSE). 🙂

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob). 😊
