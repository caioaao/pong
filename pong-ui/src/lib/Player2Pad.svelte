<script lang="ts">
	import { onMount } from "svelte";
	import Pad from "./ui/Pad.svelte";
	import { gameStateStore } from "./game-state-store";

	export let viewportSize: number;

	let x: number;
	let y: number;

	onMount(() => {
		gameStateStore.subscribe(({ player2Pad }) => {
			console.log({ player2Pad });
			x = player2Pad.pos.x;
			y = player2Pad.pos.y;
		});
	});
</script>

<Pad {x} {y} {viewportSize} />
