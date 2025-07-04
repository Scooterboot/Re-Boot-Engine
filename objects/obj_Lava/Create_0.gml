/// @description Initialize
event_inherited();

liquidType = LiquidType.Lava;

alpha = 0.75;

moveY = true;

imgIndex = 0;
lavaColor = make_color_rgb(255,200,200);

gradCol = make_color_rgb(225,32,0);
gradAlpha = 0.75;

ambSnd[0] = snd_LavaAmbiance_0;
ambSnd[1] = snd_LavaAmbiance_1;
ambSnd[2] = snd_LavaAmbiance_2;

lavaSurface = surface_create(SurfWidth2(),SurfHeight2());

extraDistH = 32;
finalSurface = surface_create(SurfWidth(), SurfHeight() + extraDistH);

function LavaSurface()
{
	if(surface_exists(lavaSurface))
	{
		var pos = SurfPos();
		
		surface_resize(lavaSurface,SurfWidth2(),SurfHeight2());
		surface_set_target(lavaSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),(x-pos.X)+posX-spriteW/2,y-pos.Y,image_xscale+1,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		lavaSurface = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(lavaSurface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}