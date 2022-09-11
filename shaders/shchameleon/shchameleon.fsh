//
// Simple passthrough fragment shader - YOU THOUGHT!!
// It's actually a simple color lookup shader.
//

uniform sampler2D in_pal;	// The palette to use.
uniform vec4 in_palData;	// Base UVs - texpage left, top, right, and bottom.
uniform float in_mix;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	// Get input color
	vec4 inCol = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
	
	// Get new rgb with a lookup - we get the x/y of the input visual asset, then add the r/g value multiplied by the width/height of the input visual asset.
	// If you're not familiar with GLSL this looks really weird but I promise it's sane. Mostly.
	vec4 newCol = texture2D(in_pal, vec2(in_palData.x + inCol.r * (in_palData.z - in_palData.x), in_palData.y + inCol.g * (in_palData.w - in_palData.y)));
	
	// Mix old color and new color - do so based on the min of the new color's alpha and the mix value.
	gl_FragColor.rgb = mix(inCol, newCol, min(newCol.a, in_mix)).rgb;
	
	// Maintain original alpha.
	gl_FragColor.a = inCol.a;
}
