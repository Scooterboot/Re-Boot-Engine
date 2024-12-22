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

/*if(!window_get_fullscreen())
{
	if(windowResizeTimer <= 0)
	{
		window_set_size(global.resWidth*screenScale,global.resHeight*screenScale);
	}
	else
	{
		windowResizeTimer--;
	}
}
else
{
	windowResizeTimer = 10;
}*/


if(room == rm_MainMenu)
{
	if(instance_exists(obj_Player))
	{
		instance_destroy(obj_Player);
	}
	if(!instance_exists(obj_MainMenu))
	{
		instance_create_depth(0,0,0,obj_MainMenu);
	}
}

var gameSpeed = 60;
if(debug > 0)
{
	if(keyboard_check(vk_shift))
	{
		gameSpeed = 2;
	}
	if(keyboard_check_pressed(vk_control))
	{
		//gameSpeed = 999;
		fastforwardtoggle = !fastforwardtoggle;
	}
	if(fastforwardtoggle)
	{
		gameSpeed = 999;
	}
}
else
{
	fastforwardtoggle = false;
}
game_set_speed(gameSpeed, gamespeed_fps);


hyperRainbowCycle = scr_wrap(hyperRainbowCycle+0.5,0,10);
