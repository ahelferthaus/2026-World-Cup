import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import { fetchTodayFixtures } from "../services/api-football";
import { CONFIG, API_FOOTBALL_KEY } from "../config";

const db = admin.firestore();

const COMPLETED_STATUSES = ["FT", "AET", "PEN"];

export const resolveMatchPredictions = onSchedule(
  {
    schedule: "every 5 minutes",
    secrets: [API_FOOTBALL_KEY],
    timeZone: "America/Denver",
  },
  async () => {
    const today = new Date().toISOString().split("T")[0];

    let fixtures;
    try {
      fixtures = await fetchTodayFixtures(today);
    } catch (error) {
      console.error("Failed to fetch fixtures for resolution:", error);
      return;
    }

    const completedMatches = fixtures.filter(
      (f) => COMPLETED_STATUSES.includes(f.fixture.status.short)
    );

    if (completedMatches.length === 0) {
      console.log("No completed matches to resolve today.");
      return;
    }

    for (const match of completedMatches) {
      const fixtureId = String(match.fixture.id);
      const homeGoals = match.goals.home;
      const awayGoals = match.goals.away;

      if (homeGoals === null || awayGoals === null) {
        console.warn(`Match ${fixtureId} marked complete but goals are null, skipping.`);
        continue;
      }

      // Determine actual outcome
      let actualWinner: string;
      if (homeGoals > awayGoals) actualWinner = "home";
      else if (awayGoals > homeGoals) actualWinner = "away";
      else actualWinner = "draw";

      // Find all pending predictions for this match
      const pendingPredictions = await db.collection("predictions")
        .where("matchId", "==", fixtureId)
        .where("status", "==", "pending")
        .get();

      if (pendingPredictions.empty) {
        continue;
      }

      const batch = db.batch();
      let resolvedCount = 0;

      for (const predDoc of pendingPredictions.docs) {
        const pred = predDoc.data();
        let won = false;
        let payout = 0;

        if (pred.type === "winner") {
          won = pred.selection === actualWinner;
          payout = won ? pred.wager * CONFIG.tokens.payoutMultipliers.matchWinner : 0;
        } else if (pred.type === "exactScore") {
          won = pred.scoreHome === homeGoals && pred.scoreAway === awayGoals;
          payout = won ? pred.wager * CONFIG.tokens.payoutMultipliers.exactScore : 0;
        }

        // Update prediction status and payout
        batch.update(predDoc.ref, {
          status: won ? "won" : "lost",
          payout: payout,
        });

        // Credit tokens if won
        if (won && payout > 0) {
          const userRef = db.collection("users").doc(pred.uid);
          batch.update(userRef, {
            tokens: admin.firestore.FieldValue.increment(payout),
          });
        }

        resolvedCount++;
      }

      await batch.commit();
      console.log(`Resolved ${resolvedCount} predictions for fixture ${fixtureId} (${actualWinner}, ${homeGoals}-${awayGoals})`);
    }
  }
);
