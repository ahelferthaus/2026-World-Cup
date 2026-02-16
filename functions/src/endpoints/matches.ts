import { onRequest } from "firebase-functions/v2/https";
import { API_FOOTBALL_KEY, CONFIG } from "../config";
import { fetchTodayFixtures } from "../services/api-football";
import { getCachedMatches, setCachedMatches } from "../services/cache";
import { SimplifiedMatch } from "../types/firestore";

export const matchesToday = onRequest(
  { cors: true, secrets: [API_FOOTBALL_KEY] },
  async (req, res) => {
    try {
      const today = new Date().toISOString().split("T")[0];

      let matches = await getCachedMatches(today, CONFIG.cache.matchesTtlMinutes);

      if (!matches) {
        const raw = await fetchTodayFixtures(today);

        matches = raw.map((fixture): SimplifiedMatch => ({
          fixtureId: fixture.fixture.id,
          kickoff: fixture.fixture.date,
          status: fixture.fixture.status.short,
          statusLong: fixture.fixture.status.long,
          elapsed: fixture.fixture.status.elapsed,
          homeTeam: {
            id: fixture.teams.home.id,
            name: fixture.teams.home.name,
            logo: fixture.teams.home.logo,
          },
          awayTeam: {
            id: fixture.teams.away.id,
            name: fixture.teams.away.name,
            logo: fixture.teams.away.logo,
          },
          score: {
            home: fixture.goals.home,
            away: fixture.goals.away,
          },
        }));

        await setCachedMatches(today, matches);
      }

      res.json({ matches });
    } catch (error) {
      console.error("Error fetching matches:", error);
      res.status(500).json({ error: "Failed to fetch matches" });
    }
  }
);
