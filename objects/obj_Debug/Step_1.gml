/// @description 

if(keyboard_check_pressed(vk_divide) || keyboard_check_pressed(vk_f1) || keyboard_check_pressed(vk_backtick))
{
	//debug = !debug;
	debug = scr_wrap(debug+1,0,3);
}

var gameSpeed = defaultGameSpeed;
if(debug > 0)
{
	if(keyboard_check_pressed(vk_control))
	{
		//gameSpeed = 999;
		fastforwardtoggle = !fastforwardtoggle;
	}
	if(fastforwardtoggle)
	{
		gameSpeed = 999;
	}
	if(keyboard_check(vk_shift))
	{
		gameSpeed = 2;
		fastforwardtoggle = false;
	}
	
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
	
	if(mouse_check_button(mb_left) && global.pauseState == PauseState.None)
	{
		with(obj_Player)
		{
			if(instance_exists(obj_Mouse))
			{
				velX = 0;
				velY = 0;
				position.X = obj_Mouse.PosX_Room();
				position.Y = obj_Mouse.PosY_Room();
				x = scr_round(position.X);
				y = scr_round(position.Y);
			}
		}
		with(obj_Camera)
		{
			stallX = true;
			stallY = true;
		}
	}
}
else
{
	fastforwardtoggle = false;
	global.zoomScale = 1;
}

game_set_speed(gameSpeed, gamespeed_fps);