<script lang="ts">
	// export let ballPos = { x: 50, y: 50 };
	export let padPos = { x: 50, y: 10 };

	const viewportWidth = 600;
	const viewportHeight = 600;

	const absPadWidth = 20;
	const absPadHeight = 2;

	function scaleX(x: number): number {
		return (x * viewportWidth) / 100;
	}

	function scaleY(Y: number): number {
		return (Y * viewportHeight) / 100;
	}

	$: padWidth = scaleX(absPadWidth);
	$: padHeight = scaleX(absPadHeight);
	$: padLeft = scaleX(padPos.x) - scaleX(absPadWidth) / 2;
	$: padBottom = scaleY(padPos.y - absPadHeight);
</script>

<main style="width:{viewportWidth}px; height:{viewportHeight}px">
	<div
		class="pad"
		style="left: {padLeft}px; bottom: {padBottom}px; width: {padWidth}px; height: {padHeight}px"
	/>
</main>

<style>
	main {
		position: relative;
		background-color: black;
	}

	.pad {
		position: absolute;
		background-color: white;
	}
</style>
