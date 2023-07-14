<script lang="ts">
	export let viewportSize = 600;
</script>

<main style="width:{viewportSize}px; height:{viewportSize}px">
	<slot />
</main>

<style>
	main {
		position: relative;
		background-color: black;
	}
</style>
