<script lang="ts">
	import { onMount } from 'svelte';
	import Overlay from '$lib/ui/Overlay.svelte';
	import Ball from '$lib/ui/Ball.svelte';
	import Pad from '$lib/ui/Pad.svelte';
	import WinnerBanner from '$lib/WinnerBanner.svelte';
	import GameScene from '$lib/GameScene.svelte';
	import { connectToBackend } from '$lib/ws';
	import pauseIconURL from '$lib/assets/pause-icon.svg';
	import { matchState, score } from './match-state-store';

	export let websocketURL = 'ws://localhost:4000/ws/dummy';

	let socket: WebSocket;

	$: isPaused = $matchState?.state === 'paused';

	onMount(() => {
		const openingSocket = connectToBackend(websocketURL);
		openingSocket.addEventListener('open', () => {
			socket = openingSocket;
		});

		return () => socket?.close();
	});

	function onKeyDown(e: KeyboardEvent) {
		switch (e.code) {
			case 'ArrowLeft':
			case 'a':
				e.preventDefault();
				socket.send('move_left');
				break;
			case 'ArrowRight':
			case 'd':
				e.preventDefault();
				socket.send('move_right');
				break;
			case 'Space':
				e.preventDefault();
				if (isPaused) {
					socket.send('unpause');
				} else {
					socket.send('pause');
				}
				break;
		}
	}
</script>

<nav>
	<a href="/">Go Back</a>
</nav>
<main>
	<header>
		<h1>Pong</h1>
		<div class="score">
			{#if $score}
				{$score.player1} - {$score.player2}
			{/if}
		</div>
	</header>
	<GameScene>
		{#if $matchState}
			{#if $matchState.state === 'created'}
				<Overlay>Waiting on the other player</Overlay>
			{:else if $matchState.state === 'starting'}
				<Overlay>Game starts in {Math.round($matchState.millis_left_until_start / 1000)}...</Overlay
				>
			{:else if $matchState.state === 'canceled'}
				<Overlay>This game was canceled :(</Overlay>
			{/if}

			{#if isPaused}
				<img class="pause-icon" src={pauseIconURL} alt="paused" />
			{/if}

			<WinnerBanner />
			{#if $matchState.state === 'in_progress'}
				<Pad viewportSize={600} {...$matchState.player1_pad.geometry} />
				<Pad viewportSize={600} {...$matchState.player2_pad.geometry} />
				<Ball viewportSize={600} {...$matchState.ball.geometry} />
			{/if}
			{#if $matchState.state === 'paused'}
				<Pad viewportSize={600} {...$matchState.prev_state.player1_pad.geometry} />
				<Pad viewportSize={600} {...$matchState.prev_state.player2_pad.geometry} />
				<Ball viewportSize={600} {...$matchState.prev_state.ball.geometry} />
			{/if}
		{/if}
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
		flex: 1;
	}

	header .score {
		flex: 1;
		text-align: right;
		font-weight: 900;
		font-size: 3.2em;
	}

	nav {
		float: right;
		margin: 0;
	}

	.pause-icon {
		width: 64px;
		height: 64px;
		position: absolute;
		top: 10px;
		right: 10px;
	}
</style>
