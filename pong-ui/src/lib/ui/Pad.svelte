<script lang="ts">
	import { scale } from '../utils';

	export let center: { x: number; y: number };
	export let viewportSize: number;
	export let width: number;
	export let height: number;

	$: scaledWidth = scale(viewportSize, width);
	$: scaledHeight = scale(viewportSize, height);

	$: left = scale(viewportSize, center.x) - scaledWidth / 2;
	$: bottom = scale(viewportSize, center.y) - scaledHeight / 2;
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
