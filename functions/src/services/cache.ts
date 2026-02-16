import * as admin from "firebase-admin";

const db = admin.firestore();

export async function getCachedMatches(date: string, ttlMinutes: number): Promise<any | null> {
  const ref = db.collection("matchesCache").doc(date);
  const doc = await ref.get();

  if (doc.exists) {
    const data = doc.data()!;
    const fetchedAt = data.fetchedAt.toDate();
    const ageMinutes = (Date.now() - fetchedAt.getTime()) / 60000;

    if (ageMinutes < ttlMinutes) {
      return data.payload;
    }
  }
  return null;
}

export async function setCachedMatches(date: string, payload: any): Promise<void> {
  const ref = db.collection("matchesCache").doc(date);
  await ref.set({
    payload: payload,
    fetchedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

export async function getCachedStandings(stage: string, ttlMinutes: number): Promise<any | null> {
  const ref = db.collection("standingsCache").doc(stage);
  const doc = await ref.get();

  if (doc.exists) {
    const data = doc.data()!;
    const fetchedAt = data.fetchedAt.toDate();
    const ageMinutes = (Date.now() - fetchedAt.getTime()) / 60000;

    if (ageMinutes < ttlMinutes) {
      return data.payload;
    }
  }
  return null;
}

export async function setCachedStandings(stage: string, payload: any): Promise<void> {
  const ref = db.collection("standingsCache").doc(stage);
  await ref.set({
    payload: payload,
    fetchedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}
