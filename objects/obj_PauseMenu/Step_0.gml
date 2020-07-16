/// @description Menus
cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;

var canPause = (room != rm_MainMenu && instance_exists(obj_Player));

if(canPause)
{
	if(instance_exists(obj_ControlOptions) && (obj_ControlOptions.selectedKey != -1 || obj_ControlOptions.keySelectDelay > 0))
	{
		isPaused = true;
	}
	else
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

if(canPause && pause && pauseFade >= 1)
{
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
	
	if(screenSelectAnim <= 0 && !instance_exists(obj_DisplayOptions) && !instance_exists(obj_AudioOptions) && !instance_exists(obj_ControlOptions))
	{
		if(cCancel && rCancel)
		{
			screenSelect = true;
		}
		
		#region Map Screen
		if(currentScreen = Screen.Map)
		{
			var P = obj_Player;
			
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
			mapX = (scr_floor(obj_Player.x/global.resWidth) + global.rmMapX) * 8 + 4;
			mapY = (scr_floor(obj_Player.y/global.resWidth) + global.rmMapY) * 8 + 4;
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
			
			var ownBeam = false;
			for(var i = 0; i < array_length_1d(P.hasBeam); i++)
			{
				if(P.hasBeam[i])
				{
					ownBeam = true;
					break;
				}
			}
			var ownSuit = false;
			for(var i = 0; i < array_length_1d(P.hasSuit); i++)
			{
				if(P.hasSuit[i])
				{
					ownSuit = true;
					break;
				}
			}
			var ownBoots = false;
			for(var i = 0; i < array_length_1d(P.hasBoots); i++)
			{
				if(P.hasBoots[i])
				{
					ownBoots = true;
					break;
				}
			}
			var ownMisc = false;
			for(var i = 0; i < array_length_1d(P.hasMisc); i++)
			{
				if(P.hasMisc[i])
				{
					ownMisc = true;
					break;
				}
			}
			
			if(invPos == -1)
			{
				if(ownBeam)
				{
					invPos = 0;
				}
				else if(ownSuit)
				{
					invPos = 2;
				}
				else if(ownBoots)
				{
					invPos = 1;
				}
				else if(ownMisc)
				{
					invPos = 3;
				}
			}
			else
			{
				toggleItem = (cSelect && rSelect);
				
				invMove = (cDown && rDown) - (cUp && rUp);
				invMoveX = (cRight && rRight) - (cLeft && rLeft);
				
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
					invMovePrev = invMove;
					audio_play_sound(snd_MenuTick,0,false);
				}
				if(invMoveX != 0 && ((invPos < 2 && (ownSuit || ownMisc)) || (invPos >= 2 && (ownBeam || ownBoots))))
				{
					invMovePrev = 1;
					audio_play_sound(snd_MenuTick,0,false);
				}
				#region Beam Toggle
				if(invPos == 0)
				{
					suitSelect = -1;
					bootsSelect = -1;
					miscSelect = -1;
					
					if(beamSelect == -1)
					{
						beamSelect = 0;
					}
					else
					{
						beamSelect += invMove;
						
						var num = array_length_1d(P.hasBeam);
						while(!P.hasBeam[scr_wrap(beamSelect,0,array_length_1d(P.hasBeam)-1)] && num > 0)
						{
							beamSelect += invMovePrev;
							num--;
						}
						
						if(beamSelect < 0 || beamSelect >= array_length_1d(P.hasBeam))
						{
							if(ownBoots)
							{
								invPos = 1;
								beamSelect = -1;
								if(invMove < 0)
								{
									bootsSelect = array_length_1d(P.hasBoots)-1;
								}
								else
								{
									bootsSelect = 0;
								}
								invMove = 0;
							}
							else
							{
								beamSelect = scr_wrap(beamSelect,0,array_length_1d(P.hasBeam)-1);
							}
						}
						
						if(invMoveX != 0)
						{
							if(ownSuit)
							{
								invPos = 2;
								beamSelect = -1;
								suitSelect = 0;
							}
							else if(ownMisc)
							{
								invPos = 3;
								beamSelect = -1;
								miscSelect = 0;
							}
							invMoveX = 0;
						}
						
						if(toggleItem && beamSelect == clamp(beamSelect,0,array_length_1d(P.hasBeam)-1) && P.hasBeam[beamSelect])
						{
							P.beam[beamSelect] = !P.beam[beamSelect];
							audio_play_sound(snd_MenuBoop,0,false);
						}
					}
				}
				#endregion
				#region Boots Toggle
				if(invPos == 1)
				{
					suitSelect = -1;
					beamSelect = -1;
					miscSelect = -1;
					
					if(bootsSelect == -1)
					{
						bootsSelect = 0;
					}
					else
					{
						bootsSelect += invMove;
						
						var num = array_length_1d(P.hasBoots);
						while(!P.hasBoots[scr_wrap(bootsSelect,0,array_length_1d(P.hasBoots)-1)] && num > 0)
						{
							bootsSelect += invMovePrev;
							num--;
						}
						
						if(bootsSelect < 0 || bootsSelect >= array_length_1d(P.hasBoots))
						{
							if(ownBeam)
							{
								invPos = 0;
								bootsSelect = -1;
								if(invMove < 0)
								{
									beamSelect = array_length_1d(P.hasBeam)-1;
								}
								else
								{
									beamSelect = 0;
								}
								invMove = 0;
							}
							else
							{
								bootsSelect = scr_wrap(bootsSelect,0,array_length_1d(P.hasBoots)-1);
							}
						}
						
						if(invMoveX != 0)
						{
							if(ownMisc)
							{
								invPos = 3;
								bootsSelect = -1;
								miscSelect = 0;
							}
							else if(ownSuit)
							{
								invPos = 2;
								bootsSelect = -1;
								suitSelect = 0;
							}
							invMoveX = 0;
						}
						
						if(toggleItem && bootsSelect == clamp(bootsSelect,0,array_length_1d(P.hasBoots)-1) && P.hasBoots[bootsSelect])
						{
							P.boots[bootsSelect] = !P.boots[bootsSelect];
							audio_play_sound(snd_MenuBoop,0,false);
						}
					}
				}
				#endregion
				#region Suit Toggle
				if(invPos == 2)
				{
					beamSelect = -1;
					bootsSelect = -1;
					miscSelect = -1;
					
					if(suitSelect == -1)
					{
						suitSelect = 0;
					}
					else
					{
						suitSelect += invMove;
						
						var num = array_length_1d(P.hasSuit);
						while(!P.hasSuit[scr_wrap(suitSelect,0,array_length_1d(P.hasSuit)-1)] && num > 0)
						{
							suitSelect += invMovePrev;
							num--;
						}
						
						if(suitSelect < 0 || suitSelect >= array_length_1d(P.hasSuit))
						{
							if(ownMisc)
							{
								invPos = 3;
								suitSelect = -1;
								if(invMove < 0)
								{
									miscSelect = array_length_1d(P.hasMisc)-1;
								}
								else
								{
									miscSelect = 0;
								}
								invMove = 0;
							}
							else
							{
								suitSelect = scr_wrap(suitSelect,0,array_length_1d(P.hasSuit)-1);
							}
						}
						
						if(invMoveX != 0)
						{
							if(ownBeam)
							{
								invPos = 0;
								suitSelect = -1;
								beamSelect = 0;
							}
							else if(ownBoots)
							{
								invPos = 1;
								suitSelect = -1;
								bootsSelect = 0;
							}
							invMoveX = 0;
						}
						
						if(toggleItem && suitSelect == clamp(suitSelect,0,array_length_1d(P.hasSuit)-1) && P.hasSuit[suitSelect])
						{
							P.suit[suitSelect] = !P.suit[suitSelect];
							if(P.dir == 0 && P.state == State.Stand)
							{
								P.bodyFrame = P.suit[Suit.Varia];
							}
							audio_play_sound(snd_MenuBoop,0,false);
						}
					}
				}
				#endregion
				#region Misc Toggle
				if(invPos == 3)
				{
					beamSelect = -1;
					bootsSelect = -1;
					suitSelect = -1;
					
					if(miscSelect == -1)
					{
						miscSelect = 0;
					}
					else
					{
						miscSelect += invMove;
						
						var num = array_length_1d(P.hasMisc);
						while(!P.hasMisc[scr_wrap(miscSelect,0,array_length_1d(P.hasMisc)-1)] && num > 0)
						{
							miscSelect += invMovePrev;
							num--;
						}
						
						if(miscSelect < 0 || miscSelect >= array_length_1d(P.hasMisc))
						{
							if(ownSuit)
							{
								invPos = 2;
								miscSelect = -1;
								if(invMove < 0)
								{
									suitSelect = array_length_1d(P.hasSuit)-1;
								}
								else
								{
									suitSelect = 0;
								}
								invMove = 0;
							}
							else
							{
								miscSelect = scr_wrap(miscSelect,0,array_length_1d(P.hasMisc)-1);
							}
						}
						
						if(invMoveX != 0)
						{
							if(ownBoots)
							{
								invPos = 1;
								miscSelect = -1;
								bootsSelect = 0;
							}
							else if(ownBeam)
							{
								invPos = 0;
								miscSelect = -1;
								beamSelect = 0;
							}
							invMoveX = 0;
						}
						
						if(toggleItem && miscSelect == clamp(miscSelect,0,array_length_1d(P.hasMisc)-1) && P.hasMisc[miscSelect])
						{
							P.misc[miscSelect] = !P.misc[miscSelect];
							audio_play_sound(snd_MenuBoop,0,false);
						}
					}
				}
				#endregion
			}
		}
		else
		{
			invMove = 0;
			invMovePrev = 1;
			invMoveX = 0;

			invMoveCounter = 0;

			invPos = -1;

			beamSelect = -1;
			suitSelect = -1;
			bootsSelect = -1;
			miscSelect = -1;
			
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
						// load save
						break;
					}
					case 4:
					{
						room_goto(rm_MainMenu);
						global.gamePaused = false;
						game_restart();
						break;
					}
					case 5:
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
		#endregion
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
			mapX = (scr_floor(obj_Player.x/global.resWidth) + global.rmMapX) * 8 + 4;
			mapY = (scr_floor(obj_Player.y/global.resWidth) + global.rmMapY) * 8 + 4;
		}
		if(global.rmMapSprt != noone)
		{
			mapX = clamp(mapX,16,sprite_get_width(global.rmMapSprt)-16);
			mapY = clamp(mapY,16,sprite_get_height(global.rmMapSprt)-16);
		}
		mapMove = 0;
	
		invMove = 0;
		invMovePrev = 1;

		invPos = -1;

		beamSelect = -1;
		suitSelect = -1;
		bootsSelect = -1;
		miscSelect = -1;
		
		optionPos = 0;
	}
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;