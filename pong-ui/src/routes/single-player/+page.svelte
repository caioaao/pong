<script lang="ts">
	import { onMount } from 'svelte';
	import Overlay from '$lib/ui/Overlay.svelte';
	import Ball from '$lib/ui/Ball.svelte';
	import Pad from '$lib/ui/Pad.svelte';
	import WinnerBanner from '$lib/WinnerBanner.svelte';
	import GameScene from '$lib/GameScene.svelte';
	import { connectToBackend } from '$lib/ws';
	import { gameState } from '$lib/game-state-store';
	import pauseIconURL from '$lib/assets/pause-icon.svg';

	let socket: WebSocket;

	$: isPaused = $gameState.isPaused;

	onMount(() => {
		const openingSocket = connectToBackend('ws://localhost:4000/ws/dummy');
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
			{$gameState.score.player1} - {$gameState.score.player2}
		</div>
	</header>
	<GameScene>
		{#if $gameState.millisUntilStart}
			<Overlay>Game starts in {Math.round($gameState.millisUntilStart / 1000)}...</Overlay>
		{/if}

		{#if isPaused}
			<img class="pause-icon" src={pauseIconURL} alt="paused" />
		{/if}

		<WinnerBanner />
		<Pad viewportSize={600} {...$gameState.player1Pad.geometry} />
		<Pad viewportSize={600} {...$gameState.player2Pad.geometry} />
		<Ball viewportSize={600} {...$gameState.ball.geometry} />
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
		font-family: Avenir, Montserrat, Corbel, 'URW Gothic', source-sans-pro, sans-serif;
		flex: 1;
		margin: 0;
		font-size: 3.2em;
	}

	header .score {
		flex: 1;
		text-align: right;
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, 'URW Gothic', source-sans-pro, sans-serif;
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
