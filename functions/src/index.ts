import * as admin from "firebase-admin";

admin.initializeApp();

// HTTP endpoints
export { matchesToday } from "./endpoints/matches";
export { standings } from "./endpoints/standings";
export { createPrediction } from "./endpoints/predictions";
export { leaderboardGlobal, leaderboardSchool } from "./endpoints/leaderboard";
export { research } from "./endpoints/research";
export { chat } from "./endpoints/chat";

// Auth triggers
export { onUserCreated } from "./triggers/on-user-create";

// Scheduled triggers
export { resolveMatchPredictions } from "./triggers/on-match-complete";
