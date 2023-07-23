<script lang="ts">
	import { matchState } from './match-state-store';
	import Overlay from './ui/Overlay.svelte';
</script>

{#if $matchState.state === 'finished'}
	<Overlay>
		Player {$matchState.winner === 'player1' ? 1 : 2} wins!
	</Overlay>
{/if}
