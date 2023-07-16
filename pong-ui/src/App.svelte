<script lang="ts">
	import { onMount } from "svelte";
	import Ball from "./lib/Ball.svelte";
	import GameScene from "./lib/GameScene.svelte";
	import Pad from "./lib/Pad.svelte";
	import { connectToBackend } from "./lib/ws";

	onMount(() => {
		const socket = connectToBackend("ws://localhost:4000/ws/dummy");
		return () => socket.close();
	});

	let padPosX = 50;
	const padThickness = 2;

	function onKeyDown(e: KeyboardEvent) {
		switch (e.code) {
			case "ArrowLeft":
			case "a":
				e.preventDefault();
				padPosX = Math.max(10, padPosX - 5);
				break;
			case "ArrowRight":
			case "d":
				e.preventDefault();
				padPosX = Math.min(90, padPosX + 5);
				break;
		}
	}
</script>

<GameScene>
	<Pad height={padThickness} x={padPosX} y={10} viewportSize={600} />
	<Pad
		height={padThickness}
		x={50}
		y={90 + padThickness}
		viewportSize={600}
	/>
	<Ball x={50} y={50} viewportSize={600} />
</GameScene>

<svelte:window on:keydown={onKeyDown} />
