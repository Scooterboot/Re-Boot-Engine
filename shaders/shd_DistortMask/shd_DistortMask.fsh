//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_spread;
uniform float u_width;

void main()
{
    //gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	vec2 center = vec2(0.5, 0.5);
	
	float outer_map = 1.0 - smoothstep(u_spread - u_width, u_spread, length(v_vTexcoord - center));
	float inner_map = smoothstep(u_spread - u_width*2.0, u_spread - u_width, length(v_vTexcoord - center));
	float map = outer_map * inner_map;
	
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	color.a *= map;
	gl_FragColor = color;
}
