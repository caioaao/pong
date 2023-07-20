<script lang="ts">
	import { gameState } from './game-state-store';

	let clazz = '';
	export { clazz as class };
</script>

<div class="score {clazz}">{$gameState.score.player1} - {$gameState.score.player2}</div>

<style>
	.score {
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, 'URW Gothic', source-sans-pro, sans-serif;
		font-size: 3.2em;
	}
</style>
