/// @description UI surface clear
if(!surface_exists(surfUI))
{
	surfUI = surface_create(global.resWidth,global.resHeight);
}
if(surface_exists(surfUI))
{
	if(surface_get_width(surfUI) != global.resWidth || surface_get_height(surfUI) != global.resHeight)
	{
		surface_resize(surfUI,global.resWidth,global.resHeight);
	}
	surface_set_target(surfUI);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}