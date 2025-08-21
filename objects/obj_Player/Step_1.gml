/// @description HUD Control
SetControlVars("menu hud visor");

#region Check any visor exists
var anyVisor = false;
for(var i = 0; i < array_length(hudVisor); i++)
{
	if(HasHUDVisor(i))
	{
		anyVisor = true;
		break;
	}
}
if(!anyVisor)
{
	hudVisorIndex = -1;
	hudAltVisorIndex = -1;
}
else
{
	if(!HasHUDVisor(hudAltVisorIndex))
	{
		hudVisorIndex = -1;
		hudAltVisorIndex = -1;
	}
	
	if(hudAltVisorIndex == -1)
	{
		for(var i = 0; i < array_length(hudVisor); i++)
		{
			if(HasHUDVisor(i))
			{
				hudAltVisorIndex = i;
				break;
			}
		}
	}
}
#endregion
#region Check any off-hand weapon exists
var anyWeap = false;
for(var i = 0; i < array_length(hudWeapon); i++)
{
	if(HasHUDWeapon(i))
	{
		anyWeap = true;
		break;
	}
}
if(!anyWeap)
{
	hudWeaponIndex = -1;
	hudAltWeaponIndex = -1;
}
else
{
	if(!HasHUDWeapon(hudAltWeaponIndex))
	{
		hudWeaponIndex = -1;
		hudAltWeaponIndex = -1;
	}
	
	if(hudAltWeaponIndex == -1)
	{
		for(var i = 0; i < array_length(hudWeapon); i++)
		{
			if(HasHUDWeapon(i))
			{
				hudAltWeaponIndex = i;
				break;
			}
		}
	}
}
#endregion

if(state == State.Elevator || state == State.Recharge || state == State.CrystalFlash || introAnimState != -1)
{
	InitControlVars("hud visor");
	
	hudPauseAnim = 0;
	uiState = PlayerUIState.None;
	pauseSelect = false;
	
	SetReleaseVars("menu");
	exit;
}

