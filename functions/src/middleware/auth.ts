import * as admin from "firebase-admin";

export async function verifyAuth(req: {headers: {authorization?: string}}): Promise<string> {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    throw new Error("UNAUTHENTICATED");
  }

  const token = authHeader.split("Bearer ")[1];
  const decoded = await admin.auth().verifyIdToken(token);
  return decoded.uid;
}

export function sendUnauthorized(res: {status: (code: number) => {json: (body: any) => void}}): void {
  res.status(401).json({ error: "Unauthorized: missing or invalid auth token" });
}
