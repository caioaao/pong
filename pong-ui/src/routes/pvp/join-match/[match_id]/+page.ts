import { getPlayers } from "$lib/api";
import type { PageLoad } from "./$types"

export const load: PageLoad = async ({ params }: { url: { searchParams: URLSearchParams }, params: { match_id: string } }) => {
	const { player1, player2 } = await getPlayers(params.match_id);
	return {
		matchID: params.match_id,
		player1,
		player2,
	}
}


