/// @description 

if(surface_exists(palSurface))
{
	surface_copy(palSurface,0,0,creator.palSurface);
	
	surface_set_target(palSurface);
	
	gpu_set_colorwriteenable(1,1,1,0);
	if(dmgFlash > 4)
	{
		draw_sprite_ext(pal_Kraid,8,0,0,1,1,0,c_white,1);
	}
	gpu_set_colorwriteenable(1,1,1,1);
	
	surface_reset_target();
}
else
{
	palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));
}

chameleon_set_surface(palSurface);
draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),image_xscale,image_yscale,rotation,c_white,image_alpha);
shader_reset();

dmgFlash = max(dmgFlash-1,0);