if(!global.roomTrans && !obj_PauseMenu.pause)
{
	if(cWeapHUDOpen && hudVisorIndex != HUDVisor.Scan && hudVisorIndex != HUDVisor.XRay)
	{
		uiState = PlayerUIState.WeapWheel;
	}
	if(cVisorHUDOpen)
	{
		uiState = PlayerUIState.VisorWheel;
	}
	
	if(uiState != PlayerUIState.None)
	{
		if(cWeapHUDOpen || cVisorHUDOpen)
		{
			hudPauseAnim = min(hudPauseAnim + 0.2, 1);
		}
		else
		{
			hudPauseAnim = max(hudPauseAnim - 0.34, 0);
			if(hudPauseAnim <= 0)
			{
				uiState = PlayerUIState.None;
			}
		}
	}
	
	if(hudPauseAnim > 0)
	{
		pauseSelect = true;
		global.gamePaused = true;
	}
	else
	{
		if(pauseSelect)
		{
			global.gamePaused = false;
		}
		pauseSelect = false;
	}
	
	#region Weapon Wheel
	if(uiState == PlayerUIState.WeapWheel)
	{
		var hMoveDir = InputDirection(0, INPUT_CLUSTER.WeapHUDMove),
			hMoveDist = InputDistance(INPUT_CLUSTER.WeapHUDMove) * hudSelectWheelSize;
		
		if(hMoveDist >= hudSelectWheelMin)
		{
			var _len = array_length(hudWeapon),
				_rad = 360/_len;
			for(var i = 0; i < _len; i++)
			{
				if(HasHUDWeapon(i))
				{
					var _dir = 90 - _rad*i;
					if(abs(angle_difference(_dir,hMoveDir)) < (_rad/2))
					{
						if(HUDWeaponHasAmmo(i))
						{
							if(hudWeaponIndex != i)
							{
								audio_play_sound(snd_MenuTick,0,false);
							}
							hudAltWeaponIndex = i;
							hudWeaponIndex = i;
						}
						else if(hudAltWeaponIndex != i)
						{
							audio_play_sound(snd_MenuTick,0,false);
							hudAltWeaponIndex = i;
							hudWeaponIndex = -1;
						}
					}
				}
			}
		}
	}
	#endregion
	#region Visor Wheel
	if(uiState == PlayerUIState.VisorWheel)
	{
		var hMoveDir = InputDirection(0, INPUT_CLUSTER.VisorHUDMove),
			hMoveDist = InputDistance(INPUT_CLUSTER.VisorHUDMove) * hudSelectWheelSize;
		
		if(hMoveDist >= hudSelectWheelMin)
		{
			var _len = array_length(hudVisor),
				_rad = 360/_len;
			for(var i = 0; i < _len; i++)
			{
				if(HasHUDVisor(i))
				{
					var _dir = 90 - _rad*i;
					if(abs(angle_difference(_dir,hMoveDir)) < (_rad/2))
					{
						/*if(hudVisorIndex == hudAltVisorIndex)
						{
							if(hudVisorIndex != i)
							{
								audio_play_sound(snd_MenuTick,0,false);
							}
							hudAltVisorIndex = i;
							hudVisorIndex = i;
						}
						else*/ if(hudAltVisorIndex != i)
						{
							audio_play_sound(snd_MenuTick,0,false);
							hudAltVisorIndex = i;
							hudVisorIndex = -1;
						}
					}
				}
			}
		}
	}
	#endregion
	
	#region Toggle current weapon
	if(HUDWeaponHasAmmo(hudAltWeaponIndex) && (hudWeaponIndex == -1 || hudWeaponIndex == hudAltWeaponIndex))
	{
		if(hudVisorIndex != HUDVisor.Scan && hudVisorIndex != HUDVisor.XRay)
		{
			if(hudWeaponIndex == -1)
			{
				if(cWeapToggleOn && rWeapToggleOn)
				{
					hudWeaponIndex = hudAltWeaponIndex;
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			else if(cWeapToggleOff && rWeapToggleOff)
			{
				hudWeaponIndex = -1;
				audio_play_sound(snd_MenuTick,0,false);
			}
		}
	}
	else
	{
		if(hudWeaponIndex >= 0)
		{
			audio_play_sound(snd_MenuTick,0,false);
		}
		hudWeaponIndex = -1;
	}
	#endregion
	#region Toggle current visor
	
	var _tVisorOn = (cVisorToggleOn && rVisorToggleOn),
		_tVisorOff = (cVisorToggleOff && rVisorToggleOff);
	if(hudAltVisorIndex == HUDVisor.Scan)
	{
		_tVisorOn &= !cFire;
		_tVisorOff |= cFire;
	}
	
	if(HasHUDVisor(hudAltVisorIndex) && (hudVisorIndex == -1 || hudVisorIndex == hudAltVisorIndex))
	{
		var canUseVisor = true;
		if(hudAltVisorIndex == HUDVisor.XRay)
		{
			canUseVisor = false;
			
			var canXRay = true;
			if(state == State.Grip)
			{
				var rcheck = x+6,// - 1,
					lcheck = x;// - 1;
				if(grippedDir == -1)
				{
					rcheck = x;
					lcheck = x-6;
				}
				if(collision_line(lcheck,y-17,rcheck,y-17,obj_CrumbleBlock,false,true))
				{
					canXRay = false;
				}
			}
			else if(grounded)
			{
				var block_bl = instance_position(bb_left(),bb_bottom()+1,solids),
					block_br = instance_position(bb_right(),bb_bottom()+1,solids),
					platform = collision_line(bb_left(),bb_bottom()+1,bb_right(),bb_bottom()+1,obj_Platform,true,true);
				if ((!instance_exists(block_bl) xor (instance_exists(block_bl) && block_bl.object_index == obj_CrumbleBlock)) && 
					(!instance_exists(block_br) xor (instance_exists(block_br) && block_br.object_index == obj_CrumbleBlock)) && 
					!instance_exists(platform))
				{
					canXRay = false;
				}
			}
			
			if(canXRay && dir != 0 && fVelX == 0 && fVelY == 0 && !cPlayerRight && !cPlayerLeft && 
				(((stateFrame == State.Stand || stateFrame == State.Crouch) && grounded) || stateFrame == State.Grip))
			{
				canUseVisor = true;
			}
		}
		
		if(canUseVisor)
		{
			if(hudVisorIndex == -1)
			{
				if(_tVisorOn)
				{
					hudVisorIndex = hudAltVisorIndex;
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			else if(_tVisorOff)
			{
				hudVisorIndex = -1;
				audio_play_sound(snd_MenuTick,0,false);
			}
		}
		else
		{
			hudVisorIndex = -1;
		}
	}
	else
	{
		hudVisorIndex = -1;
	}
	
	#endregion
	
	#region Scan Visor control
	
	if(hudVisorIndex == HUDVisor.Scan)
	{
		if(instance_exists(scanVisor))
		{
			var moveX = InputX(INPUT_CLUSTER.VisorMove),
				moveY = InputY(INPUT_CLUSTER.VisorMove);
			
			if(!pauseSelect)
			{
				var mspd = 5;
				scanVisor.x += moveX*mspd;
				scanVisor.y += moveY*mspd;
			}
		}
		else
		{
			scanVisor = instance_create_depth(global.resWidth/2, global.resHeight/2, -1, obj_ScanVisor);
		}
	}
	else
	{
		if(instance_exists(scanVisor))
        {
            scanVisor.kill = true;
        }
	}
	
	#endregion
	#region XRay Visor control
	
	if(hudVisorIndex == HUDVisor.XRay)
	{
		var xpos = new Vector2(x + 3*dir, y - 12);
		if(stateFrame == State.Grip)
		{
			if(dir == grippedDir)
			{
				xpos.X = x;
			}
			else
			{
				xpos.X = x + 5*dir;
			}
		}
					
		if(instance_exists(xrayVisor))
		{
			xrayVisor.x = xpos.X;
			xrayVisor.y = xpos.Y;
			
			if(!pauseSelect)
			{
				var moveDir = InputDirection(0,INPUT_CLUSTER.VisorMove),
					moveDist = InputDistance(INPUT_CLUSTER.VisorMove);
				
				if(moveDist > 0)
				{
					var destAng = scr_round(angle_difference(moveDir, xrayVisor.coneDir));
					xrayVisor.coneDir += min(abs(destAng), 4 * moveDist) * sign(destAng);
				}
				
				var _dir = sign(lengthdir_x(16, xrayVisor.coneDir));
				if(_dir != 0)
				{
					dir = _dir;
					if(dir != oldDir)
					{
						lastDir = oldDir;
					}
					oldDir = dir;
				}
			}
		}
		else
		{
			var xrayDepth = layer_get_depth(layer_get_id("Tiles_fade0")) - 1;
			xrayVisor = instance_create_depth(xpos.X, xpos.Y, xrayDepth, obj_XRayVisor);
			xrayVisor.kill = 0;
			xrayVisor.coneDir = 90-(dir*90);
			global.gamePaused = true;
		}
	}
	else
	{
		if(instance_exists(xrayVisor))
        {
            xrayVisor.kill = true;
        }
	}
	
	#endregion
}

SetReleaseVars("menu hud visor");