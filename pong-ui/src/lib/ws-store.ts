import { writable } from 'svelte/store'

const messageStore = writable('');

const socket = new WebSocket('ws://localhost:4000/ws/dummy');

socket.addEventListener(
	'open', function() {
		console.log('opened')
	}
);

socket.addEventListener('message', function(event) {
	messageStore.set(event.data);
})

const sendMessage = (message: string) => {
	if (socket.readyState <= 1) {
		socket.send(message);
	}
}

export default {
	subscribe: messageStore.subscribe,
	sendMessage,
}
