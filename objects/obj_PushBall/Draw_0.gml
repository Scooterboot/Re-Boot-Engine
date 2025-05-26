/// @description 

//var rot = scr_round(rotation/2.8125)*2.8125;

//draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),image_xscale,image_yscale,rot,image_blend,image_alpha);

if(surface_exists(surf))
{
	surface_set_target(surf);
	draw_clear_alpha(c_black,0);
	
	var texture = sprite_get_texture(sprite_index, image_index);
	var shd = sh_better_scaling_5xbrc;
	shader_set(shd);
	shader_set_uniform_f(shader_get_uniform(shd, "texel_size"), texture_get_texel_width(texture), texture_get_texel_height(texture));
	shader_set_uniform_f(shader_get_uniform(shd, "texture_size"), 1 / texture_get_texel_width(texture), 1 / texture_get_texel_height(texture));
	shader_set_uniform_f(shader_get_uniform(shd, "color"), 1, 1, 1, 1);
	shader_set_uniform_f(shader_get_uniform(shd, "color_to_make_transparent"), 0, 0, 0);
	
	draw_sprite_ext(sprite_index,image_index,surface_get_width(surf)/2,surface_get_height(surf)/2,rotScale,rotScale,0,c_white,1);
	shader_reset();
	
	surface_reset_target();
	
	var rot = scr_round(rotation);
	
	var surfCos = dcos(rot),
		surfSin = dsin(rot),
		surfX = (surfW/2),
		surfY = (surfH/2);
	var surfFX = scr_round(x) - surfCos*surfX - surfSin*surfY,
		surfFY = scr_round(y) - surfCos*surfY + surfSin*surfX;
	
	draw_surface_ext(surf,surfFX,surfFY,1/rotScale,1/rotScale,rot,image_blend,image_alpha);
}
else
{
	surf = surface_create(surfW*rotScale,surfH*rotScale);
	surface_set_target(surf);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}
