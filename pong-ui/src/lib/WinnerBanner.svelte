<script lang="ts">
	import { onMount } from "svelte";
	import { gameStateStore } from "./game-state-store";
	import Overlay from "./ui/Overlay.svelte";

	let winnerID: 1 | 2;

	onMount(() => {
		gameStateStore.subscribe(({ score, finished }) => {
			if (finished) {
				if (score.player1 > score.player2) {
					winnerID = 1;
				} else {
					winnerID = 2;
				}
			}
		});
	});
</script>

{#if winnerID}
	<Overlay>
		Player {winnerID} wins!
	</Overlay>
{/if}
