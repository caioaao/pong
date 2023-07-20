<script lang="ts">
	import { onMount } from "svelte";
	import { gameStateStore } from "./game-state-store";
	import Overlay from "./ui/Overlay.svelte";

	let millisUntilStart: number;
	onMount(() => {
		gameStateStore.subscribe(
			(state) => (millisUntilStart = state.millisUntilStart)
		);
	});
</script>

{#if millisUntilStart}
<Overlay>Game starts in {Math.round(millisUntilStart / 1000)}...</Overlay>
{/if}
