# Alex Learns [Flutter](https://flutter.dev/)

This project is the result of following Google's ["first Flutter app" codelab](https://codelabs.developers.google.com/codelabs/flutter-codelab-first):

> The application generates cool-sounding names, such as "newstay", "lightstream", "mainbrake", or "graypine". The user can ask for the next name, favorite the current one, and review the list of favorited names on a separate page. The app is responsive to different screen sizes.

The relevant code lives in:
* `pubspec.yaml` (similar to [`package.json`](https://docs.npmjs.com/cli/v9/configuring-npm/package-json) for [node](https://nodejs.org/en/about/) projects) 
* `lib/` (similar to the `src` folder for [React](https://reactjs.org/) projects). 
- Ignore `default/*`. This folder exists to preserve the default `main.dart` file that gets created when a user initiates a new Flutter project with `flutter new`. Keeping it as reference.

## To Run

### iOS

You'll need a valid code signing certificate if you want to run this on an iOS device.

You can connect to your Apple Developer account by signing in with your Apple ID in Xcode and create an iOS Development Certificate as well as a Provisioning Profile for your project by:

1. Open the Flutter project's Xcode target with `open ios/Runner.xcworkspace`
2. Select the 'Runner' project in the navigator then the 'Runner' target in the project settings
3. Make sure a 'Development Team' is selected under `Signing & Capabilities` > `Team`. You may need to:

- Log in with your Apple ID in Xcode first
- Ensure you have a valid unique Bundle ID
- Register your device with your Apple Developer Account
- Let Xcode automatically provision a profile for your app

4. Build or run your project again
5. Trust your newly created Development Certificate on your iOS device via `Settings` > `General` > `Device Management` > `[your new certificate]` > `Trust`

For more information, please visit Apple's App Distribution Guide's Section on [Maintaining Certificates](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingCertificates/MaintainingCertificates.html).

Or run on an iOS simulator without code signing.

### iOS Simulator

Follow the steps under `Set up the iOS simulator` in the [Flutter Docs](https://docs.flutter.dev/get-started/install/macos#set-up-the-ios-simulator).

## Resources

A few resources to get started:

* [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
* [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

There's also Flutter's [online documentation](https://docs.flutter.dev/), which provides:

* Tutorials
* Code samples
* Guidance on mobile development
* A full API reference.
