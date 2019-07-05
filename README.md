# schibsted_account_sdk

Flutter plugin for Schibsted Account SDK

> Disclaimer: This project is not maintained by Schibsted Account team. It is an independent initiative. Please report any issue or ideas directly into this repository. Pull requests are also welcome.

## Getting Started

### Example project
If you want to run the Android example project - please provide values in 
`example/android/app/src/main/assets/schibsted_account.conf` file.
For more info visit the [SDK Setup doc](https://github.com/schibsted/account-sdk-android#sdk-setup "SDK Setup doc").

### Android
Configure your Android project following the steps in [account-sdk-android docs](https://github.com/schibsted/account-sdk-android "account-sdk-android docs")

### iOS
Not supported at the moment :-(
If somebody would like to add it - don't hesitate ;-)

### Flutter

Import the classes with:
`import 'package:schibsted_account_sdk/schibsted_account.dart';`

To start the login flow, just call:
`SchibstedAccountPlugin.login;`

To log out, just call:
`SchibstedAccountPlugin.logout;`

You can listen to the exposed `SchibstedAccountPlugin.loginEvents` Stream to get the `SchibstedAccountEvent` login events which contain the current state. State can be a value from the `SchibstedAccountState` enum:
- `logged_out` - user has logged out
- `logged_in` - user has logged in and we have the User Data (email, displayName, ...)
- `unknown` - should never happen. Would be sent if Android `resultCode` was unknown and not handeled by the plugin.
- `canceled` - user cancels the Login flow.
- `fetching` - user has logged in and we start to fetch the User Data (email, displayName, ...)
- `error` - when the SDK fails at some point

For more reference on how to use the plugin check the `example` project in this repo.

### TODO
- [ ] Implement iOS
- [ ] Write tests
