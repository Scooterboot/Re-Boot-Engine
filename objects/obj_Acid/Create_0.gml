/// @description Initialize
event_inherited();

liquidType = LiquidType.Acid;

alpha = 0.75;

moveY = true;

imgIndex = 0;

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
