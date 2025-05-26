//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
const mat3 rgb2yiq = mat3(0.299, 0.587, 0.114, 0.595716, -0.274453, -0.321263, 0.211456, -0.522591, 0.311135);
const mat3 yiq2rgb = mat3(1.0, 0.9563, 0.6210, 1.0, -0.2721, -0.6474, 1.0, -1.1070, 1.7046);
//uniform float hue;
const float hue = 180.0;
const float _pi = 3.14159265359;

void main()
{
	vec4 originC = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
	
	// --- hue shift code by SLStonedPanda on reddit ---
	// https://www.reddit.com/r/gamemaker/comments/5c3nh9/i_made_ported_a_hue_shift_shader_to_gamemaker/
	vec3 yColor = rgb2yiq * texture2D(gm_BaseTexture, v_vTexcoord).rgb;
	
	//float originalHue = atan(yColor.b, yColor.g);
	//float finalHue = originalHue + hue;
	float finalHue = (-hue/360.0) * (_pi*2.0);
	
	float chroma = sqrt(yColor.b*yColor.b+yColor.g*yColor.g);
    
	vec3 yFinalColor = vec3(yColor.r, chroma * cos(finalHue), chroma * sin(finalHue));
	//gl_FragColor    = vec4(yiq2rgb*yFinalColor, originC.a);
	// ---  ---
	
	yFinalColor *= yiq2rgb;
	float cR = clamp(yFinalColor.r*0.2, 0.0, 1.0);
	float cG = clamp(yFinalColor.g + 0.3, 0.0, 1.0);
	float cB = clamp(yFinalColor.b + 0.66, 0.0, 1.0);
	
	float cA = originC.a;

	vec4 newColor = vec4(cR,cG,cB,cA);
	gl_FragColor = newColor;
}
