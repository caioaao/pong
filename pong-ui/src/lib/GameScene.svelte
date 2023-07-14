<script lang="ts">
	export let ballPos = { x: 50, y: 50 };
	export let padPos = { x: 50, y: 10 };

	const viewportWidth = 600;
	const viewportHeight = 600;

	const absPadWidth = 20;
	const absPadHeight = 2;
	const absBallRadius = 5;

	function scaleX(x: number): number {
		return (x * viewportWidth) / 100;
	}

	function scaleY(Y: number): number {
		return (Y * viewportHeight) / 100;
	}

	$: padWidth = scaleX(absPadWidth);
	$: padHeight = scaleX(absPadHeight);
	$: padLeft = scaleX(padPos.x) - padWidth / 2;
	$: padBottom = scaleY(padPos.y) - padHeight;

	$: ballRadius = scaleX(absBallRadius);
	$: ballLeft = scaleX(ballPos.x) - ballRadius;
	$: ballBottom = scaleX(ballPos.y) - ballRadius;
</script>

<main style="width:{viewportWidth}px; height:{viewportHeight}px">
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
