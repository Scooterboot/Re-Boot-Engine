/// @description 
SetControlVars_Press();

var anyStartButton = ((cStart && rStart) || (cSelect && rSelect) || (cCancel && rCancel) || (cClickL && rClickL));

if(room == rm_MainMenu)
{
	camera_set_view_pos(view_camera[0], room_width/2 - global.resWidth/2, room_height/2 - global.resHeight/2);
	
	if(state == targetState)
	{
		screenFade = max(screenFade-0.075,0);
	}
	
	var cancel = (cCancel && rCancel) || (cClickR && rClickR);
	
	if(state == MMState.TitleIntro)
	{
		// TODO: title intro anim stuff
		state = MMState.Title;
		targetState = state;
		obj_Audio.skipTitleIntro = true;
	}
	
	if(state == MMState.Title)
	{
		if(state == targetState)
		{
			if(anyStartButton && titleAlpha >= 1)
			{
				targetState = MMState.MainMenu;
				audio_play_sound(snd_MenuShwsh,0,false);
			}
		}
		else
		{
			if(pressStartAnim >= 40)
			{
				state = targetState;
			}
			pressStartAnim = min(pressStartAnim+1,40);
		}
		titleAlpha = min(titleAlpha+0.05,1);
	}
	else
	{
		pressStartAnim = 0;
	}
	
	if(state == MMState.MainMenu)
	{
		if(state == targetState)
		{
			if(!instance_exists(mainMenuPanel))
			{
				CreateMainMenuPanel();
			}
			else
			{
				mainMenuPanel.UpdatePanel();
				selectedPanel = mainMenuPanel;
			}
		}
		else
		{
			if(screenFade > 1)
			{
				state = targetState;
			}
			screenFade += 0.075;
		}
	}
	else
	{
		if(instance_exists(mainMenuPanel))
		{
			instance_destroy(mainMenuPanel);
		}
	}
	
	if(state == MMState.FileSelect || state == MMState.FileCopy)
	{
		if(state == MMState.FileSelect)
		{
			if(state == targetState)
			{
				if(instance_exists(selectedFilePanel))
				{
					selectedPanel = selectedFilePanel;
					selectedFilePanel.UpdatePanel();
					
					if(cancel || selectedFile == -1)
					{
						instance_destroy(selectedFilePanel);
						audio_play_sound(snd_MenuTick,0,false);
					}
				}
				else
				{
					selectedFile = -1;
					if(!instance_exists(fileMenuPanel))
					{
						CreateFileMenuPanel();
					}
					else
					{
						selectedPanel = fileMenuPanel;
						fileMenuPanel.UpdatePanel();
					}
					
					if(cancel)
					{
						targetState = MMState.MainMenu;
						audio_play_sound(snd_MenuTick,0,false);
					}
				}
			}
			else if(targetState == MMState.LoadGame)
			{
				if(fileIconFrame < 7)
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
					if(screenFade > 1)
					{
						state = targetState;
					}
					screenFade += 0.075;
				}
			}
			else
			{
				if(screenFade > 1)
				{
					state = targetState;
				}
				screenFade += 0.075;
			}
		}
		
		
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
						
						ds_list_read(itemList, _worldFlags_map[? "collectedItemList"]);
						filePercent[i] = (ds_list_size(itemList) / global.totalItems) * 100;
						ds_list_clear(itemList);
					}
					catch(_exception)
					{
						show_debug_message(_exception.message);
						show_debug_message(_exception.longMessage);
						show_debug_message(_exception.script);
						show_debug_message(_exception.stacktrace);
					}
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
		if(instance_exists(fileMenuPanel))
		{
			instance_destroy(fileMenuPanel);
		}
		
		for(var i = 0; i < array_length(fileEnergyMax); i++)
		{
			fileEnergyMax[i] = -1;
			fileEnergy[i] = -1;
			filePercent[i] = -1;
			fileTime[i] = -1;
		}
	}
	
	if(state == MMState.LoadGame)
	{
		scr_LoadGame(selectedFile);
	}
}
else
{
	screenFade = max(screenFade-0.075,0);
	
	fileIconFrame = 0;
	fileIconFrameCounter = 0;
	
	state = MMState.TitleIntro;
	targetState = state;
	
	for(var i = 0; i < ds_list_size(panelList); i++)
	{
		instance_destroy(panelList[| i]);
	}
}

SetControlVars_Release();