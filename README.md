# schibsted_account_sdk

Flutter plugin for Schibsted Account SDK

> Disclaimer: This project is not maintained by Schibsted Account team. It is an independent initiative. Please report any issue or ideas directly into this repository. Pull requests are also welcome.

## Getting Started

### Example project
If you want to run the Android example project - please provide values in 
`example/android/app/src/main/assets/schibsted_account.conf` file.
For more info visit the [SDK Setup doc](https://github.com/schibsted/account-sdk-android#sdk-setup "SDK Setup doc").

If you want to run the iOS example project - please provide values in 
`⁨example⁩/ios⁩/Runner⁩/SchibstedAccountConfig.plist` file.
For more info visit the [SDK Setup doc](https://github.com/schibsted/account-sdk-ios#setup "SDK Setup doc").

### Android
1. Configure your Android project following the steps in [account-sdk-android docs](https://github.com/schibsted/account-sdk-android "account-sdk-android docs")

2. Change the Application theme (Flutter creates a AndroidManifest.xml that applies a theme to the Activity, not the Application). To do that, remove the `android:theme="@style/LaunchTheme"` from the `<activity>` tag and add it to the `<application>` tag.
Then change the parent of `@style/LaunchTheme` to `@style/Theme.AppCompat.Light.NoActionBar` or some other `AppCompat` theme.

3. Add a file with to `/res/values` that has the following information:
```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="schacc_conf_client_name">example client</string>
    <string name="schacc_conf_redirect_scheme">example-scheme</string>
    <string name="schacc_conf_redirect_host">://login</string>
</resources>
```

### iOS
1. Configure your iOS project following the steps in [account-sdk-ios docs](https://github.com/schibsted/account-sdk-ios "account-sdk-ios docs")
2. Add to project file SchibstedAccountConfig.plist that has the following information:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>environment</key>
	<string>preproduction</string>
	<key>clientID</key>
	<string>&lt;client-id&gt;</string>
	<key>clientSecret</key>
	<string>&lt;client-secret&gt;</string>
	<key>appURLScheme</key>
	<string>&lt;url-schema&gt;</string>
</dict>
</plist>
```

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
- [✖] Implement iOS
- [ ] Write tests
