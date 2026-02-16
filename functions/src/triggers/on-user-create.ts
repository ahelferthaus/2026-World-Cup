import { beforeUserCreated } from "firebase-functions/v2/identity";
import * as admin from "firebase-admin";
import { CONFIG } from "../config";

const db = admin.firestore();

export const onUserCreated = beforeUserCreated(async (event) => {
  const user = event.data;
  if (!user) return;

  const uid = user.uid;
  const displayName = user.displayName || user.email?.split("@")[0] || "Player";

  await db.collection("users").doc(uid).set({
    displayName: displayName,
    school: "Centaurus High School",
    tokens: CONFIG.tokens.initialBalance,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
});
