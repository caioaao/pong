<script lang="ts">
	export let data: { matchID: string; player1: string; player2: string };
</script>

<main>
	<h1>PONG</h1>

	<p class="match-id">
		Match ID:<em>{data.matchID}</em>
	</p>

	<nav>
		<ul>
			<li>
				<a href="/pvp/match/{data.matchID}?username={data.player1}">Join as {data.player1}</a>
			</li>
			<li>
				<a href="/pvp/match/{data.matchID}?username={data.player2}">Join as {data.player2}</a>
			</li>
		</ul>
	</nav>
</main>

<style>
	.match-id {
		text-align: right;
	}
</style>
