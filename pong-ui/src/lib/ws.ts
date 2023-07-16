import { z } from "zod";
import { gameStateStore } from "./game-state-store";

// Wire schemas used for parsing messages received from the back-end
const vectorSchema = z.object({
	x: z.number(),
	y: z.number(),
});

const pointSchema = z.object({
	x: z.number(),
	y: z.number(),
});

const circleSchema = z.object({ center: pointSchema, radius: z.number() })
const rectangleSchema = z.object({ center: pointSchema, width: z.number(), height: z.number() })

const ballStateSchema = z.object({ shape: circleSchema, velocity: vectorSchema })
const playerPadSchema = z.object({ shape: rectangleSchema })
const scoreSchema = z.object({ player1: z.number(), player2: z.number() })

const wireGameStateSchema = z.object({
	ball: ballStateSchema,
	player1_pad: playerPadSchema,
	player2_pad: playerPadSchema,
	score: scoreSchema,
});

function parseGameStateFromWire(wire: string) {
	const jsonPayload = JSON.parse(wire);

	const parsed = wireGameStateSchema.parse(jsonPayload);

	return {
		ball: parsed.ball,
		player1Pad: parsed.player1_pad,
		player2Pad: parsed.player2_pad,
		score: parsed.score,
		isPaused: true,
	}
}

export function connectToBackend(url: string): WebSocket {
	const socket = new WebSocket(url);

	socket.addEventListener(
		'open', function() {
			console.log('opened')
		}
	);

	socket.addEventListener('message', function(event) {
		gameStateStore.set(parseGameStateFromWire(event.data));
	})

	return socket;
}
