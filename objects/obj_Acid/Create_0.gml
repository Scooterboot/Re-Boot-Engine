/// @description Initialize
event_inherited();

liquidType = LiquidType.Acid;

alpha = 0.75;

moveY = true;

imgIndex = 0;

acidSurface = surface_create(SurfWidth2(),SurfHeight2());

finalSurface = surface_create(SurfWidth(),SurfHeight());

function AcidSurface()
{
	if(surface_exists(acidSurface))
	{
		var pos = SurfPos();
		
		surface_resize(acidSurface,SurfWidth2(),SurfHeight2());
		surface_set_target(acidSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),(x-pos.X)+posX-spriteW/2,y-pos.Y,image_xscale+1,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		acidSurface = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(acidSurface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
