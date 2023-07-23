import { writable } from "svelte/store";
import type { Match } from "./wire-schema";

export const matchState = writable<Match>();
