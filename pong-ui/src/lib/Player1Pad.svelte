<script lang="ts">
	import { onMount } from "svelte";
	import Pad from "./ui/Pad.svelte";
	import { gameStateStore } from "./game-state-store";

	export let viewportSize: number;

	let x: number;
	let y: number;

	onMount(() => {
		gameStateStore.subscribe(({ player1Pad }) => {
			console.log({ player1Pad });
			x = player1Pad.pos.x;
			y = player1Pad.pos.y;
		});
	});
</script>

<Pad {x} {y} {viewportSize} />
