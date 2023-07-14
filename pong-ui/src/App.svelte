<script lang="ts">
	import GameScene from "./lib/GameScene.svelte";

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

<GameScene padPos={{ x: padPosX, y: 10 }} />

<svelte:window on:keydown|preventDefault={onKeyDown} />
