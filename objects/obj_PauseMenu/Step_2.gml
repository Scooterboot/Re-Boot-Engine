/// @description Menus
cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

var canPause = (room != rm_MainMenu && instance_exists(obj_Player) && obj_Player.state != State.Elevator && !instance_exists(obj_Transition) && 
(!instance_exists(obj_MessageBox) || obj_MessageBox.messageType == Message.Simple || obj_MessageBox.kill));

#region Pause Logic
if(canPause)
{
	if(instance_exists(obj_ControlOptions) && (obj_ControlOptions.selectedKey != -1 || obj_ControlOptions.keySelectDelay > 0))
	{
		isPaused = true;
	}
	else if(!loadGame && !gameEnd)
	{
		if(cStart && rStart && (pauseFade <= 0 || pauseFade >= 1))
		{
			isPaused = !isPaused;
		}
	}
	if(isPaused)
	{
		pauseFade = min(pauseFade + 0.075, 1);
	}
	else
	{
		pauseFade = max(pauseFade - 0.075, 0);
	}
	
	pause = (pauseFade > 0);
}
else
{
	isPaused = false;
	pause = false;
	pauseFade = 0;
}

if(pause)
{
	global.gamePaused = true;
	unpause = false;
}
else
{
	if(!unpause)
	{
		global.gamePaused = false;
		unpause = true;
	}
}
#endregion

