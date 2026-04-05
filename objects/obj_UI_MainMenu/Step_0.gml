/// @description 
self.SetControlVars_Press();

var anyStartButton = ((cStart && rStart) || (cMenuAccept && rMenuAccept) || (cMenuCancel && rMenuCancel) || (cClickL && rClickL));

if(room == rm_MainMenu)
{
	camera_set_view_pos(view_camera[0], room_width/2 - global.resWidth/2, room_height/2 - global.resHeight/2);
	
	if(obj_UI_SettingsMenu.activeState == UI_ActiveState.Inactive)
	{
		activeState = UI_ActiveState.Active;
		currentPage = noone;
		
		if(state == UI_MMState.TitleIntro || state == UI_MMState.Title)
		{
			moveCounterX = 0;
			moveCounterY = 0;
		}
	
		if(state == targetState)
		{
			screenFade = max(screenFade-screenFadeRate,0);
		}
	
		if(state == UI_MMState.TitleIntro)
		{
			// TODO: title intro anim stuff
			state = UI_MMState.Title;
			targetState = state;
			obj_Audio.skipTitleIntro = true;
		}
		if(state == UI_MMState.Title)
		{
			if(state == targetState)
			{
				if(anyStartButton && titleAlpha >= 1)
				{
					targetState = UI_MMState.MainMenu;
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
		if(state == UI_MMState.MainMenu)
		{
			if(state == targetState)
			{
				if(!instance_exists(mainMenuPage))
				{
					self.CreateMainMenuPage();
				}
				currentPage = mainMenuPage;
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
			if(instance_exists(mainMenuPage))
			{
				instance_destroy(mainMenuPage);
			}
		}
		
		if(state == UI_MMState.FileMenu)
		{
			if(state == targetState)
			{
				if(!instance_exists(fileMenuPage))
				{
					self.CreateFileMenuPage();
				}
			
				switch(subState)
				{
					case UI_MMSubState.None:
					{
						selectedFile = -1;
						instance_destroy(selectedFilePage);
						instance_destroy(copyFilePage);
						if(instance_exists(confirmCopyPage)) { confirmCopyPage.active = false; }
						if(instance_exists(confirmDeletePage)) { confirmDeletePage.active = false; }
					
						currentPage = fileMenuPage;
						break;
					}
					case UI_MMSubState.FileSelected:
					{
						if(instance_exists(selectedFilePage) && selectedFile != -1)
						{
							currentPage = selectedFilePage;
						}
						else
						{
							subState = UI_MMSubState.None;
						}
						break;
					}
					case UI_MMSubState.FileCopy:
					{
						if(instance_exists(copyFilePage) && selectedFile != -1)
						{
							currentPage = copyFilePage;
						}
						else
						{
							subState = UI_MMSubState.FileSelected;
						}
						break;
					}
					case UI_MMSubState.ConfirmCopy:
					{
						if(instance_exists(confirmCopyPage))
						{
							currentPage = confirmCopyPage;
						}
						else
						{
							subState = UI_MMSubState.FileCopy;
						}
						break;
					}
					case UI_MMSubState.ConfirmDelete:
					{
						if(instance_exists(confirmDeletePage))
						{
							currentPage = confirmDeletePage;
						}
						else
						{
							subState = UI_MMSubState.FileSelected;
						}
						break;
					}
				}
			}
			else
			{
				if(targetState == UI_MMState.LoadGame && fileIconFrame < 7)
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
			subState = UI_MMSubState.None;
			instance_destroy(fileMenuPage);
			instance_destroy(selectedFilePage);
			instance_destroy(copyFilePage);
			instance_destroy(confirmCopyPage);
			instance_destroy(confirmDeletePage);
		
			for(var i = 0; i < array_length(fileTime); i++)
			{
				fileTime[i] = -1;
				filePercent[i] = -1;
				fileEnergyMax[i] = -1;
				fileEnergy[i] = -1;
			}
		}
		
		if(state == UI_MMState.LoadGame)
		{
			scr_LoadGame(selectedFile);
		}
		else if(instance_exists(currentPage))
		{
			currentPage.UpdatePage();
		}
	}
	else
	{
		activeState = UI_ActiveState.Inactive;
	}
}
else
{
	screenFade = max(screenFade-screenFadeRate,0);
	
	fileIconFrame = 0;
	fileIconFrameCounter = 0;
	
	activeState = UI_ActiveState.Inactive;
	state = UI_MMState.TitleIntro;
	targetState = state;
	subState = UI_MMSubState.None;
	selectedFile = -1;
	
	for(var i = 0; i < ds_list_size(pageList); i++)
	{
		instance_destroy(pageList[| i]);
	}
	if(ds_list_size(pageList) > 0)
	{
		ds_list_clear(pageList);
	}
}

self.SetControlVars_Release();
