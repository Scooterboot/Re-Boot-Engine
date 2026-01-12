/// @description 

if(keyboard_check_pressed(vk_divide) || keyboard_check_pressed(vk_f1) || keyboard_check_pressed(vk_backtick))
{
	//debug = !debug;
	debug = scr_wrap(debug+1,0,3);
}

var gameSpeed = defaultGameSpeed;
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

if(debug > 0)
{
	if(keyboard_check(vk_add))
	{
		if(!zoomTempFlag)
		{
			var zoomspd = 0.01;
			if(global.zoomScale > 1)
			{
				global.zoomScale = max(global.zoomScale-zoomspd,1);
				if(global.zoomScale <= 1)
				{
					zoomTempFlag = true;
				}
			}
			else
			{
				global.zoomScale = max(global.zoomScale-zoomspd,0.5);
			}
		}
	}
	else if(keyboard_check(vk_subtract))
	{
		if(!zoomTempFlag)
		{
			var zoomspd = 0.01;
			if(global.zoomScale < 1)
			{
				global.zoomScale = min(global.zoomScale+zoomspd,1);
				if(global.zoomScale >= 1)
				{
					zoomTempFlag = true;
				}
			}
			else
			{
				global.zoomScale = min(global.zoomScale+zoomspd,2);
			}
		}
	}
	else
	{
		zoomTempFlag = false;
	}
}
else
{
	global.zoomScale = 1;
}