<script lang="ts">
	import { onMount } from "svelte";
	import Ball from "./lib/Ball.svelte";
	import Player1Pad from "./lib/Player1Pad.svelte";
	import Player2Pad from "./lib/Player2Pad.svelte";
	import GameScene from "./lib/GameScene.svelte";
	import { connectToBackend } from "./lib/ws";

	onMount(() => {
		const socket = connectToBackend("ws://localhost:4000/ws/dummy");
		return () => socket.close();
	});

	let padPosX = 50;

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
	<Player1Pad viewportSize={600} />
	<Player2Pad viewportSize={600} />
	<Ball viewportSize={600} />
</GameScene>

<svelte:window on:keydown={onKeyDown} />
