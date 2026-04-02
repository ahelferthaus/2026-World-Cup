# Pokin' Tokens Wiki

Complete reference documentation for the Pokin' Tokens project.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Frontend (Flutter)](#frontend-flutter)
4. [Backend (Cloud Functions)](#backend-cloud-functions)
5. [Database Schema](#database-schema)
6. [Authentication](#authentication)
7. [Feature Reference](#feature-reference)
8. [API Reference](#api-reference)
9. [Configuration](#configuration)
10. [Deployment Guide](#deployment-guide)
11. [Development Workflow](#development-workflow)

---

## Project Overview

**Pokin' Tokens** is a social sports prediction platform targeting teens, centered on the 2026 FIFA World Cup. Users receive virtual tokens to place predictions on match outcomes, challenge friends, and compete on leaderboards segmented by school and state.

### Core Value Proposition
- Free-to-play virtual token economy (no real money)
- School-based social competition layer
- AI-powered research and chat features
- Multi-sport expandability beyond World Cup soccer

### Target Audience
- High school students (ages 14-18)
- Sports fans interested in predictions and competition
- School communities (leaderboards drive organic adoption)

---

## Architecture

### System Diagram

```
[Flutter App (iOS/Android/Web)]
        |
        |  HTTPS
        v
[Firebase Cloud Functions]
    |           |           |
    v           v           v
[Firestore]  [API-Football]  [AI APIs]
                             (Perplexity, Gemini)
```

### Design Principles
- **Server-authoritative**: All token writes and prediction resolution happen server-side
- **Feature-modular**: Each feature is a self-contained module with domain/data/presentation layers
- **Dark-first**: UI designed for dark theme with neon accents and glassmorphism
- **Offline-capable**: Demo mode provides full functionality without network

### State Management
- **Riverpod 3.0** for all async state, auth state, and dependency injection
- Providers live alongside their feature modules
- `AsyncValue` extensions for consistent loading/error/data handling

### Navigation
- **GoRouter 16.0** with auth redirect guards
- `StatefulShellRoute.indexedStack` for bottom nav state preservation
- Responsive scaffold: BottomNavigationBar (mobile) / NavigationRail (tablet/desktop)

---

## Frontend (Flutter)

### App Entry Point

```
main.dart → Firebase.initializeApp() → ProviderScope → PokinTokensApp
app.dart  → MaterialApp.router with GoRouter, dark Material 3 theme
```

### Core Module (`core/`)

| Directory | Contents |
|-----------|----------|
| `constants/` | `AppColors` (92-line palette), `AppSpacing`, `AppTextStyles`, `ApiEndpoints` |
| `data/` | `DemoData` (matches, standings, teams, players, challenges, news, research, chat), school data |
| `theme/` | `AppTheme.dark` — Material 3 dark theme with Poppins font |
| `utils/` | `DateFormatter`, `TokenFormatter`, `Validators` |
| `extensions/` | `AsyncValue` helpers, `BuildContext` extensions |
| `widgets/` | 11 reusable components (see below) |

### Shared Widget Library

| Widget | Purpose |
|--------|---------|
| `AnimatedGradientBackground` | Floating animated orbs behind content |
| `GlassmorphicCard` | Frosted glass card with blur and border |
| `GlassPill` | Compact stat badge with blur background |
| `TokenBadge` | Token count display with gold styling |
| `MatchCard` | Match display with teams, scores, and status |
| `TeamFlag` | Country flag/logo from URL |
| `UserAvatar` | Profile picture with fallback |
| `GradientButton` | Primary CTA button with gradient fill |
| `CoinRain` | Falling coin celebration animation |
| `AppLoadingIndicator` | Centered spinner with message |
| `AppErrorWidget` | Error state with retry button |
| `AppEmptyState` | Empty state with icon and message |

### Color System

```
Primary:    #6C5CE7 (electric purple)
Secondary:  #00E676 (neon green / win)
Accent:     #FF6D00 (hot orange / CTA)
Background: #0D0B1E (deep dark)
Surface:    #1A1730 (card background)
Token Gold: #FFD700 (premium feel)

Neon palette: purple, cyan, pink, blue
Sport brands: NBA orange/blue/red
Status: live (green), pending (grey), lost (red), won (green)
```

### Feature Modules (18 total)

Each module follows the pattern:
```
feature_name/
  domain/       Data models (Dart classes)
  data/         Repositories (Firestore/API calls)
  presentation/ Screens, widgets, Riverpod providers
```

| Module | Screens | Key Models |
|--------|---------|------------|
| `auth` | Login, Register | `AppUser` |
| `home` | Home (2 tabs: Matches, Standings) | `MatchModel`, `StandingModel`, `TeamModel` |
| `predict` | Predict (3 tabs: Match Winner, BTTS, Player Props) | `PredictionModel` |
| `challenges` | Challenges Hub (5 tabs: Feed, My Bets, Create, H2H, Party) | `ChallengeModel` |
| `leaderboard` | Leaderboard (4 tabs) | `LeaderboardEntry` |
| `profile` | Profile, Edit Name, Prediction History | — |
| `teams` | Teams (3 tabs: Teams, Players, Golden Boot) | — |
| `bracket` | Tournament Bracket | — |
| `livegame` | Live Game with betting | — |
| `news` | News Feed | — |
| `store` | Token Store | — |
| `sporthub` | Multi-Sport Hub | — |
| `nba` | NBA Playoffs | — |
| `streaks` | Streaks & Challenges | — |
| `research` | Research Lab (Perplexity AI) | — |
| `chat` | Pokin' Pete Chatbot | — |
| `propbets` | Prop Bets | — |

---

## Backend (Cloud Functions)

### Runtime
- **Node.js 22** with TypeScript 5.7
- **Firebase Functions v2** (2nd gen, runs on Cloud Run)
- **Strict mode** with null checks and no implicit returns

### Function Registry

| Function | Type | Trigger | Purpose |
|----------|------|---------|---------|
| `matchesToday` | HTTP | `onRequest` | Fetch today's fixtures from API-Football |
| `standings` | HTTP | `onRequest` | Fetch current World Cup standings |
| `createPrediction` | HTTP | `onRequest` | Record a user's prediction |
| `leaderboardGlobal` | HTTP | `onRequest` | Global leaderboard query |
| `leaderboardSchool` | HTTP | `onRequest` | School-filtered leaderboard |
| `research` | HTTP | `onRequest` | Proxy queries to Perplexity AI |
| `chat` | HTTP | `onRequest` | Proxy messages to Gemini AI |
| `onUserCreated` | Auth | `onCreate` | Initialize user profile with starting tokens |
| `resolveMatchPredictions` | Scheduled | Every 5 min | Resolve completed predictions, credit payouts |

### Secrets Management

| Secret | Service | Purpose |
|--------|---------|---------|
| `API_FOOTBALL_KEY` | API-Football | Sports data |
| `PERPLEXITY_API_KEY` | Perplexity AI | Research queries |
| `GEMINI_API_KEY` | Google Gemini | Chat responses |

### Services Layer

**API-Football Service** (`services/api-football.ts`)
- Fetches fixture data from `v3.football.api-sports.io`
- World Cup league ID: 1, Season: 2026
- Parses fixture objects into `SimplifiedMatch` format

**Cache Service** (`services/cache.ts`)
- Writes API responses to Firestore collections (`matchesCache`, `standingsCache`)
- Configurable TTLs: matches (2 min), standings (30 min)
- Reduces API-Football quota usage

### Auth Middleware

`middleware/auth.ts` provides `verifyAuth()`:
- Extracts Bearer token from Authorization header
- Verifies with Firebase Admin SDK
- Returns decoded UID or throws `UNAUTHENTICATED`

---

## Database Schema

### Firestore Collections

**`users/{uid}`**

| Field | Type | Description |
|-------|------|-------------|
| `uid` | string | Firebase Auth UID |
| `displayName` | string | User display name (max 20 chars) |
| `school` | string | School affiliation |
| `state` | string | US state |
| `grade` | string | Grade level (e.g., "Junior (11th)") |
| `tokens` | number | Current token balance |
| `totalWagered` | number | Lifetime tokens wagered |
| `totalWon` | number | Lifetime tokens won |
| `predictionsCount` | number | Total predictions made |
| `predictionsWon` | number | Correct predictions |
| `photoUrl` | string? | Profile photo URL |
| `lastAiPhotoGenerated` | timestamp? | Rate limit for AI avatar |
| `createdAt` | timestamp | Account creation time |

**`predictions/{id}`**

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Auto-generated document ID |
| `uid` | string | Predictor's UID |
| `matchId` | number | API-Football fixture ID |
| `type` | string | Prediction type (winner, exactScore) |
| `selection` | string | User's pick |
| `scoreHome` | number? | Exact score home (if applicable) |
| `scoreAway` | number? | Exact score away (if applicable) |
| `wager` | number | Tokens wagered |
| `status` | string | pending / won / lost |
| `payout` | number | Tokens paid out (0 if lost) |
| `createdAt` | timestamp | Prediction timestamp |

**`matchesCache/{date}`** — Cached API-Football match data by date

**`standingsCache/{stage}`** — Cached standings by group/stage

### Composite Indexes

| Collection | Fields | Purpose |
|------------|--------|---------|
| `predictions` | `uid` ASC, `createdAt` DESC | User prediction history |
| `predictions` | `matchId` ASC, `status` ASC | Match resolution queries |
| `predictions` | `uid` ASC, `matchId` ASC | Check for duplicate bets |
| `users` | `school` ASC, `tokens` DESC | School leaderboard |

### Security Rules Summary

- Users: Read own doc only, update `displayName` only (validated)
- Predictions: Read own only, all writes server-side
- Cache collections: Read-only for authenticated users
- Default: Deny all unmatched paths

---

## Authentication

### Supported Providers
1. **Google Sign-In** — OAuth via `google_sign_in` package
2. **Apple Sign-In** — OAuth via `sign_in_with_apple` package (iOS/web)
3. **Email/Password** — Firebase native auth

### Auth Flow
1. User signs in via any provider
2. Firebase Auth creates/retrieves user record
3. `onUserCreated` Cloud Function triggers on first sign-in
4. Function creates `users/{uid}` document with initial token balance (100)
5. GoRouter redirect guard routes authenticated users to `/home`, unauthenticated to `/login`

### Demo Mode
When `useDemoData = true` (in `demo_data.dart`):
- Auth is bypassed with a `demoLoggedInProvider`
- All data comes from hardcoded `DemoData` class
- No Firebase credentials required

---

## Feature Reference

### Token Economy

| Parameter | Value |
|-----------|-------|
| Initial balance | 100 tokens |
| Min wager | 1 token |
| Max wager | 20 tokens |
| Match winner payout | 2.0x wager |
| Exact score payout | 5.0x wager |
| BTTS/Player Props | Odds-based (varies) |

### Prediction Resolution

The `resolveMatchPredictions` scheduled function:
1. Runs every 5 minutes
2. Queries API-Football for recently completed fixtures
3. Finds all pending predictions for those fixtures
4. Evaluates each prediction against the actual result
5. For winners: credits `wager * multiplier` tokens via Firestore `FieldValue.increment()`
6. Updates prediction status to `won` or `lost`
7. Uses batch writes for efficiency

### Challenge System

**Categories:**
- **Sports** — Tied to specific matches (who scores next, match outcome)
- **Custom** — Anything users can think of ("I beat you at Mario Kart")
- **Party Game** — In-person games ("Who blinks first")

**Lifecycle:**
```
Created → Pending → Accepted → Awaiting Outcome → Settled
                  → Declined
                  → Expired (auto after 24h)
         Disputed → Resolved
```

**Settlement:** Both parties confirm outcome. If disputed, tokens are refunded (push).

### Streak System

**Daily Challenges:**
- Make 3 predictions → 10 tokens
- Bold Bet (wager 15+) → 15 tokens
- Exact Score Try → 10 tokens
- Win One → 5 tokens

**Weekly Challenges:**
- Prediction Master (20 predictions) → 50 tokens
- 7-Day Streak → 100 tokens
- Social Butterfly (5 challenges) → 25 tokens

**Milestones:** 3, 5, 7, 14, 30, 60 day streaks with escalating rewards

### AI Features

**Research Lab:**
- Free-form search queries about football
- Proxied through Firebase Cloud Function to Perplexity AI (sonar model)
- System prompt constrains to football/soccer, under 400 words
- Returns markdown with up to 4 source citations
- Search recency filter: last month

**Pokin' Pete Chatbot:**
- Personality: witty sports commentator, enthusiastic, school-appropriate
- Powered by Google Gemini 2.0 Flash
- Supports multi-turn conversation
- Starter prompts for new users
- Temperature: 0.9 for creative responses

---

## API Reference

### Cloud Function Endpoints

All endpoints are CORS-enabled and deployed to `us-central1`.

#### `POST /research`
```json
// Request
{ "query": "Mbappe World Cup stats" }

// Response
{
  "content": "## Kylian Mbappe...",
  "citations": ["https://fifa.com", "https://espn.com"]
}
```

#### `POST /chat`
```json
// Request
{
  "messages": [
    { "role": "user", "content": "Who wins the World Cup?" }
  ]
}

// Response
{ "content": "OH you want the REAL prediction?..." }
```

#### `GET /matchesToday`
```json
// Response
{
  "matches": [
    {
      "fixtureId": 12345,
      "kickoff": "2026-06-15T18:00:00Z",
      "status": "NS",
      "homeTeam": { "id": 1, "name": "USA", "logo": "..." },
      "awayTeam": { "id": 2, "name": "Mexico", "logo": "..." },
      "score": { "home": null, "away": null }
    }
  ]
}
```

#### `GET /standings`
Returns group stage standings with team records (W/D/L/GF/GA/GD/Pts).

#### `POST /createPrediction`
Requires Bearer auth token. Creates prediction and deducts wager from user balance.

#### `GET /leaderboardGlobal` | `GET /leaderboardSchool?school=...`
Returns top 50 users sorted by token balance.

---

## Configuration

### Firebase Config (`firebase.json`)
- Functions: TypeScript source in `functions/`, pre-deploy build
- Emulators: Auth (9099), Functions (5001), Firestore (8080), UI (4000)

### App Config (`config.ts`)
```typescript
export const CONFIG = {
  apiFootball: {
    baseUrl: "https://v3.football.api-sports.io",
    worldCupLeagueId: 1,
    season: 2026,
  },
  cache: {
    matchesTtlMinutes: 2,      // Live data freshness
    standingsTtlMinutes: 30,    // Standings refresh rate
  },
  tokens: {
    initialBalance: 100,
    minWager: 1,
    maxWager: 20,
    payoutMultipliers: {
      matchWinner: 2.0,
      exactScore: 5.0,
    },
  },
};
```

### Flutter Config (`pubspec.yaml`)
- Package name: `pokin_tokens`
- Min SDK: Dart 3.7.0
- Material Design 3 with dark theme only

---

## Deployment Guide

### Firebase Setup
1. Create project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication (Google, Apple, Email providers)
3. Create Firestore database in production mode
4. Upgrade to Blaze plan (required for Cloud Functions)
5. Set secrets: `API_FOOTBALL_KEY`, `PERPLEXITY_API_KEY`, `GEMINI_API_KEY`

### Deploy Backend
```bash
cd functions && npm run build
firebase deploy --only functions
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### Build iOS
```bash
cd app
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode
# Archive and upload to App Store Connect
```

### Build Android
```bash
cd app
flutter build appbundle --release
# Upload build/app/outputs/bundle/release/app-release.aab to Play Console
```

### Build Web
```bash
cd app
flutter build web --release
# Deploy build/web/ to Firebase Hosting or any static host
firebase deploy --only hosting
```

---

## Development Workflow

### Demo Mode
Set `useDemoData = true` in `app/lib/core/data/demo_data.dart` to work without Firebase credentials. All screens function with hardcoded data.

### Adding a New Feature
1. Create feature directory: `features/my_feature/`
2. Add domain models in `domain/`
3. Add repository in `data/`
4. Add screen in `presentation/`
5. Add Riverpod providers in `presentation/providers/`
6. Register route in `routing/app_router.dart`
7. Add quick access chip in `home_screen.dart` if needed

### Adding a New Cloud Function
1. Create endpoint in `functions/src/endpoints/`
2. Export from `functions/src/index.ts`
3. Add any new secrets via `firebase functions:secrets:set`
4. Deploy: `firebase deploy --only functions`

### Code Style
- Dart: `flutter_lints` rules
- TypeScript: ESLint with `@typescript-eslint`
- Font: Poppins throughout
- Widget naming: PascalCase screens, _PrivateWidgets for internal components
