import { onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import axios from "axios";

const PERPLEXITY_API_KEY = defineSecret("PERPLEXITY_API_KEY");

export const research = onRequest(
  { cors: true, secrets: [PERPLEXITY_API_KEY] },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    const { query } = req.body;
    if (!query || typeof query !== "string" || query.trim().length === 0) {
      res.status(400).json({ error: "Missing or empty query" });
      return;
    }

    try {
      const response = await axios.post(
        "https://api.perplexity.ai/chat/completions",
        {
          model: "sonar",
          messages: [
            {
              role: "system",
              content:
                "You are a concise football/soccer research assistant for the Pokin' Tokens app. " +
                "Provide factual, stats-driven answers about players, teams, tournaments, and match history. " +
                "Keep responses under 400 words. Use markdown formatting for readability. " +
                "Focus on the 2026 FIFA World Cup when relevant.",
            },
            {
              role: "user",
              content: query.trim(),
            },
          ],
          search_recency_filter: "month",
        },
        {
          headers: {
            Authorization: `Bearer ${PERPLEXITY_API_KEY.value()}`,
            "Content-Type": "application/json",
          },
        }
      );

      const data = response.data;
      const content = data.choices?.[0]?.message?.content ?? "";
      const citations: string[] = data.citations ?? [];

      res.json({ content, citations });
    } catch (error: any) {
      console.error("Perplexity API error:", error?.response?.data ?? error);
      res.status(500).json({ error: "Research query failed" });
    }
  }
);
