import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { verifyAuth, sendUnauthorized } from "../middleware/auth";
import { CONFIG } from "../config";

const db = admin.firestore();

export const createPrediction = onRequest(
  { cors: true },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    let uid: string;
    try {
      uid = await verifyAuth(req);
    } catch {
      sendUnauthorized(res);
      return;
    }

    const { matchId, type, selection, wager, scoreHome, scoreAway } = req.body;

    // Validate required fields
    if (!matchId || !type || !selection || wager === undefined) {
      res.status(400).json({ error: "Missing required fields: matchId, type, selection, wager" });
      return;
    }

    // Validate prediction type
    if (type !== "winner" && type !== "exactScore") {
      res.status(400).json({ error: "Invalid prediction type. Must be 'winner' or 'exactScore'" });
      return;
    }

    // Validate selection for winner type
    if (type === "winner" && !["home", "away", "draw"].includes(selection)) {
      res.status(400).json({ error: "Invalid selection. Must be 'home', 'away', or 'draw'" });
      return;
    }

    // Validate exact score fields
    if (type === "exactScore") {
      if (scoreHome === undefined || scoreAway === undefined ||
          !Number.isInteger(scoreHome) || !Number.isInteger(scoreAway) ||
          scoreHome < 0 || scoreAway < 0) {
        res.status(400).json({ error: "Exact score requires valid scoreHome and scoreAway (non-negative integers)" });
        return;
      }
    }

    // Validate wager
    const wagerNum = Number(wager);
    if (!Number.isInteger(wagerNum) || wagerNum < CONFIG.tokens.minWager || wagerNum > CONFIG.tokens.maxWager) {
      res.status(400).json({ error: `Wager must be an integer between ${CONFIG.tokens.minWager} and ${CONFIG.tokens.maxWager}` });
      return;
    }

    const userRef = db.collection("users").doc(uid);
    const predictionRef = db.collection("predictions").doc();

    try {
      // Check for existing prediction on this match (outside transaction)
      const existing = await db.collection("predictions")
        .where("uid", "==", uid)
        .where("matchId", "==", String(matchId))
        .limit(1)
        .get();

      if (!existing.empty) {
        res.status(409).json({ error: "You already made a prediction on this match" });
        return;
      }

      await db.runTransaction(async (transaction) => {
        const userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw new Error("USER_NOT_FOUND");
        }

        const currentTokens = userDoc.data()!.tokens;

        if (currentTokens < wagerNum) {
          throw new Error("INSUFFICIENT_TOKENS");
        }

        // Deduct tokens
        transaction.update(userRef, {
          tokens: admin.firestore.FieldValue.increment(-wagerNum),
        });

        // Create prediction doc
        transaction.set(predictionRef, {
          uid: uid,
          matchId: String(matchId),
          type: type,
          selection: selection,
          scoreHome: type === "exactScore" ? Number(scoreHome) : null,
          scoreAway: type === "exactScore" ? Number(scoreAway) : null,
          wager: wagerNum,
          status: "pending",
          payout: 0,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      res.status(201).json({
        predictionId: predictionRef.id,
        message: "Prediction created successfully",
      });
    } catch (error: any) {
      if (error.message === "INSUFFICIENT_TOKENS") {
        res.status(400).json({ error: "Not enough tokens for this wager" });
      } else if (error.message === "USER_NOT_FOUND") {
        res.status(404).json({ error: "User profile not found" });
      } else {
        console.error("Prediction error:", error);
        res.status(500).json({ error: "Failed to create prediction" });
      }
    }
  }
);
