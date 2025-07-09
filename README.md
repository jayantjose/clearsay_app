
# 📱 Clearsay Flutter App

Clearsay is a simple Flutter-based mobile app that loads [https://clearsay.co.uk](https://clearsay.co.uk) inside a WebView with smooth in-app navigation and graceful offline handling. It is built for Android and ready for iOS (buildable via macOS).

---

## 🚀 Features

- 🌐 WebView with unrestricted JavaScript
- 🏠 **Home** and 🔙 **Back** navigation buttons
- 🔗 Opens external links in the system browser (Chrome, Safari)
- 📶 Detects internet connectivity with `connectivity_plus`
- ❌ Displays a friendly "No Internet" screen with retry button
- 🎨 Splash image shown on offline screen
- 📱 Supports Android 10+ (minSdkVersion 29)

---

## 📦 Dependencies

```yaml
flutter:
  sdk: flutter
webview_flutter: ^4.4.1
connectivity_plus: ^5.0.2
url_launcher: ^6.2.6
```

> Make sure to run `flutter pub get` after modifying `pubspec.yaml`.

---

## 📂 Folder Structure

```
lib/
 └── main.dart               # App entry point with WebView and offline handling
assets/
 └── splash/splash_image.png # Logo shown when offline
android/
 └── app/
     └── src/
         └── main/
             └── AndroidManifest.xml # Permissions + URL query setup
```

---

## 🔧 Setup Instructions

### 1. Clone this repository

```bash
git clone https://github.com/your-username/clearsay.git
cd clearsay
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

> Make sure you have an Android 10+ device or emulator connected.

---

## 🛠 Android Setup Notes

### ✅ `AndroidManifest.xml` additions

- Ensure `INTERNET` permission is added
- Add `<queries>` block to allow launching external links

```xml
<uses-permission android:name="android.permission.INTERNET"/>

<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="http" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

---

## 🍏 iOS Notes

- iOS builds must be compiled on macOS using Xcode.
- This project is iOS-ready but `.ipa` files cannot be built from Windows.

---

## 💡 Future Enhancements (Optional Ideas)

- Pull-to-refresh gesture
- Toast/snackbar on offline detection
- Dark mode-aware offline screen
- Add native splash screen using `flutter_native_splash`

---

## 📸 Screenshots

*Include screenshots here if desired*

---

## 👨‍💻 Author

Jayant Jose

---

## 📄 License

This project is open-source and free to use for internal or educational purposes.
