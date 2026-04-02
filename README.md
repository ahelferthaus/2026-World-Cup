# Pokin' Tokens

**Social sports prediction app for the 2026 FIFA World Cup.**

Pokin' Tokens is a cross-platform mobile and web app where users compete using virtual tokens to predict match outcomes, challenge friends head-to-head, and climb leaderboards. Built with Flutter and Firebase for iOS, Android, and web deployment.

---

## Features

### Predictions & Betting Markets
- **Match Winner** (1X2) with real-time odds display
- **Both Teams to Score** (BTTS) Yes/No markets
- **Player Props** (Anytime Goalscorer, First Goalscorer, Assists, Shots)
- **Over/Under 2.5 Goals** with line explanations
- **Exact Score** predictions with 5x payout multiplier
- **ALL IN** mode to risk entire token balance on a single pick

### Social & Competitive
- **P2P Challenges** with 3 categories: Sports, Custom, Party Games
- **Venmo-style social feed** showing who challenged whom and outcomes
- **Head-to-Head records** tracking wins/losses against each opponent
- **Party Mode** multiplayer lobby for group challenges
- **4-tab leaderboard**: Global, My School, By School, By State

### Live Features
- **Live match screen** with real-time friend betting and quick bet chips
- **VS tally bar** showing running token count during live games
- **Game event feed** with goal announcements and bet resolution

### AI-Powered
- **Research Lab** powered by Perplexity AI for real-time football research with source citations
- **Pokin' Pete** AI chatbot (Gemini) with soccer-fan personality, trash talk, and bold predictions

### Progression & Economy
- **Virtual token system** (100 tokens on signup, purchasable packages)
- **Daily/weekly challenges** with token rewards
- **Streak tracking** with milestone rewards (3/5/7/14/30/60 days)
- **Token Store** with Starter, Fan, Baller, and Legend packs

### Content
- **Tournament bracket** visualization (R16 through Final)
- **Multi-sport hub** with NBA Playoffs and extensible sport cards
- **Teams encyclopedia** with squads, FIFA rankings, and Golden Boot tracker
- **Sports news feed** with category filtering
- **Player detail sheets** with stats, age, position, and club info

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.7+ (Dart) |
| **State Management** | Riverpod 3.0 |
| **Routing** | GoRouter 16.0 |
| **Backend** | Firebase Cloud Functions (TypeScript, Node.js 22) |
| **Database** | Cloud Firestore |
| **Authentication** | Firebase Auth (Google, Apple, Email) |
| **Sports Data** | API-Football (proxied through Cloud Functions) |
| **AI Research** | Perplexity API (sonar model) |
| **AI Chat** | Google Gemini 2.0 Flash |
| **Design System** | Material 3, dark theme, glassmorphism |

---

## Project Structure

```
2026-World-Cup/
  app/                  Flutter app (iOS + Android + Web)
    lib/
      core/             Shared widgets, theme, constants, utilities
      features/         18 feature modules (auth, predict, challenges, etc.)
      routing/          GoRouter configuration
  functions/            Firebase Cloud Functions (TypeScript)
    src/
      endpoints/        HTTP endpoints (matches, predictions, leaderboard, research, chat)
      triggers/         Auth triggers, scheduled prediction resolution
      services/         API-Football proxy, caching layer
      middleware/       Auth verification
      types/            TypeScript interfaces
  docs/                 Specification and documentation
  firestore.rules       Firestore security rules
  firestore.indexes.json Composite indexes
  firebase.json         Firebase project configuration
```

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.7+)
- [Node.js](https://nodejs.org/) (22+)
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- A Firebase project on the Blaze plan
- API keys: [API-Football](https://www.api-football.com/), [Perplexity](https://www.perplexity.ai/), [Google Gemini](https://ai.google.dev/)

---

## Quick Start

### 1. Clone and set up Firebase

```bash
git clone https://github.com/ahelferthaus/2026-World-Cup.git
cd 2026-World-Cup

firebase login
firebase use YOUR_PROJECT_ID

# Set API secrets
firebase functions:secrets:set API_FOOTBALL_KEY
firebase functions:secrets:set PERPLEXITY_API_KEY
firebase functions:secrets:set GEMINI_API_KEY
```

### 2. Configure Flutter

```bash
cd app
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID
flutter pub get
```

### 3. Install Cloud Functions

```bash
cd ../functions
npm install
```

### 4. Run locally

```bash
# Terminal 1: Start Firebase Emulators
firebase emulators:start

# Terminal 2: Run Flutter app
cd app
flutter run
```

The app runs in **demo mode** by default (`useDemoData = true` in `demo_data.dart`), providing full functionality without API keys.

---

## Deployment

```bash
# Deploy Cloud Functions
firebase deploy --only functions

# Deploy Firestore rules and indexes
firebase deploy --only firestore

# Build release apps
cd app
flutter build apk --release          # Android APK
flutter build appbundle --release    # Play Store bundle
flutter build ios --release          # iOS (requires macOS + Xcode)
flutter build web --release          # Web app
```

---

## Security

- All API keys stored as Firebase Cloud Function secrets (never in client code)
- Token balance writes are server-side only via Firestore transactions
- Firestore rules enforce read-only access with per-user scoping
- Users can only update their own `displayName` field (max 20 chars)
- Default deny-all for unmatched Firestore paths

---

## Architecture Highlights

- **Clean feature architecture**: Each feature module has its own domain, data, and presentation layers
- **Responsive layout**: Bottom nav (mobile), navigation rail (tablet), extended rail (desktop)
- **Server-side prediction resolution**: Scheduled Cloud Function runs every 5 minutes to resolve predictions and credit payouts
- **Caching layer**: API-Football responses cached in Firestore with configurable TTLs (2 min matches, 30 min standings)
- **Demo mode**: Full app experience with hardcoded data for development and testing without API credentials

---

## Codebase Stats

- **~16,000 lines of code** across 115 source files
- **18 feature modules** with 20+ screens
- **11 reusable widgets** in the shared component library
- **7 Cloud Functions** (5 HTTP endpoints, 1 auth trigger, 1 scheduled trigger)
- **4 Firestore composite indexes** optimized for leaderboard and prediction queries

---

## License

Private project - not for distribution.
