import { z } from "zod";

const xySchema = z.object({ x: z.number(), y: z.number() })

const circleSchema = z.object({ center: xySchema, radius: z.number() })
const rectangleSchema = z.object({ center: xySchema, width: z.number(), height: z.number() })

const ballSchema = z.object({ geometry: circleSchema, velocity: xySchema })
const playerPadSchema = z.object({ geometry: rectangleSchema })
const scoreSchema = z.object({ player1: z.number(), player2: z.number() })

export const newMatchSchema = z.object({
	state: z.literal("created"),
	millis_left_until_timeout: z.number(),
	players_ready: z.array(z.enum(["player1", "player2"]))
})

export const startingMatchSchema = z.object({
	state: z.literal("starting"),
	millis_left_until_start: z.number(),
})

export const inProgressMatchSchema = z.object({
	state: z.literal("in_progress"),
	ball: ballSchema,
	player1_pad: playerPadSchema,
	player2_pad: playerPadSchema,
	score: scoreSchema,
})

export const pausedMatchSchema = z.object({
	state: z.literal("paused"),
	prev_state: inProgressMatchSchema,
})

export const finishedMatchSchema = z.object({
	state: z.literal("finished"),
	final_score: scoreSchema,
	winner: z.enum(["player1", "player2"])
})

export const canceledMatchSchema = z.object({
	state: z.literal("canceled")
})

export const matchSchema = z.discriminatedUnion("state", [
	newMatchSchema,
	startingMatchSchema,
	inProgressMatchSchema,
	pausedMatchSchema,
	finishedMatchSchema,
	canceledMatchSchema,
])
export type Match = z.infer<typeof matchSchema>
