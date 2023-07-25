<script lang="ts">
	import Game from '$lib/Game.svelte';

	export let data: { matchID: string; playerUsername: string };
</script>

<Game websocketPath="/ws/pvp?player={data.playerUsername}&match={data.matchID}" />