if(canPause && pause && pauseFade >= 1 && !loadGame && !gameEnd)
{
	#region Menu Select
	if(screenSelect)
	{
		screenSelectAnim = min(screenSelectAnim + 0.1, 1);
	}
	else
	{
		screenSelectAnim = max(screenSelectAnim - 0.1, 0);
	}
	
	if(screenSelectAnim >= 1 && screenSelect)
	{
		screenSelectAnim = 1.5;
		if(cUp && rUp)
		{
			currentScreen = Screen.Map;
			screenSelect = false;
		}
		if(cDown && rDown)
		{
			currentScreen = Screen.Options;
			screenSelect = false;
		}
		if(cLeft && rLeft)
		{
			currentScreen = Screen.LogBook;
			screenSelect = false;
		}
		if(cRight && rRight)
		{
			currentScreen = Screen.Inventory;
			screenSelect = false;
		}
	}
	#endregion
	
	#region Populate Inventory Lists
	if(currentScreen = Screen.Inventory)
	{
		var P = obj_Player;
		
		if(!ds_exists(invListL,ds_type_list))
		{
			invListL = ds_list_create();
		}
		else if(ds_list_empty(invListL))
		{
			for(var i = 0; i < array_length(P.hasSuit); i++)
			{
				if(P.hasSuit[i])
				{
					ds_list_add(invListL,"Suit_"+string(i));
				}
			}
			for(var i = 0; i < array_length(P.hasBeam); i++)
			{
				if(P.hasBeam[i])
				{
					ds_list_add(invListL,"Beam_"+string(i));
				}
			}
			for(var i = 0; i < array_length(P.hasItem); i++)
			{
				if(P.hasItem[i])
				{
					ds_list_add(invListL,"Item_"+string(i));
				}
			}
		}
		if(!ds_exists(invListR,ds_type_list))
		{
			invListR = ds_list_create();
		}
		else if(ds_list_empty(invListR))
		{
			for(var i = 0; i < array_length(P.hasMisc); i++)
			{
				if(P.hasMisc[i])
				{
					ds_list_add(invListR,"Misc_"+string(i));
				}
			}
			for(var i = 0; i < array_length(P.hasBoots); i++)
			{
				if(P.hasBoots[i])
				{
					ds_list_add(invListR,"Boots_"+string(i));
				}
			}
		}
		
		if(invPos == -1)
		{
			if(!ds_list_empty(invListL))
			{
				invPos = 0;
				invPosX = 0;
			}
			else if(!ds_list_empty(invListR))
			{
				invPos = 0;
				invPosX = 1;
			}
		}
	}
	else
	{
		if(ds_exists(invListL,ds_type_list))
		{
			ds_list_clear(invListL);
		}
		if(ds_exists(invListR,ds_type_list))
		{
			ds_list_clear(invListR);
		}
	}
	#endregion
	
	if(screenSelectAnim <= 0 && !instance_exists(obj_DisplayOptions) && !instance_exists(obj_AudioOptions) && !instance_exists(obj_ControlOptions))
	{
		if(cCancel && rCancel && confirmRestart == -1 && confirmQuitMM == -1 && confirmQuitDT == -1)
		{
			screenSelect = true;
		}
		
		#region Map Screen
		if(currentScreen = Screen.Map)
		{
			var mapMoveX = (cRight) - (cLeft),
				mapMoveY = (cDown) - (cUp);
			
			if(mapMoveX != 0 || mapMoveY != 0)
			{
				mapMove = min(mapMove + 0.1, 1);
			}
			else
			{
				mapMove = 0;
			}
			
			if(global.rmMapSprt != noone)
			{
				mapX = clamp(mapX+mapMoveX*mapMove,16,sprite_get_width(global.rmMapSprt)-16);
				mapY = clamp(mapY+mapMoveY*mapMove,16,sprite_get_height(global.rmMapSprt)-16);
			}
		}
		else
		{
			mapX = (scr_floor(obj_Player.x/global.rmMapSize) + global.rmMapX) * 8 + 4;
			mapY = (scr_floor(obj_Player.y/global.rmMapSize) + global.rmMapY) * 8 + 4;
			if(global.rmMapSprt != noone)
			{
				mapX = clamp(mapX,16,sprite_get_width(global.rmMapSprt)-16);
				mapY = clamp(mapY,16,sprite_get_height(global.rmMapSprt)-16);
			}
			mapMove = 0;
		}
		#endregion
		#region Inventory Screen
		if(currentScreen = Screen.Inventory)
		{
			var P = obj_Player;
			
			if(invPos != -1)
			{
				toggleItem = (cSelect && rSelect);
				
				var invMove = (cDown && rDown) - (cUp && rUp);
				var invMoveX = (cRight && rRight) - (cLeft && rLeft);
				
				if(cDown || cUp)
				{
					invMoveCounter = min(invMoveCounter + 1, 30);
				}
				else
				{
					invMoveCounter = 0;
				}
				if(invMoveCounter >= 30)
				{
					invMove = cDown - cUp;
					invMoveCounter -= 5;
				}
				
				if(invMove != 0)
				{
					var limit = ds_list_size(invListL);
					if(invPosX == 1)
					{
						limit = ds_list_size(invListR);
					}
					if(limit > 1)
					{
						invPos = scr_wrap(invPos+invMove,0,limit-1);
						audio_play_sound(snd_MenuTick,0,false);
					}
				}
				var moveX = (invMoveX != 0 && ((invPosX == 0 && !ds_list_empty(invListR)) || (invPosX == 1 && !ds_list_empty(invListL))));
				if(moveX)
				{
					audio_play_sound(snd_MenuTick,0,false);
				}
				
				if(invPosX == 0)
				{
					var ability = invListL[| invPos];
					var index = string_digits(ability);
					
					if(moveX)
					{
						invPosX = 1;
						invPos = 0;
						if(string_pos("Item",ability) != 0)
						{
							for(var i = 0; i < ds_list_size(invListR); i++)
							{
								var pos = ds_list_find_value(invListR,i);
								if(string_pos("Boots",pos) != 0)
								{
									invPos = i;
									break;
								}
							}
						}
					}
					if(toggleItem)
					{
						if(string_pos("Suit",ability) != 0)
						{
							P.suit[index] = !P.suit[index];
						}
						if(string_pos("Beam",ability) != 0)
						{
							P.beam[index] = !P.beam[index];
						}
						if(string_pos("Item",ability) != 0)
						{
							toggleItem = false;
						}
						else
						{
							audio_play_sound(snd_MenuBoop,0,false);
						}
					}
				}
				else if(invPosX == 1)
				{
					var ability = invListR[| invPos];
					var index = string_digits(ability);
					
					if(moveX)
					{
						invPosX = 0;
						invPos = 0;
						if(string_pos("Misc",ability) != 0)
						{
							for(var i = 0; i < ds_list_size(invListL); i++)
							{
								var pos = ds_list_find_value(invListL,i);
								if(string_pos("Beam",pos) != 0)
								{
									invPos = i;
									break;
								}
							}
						}
						if(string_pos("Boots",ability) != 0)
						{
							for(var i = 0; i < ds_list_size(invListL); i++)
							{
								var pos = ds_list_find_value(invListL,i);
								if(string_pos("Item",pos) != 0)
								{
									invPos = i;
									break;
								}
							}
						}
					}
					if(toggleItem)
					{
						if(string_pos("Misc",ability) != 0)
						{
							P.misc[index] = !P.misc[index];
						}
						if(string_pos("Boots",ability) != 0)
						{
							P.boots[index] = !P.boots[index];
						}
						audio_play_sound(snd_MenuBoop,0,false);
					}
				}
			}
		}
		else
		{
			invMoveCounter = 0;

			invPos = -1;
			invPosX = 0;
			
			toggleItem = false;
		}
		#endregion
		#region Log Book Screen
		if(currentScreen = Screen.LogBook)
		{
			
		}
		#endregion
		#region Options Screen
		if(currentScreen = Screen.Options)
		{
			if(confirmRestart == -1 && confirmQuitMM == -1 && confirmQuitDT == -1)
			{
				var move = (cDown && rDown) - (cUp && rUp),
					select = (cSelect && rSelect);
			
				if(move != 0)
				{
					optionPos = scr_wrap(optionPos+move,0,array_length(option)-1);
					audio_play_sound(snd_MenuTick,0,false);
				}
			
				if(select)
				{
					select = false;
					if(optionPos >= 3 && optionPos <= 5)
					{
						audio_play_sound(snd_MenuTick,0,false);
					}
					else
					{
						audio_play_sound(snd_MenuBoop,0,false);
					}
					switch(optionPos)
					{
						case 0:
						{
							instance_create_depth(0,0,-1,obj_DisplayOptions);
							break;
						}
						case 1:
						{
							instance_create_depth(0,0,-1,obj_AudioOptions);
							break;
						}
						case 2:
						{
							instance_create_depth(0,0,-1,obj_ControlOptions);
							break;
						}
						case 3:
						{
							//global.rmMusic = noone;
							//loadGame = true;
							confirmRestart = 0;
							break;
						}
						case 4:
						{
							//global.rmMusic = noone;
							//gameEnd = true;
							confirmQuitMM = 0;
							break;
						}
						case 5:
						{
							//game_end();
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
					confirmPos = scr_wrap(confirmPos+move,0,1);
					audio_play_sound(snd_MenuTick,0,false);
				}
				
				if(cancel)
				{
					confirmPos = 0;
					confirmRestart = -1;
					confirmQuitMM = -1;
					confirmQuitDT = -1;
					audio_play_sound(snd_MenuTick,0,false);
				}
				else if(select)
				{
					if(confirmPos == 1)
					{
						audio_play_sound(snd_MenuBoop,0,false);
						if(confirmRestart >= 0)
						{
							global.rmMusic = noone;
							loadGame = true;
						}
						if(confirmQuitMM >= 0)
						{
							global.rmMusic = noone;
							gameEnd = true;
						}
						if(confirmQuitDT >= 0)
						{
							game_end();
						}
					}
					else
					{
						confirmRestart = -1;
						confirmQuitMM = -1;
						confirmQuitDT = -1;
						audio_play_sound(snd_MenuTick,0,false);
					}
				}
			}
		}
		else
		{
			optionPos = 0;
		}
		#endregion
	}
}
else if(loadGame)
{
	if(!gameLoaded)
	{
		if(loadFade >= 1.15)
		{
			scr_LoadGame(global.currentPlayFile);
			gameLoaded = true;
			isPaused = false;
			pause = false;
			pauseFade = 0;
		}
		loadFade = min(loadFade+0.075,1.15);
	}
	else
	{
		if(loadFade <= 0)
		{
			gameLoaded = false;
			loadGame = false;
		}
		loadFade = max(loadFade-0.075,0);
	}
}
else if(gameEnd)
{
	if(!gameEnded)
	{
		if(loadFade >= 1.15)
		{
			instance_destroy(obj_Player);
			instance_destroy(obj_Camera);
			room_goto(rm_MainMenu);
			gameEnded = true;
			isPaused = false;
			pause = false;
			pauseFade = 0;
		}
		loadFade = min(loadFade+0.075,1.15);
	}
	else
	{
		if(loadFade <= 0)
		{
			gameEnded = false;
			gameEnd = false;
		}
		loadFade = max(loadFade-0.075,0);
	}
}
else
{
	if(pauseFade <= 0)
	{
		screenSelect = false;
		screenSelectAnim = 0;
		currentScreen = Screen.Map;
		
		if(instance_exists(obj_Player))
		{
			mapX = (scr_floor(obj_Player.x/global.rmMapSize) + global.rmMapX) * 8 + 4;
			mapY = (scr_floor(obj_Player.y/global.rmMapSize) + global.rmMapY) * 8 + 4;
		}
		if(global.rmMapSprt != noone)
		{
			mapX = clamp(mapX,16,sprite_get_width(global.rmMapSprt)-16);
			mapY = clamp(mapY,16,sprite_get_height(global.rmMapSprt)-16);
		}
		mapMove = 0;

		invPos = -1;
		invPosX = 0;
		
		toggleItem = false;
		
		if(ds_exists(invListL,ds_type_list))
		{
			ds_list_clear(invListL);
		}
		if(ds_exists(invListR,ds_type_list))
		{
			ds_list_clear(invListR);
		}
		
		optionPos = 0;
		
		confirmPos = 0;
		confirmRestart = -1;
		confirmQuitMM = -1;
		confirmQuitDT = -1;
	}
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;