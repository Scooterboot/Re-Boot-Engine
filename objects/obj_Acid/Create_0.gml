/// @description Initialize
event_inherited();

liquidType = LiquidType.Acid;

alpha = 0.75;

moveY = true;

imgIndex = 0;

surfWidth = scaledW() + spriteW;
surfHeight = scaledH() + spriteH;

acidSurface = surface_create(surfWidth,surfHeight);

finalSurface = surface_create(ceil(scaledW()), ceil(scaledH()));

function AcidSurface()
{
	if(surface_exists(acidSurface))
	{
		surface_resize(acidSurface,surfWidth,surfHeight);
		surface_set_target(acidSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),posX,0,image_xscale+1,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		acidSurface = surface_create(surfWidth,surfHeight);
		surface_set_target(acidSurface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
