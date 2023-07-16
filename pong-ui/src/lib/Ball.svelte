<script lang="ts">
	import { onMount } from "svelte";
	import Ball from "./ui/Ball.svelte";
	import { gameStateStore } from "./game-state-store";

	export let viewportSize: number;
	let x: number, y: number;

	onMount(() => {
		gameStateStore.subscribe(({ ball }) => {
			console.log({ ball });
			x = ball.pos.x;
			y = ball.pos.y;
		});
	});
</script>

<Ball {x} {y} {viewportSize} />
