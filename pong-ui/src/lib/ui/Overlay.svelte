<div class="overlay">
	<span>
		<slot />
	</span>
</div>

<style>
	.overlay {
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.8);
		position: relative;
		z-index: 1;
	}
	.overlay span {
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		color: white;
		text-transform: uppercase;
		font-weight: 900;
		font-family: Avenir, Montserrat, Corbel, "URW Gothic",
			source-sans-pro, sans-serif;
		font-size: 3.2em;
		vertical-align: baseline;
		text-align: center;
	}
</style>
