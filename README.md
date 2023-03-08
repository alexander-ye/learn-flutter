# Alex Learns [Flutter](https://flutter.dev/)

The result of me playing around with a few Flutter tutorials.

Relevant code lives in:

- `pubspec.yaml` (similar to [`package.json`](https://docs.npmjs.com/cli/v9/configuring-npm/package-json) for [node](https://nodejs.org/en/about/) projects)
- `lib/` (similar to the `src` folder for [React](https://reactjs.org/) projects).

* `default/*`: the default `main.dart` file that gets created when a user initiates a new Flutter project with `flutter new`. It's a counter app. Keeping it as reference.
* `randomwordpairgenerator`: Google's ["first Flutter app" codelab](https://codelabs.developers.google.com/codelabs/flutter-codelab-first) with the additional feature of removing favorites from the favorites screen.

  > The application generates cool-sounding names, such as "newstay", "lightstream", "mainbrake", or "graypine". The user can ask for the next name, favorite the current one, and review the list of favorited names on a separate page. The app is responsive to different screen sizes.

* `shoppingcart`: Google's ["Introduction to widgets"](https://docs.flutter.dev/development/ui/widgets-intro#bringing-it-all-together) with the additional feature of adding and removing products.

  > A hypothetical shopping application displays various products offered for sale, and maintains a shopping cart for intended purchases.

* `expansionpanels`: Google's ["ExpansionPanelList class example"](https://api.flutter.dev/flutter/material/ExpansionPanelList-class.html).

  > Here is a simple example of how to implement ExpansionPanelList.

## To Run

### Code

All example apps are imported in the root `main.dart` file located in `lib`. The relevant function names for each app is commented right after its respective import.

To play around with the app of interest, simply replace the return value of `App`'s `build()` method with the proper function name:

```
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    // Replace the return value with an App of interest
    return ShoppingCartApp();
  }
}
```

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

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

There's also Flutter's [online documentation](https://docs.flutter.dev/), which provides:

- Tutorials
- Code samples
- Guidance on mobile development
- A full API reference.
