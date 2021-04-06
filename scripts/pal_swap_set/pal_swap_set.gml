/// @description pal_swap_set(palette_sprite_index, palette_index1, palette_index2, palette_dif, palette is surface);
/// @param palette_sprite_index
/// @param  palette_index1
/// @param  palette_index2
/// @param  palette_dif
/// @param  palette is surface
function pal_swap_set() {
	shader_set(Pal_Shader);
	var _pal_sprite=argument[0],
	    _pal_index=argument[1],
	    _pal_index2 = argument[2],
	    _pal_dif = argument[3];

	if(!argument[4])
	{   //Using a sprite based palette

	    var tex = sprite_get_texture(_pal_sprite, 0);
	    var UVs = sprite_get_uvs(_pal_sprite, 0);
    
	    texture_set_stage(Pal_Texture, tex);
	    gpu_set_texfilter_ext(Pal_Texture, 1);
    
	    var texel_x = texture_get_texel_width(tex);
	    var texel_y = texture_get_texel_height(tex);
	    var texel_hx = texel_x * 0.5;
	    var texel_hy = texel_y * 0.5;
    
	    shader_set_uniform_f(Pal_Texel_Size, texel_x, texel_y);
	    shader_set_uniform_f(Pal_UVs, UVs[0] + texel_hx, UVs[1] + texel_hy, UVs[2] + texel_hx, UVs[3] + texel_hy);
	    shader_set_uniform_f(Pal_Index, _pal_index);
	    shader_set_uniform_f(Pal_Index2, _pal_index2);
	    shader_set_uniform_f(Pal_Dif, _pal_dif);
	}
	else
	{   //Using a surface based palette
	    var tex = surface_get_texture(_pal_sprite);
    
	    texture_set_stage(Pal_Texture, tex);
	    gpu_set_texfilter_ext(Pal_Texture, 1);
    
	    var texel_x = texture_get_texel_width(tex);
	    var texel_y = texture_get_texel_height(tex);
	    var texel_hx = texel_x * 0.5;
	    var texel_hy = texel_y * 0.5;
    
	    shader_set_uniform_f(Pal_Texel_Size, texel_x, texel_y);
	    shader_set_uniform_f(Pal_UVs, texel_hx, texel_hy, 1.0+texel_hx, 1.0+texel_hy);
	    shader_set_uniform_f(Pal_Index, _pal_index);
	    shader_set_uniform_f(Pal_Index2, _pal_index2);
	    shader_set_uniform_f(Pal_Dif, _pal_dif);
	}



}
