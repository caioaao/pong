<script lang="ts">
	let matchID: string;
</script>

<main>
	<h1>PONG</h1>
	<label for="match-id">Match ID</label>
	<input type="text" id="match-id" bind:value={matchID} />
	<a class="join-button" href={matchID ? `/pvp/join-match/${matchID}` : ''}> Join </a>
</main>

<style>
	main {
		width: 600px;
		display: flex;
		flex-direction: column;
	}
	h1 {
		margin-bottom: 20px;
	}

	label {
		text-align: left;
		font-size: 1.5rem;
	}

	input {
		line-height: 3rem;
		font-size: 1.5rem;
		font-size: 2rem;
		margin-bottom: 20px;
		width: 100%;
		padding: 0;
	}

	.join-button {
		text-align: center;
		font-size: 2rem;
		margin-top: 20px;
		display: block;
		padding: 1rem 0;
		width: 100%;
		background-color: #eeeeee;
		color: #333;
		text-transform: uppercase;
	}
</style>
