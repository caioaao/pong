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

<main>
	<header>
		<h1>Pong</h1>
		<div class="score">0 - 0</div>
	</header>
	<GameScene>
		<Player1Pad viewportSize={600} />
		<Player2Pad viewportSize={600} />
		<Ball viewportSize={600} />
	</GameScene>
</main>

<svelte:window on:keydown={onKeyDown} />

<style>
	header {
		position: relative;
		width: 100%;
		display: flex;
		align-items: baseline;
	}

	header h1 {
		text-align: left;
		text-transform: uppercase;
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, "URW Gothic",
			source-sans-pro, sans-serif;
		flex: 1;
		margin: 0;
		font-size: 3.2em;
	}

	header .score {
		flex: 1;
		text-align: right;
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, "URW Gothic",
			source-sans-pro, sans-serif;
		font-size: 3.2em;
	}
</style>
