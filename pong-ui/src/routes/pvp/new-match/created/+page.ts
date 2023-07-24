import type { PageLoad } from "./$types"

export const load: PageLoad = ({ url }: { url: { searchParams: URLSearchParams } }) => {
	return {
		matchID: url.searchParams.get("match_id"),
		player1: url.searchParams.get("player1"),
		player2: url.searchParams.get("player2"),
	}
}
