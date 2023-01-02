/// @description Insert description here
// You can write your code in this editor

if(room != goal)
{
	if(surface_exists(transSurf))
	{
		surface_set_target(transSurf);
		draw_clear_alpha(c_black,1);
		
		var appSurfScale = 1;
		if(global.upscale == 7)
		{
			appSurfScale = 1/obj_Main.screenScale;
		}
		draw_surface_ext(application_surface,0,0,appSurfScale,appSurfScale,0,c_white,1);
	    surface_reset_target();
	}
	else
	{
	    transSurf = surface_create(global.resWidth,global.resHeight);
	    surface_set_target(transSurf);
	    draw_clear_alpha(c_black,1);
	    surface_reset_target();
	}
}
else if(surface_exists(transSurf))
{
	var screenX = nextDoor.x + screenPosX - (global.resWidth/2),
		screenY = nextDoor.y + screenPosY - (global.resHeight/2);
	
	draw_surface_ext(transSurf,screenX,screenY,1,1,0,c_white,1);
}