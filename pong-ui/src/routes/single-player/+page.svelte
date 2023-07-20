<script lang="ts">
	import { onMount } from 'svelte';
	import Ball from '$lib/Ball.svelte';
	import Player1Pad from '$lib/Player1Pad.svelte';
	import Player2Pad from '$lib/Player2Pad.svelte';
	import WinnerBanner from '$lib/WinnerBanner.svelte';
	import GameScene from '$lib/GameScene.svelte';
	import Score from '$lib/Score.svelte';
	import StartCountdown from '$lib/StartCountdown.svelte';
	import { connectToBackend } from '$lib/ws';
	import { gameStateStore } from '$lib/game-state-store';
	import PauseIcon from '$lib/PauseIcon.svelte';

	let socket: WebSocket;

	$: isPaused = $gameStateStore.isPaused;

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
			<Score />
		</div>
	</header>
	<GameScene>
		<StartCountdown />
		<PauseIcon />
		<WinnerBanner />
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
		font-family: Avenir, Montserrat, Corbel, 'URW Gothic', source-sans-pro, sans-serif;
		flex: 1;
		margin: 0;
		font-size: 3.2em;
	}

	header .score {
		flex: 1;
		text-align: right;
	}

	nav {
		float: right;
		margin: 0;
	}
</style>
