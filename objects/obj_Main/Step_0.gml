/// @description Main
discord_update_text("Testing stuff", "Debug Area");
discord_update_image("brinstarelevator", "smallicon", "Derp", "Made by Scooterboot");

discord_update();


if (view_camera[0] == -1)
{
	view_camera[0] = camera_create_view(0, 0, global.resWidth, global.resHeight);
}

view_visible[0] = true;
view_enabled = true;

view_set_wport(0,global.resWidth);
view_set_hport(0,global.resHeight);
camera_set_view_size(view_camera[0],global.resWidth,global.resHeight);

global.screenX = (window_get_width() - (surface_get_width(application_surface)*screenScale)) / 2;
global.screenY = (window_get_height() - (surface_get_height(application_surface)*screenScale)) / 2;

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
	window_set_size(global.resWidth*screenScale,global.resHeight*screenScale);
}


if(room == rm_MainMenu)
{
	if(instance_exists(obj_Player))
	{
		instance_destroy(obj_Player);
	}
	//if(file selected and stuff)
	//{
		// load game stuff here
		room_goto(rm_debug01);
		var sx = 80,
			sy = 694;
		instance_create_layer(sx,sy,"Player",obj_Player);
		instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);
	//}
}

if(keyboard_check(vk_shift))
{
	room_speed = 2;
}
else
{
	room_speed = 60;
}