/// @description 
SetControlVars_Press();

var anyStartButton = ((cStart && rStart) || (cSelect && rSelect) || (cCancel && rCancel) || (cClickL && rClickL));

if(room == rm_MainMenu)
{
	camera_set_view_pos(view_camera[0], room_width/2 - global.resWidth/2, room_height/2 - global.resHeight/2);
	
	var select = (cSelect && rSelect) || (cClickL && rClickL),
		cancel = (cCancel && rCancel) || (cClickR && rClickR);
	if(state != MMState.TitleIntro && state != MMState.Title)
	{
		if((cLeft || cRight) && !select && !cancel)
		{
			moveCounterX = min(moveCounterX + 1, moveCounterMax);
		}
		else
		{
			moveCounterX = 0;
		}
		
		if((cUp || cDown) && !select && !cancel)
		{
			moveCounterY = min(moveCounterY + 1, moveCounterMax);
		}
		else
		{
			moveCounterY = 0;
		}
	}
	
	if(state == targetState)
	{
		screenFade = max(screenFade-screenFadeRate,0);
	}
	
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
			screenFade += screenFadeRate;
		}
	}
	else
	{
		if(instance_exists(mainMenuPanel))
		{
			instance_destroy(mainMenuPanel);
		}
	}
	
	if(state == MMState.FileMenu)
	{
		if(state == targetState)
		{
			if(!instance_exists(fileMenuPanel))
			{
				CreateFileMenuPanel();
			}
			
			switch(subState)
			{
				case MMSubState.None:
				{
					selectedFile = -1;
					instance_destroy(selectedFilePanel);
					instance_destroy(copyFilePanel);
					instance_destroy(confirmCopyPanel);
					
					if(instance_exists(fileMenuPanel))
					{
						selectedPanel = fileMenuPanel;
						fileMenuPanel.UpdatePanel();
						
						if(cancel)
						{
							targetState = MMState.MainMenu;
							audio_play_sound(snd_MenuTick,0,false);
						}
					}
					break;
				}
				case MMSubState.FileSelected:
				{
					if(instance_exists(selectedFilePanel) && selectedFile != -1)
					{
						selectedPanel = selectedFilePanel;
						selectedFilePanel.UpdatePanel();
						
						if(cancel)
						{
							selectedFile = -1;
							subState = MMSubState.None;
							instance_destroy(selectedFilePanel);
							audio_play_sound(snd_MenuTick,0,false);
						}
					}
					else
					{
						subState = MMSubState.None;
					}
					break;
				}
				case MMSubState.FileCopy:
				{
					if(instance_exists(copyFilePanel) && selectedFile != -1)
					{
						selectedPanel = copyFilePanel;
						copyFilePanel.UpdatePanel();
						
						if(cancel)
						{
							subState = MMSubState.FileSelected;
							instance_destroy(copyFilePanel);
							audio_play_sound(snd_MenuTick,0,false);
						}
					}
					else
					{
						subState = MMSubState.FileSelected;
					}
					break;
				}
				case MMSubState.ConfirmCopy:
				{
					if(instance_exists(confirmCopyPanel))
					{
						selectedPanel = confirmCopyPanel;
						confirmCopyPanel.UpdatePanel();
						
						if(cancel)
						{
							subState = MMSubState.FileCopy;
							instance_destroy(confirmCopyPanel);
							audio_play_sound(snd_MenuTick,0,false);
						}
					}
					else
					{
						subState = MMSubState.FileCopy;
					}
					break;
				}
				case MMSubState.ConfirmDelete:
				{
					if(instance_exists(confirmDeletePanel))
					{
						selectedPanel = confirmDeletePanel;
						confirmDeletePanel.UpdatePanel();
						
						if(cancel)
						{
							subState = MMSubState.FileSelected;
							instance_destroy(confirmDeletePanel);
							audio_play_sound(snd_MenuTick,0,false);
						}
					}
					else
					{
						subState = MMSubState.FileSelected;
					}
					break;
				}
			}
		}
		else
		{
			if(targetState == MMState.LoadGame && fileIconFrame < 7)
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
				screenFade += screenFadeRate;
			}
		}
		
		for(var i = 0; i < array_length(fileTime); i++)
		{
			if(fileTime[i] == -1)
			{
				if(file_exists(scr_GetFileName(i)))
				{
					try
					{
						var _wrapper = scr_LoadJSONFromFile(scr_GetFileName(i));
						var _list = _wrapper[? "ROOT"];
					
						var _map = _list[| 0];
					
						var _worldFlags_map = _list[| 2];
						fileTime[i] = _worldFlags_map[? "currentPlayTime"];
						
						ds_list_read(itemList, _worldFlags_map[? "collectedItemList"]);
						filePercent[i] = (ds_list_size(itemList) / global.totalItems) * 100;
						ds_list_clear(itemList);
					
						fileEnergyMax[i] = _map[? "energyMax"];
						fileEnergy[i] = _map[? "energy"];
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
					fileTime[i] = -2;
					filePercent[i] = -2;
					fileEnergyMax[i] = -2;
					fileEnergy[i] = -2;
				}
			}
		}
	}
	else
	{
		subState = MMSubState.None;
		if(instance_exists(fileMenuPanel))
		{
			instance_destroy(fileMenuPanel);
		}
		
		for(var i = 0; i < array_length(fileTime); i++)
		{
			fileTime[i] = -1;
			filePercent[i] = -1;
			fileEnergyMax[i] = -1;
			fileEnergy[i] = -1;
		}
	}
	
	if(state == MMState.LoadGame)
	{
		scr_LoadGame(selectedFile);
	}
	
	if(moveCounterX >= moveCounterMax)
	{
		moveCounterX -= 5;
	}
	if(moveCounterY >= moveCounterMax)
	{
		moveCounterY -= 5;
	}
}
else
{
	screenFade = max(screenFade-screenFadeRate,0);
	
	fileIconFrame = 0;
	fileIconFrameCounter = 0;
	
	state = MMState.TitleIntro;
	targetState = state;
	subState = MMSubState.None;
	selectedFile = -1;
	
	moveCounterX = 0;
	moveCounterY = 0;
	
	for(var i = 0; i < ds_list_size(panelList); i++)
	{
		instance_destroy(panelList[| i]);
	}
}

SetControlVars_Release();