import { onRequest } from "firebase-functions/v2/https";
import { API_FOOTBALL_KEY, CONFIG } from "../config";
import { fetchStandings } from "../services/api-football";
import { getCachedStandings, setCachedStandings } from "../services/cache";
import { GroupStanding } from "../types/firestore";

export const standings = onRequest(
  { cors: true, secrets: [API_FOOTBALL_KEY] },
  async (req, res) => {
    try {
      let data = await getCachedStandings("groups", CONFIG.cache.standingsTtlMinutes);

      if (!data) {
        const raw = await fetchStandings();
        const league = raw[0]?.league;

        if (!league) {
          res.json({ groups: [] });
          return;
        }

        const groups: GroupStanding[] = league.standings.map((group) => ({
          name: group[0]?.group || "Unknown",
          teams: group.map((entry) => ({
            rank: entry.rank,
            team: {
              id: entry.team.id,
              name: entry.team.name,
              logo: entry.team.logo,
            },
            points: entry.points,
            played: entry.all.played,
            won: entry.all.win,
            drawn: entry.all.draw,
            lost: entry.all.lose,
            goalsFor: entry.all.goals.for,
            goalsAgainst: entry.all.goals.against,
            goalDiff: entry.goalsDiff,
          })),
        }));

        data = { groups };
        await setCachedStandings("groups", data);
      }

      res.json(data);
    } catch (error) {
      console.error("Error fetching standings:", error);
      res.status(500).json({ error: "Failed to fetch standings" });
    }
  }
);
