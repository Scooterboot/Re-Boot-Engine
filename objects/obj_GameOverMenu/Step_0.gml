/// @description Game Over Menu
event_inherited();

cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

if(room == rm_GameOver)
{
	camera_set_view_pos(view_camera[0], room_width/2 - global.resWidth/2, room_height/2 - global.resHeight/2);
	
	if(optionSelected == -1)
	{
		if(confirmQuitMM == -1 && confirmQuitDT == -1)
		{
			var move = (cDown && rDown) - (cUp && rUp),
				select = (cSelect && rSelect);
			
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
				optionPos = scr_wrap(optionPos+move,0,array_length(option));
				audio_play_sound(snd_MenuTick,0,false);
			}
			
			if(select)
			{
				select = false;
				if(optionPos == 0)
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
						optionSelected = 0;
						break;
					}
					case 1:
					{
						confirmQuitMM = 0;
						break;
					}
					case 2:
					{
						confirmQuitDT = 0;
						break;
					}
				}
			}
		}
		else
		{
			var move = (cRight && rRight) - (cLeft && rLeft),
				select = (cSelect && rSelect),
				cancel = (cCancel && rCancel);
				
			if(move != 0)
			{
				confirmPos = scr_wrap(confirmPos+move,0,2);
				audio_play_sound(snd_MenuTick,0,false);
			}
				
			if(cancel)
			{
				confirmPos = 0;
				confirmQuitMM = -1;
				confirmQuitDT = -1;
				audio_play_sound(snd_MenuTick,0,false);
			}
			else if(select)
			{
				if(confirmPos == 1)
				{
					audio_play_sound(snd_MenuBoop,0,false);
					if(confirmQuitMM >= 0)
					{
						global.SilenceMusic();
						optionSelected = 1;
					}
					if(confirmQuitDT >= 0)
					{
						game_end();
					}
				}
				else
				{
					confirmQuitMM = -1;
					confirmQuitDT = -1;
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
		}
		
		screenFade = max(screenFade - 0.075,0);
	}
	else
	{
		if(screenFade >= 1.15)
		{
			if(optionSelected == 0)
			{
				scr_LoadGame(global.currentPlayFile);
			}
			else if(optionSelected == 1)
			{
				instance_destroy(obj_Player);
				instance_destroy(obj_Camera);
				room_goto(rm_MainMenu);
			}
		}
		screenFade = min(screenFade + 0.075,1.15);
		moveCounter = 0;
	}
}
else
{
	if(screenFade <= 0)
	{
		instance_destroy();
	}
	screenFade = max(screenFade - 0.075,0);
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;
