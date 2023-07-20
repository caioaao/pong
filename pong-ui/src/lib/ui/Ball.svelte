<script lang="ts">
	import { scale } from '../utils';

	export let center: { x: number; y: number }, radius: number;
	export let viewportSize: number;

	$: scaledRadius = scale(viewportSize, radius);
	$: left = scale(viewportSize, center.x) - scaledRadius;
	$: bottom = scale(viewportSize, center.y) - scaledRadius;
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
