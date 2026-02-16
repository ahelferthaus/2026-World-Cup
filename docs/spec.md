# 2026 World Cup - Centaurus: Product Specification

## Overview
A cross-platform mobile app MVP for teens at Centaurus High School to make virtual-token predictions on 2026 FIFA World Cup matches.

## Core Features (V1)

### Authentication
- Sign in with Apple + Google + Email via Firebase Auth
- User profile: displayName, school (default "Centaurus High School"), createdAt
- Login required to use the app

### Live Matches + Standings
- Home tab shows today's matches (kickoff time, teams, live score, status)
- Standings screen shows group tables

### Token Predictions
- Each user starts with 100 virtual tokens
- Predict match winner (home/away/draw) or exact score
- Wager 1-20 tokens per prediction
- 2x payout for correct winner, 5x for exact score
- No real money involved

### Leaderboards
- Global leaderboard by token balance
- School leaderboard filtered by school

### Profile
- Token balance display
- Prediction history
- Change display name
- School displayed (read-only for MVP)

## Architecture
- Flutter (cross-platform mobile)
- Firebase Auth + Firestore + Cloud Functions
- Sports data proxied through Cloud Functions
- API keys stored in Cloud Functions secrets only
- All token updates server-side via Firestore transactions

## Sports API
- Primary: API-Football (api-sports.io)
- World Cup league ID: 1, Season: 2026
