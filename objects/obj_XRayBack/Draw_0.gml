/// @description Draw obj_XRay's 100 depth tile surface
var camx = camera_get_view_x(view_camera[0]),
	camy = camera_get_view_y(view_camera[0]);

if !(instance_exists(obj_XRay))
{
	instance_destroy();
}
else
with (obj_XRay)
{
	if !(surface_exists(SurfaceBack))
	{
		SurfaceBack = surface_create(Width,Height);
		xray_redraw_back();
	}
 
	if !(surface_exists(SurfaceBackTemp))
	{
		SurfaceBackTemp = surface_create(Width,Height);
	}
 
	VisorX = x - camx;
	VisorY = y - camy; 
 
	// -- Get rid of the easy background surface shit whatever
 
	surface_set_target(SurfaceBackTemp);
	draw_clear_alpha(0,0);
 
	draw_surface(SurfaceBack,0,0);
 
	gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);
 
	draw_set_alpha(0);
	draw_triangle(VisorX,VisorY,VisorX+lengthdir_x(500,ConeDir+ConeSpread),VisorY+lengthdir_y(500,ConeDir+ConeSpread),VisorX+lengthdir_x(500,ConeDir-ConeSpread),VisorY+lengthdir_y(500,ConeDir-ConeSpread), 0);
	draw_set_alpha(1);
 
	gpu_set_blendmode(bm_normal);
 
	surface_reset_target();

	draw_surface(SurfaceBackTemp,camx,camy);
}