# Flight-Sync Admin App – Dev & Deployment

Admin panel for the Flight Sync ecosystem, built with Flutter for **mobile and web**.

This document explains:

- How to **set up the project** locally
- How to **run the app** on mobile and web
- How to **build an Android APK / App Bundle**
- How to **deploy the web build to Vercel (free tier)**

---

## 1. Prerequisites

Make sure you have the following installed:

- **Flutter SDK** (stable channel)  
  - Verify: `flutter --version`
- **Android toolchain** (for mobile builds)
  - Android Studio (or Android SDK + platform tools)
  - At least one Android device/emulator
  - Verify: `flutter doctor`
- **Web tooling**
  - A modern browser (Chrome recommended)
- **Node.js + npm** (for Vercel CLI)
  - Verify: `node -v`, `npm -v`
- **Vercel account** (free)  
  - Vercel CLI:  
    ```bash
    npm install -g vercel
    ```

---

## 2. Install Dependencies

From the project root:

```bash
cd /home/leul/Desktop/personal/flight_sync_admin
flutter pub get
```

---

## 3. Running the App Locally

### 3.1 Mobile (Android)

1. Start an Android emulator **or** connect a device with USB debugging enabled.
2. From the project root:

```bash
flutter run
```

To choose a specific device:

```bash
flutter devices          # lists devices
flutter run -d <device_id>
```

### 3.2 Web (Flutter Web)

Run in Chrome:

```bash
flutter run -d chrome
```

Or run as a web server only:

```bash
flutter run -d web-server
```

---

## 4. Build Android APK / App Bundle

### 4.1 Release APK

```bash
flutter build apk --release
```

Output:

- `build/app/outputs/flutter-apk/app-release.apk`

Install on a device (optional):

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### 4.2 Play Store App Bundle (AAB)

If you plan to publish on the Play Store:

```bash
flutter build appbundle --release
```

Output:

- `build/app/outputs/bundle/release/app-release.aab`

Upload this `.aab` file in the Google Play Console.

---

## 5. Build Web Assets (for Deployment)

Generate the web build:

```bash
flutter build web --release
```

Output directory:

- `build/web`

This folder contains `index.html`, `main.dart.js`, and all assets needed for hosting.

---

## 6. Deploy Web Version to Vercel (Free)

We deploy the **prebuilt** Flutter web output (`build/web`) using Vercel.

### 6.1 One-Time Vercel Setup

1. **Login** from terminal:

   ```bash
   vercel login
   ```

2. (Recommended) Create a `vercel.json` file in the project root:

   ```json
   {
     "version": 2,
     "framework": null,
     "outputDirectory": "build/web"
   }
   ```

This tells Vercel to serve files from `build/web`.

### 6.2 Build Web Locally

Every time before you deploy:

```bash
flutter build web --release
```

### 6.3 First Deployment (Preview)

From the project root:

```bash
vercel deploy --prebuilt
```

During the first run, Vercel will ask:

- **Link to existing project?** → choose **No** (first time)
- **Project name** → e.g. `flight-sync-admin`
- **Framework** → choose **Other**
- **Output directory** → `build/web` (if asked; `vercel.json` can auto-detect)

After deployment, you get a **preview URL** (e.g. `https://flight-sync-admin-xyz.vercel.app`).

### 6.4 Production Deployment

When you’re ready for production:

```bash
flutter build web --release
vercel deploy --prebuilt --prod
```

This creates/updates your **production** deployment with a stable URL.  
You can later attach a custom domain from the Vercel dashboard if desired.

---

## 7. Common Commands Cheat Sheet

```bash
# Install dependencies
flutter pub get

# Run on Android (debug)
flutter run

# Run on web (Chrome)
flutter run -d chrome

# Build Android release APK
flutter build apk --release

# Build Android release AAB
flutter build appbundle --release

# Build web release
flutter build web --release

# Vercel: deploy prebuilt web (preview)
vercel deploy --prebuilt

# Vercel: deploy prebuilt web (production)
vercel deploy --prebuilt --prod
```

---

## 8. Helpful Links

- Flutter docs: https://docs.flutter.dev/
- Vercel docs: https://vercel.com/docs

