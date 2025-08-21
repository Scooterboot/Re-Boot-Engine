/// @description Menus
SetControlVars(controlGroups);
cRight = cMenuRight;
cLeft = cMenuLeft;
cUp = cMenuUp;
cDown = cMenuDown;
cSelect = cMenuAccept;
cCancel = cMenuCancel;

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
	if(screen == 3 && optionPos == 2 && (cRight || cLeft))
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
	
	if(selectedKey != -1 || keySelectDelay > 0)
	{
		move = 0;
		moveX = 0;
		select = false;
		cancel = false;
		moveCounter = 0;
		moveCounterX = 0;
	}
	
	if(move != 0)
	{
		optionPos += move;
		movePrev = move;
		audio_play_sound(snd_MenuTick,0,false);
	}
	if(screen == 0)
	{
		/*if(global.gpSlot <= -1 && optionPos == 6)
		{
			optionPos += movePrev;
		}*/
		optionPos = scr_wrap(optionPos,0,array_length(option));
		if(select || (moveX != 0 && optionPos < 4))
		{
			if(optionPos >= 4)
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
					//HUD Style
					global.HUD = scr_wrap(global.HUD+moveX+select,0,3);
					break;
				}
				case 1:
				{
					//Aim Style
					global.aimStyle = scr_wrap(global.aimStyle+moveX+select,0,3);
					break;
				}
				case 2:
				{
					//Auto-Sprint
					global.autoSprint = !global.autoSprint;
					break;
				}
				case 3:
				{
					//Quick-Climb
					global.quickClimb = !global.quickClimb;
					break;
				}
				case 4:
				{
					//Moar Options
					select = false;
					screen = 1;
					prevOptionPos = optionPos;
					optionPos = 0;
					break;
				}
				case 5:
				{
					//Keyboard bindings
					select = false;
					//screen = 2;
					//prevOptionPos = optionPos;
					//optionPos = 0;
					break;
				}
				case 6:
				{
					//Controller bindings
					select = false;
					//screen = 3;
					//prevOptionPos = optionPos;
					//optionPos = 0;
					break;
				}
				case 7:
				{
					//Back
					menuClosing = true;
					break;
				}
			}
			
			currentOption = [
			global.HUD,
			global.aimStyle,
			global.autoSprint,
			global.quickClimb];
			
			ini_open("settings.ini");
			ini_write_real("Controls", "hud style", global.HUD);
			ini_write_real("Controls", "aim style", global.aimStyle);
			ini_write_real("Controls", "auto sprint", global.autoSprint);
			ini_write_real("Controls", "quick climb", global.quickClimb);
			ini_close();
		}
		if(cancel)
		{
			audio_play_sound(snd_MenuBoop,0,false);
			menuClosing = true;
		}
	}
	else if(cancel)
	{
		optionPos = prevOptionPos;
		screen = 0;
		movePrev = -1;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	if(screen == 1)
	{
		optionPos = scr_wrap(optionPos,0,array_length(advOption));
		if(select || (moveX != 0 && optionPos < 4))
		{
			if(optionPos >= 4)
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
					//Grip climb style
					global.gripStyle = scr_wrap(global.gripStyle+moveX+select,0,3);
					break;
				}
				case 1:
				{
					//Grapple reel style
					global.grappleStyle = scr_wrap(global.grappleStyle+moveX+select,0,2);
					break;
				}
				case 2:
				{
					//Spider ball control
					global.spiderBallStyle = scr_wrap(global.spiderBallStyle+moveX+select,0,2);//3);
					break;
				}
				case 3:
				{
					//Accel dash control
					global.dodgeStyle = scr_wrap(global.dodgeStyle+moveX+select,0,2);
					break;
				}
				case 4:
				{
					//Back
					optionPos = prevOptionPos;
					screen = 0;
					break;
				}
			}
			
			advCurrentOption = [
			global.gripStyle,
			global.grappleStyle,
			global.spiderBallStyle,
			global.dodgeStyle];
			
			ini_open("settings.ini");
			ini_write_real("Controls", "grip control", global.gripStyle);
			ini_write_real("Controls", "grapple control", global.grappleStyle);
			ini_write_real("Controls", "spiderball control", global.spiderBallStyle);
			ini_write_real("Controls", "dodge control", global.dodgeStyle);
			ini_close();
		}
	}
	/*if(screen == 2)
	{
		if(global.aimStyle != 0 && optionPos == 8)
		{
			optionPos += movePrev;
		}
		optionPos = scr_wrap(optionPos,0,array_length(controlKey));
		if(select)
		{
			if(optionPos < array_length(controlKey)-2)
			{
				if(selectedKey == -1)
				{
					selectedKey = optionPos;
					keySelectDelay = 5;
				}
			}
			else if(optionPos < array_length(controlKey)-1)
			{
				global.key[0] = vk_up;
				global.key[1] = vk_down;
				global.key[2] = vk_left;
				global.key[3] = vk_right;
				global.key[4] = ord("Z");
				global.key[5] = ord("X");
				global.key[6] = ord("C");
				global.key[7] = ord("S");
				global.key[8] = ord("A");
				global.key[9] = ord("D");
				global.key[10] = ord("V");
				global.key[11] = ord("Q");
				global.key[12] = ord("W");
				global.key_m[0] = vk_enter;
				global.key_m[1] = ord("Z");
				global.key_m[2] = ord("X");
				scr_SaveKeyboard(global.key[0],0);
				for(var i = 0; i < array_length(global.key); i++)
				{
					currentControlKey[i] = global.key[i];
				}
				for(var i = 0; i < array_length(global.key_m); i++)
				{
					currentControlKey[i+array_length(global.key)] = global.key_m[i];
				}
				audio_play_sound(snd_MenuBoop,0,false);
			}
			else
			{
				optionPos = prevOptionPos;
				screen = 0;
				audio_play_sound(snd_MenuBoop,0,false);
			}
		}
		if(selectedKey >= 0)
		{
			if(keySelectDelay <= 0)
			{
				if(keyboard_check_pressed(vk_anykey))
				{
					audio_play_sound(snd_MenuBoop,0,false);
					var newKey = keyboard_key;
					if(newKey != vk_escape)
					{
						scr_SaveKeyboard(newKey,selectedKey);
						
						for(var i = 0; i < array_length(global.key); i++)
						{
							currentControlKey[i] = global.key[i];
						}
						for(var i = 0; i < array_length(global.key_m); i++)
						{
							currentControlKey[i+array_length(global.key)] = global.key_m[i];
						}
					}
					selectedKey = -1;
					keySelectDelay = 10;
				}
				if(gamepad_button_check_pressed(global.gpSlot,gp_anybutton()))
				{
					selectedKey = -1;
					keySelectDelay = 10;
				}
			}
		}
	}
	if(screen == 3)
	{
		if(global.aimStyle != 0 && optionPos == 7)
		{
			optionPos += movePrev;
		}
		optionPos = scr_wrap(optionPos,0,array_length(controlButton));
		if(select || (moveX != 0 && optionPos <= 2))
		{
			if(optionPos < array_length(controlButton)-2)
			{
				if(selectedKey == -1)
				{
					if(optionPos >= 3)
					{
						selectedKey = optionPos-3;
						keySelectDelay = 5;
					}
					else
					{
						if(optionPos == 0)
						{
							global.gp_usePad = !global.gp_usePad;
							if(!global.gp_usePad && !global.gp_useStick)
							{
								global.gp_useStick = true;
							}
							audio_play_sound(snd_MenuTick,0,false);
						}
						if(optionPos == 1)
						{
							global.gp_useStick = !global.gp_useStick;
							if(!global.gp_usePad && !global.gp_useStick)
							{
								global.gp_usePad = true;
							}
							audio_play_sound(snd_MenuTick,0,false);
						}
						if(optionPos == 2)
						{
							if(moveX != 0)
							{
								global.gp_deadZone = clamp(global.gp_deadZone + 0.01*moveX,0.1,0.9);
								audio_play_sound(snd_Menu_Cursor_1,0,false);
							}
						}
						
						currentControlButton[0] = global.gp_usePad;
						currentControlButton[1] = global.gp_useStick;
						currentControlButton[2] = global.gp_deadZone;
						
						ini_open("settings.ini");
						ini_write_real("Gamepad", "enable dpad", global.gp_usePad);
						ini_write_real("Gamepad", "enable left stick", global.gp_useStick);
						ini_write_real("Gamepad", "dead zone", global.gp_deadZone);
						ini_close();
					}
				}
			}
			else if(optionPos < array_length(controlButton)-1)
			{
				global.gp_usePad = true;
				global.gp_useStick = true;
				global.gp_deadZone = 0.5;

				global.gp[0] = gp_face1;
				global.gp[1] = gp_face3;
				global.gp[2] = gp_face2;
				global.gp[3] = gp_shoulderrb;
				global.gp[4] = gp_shoulderlb;
				global.gp[5] = gp_shoulderl;
				global.gp[6] = gp_shoulderr;
				global.gp[7] = gp_select;
				global.gp[8] = gp_face4;

				global.gp_m[0] = gp_start;
				global.gp_m[1] = gp_face1;
				global.gp_m[2] = gp_face2;
				scr_SaveGamepad(global.gp[0],0);
				
				currentControlButton[0] = global.gp_usePad;
				currentControlButton[1] = global.gp_useStick;
				currentControlButton[2] = global.gp_deadZone;
				for(var i = 0; i < array_length(global.gp); i++)
				{
					currentControlButton[i+3] = global.gp[i];
				}
				for(var i = 0; i < array_length(global.gp_m); i++)
				{
					currentControlButton[i+3+array_length(global.gp)] = global.gp_m[i];
				}
				audio_play_sound(snd_MenuBoop,0,false);
			}
			else
			{
				optionPos = prevOptionPos;
				screen = 0;
				movePrev = -1;
				audio_play_sound(snd_MenuBoop,0,false);
			}
		}
		if(selectedKey >= 0)
		{
			if(keySelectDelay <= 0)
			{
				if(gamepad_button_check_pressed(global.gpSlot, gp_anybutton()))
				{
					audio_play_sound(snd_MenuBoop,0,false);
					var newButton = gp_anybutton();
					if (newButton != gp_padr && newButton != gp_padl && newButton != gp_padu && newButton != gp_padd && 
						newButton != gp_axislh && newButton != gp_axislv && newButton != gp_axisrh && newButton != gp_axisrv)
					{
						scr_SaveGamepad(newButton,selectedKey);
						
						for(var i = 0; i < array_length(global.gp); i++)
						{
							currentControlButton[i+3] = global.gp[i];
						}
						for(var i = 0; i < array_length(global.gp_m); i++)
						{
							currentControlButton[i+3+array_length(global.gp)] = global.gp_m[i];
						}
					}
					selectedKey = -1;
					keySelectDelay = 10;
				}
				if(keyboard_check_pressed(vk_anykey))
				{
					selectedKey = -1;
					keySelectDelay = 10;
				}
			}
		}
	}*/
}

/*if(global.gpSlot != -1)
{
	option[6] = gpFound;
}
else
{
	option[6] = gpNotFound;
}*/

controlKey[12] = cNameHUD[global.HUD];
controlButton[11] = controlKey[12];

controlKey[7] = cNameAim[(global.aimStyle != 0)];
controlButton[6] = controlKey[7];

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

keySelectDelay = max(keySelectDelay - 1, 0);

SetReleaseVars(controlGroups);
rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;