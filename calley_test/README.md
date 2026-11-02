# Calley Test – Flutter Machine Test

Flutter app integrating the Mock API V2 (Get List, Get List Details).

## Architecture
`lib/` → core (config/theme) · models · services (REST) · providers (state, Provider) · screens · widgets

## Setup
```bash
flutter create --org com.yourname --project-name calley_test .   # generates android/ios folders
flutter pub get
```
Android: add to `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries><intent><action android:name="android.intent.action.DIAL"/><data android:scheme="tel"/></intent></queries>
```
iOS: add `tel` to `LSApplicationQueriesSchemes` in `ios/Runner/Info.plist`.

## Run / Build
```bash
flutter run
flutter build apk --debug      # build/app/outputs/flutter-apk/app-debug.apk
```
