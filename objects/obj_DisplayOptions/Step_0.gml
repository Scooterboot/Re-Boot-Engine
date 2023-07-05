/// @description Menu

cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

if(room != rm_MainMenu && (global.roomTrans || !global.gamePaused || !obj_PauseMenu.isPaused))
{
	menuClosing = true;
}

var resText = "("+string(global.resWidth*obj_Main.screenScale)+"x"+string(global.resHeight*obj_Main.screenScale)+")";
currentOptionName[1,0] = "STRETCH "+resText;
currentOptionName[1,1] = string(global.screenScale)+"x "+resText;

if(screenFade >= 1 && !menuClosing)
{
	var move = (cDown && rDown) - (cUp && rUp),
		moveX = (cRight && rRight) - (cLeft && rLeft),
		select = (cSelect && rSelect),
		cancel = (cCancel && rCancel);
	
	if(cDown || cUp)
	{
		moveCounter = min(moveCounter + 1, 30);
	}
	else
	{
		moveCounter = 0;
	}
	if(moveCounter >= 30)
	{
		move = cDown - cUp;
		moveCounter -= 5;
	}
	
	if(move != 0)
	{
		optionPos += move;
		movePrev = move;
		audio_play_sound(snd_MenuTick,0,false);
	}
	optionPos = scr_wrap(optionPos,0,array_length(option));
	if(select || (moveX != 0 && optionPos < array_length(option)-1))
	{
		if(optionPos >= array_length(option)-1)
		{
			audio_play_sound(snd_MenuBoop,0,false);
		}
		else
		{
			audio_play_sound(snd_MenuTick,0,false);
		}
		
		switch(optionPos)
		{
			case 0:
			{
				//Fullscreen
				global.fullScreen = !global.fullScreen;
				window_set_fullscreen(global.fullScreen);
				break;
			}
			case 1:
			{
				//Display Scale
				var temp = global.screenScale;
				global.screenScale = scr_wrap(global.screenScale+select+moveX,0,global.maxScreenScale+1);
				
				var winMoveX = (global.resWidth*temp - global.resWidth*global.screenScale) / 2,
					winMoveY = (global.resHeight*temp - global.resHeight*global.screenScale) / 2;
				window_set_position(window_get_x()+winMoveX,window_get_y()+winMoveY);
				
				break;
			}
			case 2:
			{
				//Widescreen
				global.widescreenEnabled = !global.widescreenEnabled;
				
				if(instance_exists(obj_Camera))
				{
					var camMoveX = (global.wideResWidth-global.ogResWidth)/2;
					var rWidth = global.ogResWidth;
					if(global.widescreenEnabled)
					{
						camMoveX = -camMoveX;
						rWidth = global.wideResWidth;
					}
					obj_Camera.x = clamp(obj_Camera.x+camMoveX,0,room_width-rWidth);
					camera_set_view_pos(view_camera[0],
					clamp(camera_get_view_x(view_camera[0])+camMoveX,0,room_width-rWidth),
					clamp(camera_get_view_y(view_camera[0]),0,room_height-global.resHeight));
				}
				var winMoveX = (global.wideResWidth*obj_Main.screenScale - global.ogResWidth*obj_Main.screenScale)/2;
				if(global.widescreenEnabled)
				{
					winMoveX = -winMoveX;
				}
				window_set_position(window_get_x()+winMoveX,window_get_y());
				
				screenBlackout = 3;
				if(!window_get_fullscreen())
				{
					screenBlackout = 15;
				}
				break;
			}
			case 3:
			{
				//VSync
				global.vsync = !global.vsync;
				display_reset(0,global.vsync);
				screenBlackout = 3;
				break;
			}
			case 4:
			{
				//Upscale mode
				global.upscale = scr_wrap(global.upscale+select+moveX,0,7);//6);
				break;
			}
			case 5:
			{
				//Show/Hide HUD
				global.hudDisplay = !global.hudDisplay;
				break;
			}
			case 6:
			{
				//Show/Hide Minimap
				global.hudMap = !global.hudMap;
				break;
			}
			case 7:
			{
				global.waterDistortion = !global.waterDistortion;
				break;
			}
			case 8:
			{
				//Back
				menuClosing = true;
				break;
			}
		}
		
		currentOption = array(
		global.fullScreen,
		global.screenScale,
		global.widescreenEnabled,
		global.vsync,
		global.upscale,
		global.hudDisplay,
		global.hudMap,
		global.waterDistortion);
		ini_open("settings.ini");
		ini_write_real("Display", "fullscreen", global.fullScreen);
		ini_write_real("Display", "scale", global.screenScale);
		ini_write_real("Display", "widescreen", global.widescreenEnabled);
		ini_write_real("Display", "vsync", global.vsync);
		ini_write_real("Display", "upscale", global.upscale);
		ini_write_real("Display", "hud", global.hudDisplay);
		ini_write_real("Display", "hud map", global.hudMap);
		ini_write_real("Display", "water distortion", global.waterDistortion);
		ini_close();
	}
	if(cancel)
	{
		audio_play_sound(snd_MenuBoop,0,false);
		menuClosing = true;
	}
}

if(menuClosing)
{
	screenFade = max(screenFade - 0.1, 0);
	if(screenFade <= 0)
	{
		instance_destroy();
	}
}
else
{
	screenFade = min(screenFade + 0.1, 1);
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;