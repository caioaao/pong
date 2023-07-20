<script lang="ts">
	import { onMount } from 'svelte';
	import pauseIconURL from '../assets/pause-icon.svg';
	import { gameStateStore } from './game-state-store';

	let isPaused: boolean;
	onMount(() => {
		gameStateStore.subscribe((state) => (isPaused = state.isPaused));
	});
</script>

{#if isPaused}
	<img src={pauseIconURL} alt="paused" />
{/if}

<style>
	img {
		width: 64px;
		height: 64px;
		position: absolute;
		top: 10px;
		right: 10px;
	}
</style>
