/// @description Initialize
//discord_start("569344917676228631");

scr_MainInitialize();

depth = -1;

debug = 0;

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
windowResizeTimer = 0;
window_center(); // <- this stopped working for some reason. had to fix it with the code below \/

/*
var winMoveX = (global.ogResWidth - global.resWidth*screenScale) / 2,
	winMoveY = (global.resHeight - global.resHeight*screenScale) / 2;
window_set_position(window_get_x()+winMoveX,window_get_y()+winMoveY);
*/

oldDelta = delta_time;

hyperRainbowCycle = 0;


stateText[0] = "Stand";
stateText[1] = "Elevator";
stateText[2] = "Recharge";
stateText[3] = "Crouch";
stateText[4] = "Walk";
stateText[5] = "Moon";
stateText[6] = "Run";
stateText[7] = "Brake";
stateText[8] = "Morph";
stateText[9] = "Jump";
stateText[10] = "Somersault";
stateText[11] = "Grip";
stateText[12] = "Spark";
stateText[13] = "BallSpark";
stateText[14] = "Grapple";
stateText[15] = "Hurt";
stateText[16] = "DmgBoost";
stateText[17] = "Death";
stateText[18] = "Dodge";
stateText[19] = "CrystalFlash";
stateText[20] = "Push";

edgeText[0] = "None";
edgeText[1] = "Bottom";
edgeText[2] = "Top";
edgeText[3] = "Left";
edgeText[4] = "Right";

zoomScale = 1;
zoomTempFlag = false;