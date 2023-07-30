/// @description Initialize
event_inherited();

liquidType = LiquidType.Lava;

alpha = 0.75;

moveY = true;

imgIndex = 0;
lavaColor = make_color_rgb(255,200,200);

surfWidth = scaledW() + spriteW;
surfHeight = scaledH() + spriteH;

lavaSurface = surface_create(surfWidth,surfHeight);

finalSurface = surface_create(ceil(scaledW()), ceil(scaledH()));

function LavaSurface()
{
	if(surface_exists(lavaSurface))
	{
		surface_resize(lavaSurface,surfWidth,surfHeight);
		surface_set_target(lavaSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),posX,0,image_xscale+1,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		lavaSurface = surface_create(surfWidth,surfHeight);
		surface_set_target(lavaSurface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}

gradCol = make_color_rgb(225,32,0);
gradAlpha = 0.75;