# Development Notes

## API Key Setup

### API-Football
1. Sign up at https://www.api-football.com/ (or via RapidAPI)
2. Get your API key from the dashboard
3. Set it as a Firebase secret:
   ```
   npx firebase-tools functions:secrets:set API_FOOTBALL_KEY
   ```
4. The key is used in Cloud Functions only (never in app code)

### Firebase Setup
1. Create project at https://console.firebase.google.com/
2. Enable Authentication providers: Email/Password, Google, Apple
3. Create Firestore database in production mode
4. Run `flutterfire configure` in the app/ directory

## Payout Multipliers
- Correct winner prediction: 2x wager
- Correct exact score: 5x wager

## Scheduled Functions
- `resolveMatchPredictions`: Runs every 5 minutes, checks for completed matches and resolves pending predictions

## Cache TTLs
- Match data: 2 minutes (refreshes frequently during live matches)
- Standings data: 30 minutes

## Known Limitations (MVP)
- School is read-only (hardcoded to "Centaurus High School")
- No push notifications for match results
- No social features (comments, sharing)
- No admin dashboard
- Prediction resolution depends on scheduled function running
