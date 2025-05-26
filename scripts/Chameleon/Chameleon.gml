
// Palette swapper (re)written by me (Scooterboot), based on Loj's Chameleon
// https://github.com/Lojemiru/Chameleon

#macro __PAL_SHADER shd_Chameleon

function chameleon_init()
{
	global._palTexture = shader_get_sampler_index(__PAL_SHADER,"palTexture");
	global._palTexelSize = shader_get_uniform(__PAL_SHADER,"texelSize");
	global._palUVs = shader_get_uniform(__PAL_SHADER,"palUVs");
	global._palIndex = shader_get_uniform(__PAL_SHADER,"palIndex");
	global._palIndex2 = shader_get_uniform(__PAL_SHADER,"palIndex2");
	global._palMix = shader_get_uniform(__PAL_SHADER,"palMix");
	global._palNum = shader_get_uniform(__PAL_SHADER,"palNum");
}

function chameleon_set(_palSprite, _index, _index2, _mix, _palNum)
{
	shader_set(__PAL_SHADER);
	
	var tex = sprite_get_texture(_palSprite,0);
	var UVs = sprite_get_uvs(_palSprite,0);
	
	texture_set_stage(global._palTexture, tex);
	gpu_set_texfilter_ext(global._palTexture, false);
	
	var texel_x = texture_get_texel_width(tex);
	var texel_y = texture_get_texel_height(tex);
	
	shader_set_uniform_f(global._palTexelSize, texel_x, texel_y);
	shader_set_uniform_f(global._palUVs, UVs[0], UVs[1], UVs[2], UVs[3]);
	shader_set_uniform_f(global._palIndex, _index);
	shader_set_uniform_f(global._palIndex2, _index2);
	shader_set_uniform_f(global._palMix, _mix);
	shader_set_uniform_i(global._palNum, _palNum);
}

function chameleon_set_surface(_palSurface)
{
	shader_set(__PAL_SHADER);
	
	var tex = surface_get_texture(_palSurface);
	
	texture_set_stage(global._palTexture, tex);
	gpu_set_texfilter_ext(global._palTexture, false);
	
	var texel_x = texture_get_texel_width(tex);
	var texel_y = texture_get_texel_height(tex);
	
	shader_set_uniform_f(global._palTexelSize, texel_x, texel_y);
	shader_set_uniform_f(global._palUVs, 0, 0, 1, 1);
	shader_set_uniform_f(global._palIndex, 0);
	shader_set_uniform_f(global._palIndex2, 0);
	shader_set_uniform_f(global._palMix, 0);
	shader_set_uniform_i(global._palNum, 1);
}