/// @description Main
//discord_update_text("Testing stuff", "Debug Area");
//discord_update_image("brinstarelevator", "smallicon", "Derp", "Made by Scooterboot");

//discord_update();
global.currentItemPercent = (ds_list_size(global.collectedItemList) / global.totalItems) * 100;


if(global.widescreenEnabled)
{
	global.resWidth = global.wideResWidth;
}
else
{
	global.resWidth = global.ogResWidth;
}

if (view_camera[0] == -1)
{
	view_camera[0] = camera_create_view(0, 0, global.resWidth, global.resHeight);
}

view_visible[0] = true;
view_enabled = true;

view_set_wport(0,global.resWidth);
view_set_hport(0,global.resHeight);
camera_set_view_size(view_camera[0],global.resWidth,global.resHeight);

if(global.upscale == 7)
{
	global.screenX = (window_get_width() - surface_get_width(application_surface)) / 2;
	global.screenY = (window_get_height() - surface_get_height(application_surface)) / 2;
}
else
{
	global.screenX = (window_get_width() - (surface_get_width(application_surface)*screenScale)) / 2;
	global.screenY = (window_get_height() - (surface_get_height(application_surface)*screenScale)) / 2;
}

if(display_get_width() >= global.resWidth*(global.maxScreenScale+1) && display_get_height() >= global.resHeight*(global.maxScreenScale+1))
{
	global.maxScreenScale += 1;
}
if((display_get_width() < global.resWidth*global.maxScreenScale || display_get_height() < global.resHeight*global.maxScreenScale) && global.maxScreenScale > 1)
{
    global.maxScreenScale -= 1;
}

if(global.screenScale >= 1)
{
	screenScale = global.screenScale;
}
else if(global.screenScale == 0)
{
	screenScale = min(max(window_get_width()/global.resWidth,1),max(window_get_height()/global.resHeight,1));
}

if(!window_get_fullscreen())
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
}


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
else if(!global.gamePaused)
{
	global.currentPlayTime += (1 / room_speed) * (oldDelta / delta_time);
	
	/*if(keyboard_check(vk_shift))
	{
		global.currentPlayTime += 3600;
	}*/
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
		toggleFastForward = !toggleFastForward;
	}
	if(toggleFastForward)
	{
		gameSpeed = 600;
	}
}
game_set_speed(gameSpeed, gamespeed_fps);

if(keyboard_check_pressed(vk_f12))
{
    screen_save_part("screenshot.png",global.screenX,global.screenY,global.resWidth*screenScale,global.resHeight*screenScale);
}


oldDelta = delta_time;

hyperRainbowCycle = scr_wrap(hyperRainbowCycle+0.5,0,10);
