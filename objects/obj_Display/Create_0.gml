/// @description Initialize

application_surface_draw_enable(false); //disable default application surface drawing
display_set_gui_maximize(1, 1, 0, 0);
gpu_set_zwriteenable(false);
surface_depth_disable(true);

ini_open("settings.ini");
	global.fullScreen = ini_read_real("Display", "fullscreen", false);
	global.screenScale = ini_read_real("Display", "scale", 3);
	global.widescreenEnabled = ini_read_real("Display", "widescreen", true);
	global.vsync = ini_read_real("Display", "vsync", true);
	global.upscale = ini_read_real("Display", "upscale", 0);
	global.hudDisplay = ini_read_real("Display", "hud display", true);
	global.hudMap = ini_read_real("Display", "hud map", true);
	global.waterDistortion = ini_read_real("Display", "water distortion", true);
ini_close();

// Reference of resolutions from other games
// Super Metroid:	256 x 224 (widescreen: 400 x 224) | in tiles: 16 x 14		(ws: 25 x 14)
// AM2R:			320 x 240 (widescreen: 426 x 240) | in tiles: 20 x 15		(ws: 26.625 x 15)
// Axiom Verge:		360 x 270 (widescreen: 480 x 270) | in tiles: 22.5 x 16.875	(ws: 30 x 16.875)
global.wideResWidth = 426;
global.ogResWidth = 320;
global.resHeight = 240;

global.resWidth = global.ogResWidth;
if(global.widescreenEnabled)
{
	global.resWidth = global.wideResWidth;
}

global.maxScreenScale = 1;

screenScale = 1;
if(global.screenScale > 0)
{
	screenScale = global.screenScale;
}

global.zoomScale = 1;
global.zoomResWidth = global.resWidth*global.zoomScale;
global.zoomResHeight = global.resHeight*global.zoomScale;

surface_resize(application_surface,ceil(global.zoomResWidth),ceil(global.zoomResHeight));

if (view_camera[0] == -1)
{
	view_camera[0] = camera_create_view(0, 0, ceil(global.zoomResWidth), ceil(global.zoomResHeight));
}

view_set_wport(0,ceil(global.zoomResWidth));
view_set_hport(0,ceil(global.zoomResHeight));
camera_set_view_size(view_camera[0],ceil(global.zoomResWidth),ceil(global.zoomResHeight));

window_set_fullscreen(global.fullScreen);
display_reset(0, global.vsync);
window_set_size(global.resWidth*screenScale,global.resHeight*screenScale);
window_center();

global.screenX = (window_get_width() - (global.resWidth*screenScale)) / 2;
global.screenY = (window_get_height() - (global.resHeight*screenScale)) / 2;

hyperRainbowCycle = 0;

surfUI = surface_create(global.resWidth,global.resHeight);
finalAppSurf = surface_create(global.resWidth,global.resHeight);