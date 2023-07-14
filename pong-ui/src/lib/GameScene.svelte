<script lang="ts">
	export let ballPos = { x: 50, y: 50 };
	export let padPos = { x: 50, y: 10 };
	export let viewportSize = 600;

	const absPadWidth = 20;
	const absPadHeight = 2;
	const absBallRadius = 5;

	function scale(x: number): number {
		return (x * viewportSize) / 100;
	}

	$: padWidth = scale(absPadWidth);
	$: padHeight = scale(absPadHeight);
	$: padLeft = scale(padPos.x) - padWidth / 2;
	$: padBottom = scale(padPos.y) - padHeight;

	$: ballRadius = scale(absBallRadius);
	$: ballLeft = scale(ballPos.x) - ballRadius;
	$: ballBottom = scale(ballPos.y) - ballRadius;
</script>

<main style="width:{viewportSize}px; height:{viewportSize}px">
	<div
		class="pad"
		style="left: {padLeft}px;
		bottom: {padBottom}px; 
		width: {padWidth}px; 
		height: {padHeight}px;"
	/>
	<div
		class="ball"
		style="width: {ballRadius * 2}px; 
		height: {ballRadius * 2}px;
		left:{ballLeft}px;
		bottom: {ballBottom}px;
		border-radius: {ballRadius}px"
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

	.ball {
		position: absolute;
		background-color: white;
	}
</style>
