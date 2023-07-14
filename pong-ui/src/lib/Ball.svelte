<script lang="ts">
	import { scale } from "./utils";

	export let x: number, y: number, viewportSize: number;
	export let radius = 5;

	$: scaledRadius = scale(viewportSize, radius);
	$: left = scale(viewportSize, x) - scaledRadius;
	$: bottom = scale(viewportSize, y) - scaledRadius;
</script>

<div
	class="ball"
	style="width: {scaledRadius * 2}px; 
		height: {scaledRadius * 2}px;
		left:{left}px;
		bottom: {bottom}px;
		border-radius: {scaledRadius}px"
/>

<style>
	.ball {
		position: absolute;
		background-color: white;
	}
</style>
