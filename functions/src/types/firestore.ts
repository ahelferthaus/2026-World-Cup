import { Timestamp } from "firebase-admin/firestore";

export interface UserDoc {
  displayName: string;
  school: string;
  tokens: number;
  createdAt: Timestamp;
}

export interface PredictionDoc {
  uid: string;
  matchId: string;
  type: "winner" | "exactScore";
  selection: string;
  scoreHome: number | null;
  scoreAway: number | null;
  wager: number;
  status: "pending" | "won" | "lost";
  payout: number;
  createdAt: Timestamp;
}

export interface MatchesCacheDoc {
  payload: any;
  fetchedAt: Timestamp;
}

export interface StandingsCacheDoc {
  payload: any;
  fetchedAt: Timestamp;
}

export interface LeaderboardEntry {
  rank: number;
  uid: string;
  displayName: string;
  school: string;
  tokens: number;
}

export interface SimplifiedMatch {
  fixtureId: number;
  kickoff: string;
  status: string;
  statusLong: string;
  elapsed: number | null;
  homeTeam: {
    id: number;
    name: string;
    logo: string;
  };
  awayTeam: {
    id: number;
    name: string;
    logo: string;
  };
  score: {
    home: number | null;
    away: number | null;
  };
}

export interface GroupStanding {
  name: string;
  teams: GroupTeam[];
}

export interface GroupTeam {
  rank: number;
  team: {
    id: number;
    name: string;
    logo: string;
  };
  points: number;
  played: number;
  won: number;
  drawn: number;
  lost: number;
  goalsFor: number;
  goalsAgainst: number;
  goalDiff: number;
}
