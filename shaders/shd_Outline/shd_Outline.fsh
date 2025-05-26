//
// Simple passthrough fragment shader
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float outlineH;
uniform float outlineW;
uniform vec4 outlineColor; 

void main()
{
	vec2 offsetx;
	offsetx.x = outlineW;
	vec2 offsety;
	offsety.y = outlineH;
  
	float alpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;
	vec4 newColor = texture2D( gm_BaseTexture, v_vTexcoord );
  
	/*if ( alpha < 1.0 ) { newColor = outlineColor; } 

	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offsetx).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offsetx).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offsety).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offsety).a);*/
	if (texture2D( gm_BaseTexture, v_vTexcoord + offsetx).a < 1.0 ||
		texture2D( gm_BaseTexture, v_vTexcoord - offsetx).a < 1.0 ||
		texture2D( gm_BaseTexture, v_vTexcoord + offsety).a < 1.0 ||
		texture2D( gm_BaseTexture, v_vTexcoord - offsety).a < 1.0)
	{
		newColor = outlineColor;
	}
    
  
	gl_FragColor = newColor;
	gl_FragColor.a = alpha;
}