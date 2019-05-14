/// @description Menus
cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cNext = obj_Control.mNext;
cPrev = obj_Control.mPrev;
cStart = obj_Control.start;

var canPause = (room != rm_MainMenu && instance_exists(obj_Player));

if(canPause)
{
	if(cStart && rStart && (pauseFade <= 0 || pauseFade >= 1))
	{
		isPaused = !isPaused;
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
	
	if(screenSelectAnim <= 0)
	{
		if(cCancel && rCancel)
		{
			screenSelect = true;
		}
		
		#region Map Screen
		if(currentScreen = Screen.Map)
		{
			
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
			
			if(statusPos == -1)
			{
				if(ownBeam)
				{
					statusPos = 0;
				}
				else if(ownSuit)
				{
					statusPos = 2;
				}
				else if(ownBoots)
				{
					statusPos = 1;
				}
				else if(ownMisc)
				{
					statusPos = 3;
				}
			}
			else
			{
				toggleItem = (cSelect && rSelect);
				
				statusMove = (cDown && rDown) - (cUp && rUp);
				statusMoveX = (cRight && rRight) - (cLeft && rLeft);
				if(statusMove != 0)
				{
					statusMovePrev = statusMove;
					audio_play_sound(snd_MenuTick,0,false);
				}
				if(statusMoveX != 0 && ((statusPos < 2 && (ownSuit || ownMisc)) || (statusPos >= 2 && (ownBeam || ownBoots))))
				{
					statusMovePrev = 1;
					audio_play_sound(snd_MenuTick,0,false);
				}
				#region Beam Toggle
				if(statusPos == 0)
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
						beamSelect += statusMove;
						
						var num = array_length_1d(P.hasBeam);
						while(!P.hasBeam[scr_wrap(beamSelect,0,array_length_1d(P.hasBeam)-1)] && num > 0)
						{
							beamSelect += statusMovePrev;
							num--;
						}
						
						if(beamSelect < 0 || beamSelect >= array_length_1d(P.hasBeam))
						{
							if(ownBoots)
							{
								statusPos = 1;
								beamSelect = -1;
								if(statusMove < 0)
								{
									bootsSelect = array_length_1d(P.hasBoots)-1;
								}
								else
								{
									bootsSelect = 0;
								}
								statusMove = 0;
							}
							else
							{
								beamSelect = scr_wrap(beamSelect,0,array_length_1d(P.hasBeam)-1);
							}
						}
						
						if(statusMoveX != 0)
						{
							if(ownSuit)
							{
								statusPos = 2;
								beamSelect = -1;
								suitSelect = 0;
							}
							else if(ownMisc)
							{
								statusPos = 3;
								beamSelect = -1;
								miscSelect = 0;
							}
							statusMoveX = 0;
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
				if(statusPos == 1)
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
						bootsSelect += statusMove;
						
						var num = array_length_1d(P.hasBoots);
						while(!P.hasBoots[scr_wrap(bootsSelect,0,array_length_1d(P.hasBoots)-1)] && num > 0)
						{
							bootsSelect += statusMovePrev;
							num--;
						}
						
						if(bootsSelect < 0 || bootsSelect >= array_length_1d(P.hasBoots))
						{
							if(ownBeam)
							{
								statusPos = 0;
								bootsSelect = -1;
								if(statusMove < 0)
								{
									beamSelect = array_length_1d(P.hasBeam)-1;
								}
								else
								{
									beamSelect = 0;
								}
								statusMove = 0;
							}
							else
							{
								bootsSelect = scr_wrap(bootsSelect,0,array_length_1d(P.hasBoots)-1);
							}
						}
						
						if(statusMoveX != 0)
						{
							if(ownMisc)
							{
								statusPos = 3;
								bootsSelect = -1;
								miscSelect = 0;
							}
							else if(ownSuit)
							{
								statusPos = 2;
								bootsSelect = -1;
								suitSelect = 0;
							}
							statusMoveX = 0;
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
				if(statusPos == 2)
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
						suitSelect += statusMove;
						
						var num = array_length_1d(P.hasSuit);
						while(!P.hasSuit[scr_wrap(suitSelect,0,array_length_1d(P.hasSuit)-1)] && num > 0)
						{
							suitSelect += statusMovePrev;
							num--;
						}
						
						if(suitSelect < 0 || suitSelect >= array_length_1d(P.hasSuit))
						{
							if(ownMisc)
							{
								statusPos = 3;
								suitSelect = -1;
								if(statusMove < 0)
								{
									miscSelect = array_length_1d(P.hasMisc)-1;
								}
								else
								{
									miscSelect = 0;
								}
								statusMove = 0;
							}
							else
							{
								suitSelect = scr_wrap(suitSelect,0,array_length_1d(P.hasSuit)-1);
							}
						}
						
						if(statusMoveX != 0)
						{
							if(ownBeam)
							{
								statusPos = 0;
								suitSelect = -1;
								beamSelect = 0;
							}
							else if(ownBoots)
							{
								statusPos = 1;
								suitSelect = -1;
								bootsSelect = 0;
							}
							statusMoveX = 0;
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
				if(statusPos == 3)
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
						miscSelect += statusMove;
						
						var num = array_length_1d(P.hasMisc);
						while(!P.hasMisc[scr_wrap(miscSelect,0,array_length_1d(P.hasMisc)-1)] && num > 0)
						{
							miscSelect += statusMovePrev;
							num--;
						}
						
						if(miscSelect < 0 || miscSelect >= array_length_1d(P.hasMisc))
						{
							if(ownSuit)
							{
								statusPos = 2;
								miscSelect = -1;
								if(statusMove < 0)
								{
									suitSelect = array_length_1d(P.hasSuit)-1;
								}
								else
								{
									suitSelect = 0;
								}
								statusMove = 0;
							}
							else
							{
								miscSelect = scr_wrap(miscSelect,0,array_length_1d(P.hasMisc)-1);
							}
						}
						
						if(statusMoveX != 0)
						{
							if(ownBoots)
							{
								statusPos = 1;
								miscSelect = -1;
								bootsSelect = 0;
							}
							else if(ownBeam)
							{
								statusPos = 0;
								miscSelect = -1;
								beamSelect = 0;
							}
							statusMoveX = 0;
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
			statusMove = 0;
			statusMovePrev = 1;

			statusPos = -1;

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
			
		}
		#endregion
	}
}
else
{
	if(!canPause)
	{
		pauseFade = 0;
	}
	if(pauseFade <= 0)
	{
		screenSelect = false;
		screenSelectAnim = 0;
		currentScreen = Screen.Map;
	
		statusMove = 0;
		statusMovePrev = 1;

		statusPos = -1;

		beamSelect = -1;
		suitSelect = -1;
		bootsSelect = -1;
		miscSelect = -1;
	}
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rNext = !cNext;
rPrev = !cPrev;
rStart = !cStart;