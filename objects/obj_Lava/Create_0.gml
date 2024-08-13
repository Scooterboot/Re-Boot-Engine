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

function SurfPos()
{
	return new Vector2(scr_round(max(x,camera_get_view_x(view_camera[0]))),scr_round(max(y,camera_get_view_y(view_camera[0]))));
}

function SurfWidth()
{
	var pos = SurfPos();
	return max(scr_round(min(surface_get_width(application_surface),bbox_right-pos.X + 1)), 0);
}
function SurfHeight()
{
	var pos = SurfPos();
	return max(scr_round(min(surface_get_height(application_surface),bbox_bottom-pos.Y + 1)), 0);
}
function SurfWidth2() { return SurfWidth() + spriteW; }
function SurfHeight2() { return SurfHeight() + spriteH; }

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