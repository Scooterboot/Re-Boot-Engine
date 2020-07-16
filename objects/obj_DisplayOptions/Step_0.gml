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
	optionPos = scr_wrap(optionPos,0,array_length_1d(option)-1);
	if(select || (moveX != 0 && optionPos < array_length_1d(option)-1))
	{
		if(optionPos >= array_length_1d(option)-1)
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
				global.screenScale = scr_wrap(global.screenScale+select+moveX,0,global.maxScreenScale);
				break;
			}
			case 2:
			{
				//VSync
				global.vsync = !global.vsync;
				display_reset(0,global.vsync);
				break;
			}
			case 3:
			{
				//Upscale mode
				global.upscale = scr_wrap(global.upscale+select+moveX,0,6);
				break;
			}
			case 4:
			{
				//Show/Hide HUD
				global.hudDisplay = !global.hudDisplay;
				break;
			}
			case 5:
			{
				//Show/Hide Minimap
				global.hudMap = !global.hudMap;
				break;
			}
			case 6:
			{
				global.waterDistortion = !global.waterDistortion;
				break;
			}
			case 7:
			{
				//Back
				menuClosing = true;
				break;
			}
		}
		
		currentOption = array(
		global.fullScreen,
		global.screenScale,
		global.vsync,
		global.upscale,
		global.hudDisplay,
		global.hudMap,
		global.waterDistortion);
		ini_open("settings.ini");
		ini_write_real("Display", "fullscreen", global.fullScreen);
		ini_write_real("Display", "scale", global.screenScale);
		ini_write_real("Display", "vsync", global.vsync);
		ini_write_real("Display", "upscale", global.upscale);
		ini_write_real("Display", "hud", global.hudDisplay);
		ini_write_real("Display", "hud map", global.hudMap);
		ini_write_real("Display", "water distortion", global.waterDistortion);
		ini_close();
		
		currentOptionName[1,1] = string(global.screenScale)+"x";
	}
	if(cancel)
	{
		audio_play_sound(snd_MenuBoop,0,false);
		menuClosing = true;
	}
}

if(menuClosing)
{
	var rate = 0.25;
	if(!obj_PauseMenu.isPaused)
	{
		rate = 0.1;
	}
	screenFade = max(screenFade - rate, 0);
	if(screenFade <= 0)
	{
		instance_destroy();
	}
}
else
{
	screenFade = min(screenFade + 0.25, 1);
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;