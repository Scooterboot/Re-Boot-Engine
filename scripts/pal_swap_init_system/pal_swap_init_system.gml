/// @description pal_swap_init_system(shader)
/// @param shader
function pal_swap_init_system() {
	//Initiates the palette system.  Call once at the beginning of your game somewhere.

	globalvar Pal_Shader,Pal_Texel_Size, Pal_UVs, Pal_Index, Pal_Index2, Pal_Dif, Pal_Texture;
	Pal_Shader = argument[0];
	Pal_Texel_Size = shader_get_uniform(argument[0], "texel_size");
	Pal_UVs = shader_get_uniform(argument[0], "palette_UVs");
	Pal_Index = shader_get_uniform(argument[0], "palette_index");
	Pal_Index2 = shader_get_uniform(argument[0], "palette_index2");
	Pal_Dif = shader_get_uniform(argument[0], "palette_dif");
	Pal_Texture = shader_get_sampler_index(argument[0], "palette_texture");



}
