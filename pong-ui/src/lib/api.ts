import { PUBLIC_BACKEND_URL } from "$env/static/public";

// TODO add zod schemas to validate responses

export async function createMatch(player1: string, player2: string) {
	const res = await fetch(`${PUBLIC_BACKEND_URL}/matches`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ player1, player2 })
	});
	const { match_id } = await res.json();
	return { matchID: match_id }
}

export async function getPlayers(matchID: string) {
	const res = await fetch(`${PUBLIC_BACKEND_URL}/matches/${matchID}/players`);
	return await res.json() as { player1: string, player2: string };
}
