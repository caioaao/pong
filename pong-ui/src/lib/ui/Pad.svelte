<script lang="ts">
	import { scale } from "../utils";

	export let x: number;
	export let y: number;
	export let viewportSize: number;

	export let width = 20;
	export let height = 2;

	$: scaledWidth = scale(viewportSize, width);
	$: scaledHeight = scale(viewportSize, height);

	$: left = scale(viewportSize, x) - scaledWidth / 2;
	$: bottom = scale(viewportSize, y) - scaledHeight;
</script>

<div
	class="pad"
	style="left: {left}px;
		bottom: {bottom}px; 
		width: {scaledWidth}px; 
		height: {scaledHeight}px;"
/>

<style>
	.pad {
		position: absolute;
		background-color: white;
	}
</style>
