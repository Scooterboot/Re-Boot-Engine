//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 texelSize;

void main()
{
    vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(texelSize.x,0) );
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(-texelSize.x,0) );
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(0,texelSize.y) );
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(0,-texelSize.y) );
	
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(texelSize.x,texelSize.y) );
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(-texelSize.x,texelSize.y) );
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(texelSize.x,-texelSize.y) );
	col += texture2D( gm_BaseTexture, v_vTexcoord+vec2(-texelSize.x,-texelSize.y) );
	
	col /= 9.0;
	
	gl_FragColor = col * v_vColour;
}
