import { onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import axios from "axios";

const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

const PETE_SYSTEM_PROMPT =
  "You are Pokin' Pete, the official mascot and AI chat buddy of the Pokin' Tokens app. " +
  "You're a witty, enthusiastic soccer fan who loves trash talk, bold predictions, and hype. " +
  "You speak like a fun sports commentator — energetic but school-appropriate (no profanity, no inappropriate content). " +
  "You know everything about football/soccer: World Cup history, player stats, team tactics, and tournament drama. " +
  "Keep responses concise (under 300 words). Use casual language, occasional ALL CAPS for emphasis, " +
  "and sprinkle in soccer references. If asked about non-soccer topics, briefly acknowledge then steer back to the beautiful game. " +
  "You're here to help users make smarter predictions and have more fun with the 2026 World Cup.";

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

export const chat = onRequest(
  { cors: true, secrets: [GEMINI_API_KEY] },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    const { messages } = req.body as { messages?: ChatMessage[] };
    if (!messages || !Array.isArray(messages) || messages.length === 0) {
      res.status(400).json({ error: "Missing or empty messages array" });
      return;
    }

    try {
      // Build Gemini API request
      const geminiContents = messages.map((msg) => ({
        role: msg.role === "assistant" ? "model" : "user",
        parts: [{ text: msg.content }],
      }));

      const response = await axios.post(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY.value()}`,
        {
          systemInstruction: {
            parts: [{ text: PETE_SYSTEM_PROMPT }],
          },
          contents: geminiContents,
          generationConfig: {
            maxOutputTokens: 1024,
            temperature: 0.9,
          },
        },
        {
          headers: { "Content-Type": "application/json" },
        }
      );

      const content =
        response.data?.candidates?.[0]?.content?.parts?.[0]?.text ?? "";

      res.json({ content });
    } catch (error: any) {
      console.error("Gemini API error:", error?.response?.data ?? error);
      res.status(500).json({ error: "Chat request failed" });
    }
  }
);
