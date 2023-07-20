<script lang="ts">
	import { navigateTo } from "../lib/routing-store";
</script>

<nav>
	<a href="/" on:click|preventDefault={() => navigateTo("/")}>Home</a>
	<a
		href="/single-player"
		on:click|preventDefault={() => navigateTo("/single-player")}
	>
		Single Player
	</a>
</nav>
