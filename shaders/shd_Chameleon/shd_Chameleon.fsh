
// Palette swapper (re)written by me (Scooterboot), based on Loj's Chameleon
// https://github.com/Lojemiru/Chameleon

uniform sampler2D palTexture;
uniform vec2 texelSize;
uniform vec4 palUVs;
uniform float palIndex;
uniform float palIndex2;
uniform float palMix;
uniform int palNum;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

vec4 blackToTransparent(vec4 col)
{
	if(col.r <= 0.0 && col.g <= 0.0 && col.b <= 0.0)
	{
		return vec4(0.0,0.0,0.0,0.0);
	}
	return col;
}

void main()
{
	vec4 inCol = texture2D(gm_BaseTexture, v_vTexcoord);
	
	float width = (palUVs.z - palUVs.x) / float(palNum);
	float height = (palUVs.w - palUVs.y);
	
	vec2 pos = vec2(palUVs.x + inCol.r * width, palUVs.y + inCol.g * height);
	
	if(width <= texelSize.x)
	{
		width = texelSize.x;
		pos.x = palUVs.x;
	}
	
	vec4 outCol1_0 = blackToTransparent(texture2D(palTexture, vec2(pos.x + width * floor(palIndex), pos.y)));
	vec4 outCol1_1 = blackToTransparent(texture2D(palTexture, vec2(pos.x + width * ceil(palIndex), pos.y)));
	vec4 outCol1 = mix(outCol1_0, outCol1_1, fract(palIndex));
	
	vec4 outCol2_0 = blackToTransparent(texture2D(palTexture, vec2(pos.x + width * floor(palIndex2), pos.y)));
	vec4 outCol2_1 = blackToTransparent(texture2D(palTexture, vec2(pos.x + width * ceil(palIndex2), pos.y)));
	vec4 outCol2 = mix(outCol2_0, outCol2_1, fract(palIndex2));
	
	vec4 finalCol = mix(outCol1, outCol2, palMix) * v_vColour;
	finalCol.a *= inCol.a;
	gl_FragColor = finalCol;
}