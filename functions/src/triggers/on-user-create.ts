import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { CONFIG } from "../config";

const db = admin.firestore();

// Called once after user signs up to initialize their profile document.
// Client calls this after first authentication.
export const onUserCreated = onCall(async (request) => {
  const auth = request.auth;
  if (!auth) {
    throw new HttpsError("unauthenticated", "Must be signed in.");
  }

  const uid = auth.uid;
  const userRef = db.collection("users").doc(uid);
  const existing = await userRef.get();

  // Only create if the doc doesn't already exist (idempotent)
  if (!existing.exists) {
    await userRef.set({
      displayName: auth.token.name || auth.token.email?.split("@")[0] || "Player",
      school: "Centaurus High School",
      tokens: CONFIG.tokens.initialBalance,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  return { success: true };
});
