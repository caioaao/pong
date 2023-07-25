<script lang="ts">
	import { goto } from '$app/navigation';
	import { createMatch } from '$lib/api';

	let player1: string;
	let player2: string;

	let isSubmitting = false;
	let submissionErr: string;

	async function submitForm() {
		if (isSubmitting) return;
		isSubmitting = true;
		try {
			const { matchID } = await createMatch(player1, player2);
			goto(`/pvp/join-match/${matchID}`);
		} catch {
			submissionErr = 'Something went wrong when creating the match. Try again';
			isSubmitting = false;
		}
	}
</script>

<h1>PONG</h1>
{#if submissionErr}
	<p class="error">
		{submissionErr}
	</p>
{/if}
<form on:submit|preventDefault={submitForm}>
	<label for="player1">Player 1</label>
	<input type="text" id="player1" name="player1" bind:value={player1} />
	<label for="player2">Player 2</label>
	<input type="text" id="player2" name="player2" bind:value={player2} />
	<button type="submit" disabled={isSubmitting || !player1 || !player2 || player1 === player2}>
		Start!
	</button>
</form>

<style>
	form {
		width: 600px;
		display: flex;
		flex-direction: column;
		text-align: left;
		font-size: 1.5rem;
	}

	input {
		line-height: 3rem;
		font-size: 2rem;
		margin-bottom: 20px;
	}

	button {
		font-size: 2rem;
		margin-top: 20px;
	}
</style>
