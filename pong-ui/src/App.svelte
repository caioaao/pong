<script lang="ts">
	import { onMount } from "svelte";
	import SinglePlayer from "./routes/SinglePlayer.svelte";
	import Home from "./routes/Home.svelte";
	import { subscribeToRoute } from "./lib/routing-store";
	let pathname: string;

	onMount(() => {
		subscribeToRoute((route) => (pathname = route));
	});
</script>

{#if pathname === "/"}
	<Home />
{:else if pathname === "/single-player"}
	<SinglePlayer />
{/if}

<style>
</style>
