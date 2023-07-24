import type { PageLoad } from "./$types"

export const load: PageLoad = ({ url, params }: { url: { searchParams: URLSearchParams }, params: { match_id: string } }) => {
	return {
		matchID: params.match_id,
		playerUsername: url.searchParams.get("username"),
	}
}

