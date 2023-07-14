<script lang="ts">
	import Ball from "./lib/Ball.svelte";
	import GameScene from "./lib/GameScene.svelte";
	import Pad from "./lib/Pad.svelte";

	let padPosX = 50;

	function onKeyDown(e: KeyboardEvent) {
		switch (e.code) {
			case "ArrowLeft":
			case "a":
				padPosX = Math.max(10, padPosX - 5);
				break;
			case "ArrowRight":
			case "d":
				padPosX = Math.min(90, padPosX + 5);
				break;
		}
	}
</script>

<GameScene>
	<Pad x={padPosX} y={10} viewportSize={600} />
	<Ball x={50} y={50} viewportSize={600} />
</GameScene>

<svelte:window on:keydown|preventDefault={onKeyDown} />
