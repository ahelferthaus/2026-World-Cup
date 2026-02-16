import { defineSecret } from "firebase-functions/params";

export const API_FOOTBALL_KEY = defineSecret("API_FOOTBALL_KEY");

export const CONFIG = {
  apiFootball: {
    baseUrl: "https://v3.football.api-sports.io",
    host: "v3.football.api-sports.io",
    worldCupLeagueId: 1,
    season: 2026,
  },
  cache: {
    matchesTtlMinutes: 2,
    standingsTtlMinutes: 30,
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
