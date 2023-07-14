<script lang="ts">
	export let viewportWidth = 600;
	export let viewportHeight = 600;

	// measured in percent (from 0 to 100)
	export let playerBarPosition = 0;

	$: padWidth = viewportWidth / 4.5;
	$: padHeight = viewportHeight / 30;
	$: padRailWidth = viewportWidth * 0.9;
	$: barPosX = (playerBarPosition * (padRailWidth - padWidth)) / 100;
	$: padRailHMargin = (viewportWidth - padRailWidth) / 2;
</script>

<main style="width:{viewportWidth}px; height:{viewportHeight}px">
	<div
		class="pad-rail"
		style="height: {padHeight}px; 
		width: {padRailWidth}px;
		margin-left: {padRailHMargin}px;
		margin-right: {padRailHMargin}px;
		bottom: {padHeight * 2}px"
	>
		<div
			class="pad"
			style="left: {barPosX}px; width: {padWidth}px; height: {padHeight}px"
		/>
	</div>
</main>

<style>
	main {
		position: relative;
		background-color: black;
	}

	.pad-rail {
		position: absolute;
	}

	.pad {
		position: absolute;
		background-color: white;
	}
</style>
