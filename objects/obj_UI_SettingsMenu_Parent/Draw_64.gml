
var ww = global.resWidth,
	hh = global.resHeight;

if(!surface_exists(surf))
{
	surf = surface_create(ww, hh);
}
if(surface_exists(surf))
{
	if(surface_get_width(surf) != ww)
	{
		surface_resize(surf, ww, hh);
	}
	
	surface_set_target(surf);
	
	BentoDrawClear(, 1);
	draw_sprite_ext(bg_Space, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
	
	bm_set_one();
	
	BentoEnvironmentDraw(environment);
	
	var _headStr = headerText[0],
		_footStr = footerText[0];
	
	self.DrawUIHeader(_headStr);
	self.DrawUIFooter(_footStr);
	
	bm_reset();
	
	surface_reset_target();
	
	if(screenFade > 0)
	{
		surface_set_target(obj_Display.surfUI);
		bm_set_one();
		
		draw_surface_ext(surf, 0,0, 1,1, 0, c_white, screenFade);
		
		bm_reset();
		surface_reset_target();
	}
}