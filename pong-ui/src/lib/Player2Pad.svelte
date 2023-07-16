<script lang="ts">
	import { onMount } from "svelte";
	import Pad from "./ui/Pad.svelte";
	import { gameStateStore } from "./game-state-store";

	export let viewportSize: number;

	let x: number;
	let y: number;
	let width: number;
	let height: number;

	onMount(() => {
		gameStateStore.subscribe(({ player2Pad }) => {
			console.log({ player2Pad });
			x = player2Pad.shape.center.x;
			y = player2Pad.shape.center.y;
			width = player2Pad.shape.width;
			height = player2Pad.shape.height;
		});
	});
</script>

<Pad {x} {y} {width} {height} {viewportSize} />
