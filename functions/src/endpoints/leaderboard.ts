import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { LeaderboardEntry } from "../types/firestore";

const db = admin.firestore();

export const leaderboardGlobal = onRequest(
  { cors: true },
  async (req, res) => {
    try {
      const snapshot = await db.collection("users")
        .orderBy("tokens", "desc")
        .limit(100)
        .get();

      const leaderboard: LeaderboardEntry[] = snapshot.docs.map((doc, index) => ({
        rank: index + 1,
        uid: doc.id,
        displayName: doc.data().displayName,
        school: doc.data().school,
        tokens: doc.data().tokens,
      }));

      res.json({ leaderboard });
    } catch (error) {
      console.error("Global leaderboard error:", error);
      res.status(500).json({ error: "Failed to fetch leaderboard" });
    }
  }
);

export const leaderboardSchool = onRequest(
  { cors: true },
  async (req, res) => {
    try {
      const school = req.query.school as string;
      if (!school) {
        res.status(400).json({ error: "Missing required query parameter: school" });
        return;
      }

      const snapshot = await db.collection("users")
        .where("school", "==", school)
        .orderBy("tokens", "desc")
        .limit(100)
        .get();

      const leaderboard: LeaderboardEntry[] = snapshot.docs.map((doc, index) => ({
        rank: index + 1,
        uid: doc.id,
        displayName: doc.data().displayName,
        school: doc.data().school,
        tokens: doc.data().tokens,
      }));

      res.json({ leaderboard });
    } catch (error) {
      console.error("School leaderboard error:", error);
      res.status(500).json({ error: "Failed to fetch school leaderboard" });
    }
  }
);
