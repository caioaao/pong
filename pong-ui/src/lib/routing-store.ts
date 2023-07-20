import { writable } from 'svelte/store'

const routingStore = writable(window.location.pathname);

export function navigateTo(path: string) {
	routingStore.set(path);
}

export const subscribeToRoute = routingStore.subscribe;
