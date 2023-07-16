import { writable } from 'svelte/store'

export interface GameState {
	ball: { pos: { x: number, y: number }, velocity: { x: number, y: number } }
	player1Pad: { pos: { x: number, y: number } }
	player2Pad: { pos: { x: number, y: number } }
	isPaused: boolean;
	score: { player1: number, player2: number }
}

export const gameStateStore = writable<GameState>({
	ball: { pos: { x: 50, y: 50 }, velocity: { x: 0, y: 0 } },
	player1Pad: { pos: { x: 50, y: 20 } },
	player2Pad: { pos: { x: 50, y: 90 } },
	isPaused: true,
	score: { player1: 0, player2: 0 },
});


