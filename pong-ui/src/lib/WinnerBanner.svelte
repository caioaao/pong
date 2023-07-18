<script lang="ts">
	import { onMount } from "svelte";
	import { gameStateStore } from "./game-state-store";

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

{#if winnerID }
<div class="overlay" />
<span class="text">Player {winnerID} wins!</span>
{/if}

<style>
	.overlay {
		width: 100%;
		height: 100%;
		background-color: black;
		position: relative;
		z-index: 1;
		opacity: .8;
	}
	.text {
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		color: white;
		text-transform: uppercase;
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, "URW Gothic",
			source-sans-pro, sans-serif;
		font-size: 3.2em;
		z-index: 2;
	}
</style>
