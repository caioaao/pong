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
	ball: { geometry: Circle, velocity: { x: number, y: number } }
	player1Pad: { geometry: Rectangle }
	player2Pad: { geometry: Rectangle }
	isPaused: boolean;
	score: { player1: number, player2: number }
}

export const gameStateStore = writable<GameState>({
	ball: { geometry: { center: { x: 50, y: 50 }, radius: 5 }, velocity: { x: 0, y: 0 } },
	player1Pad: { geometry: { center: { x: 50, y: 20 }, width: 10, height: 2 } },
	player2Pad: { geometry: { center: { x: 50, y: 90 }, width: 10, height: 2 } },
	isPaused: true,
	score: { player1: 0, player2: 0 },
});


