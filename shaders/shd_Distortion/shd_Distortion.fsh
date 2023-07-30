
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D distortion_texture_page; // the name of the surface in the shader	

void main()
{
	// find the offset colour for this location (this is where the magic happens) 
	vec2 distort_amount = vec2( (v_vColour * texture2D( distortion_texture_page, v_vTexcoord)).xy);

	// FOR NORMAL MAPS:  (	either directX or OpenGL flip the green channel, 
	//			while you dont need to worry about it in GM more 
	//			normal maps have green pointing the wrong way)
	distort_amount.x = 1.0 - distort_amount.x;

	distort_amount -= 0.5;//128.0;
	if (distort_amount.x > 0.5) {distort_amount.x -= 1.0;}// wrap around
	if (distort_amount.y > 0.5) {distort_amount.y -= 1.0;}// wrap around
	distort_amount /= 4.0;

	gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord+distort_amount);
}