/// @description Initialize
//discord_start("569344917676228631");

scr_MainInitialize();

depth = 0;

screenScale = 1;
if(global.screenScale > 0)
{
	screenScale = global.screenScale;
}

if(global.widescreenEnabled)
{
	global.resWidth = global.wideResWidth;
}
else
{
	global.resWidth = global.ogResWidth;
}

surface_resize(application_surface,global.resWidth,global.resHeight);

if (view_camera[0] == -1)
{
	view_camera[0] = camera_create_view(0, 0, global.resWidth, global.resHeight);
}

view_set_wport(0,global.resWidth);
view_set_hport(0,global.resHeight);
camera_set_view_size(view_camera[0],global.resWidth,global.resHeight);


global.screenX = (window_get_width() - (surface_get_width(application_surface)*screenScale)) / 2;
global.screenY = (window_get_height() - (surface_get_height(application_surface)*screenScale)) / 2;


window_set_fullscreen(global.fullScreen);
display_reset(0, global.vsync);
window_set_size(global.resWidth*screenScale,global.resHeight*screenScale);
window_center();
windowResizeTimer = 0;

oldDelta = delta_time;

messageCounter = 0;
messageType = 0;
message[0] = "GAME SAVED";