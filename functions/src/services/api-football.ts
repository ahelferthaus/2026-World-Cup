import axios from "axios";
import { CONFIG, API_FOOTBALL_KEY } from "../config";
import { FixtureResponse, StandingsResponse } from "../types/api-football";

export async function fetchTodayFixtures(date: string): Promise<FixtureResponse[]> {
  const response = await axios.get(`${CONFIG.apiFootball.baseUrl}/fixtures`, {
    headers: {
      "x-apisports-key": API_FOOTBALL_KEY.value(),
    },
    params: {
      league: CONFIG.apiFootball.worldCupLeagueId,
      season: CONFIG.apiFootball.season,
      date: date,
    },
  });
  return response.data.response;
}

export async function fetchStandings(): Promise<StandingsResponse[]> {
  const response = await axios.get(`${CONFIG.apiFootball.baseUrl}/standings`, {
    headers: {
      "x-apisports-key": API_FOOTBALL_KEY.value(),
    },
    params: {
      league: CONFIG.apiFootball.worldCupLeagueId,
      season: CONFIG.apiFootball.season,
    },
  });
  return response.data.response;
}

export async function fetchFixtureById(fixtureId: number): Promise<FixtureResponse> {
  const response = await axios.get(`${CONFIG.apiFootball.baseUrl}/fixtures`, {
    headers: {
      "x-apisports-key": API_FOOTBALL_KEY.value(),
    },
    params: { id: fixtureId },
  });
  return response.data.response[0];
}
