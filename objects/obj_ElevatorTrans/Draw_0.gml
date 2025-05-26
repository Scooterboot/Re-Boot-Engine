/// @description Screen fade
if(surface_exists(transSurf))
{
	surface_resize(transSurf,ceil(global.zoomResWidth),ceil(global.zoomResHeight));
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
	
	draw_surface_ext(application_surface,0,0,1,1,0,c_white,1-alpha);
    surface_reset_target();

	gpu_set_blendenable(false);
    draw_surface_ext(transSurf,camera_get_view_x(view_camera[0]),camera_get_view_y(view_camera[0]),1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
    transSurf = surface_create(ceil(global.zoomResWidth),ceil(global.zoomResHeight));
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    surface_reset_target();
}