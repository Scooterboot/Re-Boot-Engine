/*
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D palette_texture;
uniform vec2 texel_size;
uniform vec4 palette_UVs;
uniform float palette_index;
uniform float palette_index2;
uniform float palette_dif;

void main()
{
    vec4 source = texture2D( gm_BaseTexture, v_vTexcoord );
    vec4 source2 = texture2D( gm_BaseTexture, v_vTexcoord );
    
    for(float i = palette_UVs.y; i < palette_UVs.w; i+=texel_size.y )
    {
        if (distance(source, texture2D(palette_texture, vec2(palette_UVs.x, i))) <= 0.004)
        {
            float palette_V = palette_UVs.x + texel_size.x * palette_index;
            source = texture2D(palette_texture, vec2(palette_V, i));
            break;
        }
    }
    for(float i = palette_UVs.y; i < palette_UVs.w; i+=texel_size.y )
    {
        if (distance(source2, texture2D(palette_texture, vec2(palette_UVs.x, i))) <= 0.004)
        {
            float palette_V = palette_UVs.x + texel_size.x * palette_index2;
            source2 = texture2D(palette_texture, vec2(palette_V, i));
            break;
        }
    }
    
    gl_FragColor = ((source*(1.0-palette_dif)) + (source2*palette_dif)) * v_vColour;
}
*/

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D palette_texture;
uniform vec2 texel_size;
uniform vec4 palette_UVs;
uniform float palette_index;
uniform float palette_index2;
uniform float palette_dif;

void main()
{
	vec4 source = texture2D(gm_BaseTexture, v_vTexcoord);
	
	vec4 dest1 = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 dest2 = texture2D(gm_BaseTexture, v_vTexcoord);
    
	for(float i = palette_UVs.y; i < palette_UVs.w; i += texel_size.y )
	{
		//if (distance(source, texture2D(palette_texture, vec2(palette_UVs.x, i))) <= 0.004)
		if (texture2D(palette_texture, vec2(palette_UVs.x, i)) == source)
		{
			float palette_V1 = palette_UVs.x + texel_size.x * palette_index;
			float palette_V2 = palette_UVs.x + texel_size.x * palette_index2;
			dest1 = texture2D(palette_texture, vec2(palette_V1, i));
			dest2 = texture2D(palette_texture, vec2(palette_V2, i));
			break;
		}
	}
	
	gl_FragColor = mix(dest1, dest2, palette_dif) * v_vColour;
}