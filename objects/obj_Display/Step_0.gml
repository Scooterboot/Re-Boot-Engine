/// @description Main

global.resWidth = global.ogResWidth;
if(global.widescreenEnabled)
{
	global.resWidth = global.wideResWidth;
}

if(display_get_width() >= global.resWidth*(global.maxScreenScale+1) && display_get_height() >= global.resHeight*(global.maxScreenScale+1))
{
	global.maxScreenScale += 1;
}
if((display_get_width() < global.resWidth*global.maxScreenScale || display_get_height() < global.resHeight*global.maxScreenScale) && global.maxScreenScale > 1)
{
    global.maxScreenScale -= 1;
}

global.screenX = (window_get_width() - (global.resWidth*screenScale)) / 2;
global.screenY = (window_get_height() - (global.resHeight*screenScale)) / 2;

global.zoomResWidth = global.resWidth*global.zoomScale;
global.zoomResHeight = global.resHeight*global.zoomScale;

surface_resize(application_surface,ceil(global.zoomResWidth),ceil(global.zoomResHeight));

if (view_camera[0] == -1)
{
	view_camera[0] = camera_create_view(0, 0, ceil(global.zoomResWidth), ceil(global.zoomResHeight));
}

view_visible[0] = true;
view_enabled = true;

view_set_wport(0,ceil(global.zoomResWidth));
view_set_hport(0,ceil(global.zoomResHeight));
camera_set_view_size(view_camera[0],ceil(global.zoomResWidth),ceil(global.zoomResHeight));

if(global.screenScale >= 1)
{
	screenScale = global.screenScale;
}
else if(global.screenScale == 0)
{
	screenScale = min(max(window_get_width()/global.resWidth,1),max(window_get_height()/global.resHeight,1));
}

if(obj_Debug.debug > 0)
{
	window_set_cursor(cr_default);
}
else if(window_get_cursor() != cr_none)
{
	window_set_cursor(cr_none);
}

hyperRainbowCycle = scr_wrap(hyperRainbowCycle+0.5,0,10);

if(!instance_exists(obj_Camera))
{
	global.cameraX = camera_get_view_x(view_camera[0]);
	global.cameraY = camera_get_view_y(view_camera[0]);
	global.cameraWidth = camera_get_view_width(view_camera[0]);
	global.cameraHeight = camera_get_view_height(view_camera[0]);
}
