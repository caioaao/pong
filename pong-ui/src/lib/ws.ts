import { matchState } from "./match-state-store";
import { matchSchema } from './wire-schema';

export function connectToBackend(url: string): WebSocket {
	const socket = new WebSocket(url);
	let heartbeatTicker: number;

	socket.addEventListener(
		'open', function() {
			heartbeatTicker = window.setInterval(() => socket.send(""), 3000);
			console.log('opened')
		}
	);
	socket.addEventListener(
		'close', function() {
			clearInterval(heartbeatTicker);
			console.log('closed')
		}
	);

	socket.addEventListener('message', function(event) {
		try {
			matchState.set(matchSchema.parse(JSON.parse(event.data)));
		} catch (err) {
			console.error({ rawMessage: event.data })
			throw (err)
		}
	})

	return socket;
}
