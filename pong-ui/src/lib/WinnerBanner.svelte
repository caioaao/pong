<script lang="ts">
	import { gameState } from './game-state-store';
	import Overlay from './ui/Overlay.svelte';

	let winnerID: 1 | 2;
	$: {
		if ($gameState.finished) {
			if ($gameState.score.player1 > $gameState.score.player2) {
				winnerID = 1;
			} else {
				winnerID = 2;
			}
		}
	}
</script>

{#if winnerID}
	<Overlay>
		Player {winnerID} wins!
	</Overlay>
{/if}
