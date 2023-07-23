import { derived, writable } from "svelte/store";
import type { Match } from "./wire-schema";

export const matchState = writable<Match>();

export const score = derived(matchState, $state => {
	if (!$state) return
	switch ($state.state) {
		case "in_progress":
			return $state.score;
		case "paused":
			return $state.prev_state.score;
		case "finished":
			return $state.final_score;
		default:
			return;
	}
})

