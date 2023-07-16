import { writable } from 'svelte/store'

interface Circle {
	center: { x: number, y: number }
	radius: number
}

interface Rectangle {
	center: { x: number, y: number }
	width: number
	height: number
}

export interface GameState {
	ball: { shape: Circle, velocity: { x: number, y: number } }
	player1Pad: { shape: Rectangle }
	player2Pad: { shape: Rectangle }
	isPaused: boolean;
	score: { player1: number, player2: number }
}

export const gameStateStore = writable<GameState>({
	ball: { shape: { center: { x: 50, y: 50 }, radius: 5 }, velocity: { x: 0, y: 0 } },
	player1Pad: { shape: { center: { x: 50, y: 20 }, width: 10, height: 2 } },
	player2Pad: { shape: { center: { x: 50, y: 90 }, width: 10, height: 2 } },
	isPaused: true,
	score: { player1: 0, player2: 0 },
});


