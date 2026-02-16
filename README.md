# 2026 World Cup - Centaurus

A cross-platform mobile app for teens to make virtual-token predictions on 2026 FIFA World Cup matches. Built with Flutter and Firebase.

## Project Structure

```
2026-World-Cup/
  app/              Flutter mobile app (iOS + Android)
  functions/        Firebase Cloud Functions (TypeScript)
  docs/             Specification and development notes
  firestore.rules   Firestore security rules
  firebase.json     Firebase project configuration
```

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.29+)
- [Node.js](https://nodejs.org/) (22+)
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- A Firebase project on the Blaze plan
- An API-Football API key (https://www.api-football.com/)

## Local Development Setup

### 1. Clone the repository

```bash
git clone https://github.com/ahelferthaus/2026-World-Cup.git
cd 2026-World-Cup
```

### 2. Set up Firebase

```bash
# Login to Firebase
npx firebase-tools login

# Set your project
npx firebase-tools use YOUR_PROJECT_ID

# Set the API key secret
npx firebase-tools functions:secrets:set API_FOOTBALL_KEY
```

### 3. Configure Flutter for Firebase

```bash
cd app
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID
flutter pub get
cd ..
```

### 4. Install Cloud Functions dependencies

```bash
cd functions
npm install
cd ..
```

### 5. Run with Firebase Emulators

```bash
# Start emulators (Functions, Firestore, Auth)
npx firebase-tools emulators:start

# In a separate terminal, run the Flutter app
cd app
flutter run
```

## Environment Variables

Copy `.env.example` to `.env` and fill in your values. API keys are stored as Firebase secrets, not in `.env`.

```bash
# Set the sports API key (Cloud Functions secret)
npx firebase-tools functions:secrets:set API_FOOTBALL_KEY
```

## Firebase Deploy

```bash
# Deploy everything
npx firebase-tools deploy

# Deploy only functions
npx firebase-tools deploy --only functions

# Deploy only Firestore rules
npx firebase-tools deploy --only firestore:rules

# Deploy only indexes
npx firebase-tools deploy --only firestore:indexes
```

## Build Release

```bash
# Android APK
cd app
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS with Xcode)
flutter build ios --release
```

## Push to GitHub

```bash
git init
git remote add origin https://github.com/ahelferthaus/2026-World-Cup.git
git add .
git commit -m "Initial MVP: World Cup 2026 Centaurus prediction app"
git branch -M main
git push -u origin main
```

## Architecture

- **Frontend**: Flutter with Riverpod (state management) and GoRouter (routing)
- **Backend**: Firebase Cloud Functions (TypeScript) as API proxy
- **Database**: Cloud Firestore
- **Auth**: Firebase Authentication (Google, Apple, Email)
- **Sports Data**: API-Football (proxied through Cloud Functions)

All API keys are stored in Cloud Functions secrets. Token balance updates are server-side only via Firestore transactions.

## License

Private project - not for distribution.
