<script lang="ts">
	import { onMount } from "svelte";
	import { gameStateStore } from "./game-state-store";

	let clazz = "";
	export { clazz as class };
	let player1: number;
	let player2: number;

	onMount(() => {
		gameStateStore.subscribe(({ score }) => {
			player1 = score.player1;
			player2 = score.player2;
		});
	});
</script>

<div class="score {clazz}">{player1} - {player2}</div>

<style>
	.score {
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, "URW Gothic",
			source-sans-pro, sans-serif;
		font-size: 3.2em;
	}
</style>
