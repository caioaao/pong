<script lang="ts">
	import Game from '$lib/Game.svelte';

	export let data: { matchID: string; playerUsername: string };
</script>

<Game websocketURL="ws://localhost:4000/ws?player={data.playerUsername}&match={data.matchID}" />
