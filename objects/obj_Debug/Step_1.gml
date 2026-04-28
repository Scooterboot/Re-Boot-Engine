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
	
	if(keyboard_check_pressed(vk_multiply))
	{
		extraView = !extraView;
	}
}
else
{
	fastforwardtoggle = false;
	global.zoomScale = 1;
	
	extraView = false;
}

game_set_speed(gameSpeed, gamespeed_fps);

if(extraView)
{
	var _eViewW = global.resWidth/2,
		_eViewH = global.resHeight/2;
	if(view_camera[1] == -1)
	{
		view_camera[1] = camera_create_view(0,0,_eViewW,_eViewH);
	}
	
	view_visible[1] = true;
	
	view_set_xport(1,global.resWidth-_eViewW);
	view_set_yport(1,global.resHeight-_eViewH);
	view_set_wport(1,_eViewW);
	view_set_hport(1,_eViewH);
	camera_set_view_size(view_camera[1],room_width,room_height);
	camera_set_view_pos(view_camera[1], 0, 0);
}
else
{
	view_visible[1] = false;
	camera_destroy(view_visible[1]);
}