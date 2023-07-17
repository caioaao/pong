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
		gameStateStore.subscribe(({ player1Pad }) => {
			console.log({ player1Pad });
			x = player1Pad.geometry.center.x;
			y = player1Pad.geometry.center.y;
			width = player1Pad.geometry.width;
			height = player1Pad.geometry.height;
		});
	});
</script>

<Pad {x} {y} {width} {height} {viewportSize} />
