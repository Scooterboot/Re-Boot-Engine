/// @description Main Menu
event_inherited();

cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

var anyStartButton = ((cStart && rStart) || (cSelect && rSelect) || (cCancel && rCancel));

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
	
	if(currentScreen == MainScreen.TitleIntro || currentScreen == MainScreen.Title)
	{
		camera_set_view_pos(view_camera[0],room_width/2 - global.resWidth/2,0);
	}
	else
	{
		camera_set_view_pos(view_camera[0],0,0);
	}
	
	if(currentScreen != targetScreen)
	{
		if(targetScreen == MainScreen.FileSelect && pressStartAnim < 40)
		{
			pressStartAnim = min(pressStartAnim+1,40);
		}
		else if(targetScreen == MainScreen.LoadGame && fileIconFrame < 7)
		{
			fileIconFrameCounter++;
			if(fileIconFrameCounter > 6)
			{
				fileIconFrame++;
				fileIconFrameCounter = 0;
			}
		}
		else
		{
			screenFade = min(screenFade+0.075,1);
		}
	}
	else
	{
		screenFade = max(screenFade-0.075,0);
		fileIconFrame = 0;
		fileIconFrameCounter = 0;
	}
	if(screenFade >= 1)
	{
		currentScreen = targetScreen;
	}
	
	if(screenFade <= 0 && !instance_exists(obj_DisplayOptions) && !instance_exists(obj_AudioOptions) && !instance_exists(obj_ControlOptions))
	{
		if(currentScreen == MainScreen.TitleIntro)
		{
			//yada yada intro stuff
			targetScreen = MainScreen.Title;
			currentScreen = MainScreen.Title;
			skipIntro = true;
		}
		if(currentScreen == MainScreen.Title)
		{
			if(anyStartButton && targetScreen == currentScreen && titleFade >= 1)
			{
				targetScreen = MainScreen.FileSelect;
				//audio_play_sound(snd_StartButton,0,false);
				audio_play_sound(snd_MenuShwsh,0,false);
			}
			titleFade = min(titleFade+0.05,1);
		}
		else
		{
			pressStartAnim = 0;
			titleFade = 0;
		}
		if(currentScreen == MainScreen.FileSelect)
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
			
			if(selectedFile == -1)
			{
				if(cCancel && rCancel)
				{
					targetScreen = MainScreen.Title;
				}
				
				if(move != 0)
				{
					optionPos = scr_wrap(optionPos+move,0,array_length(option)-1);
					audio_play_sound(snd_MenuTick,0,false);
				}
				
				if(select)
				{
					select = false;
					switch(optionPos)
					{
						case 0:
						{
							selectedFile = 0;
							audio_play_sound(snd_MenuTick,0,false);
							break;
						}
						case 1:
						{
							selectedFile = 1;
							audio_play_sound(snd_MenuTick,0,false);
							break;
						}
						case 2:
						{
							selectedFile = 2;
							audio_play_sound(snd_MenuTick,0,false);
							break;
						}
						case 3:
						{
							instance_create_depth(0,0,-1,obj_DisplayOptions);
							audio_play_sound(snd_MenuBoop,0,false);
							break;
						}
						case 4:
						{
							instance_create_depth(0,0,-1,obj_AudioOptions);
							audio_play_sound(snd_MenuBoop,0,false);
							break;
						}
						case 5:
						{
							instance_create_depth(0,0,-1,obj_ControlOptions);
							audio_play_sound(snd_MenuBoop,0,false);
							break;
						}
						case 6:
						{
							game_end();
							break;
						}
					}
				}
				optionSubPos = 0;
			}
			else
			{
				if(cCancel && rCancel)
				{
					selectedFile = -1;
				}
				
				if(move != 0 && selectedFile >= 0 && file_exists(scr_GetFileName(selectedFile)))
				{
					optionSubPos = scr_wrap(optionSubPos+move,0,array_length(subOption)-1);
					audio_play_sound(snd_MenuTick,0,false);
				}
				
				if(select)
				{
					select = false;
					switch(optionSubPos)
					{
						case 0:
						{
							//load and start game
							if(targetScreen != MainScreen.LoadGame)
							{
								targetScreen = MainScreen.LoadGame;
								audio_play_sound(snd_MenuShwsh,0,false);
							}
							break;
						}
						case 1:
						{
							//copy file
							
							audio_play_sound(snd_MenuTick,0,false);
							break;
						}
						case 2:
						{
							//delete file
							scr_DeleteGame(selectedFile);
							fileEnergyMax[selectedFile] = -1;
							audio_play_sound(snd_MenuBoop,0,false);
							selectedFile = -1;
							break;
						}
					}
				}
			}
		}
		else
		{
			optionPos = 0;
			optionSubPos = 0;
		}
	}
	if(currentScreen == MainScreen.FileSelect)
	{
		for(var i = 0; i < array_length(fileEnergyMax); i++)
		{
			if(fileEnergyMax[i] == -1)
			{
				if(file_exists(scr_GetFileName(i)))
				{
					try
					{
						var _wrapper = scr_LoadJSONFromFile(scr_GetFileName(i));
						var _list = _wrapper[? "ROOT"];
					
						var _map = _list[| 0];
					
						fileEnergyMax[i] = _map[? "energyMax"];
						fileEnergy[i] = _map[? "energy"];
					
						var _worldFlags_map = _list[| 2];
						fileTime[i] = _worldFlags_map[? "currentPlayTime"];
						
						var itemList = ds_list_create();
						ds_list_read(itemList, _worldFlags_map[? "collectedItemList"]);
						filePercent[i] = (ds_list_size(itemList) / global.totalItems) * 100;
					}
					catch(_exception)
					{
						show_debug_message(_exception.message);
						show_debug_message(_exception.longMessage);
						show_debug_message(_exception.script);
						show_debug_message(_exception.stacktrace);
					}
					/*finally
					{
						fileEnergyMax[i] = -2;
						fileEnergy[i] = -2;
						filePercent[i] = -2;
						fileTime[i] = -2;
					}*/
				}
				else
				{
					fileEnergyMax[i] = -2;
					fileEnergy[i] = -2;
					filePercent[i] = -2;
					fileTime[i] = -2;
				}
			}
		}
	}
	else
	{
		for(var i = 0; i < array_length(fileEnergyMax); i++)
		{
			fileEnergyMax[i] = -1;
			fileEnergy[i] = -1;
			filePercent[i] = -1;
			fileTime[i] = -1;
		}
	}
	if(currentScreen == MainScreen.LoadGame)
	{
		scr_LoadGame(selectedFile);
	}
	
	if(global.musicVolume > 0)
	{
		if(!audio_is_playing(titleMusic))
		{
			titleMusic = audio_play_sound(mus_Title,0,true);
		}
		else
		{
			if(skipIntro)
			{
				if(audio_sound_get_track_position(titleMusic) < 24.753)
				{
					audio_sound_set_track_position(titleMusic,24.753);
				}
			}
			else if(audio_sound_get_track_position(titleMusic) > 25)
			{
				skipIntro = true;
			}
			
			var trackPos = audio_sound_get_track_position(titleMusic);
			if(trackPos >= 90.858)
			{
				audio_sound_set_track_position(titleMusic,trackPos-32.768);
			}
		}
	}
	else
	{
		audio_stop_sound(titleMusic);
	}
}
else
{
	screenFade = max(screenFade-0.075,0);
	if(screenFade <= 0)
	{
		instance_destroy();
	}
	
	if(audio_is_playing(titleMusic))
	{
		audio_sound_gain(titleMusic,0,225);
		if(audio_sound_get_gain(titleMusic) <= 0)
		{
			audio_stop_sound(titleMusic);
		}
	}
	skipIntro = false;
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;