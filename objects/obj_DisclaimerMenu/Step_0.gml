/// @description 
event_inherited();

cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

if(room == rm_Disclaimer)
{
	camera_set_view_pos(view_camera[0],room_width/2-global.resWidth/2,0);
	
	if(skipDisc)
	{
		room_goto(rm_MainMenu);
		instance_create_depth(0,0,0,obj_MainMenu);
		exit;
	}
	
	revealCounter++;
	if(revealCounter > 120)
	{
		for(var i = 0; i < array_length(revealText); i++)
		{
			if(revealCounter > 120 + 120*i)
			{
				revealText[i] = min(revealText[i]+0.075,1);
			}
		}
	}
	
	if(revealText[5] > 0)
	{
		if(optionSelected == -1)
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
						optionSelected = 1;
						break;
					}
				}
			}
		}
		else
		{
			if(screenFade >= 1.15)
			{
				if(optionSelected == 1)
				{
					skipDisc = true;
					ini_open("settings.ini");
					ini_write_real("misc", "disclaimer understood", skipDisc);
					ini_close();
				}
				
				room_goto(rm_MainMenu);
				instance_create_depth(0,0,0,obj_MainMenu);
			}
			screenFade = min(screenFade + 0.075,1.15);
			moveCounter = 0;
		}
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
