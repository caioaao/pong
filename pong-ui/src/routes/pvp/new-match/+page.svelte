<h1>PONG</h1>
<form>
	<label for="player1">Your name</label>
	<input type="text" id="player1" name="player1" />
	<label for="player1">Your friend's name</label>
	<input type="text" id="player2" name="player2" />
	<button type="submit">Start!</button>
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
