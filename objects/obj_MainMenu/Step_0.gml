/// @description Main Menu
cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

if(room == rm_MainMenu)
{
	var debug = false;
	if(debug)
	{
		room_goto(rm_debug01);
		var sx = 80,
			sy = 694;
		instance_create_layer(sx,sy,"Player",obj_Player);
		instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);
		instance_destroy();
		exit;
	}
	
	if(!instance_exists(obj_DisplayOptions) && !instance_exists(obj_AudioOptions) && !instance_exists(obj_ControlOptions))
	{
		if(currentScreen == MainScreen.TitleIntro)
		{
			//yada yada intro stuff
			currentScreen = MainScreen.Title;
		}
		if(currentScreen == MainScreen.Title)
		{
			if(cStart && rStart)
			{
				currentScreen = MainScreen.FileSelect;
			}
		}
		if(currentScreen == MainScreen.FileSelect)
		{
			if(cCancel && rCancel)
			{
				currentScreen = MainScreen.Title;
			}
			
			var move = (cDown && rDown) - (cUp && rUp),
				select = (cSelect && rSelect);
			
			if(move != 0)
			{
				optionPos = scr_wrap(optionPos+move,0,array_length_1d(option)-1);
				audio_play_sound(snd_MenuTick,0,false);
			}
			
			if(select)
			{
				select = false;
				audio_play_sound(snd_MenuBoop,0,false);
				switch(optionPos)
				{
					case 0:
					{
						global.currentPlayFile = 0;
						//load file 1
						break;
					}
					case 1:
					{
						global.currentPlayFile = 1;
						//load file 2
						break;
					}
					case 2:
					{
						global.currentPlayFile = 2;
						//load file 3
						break;
					}
					case 3:
					{
						instance_create_depth(0,0,-1,obj_DisplayOptions);
						break;
					}
					case 4:
					{
						instance_create_depth(0,0,-1,obj_AudioOptions);
						break;
					}
					case 5:
					{
						instance_create_depth(0,0,-1,obj_ControlOptions);
						break;
					}
					case 6:
					{
						game_end();
						break;
					}
				}
			}
		}
		else
		{
			optionPos = 0;
		}
	}
}
else
{
	instance_destroy();
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;