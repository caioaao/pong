<script lang="ts">
	import { onMount } from "svelte";
	import Ball from "./ui/Ball.svelte";
	import { gameStateStore } from "./game-state-store";

	export let viewportSize: number;
	let x: number, y: number, radius: number;

	onMount(() => {
		gameStateStore.subscribe(({ ball }) => {
			console.log({ ball });
			x = ball.shape.center.x;
			y = ball.shape.center.y;
			radius = ball.shape.radius;
		});
	});
</script>

<Ball {x} {y} {radius} {viewportSize} />
