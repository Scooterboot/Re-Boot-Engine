/// @description Initialize

debug = 0;

gpu_set_zwriteenable(false);

screenScale = 1;
if(global.screenScale > 0)
{
	screenScale = global.screenScale;
}

global.resWidth = global.ogResWidth;
if(global.widescreenEnabled)
{
	global.resWidth = global.wideResWidth;
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

view_set_wport(0,ceil(global.zoomResWidth));
view_set_hport(0,ceil(global.zoomResHeight));
camera_set_view_size(view_camera[0],ceil(global.zoomResWidth),ceil(global.zoomResHeight));

window_set_fullscreen(global.fullScreen);
display_reset(0, global.vsync);
window_set_size(global.resWidth*screenScale,global.resHeight*screenScale);
//windowResizeTimer = 0;
window_center();

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

zoomTempFlag = false;

distortStage = shader_get_sampler_index(shd_Distortion,"distortion_texture_page");
distortTexel = shader_get_uniform(shd_Distortion,"texelSize");
surfDistort = surface_create(global.zoomResWidth,global.zoomResHeight);
finalAppSurface = surface_create(global.zoomResWidth,global.zoomResHeight);