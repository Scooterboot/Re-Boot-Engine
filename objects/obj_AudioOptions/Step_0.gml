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
	if(cRight || cLeft)
	{
		moveCounterX = min(moveCounterX + 1, 30);
	}
	else
	{
		moveCounterX = 0;
	}
	if(moveCounterX >= 30)
	{
		moveX = cRight - cLeft;
	}
	
	if(move != 0)
	{
		optionPos += move;
		movePrev = move;
		audio_play_sound(snd_MenuTick,0,false);
	}
	var backPos = array_length(option)-1;
	optionPos = scr_wrap(optionPos,0,backPos+1);
	if((select && optionPos == backPos) || (moveX != 0 && optionPos < backPos))
	{
		if(optionPos >= backPos)
		{
			audio_play_sound(snd_MenuBoop,0,false);
		}
		/*else
		{
			audio_play_sound(snd_MenuTick,0,false);
		}*/
		
		switch(optionPos)
		{
			case 0:
			{
				//Music Volume
				//global.musicVolume = clamp(global.musicVolume+moveX*0.01,0,1);
				//global.musicVolume = scr_round(global.musicVolume*100)/100;
				
				var musvol = global.musicVolume*100;
				musvol = clamp(musvol+moveX,0,100);
				global.musicVolume = musvol/100;
				
				if(global.musicVolume > 0 && global.musicVolume < 1)
				{
					audio_play_sound(snd_Menu_Cursor_1,0,false);
				}
				audio_group_set_gain(audio_music,global.musicVolume,0);
				break;
			}
			case 1:
			{
				//Sound Volume
				//global.soundVolume = clamp(global.soundVolume+moveX*0.01,0,1);
				//global.soundVolume = scr_round(global.soundVolume*100)/100;
				
				var sndvol = global.soundVolume*100;
				sndvol = clamp(sndvol+moveX,0,100);
				global.soundVolume = sndvol/100;
				
				if(global.soundVolume > 0 && global.soundVolume < 1)
				{
					audio_play_sound(snd_Menu_Cursor_1,0,false);
				}
				audio_group_set_gain(audio_sound,global.soundVolume,0);
				break;
			}
			case 2:
			{
				//Ambiance Volume
				//global.ambianceVolume = clamp(global.ambianceVolume+moveX*0.01,0,1);
				//global.ambianceVolume = scr_round(global.ambianceVolume*100)/100;
				
				var ambvol = global.ambianceVolume*100;
				ambvol = clamp(ambvol+moveX,0,100);
				global.ambianceVolume = ambvol/100;
				
				if(global.ambianceVolume > 0 && global.ambianceVolume < 1)
				{
					audio_play_sound(snd_Menu_Cursor_1,0,false);
				}
				audio_group_set_gain(audio_ambiance,global.ambianceVolume,0);
				break;
			}
			case 3:
			{
				//Back
				menuClosing = true;
				break;
			}
		}
		
		currentOption = array(
		global.musicVolume,
		global.soundVolume,
		global.ambianceVolume);
		ini_open("settings.ini");
		ini_write_real("Audio", "music", global.musicVolume);
		ini_write_real("Audio", "sound", global.soundVolume);
		ini_write_real("Audio", "ambiance", global.ambianceVolume);
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