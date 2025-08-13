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
				if(dir == -1)
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
				if(cVisorToggleOn && rVisorToggleOn)
				{
					hudVisorIndex = hudAltVisorIndex;
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			else if(cVisorToggleOff && rVisorToggleOff)
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
		if(instance_exists(Scan))
		{
			var moveX = InputX(INPUT_CLUSTER.VisorMove),
				moveY = InputY(INPUT_CLUSTER.VisorMove);
			
			if(!pauseSelect)
			{
				var mspd = 5;
				Scan.x += moveX*mspd;
				Scan.y += moveY*mspd;
			}
		}
		else
		{
			Scan = instance_create_depth(x, y, -1, obj_ScanVisor);
			Scan.x = camera_get_view_x(view_camera[0]) + global.resWidth/2;
			Scan.y = camera_get_view_y(view_camera[0]) + global.resHeight/2;
		}
	}
	else
	{
		if(instance_exists(Scan))
        {
            Scan.kill = true;
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
					
		if(instance_exists(XRay))
		{
			XRay.x = xpos.X;
			XRay.y = xpos.Y;
			
			if(!pauseSelect)
			{
				var moveDir = InputDirection(0,INPUT_CLUSTER.VisorMove),
					moveDist = InputDistance(INPUT_CLUSTER.VisorMove);
				
				if(moveDist > 0)
				{
					var destAng = scr_round(angle_difference(moveDir, XRay.coneDir));
					XRay.coneDir += min(abs(destAng), 4 * moveDist) * sign(destAng);
				}
				
				var _dir = sign(lengthdir_x(16, XRay.coneDir));
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
			XRay = instance_create_depth(xpos.X, xpos.Y, xrayDepth, obj_XRayVisor);
			XRay.kill = 0;
			XRay.coneDir = 90-(dir*90);
			global.gamePaused = true;
		}
	}
	else
	{
		if(instance_exists(XRay))
        {
            XRay.kill = true;
        }
	}
	
	#endregion
}

SetReleaseVars("menu hud visor");

//cHSelect = obj_Control.hSelect;
//cHCancel = obj_Control.hCancel;
//cHRight = obj_Control.right;
//cHLeft = obj_Control.left;
//cHUp = obj_Control.up;
//cHDown = obj_Control.down;
//cHToggle = obj_Control.mSelect;
/*
var beamNum = (hasItem[Item.IceBeam]+hasItem[Item.WaveBeam]+hasItem[Item.Spazer]+hasItem[Item.PlasmaBeam]),
	itemNum = (item[Item.Missile]+item[Item.SuperMissile]+item[Item.PowerBomb]+item[Item.GrappleBeam]+item[Item.XRayVisor]);

if(!global.roomTrans && !obj_PauseMenu.pause)
{
	if(global.grappleAimAssist && state != State.Morph && item[Item.GrappleBeam] && hudSlot == 1 && hudSlotItem[1] == 3)
	{
		if(!instance_exists(grapReticle))
		{
			grapReticle = instance_create_depth(x,y,-4,obj_GrappleTargetAssist);
		}
	}
	else if(instance_exists(grapReticle))
	{
		instance_destroy(grapReticle);
	}
	
	if(global.HUD == 0)
	{
		hudSlotItem[0] = 0;
		moveHPrev = 1;
		pauseSelect = false;
		
		var itemAmmo = [ (item[Item.Missile] && missileStat > 0), (item[Item.SuperMissile] && superMissileStat > 0), (item[Item.PowerBomb] && powerBombStat > 0), item[Item.GrappleBeam], item[Item.XRayVisor] ];
		var itemNum2 = (itemAmmo[0] + itemAmmo[1] + itemAmmo[2] + itemAmmo[3] + itemAmmo[4]);
		
		if(itemNum2 > 0)
		{
			if(cHSelect && rHSelect)
			{
				if(hudSlot == 0)
				{
					hudSlot = 1;
				}
				else
				{
					hudSlotItem[1]++;
				}
				
				var numH = 5;
				while(!itemAmmo[scr_wrap(hudSlotItem[1], 0, 5)] && numH > 0)
				{
					hudSlotItem[1]++;
				}
				
				if(hudSlotItem[1] > 4)
				{
					hudSlot = 0;
					hudSlotItem[1] = 0;
				}
				
				audio_play_sound(snd_MenuTick,0,false);
			}
			else if(hudSlot == 1)
			{
				if(!itemAmmo[scr_wrap(hudSlotItem[1], 0, 5)])
				{
					if(hudSlotItem[1] == Item.Missile && itemAmmo[Item.SuperMissile])
					{
						hudSlotItem[1] = Item.SuperMissile;
					}
					else if(hudSlotItem[1] == Item.SuperMissile && itemAmmo[Item.Missile])
					{
						hudSlotItem[1] = Item.Missile;
					}
					else
					{
						hudSlot = 0;
						hudSlotItem[1] = 0;
					}
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			
			if(hudSlot == 1 && ((cHCancel && rHCancel) || hudSlotItem[1] > 4))
			{
				hudSlot = 0;
				hudSlotItem[1] = 0;
				if(cHCancel)
				{
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
		}
		else
		{
			hudSlot = 0;
			hudSlotItem[1] = 0;
		}
		
		if(hudSlot == 0)
		{
			hudSlotItem[1] = 0;
		}
	}
	else if(global.HUD == 1)
	{
		hudSlotItem[0] = 0;
		if(cHCancel && itemNum > 0)
		{
			if(cHCancel && rHCancel)
			{
				audio_play_sound(snd_MenuTick,0,false);
			}
			hudSlot = 1;
		}
		else
		{
			hudSlot = 0;
		}
		
		if(itemNum > 1)
		{
			if(cHSelect)
			{
				pauseSelect = true;
				global.gamePaused = true;
					
				moveH = (cHRight && rHRight) - (cHLeft && rHLeft);
				if(moveH != 0)
				{
					//hudBOffsetX = 28*moveH;
					//hudIOffsetX = 28*moveH;
					moveHPrev = moveH;
					audio_play_sound(snd_MenuTick,0,false);
				}
				hudSlotItem[1] += moveH;
			}
			else
			{
				moveHPrev = 1;
				if(!rHSelect)
				{
					global.gamePaused = false;
				}
				pauseSelect = false;
			}
		}
		else
		{
			pauseSelect = false;
		}
	}
	else if(global.HUD == 2)
	{
		if(cHCancel && rHCancel && itemNum > 0)
		{
			hudSlot = scr_wrap(hudSlot + 1, 0, 2);
			audio_play_sound(snd_MenuTick,0,false);
		}
		if(cHSelect)
		{
			global.gamePaused = true;
			//if(((cHUp && rHUp) || (cHDown && rHDown)) && itemNum > 0)
			//{
			//	hudSlot = scr_wrap(hudSlot + 1, 0, 1);
			//	audio_play_sound(snd_MenuTick,0,false);
			//}
			if((hudSlot == 0 && beamNum > 0) || (hudSlot == 1 && itemNum > 1))
			{
				moveH = (cHRight && rHRight) - (cHLeft && rHLeft);
				if(moveH != 0)
				{
					hudBOffsetX = 28*moveH;
					hudIOffsetX = 28*moveH;
					moveHPrev = moveH;
					audio_play_sound(snd_MenuTick,0,false);
				}
				hudSlotItem[hudSlot] += moveH;
			}
			var hudSlotItem2 = scr_wrap(hudSlotItem[0], 1, 5);
			if(hudSlot == 0 && hudSlotItem[0] != 0)
			{
				if(cHToggle && rHToggle && hasItem[beamIndex[hudSlotItem2]])
				{
					item[beamIndex[hudSlotItem2]] = !item[beamIndex[hudSlotItem2]];
					audio_play_sound(snd_MenuShwsh,0,false);
				}
			}
		}
		else if(!rHSelect)
		{
			global.gamePaused = false;
		}
		pauseSelect = cHSelect;
	}
}

var numH = 5;
while(!hasItem[beamIndex[scr_wrap(hudSlotItem[0], 1, 5)]] && hudSlotItem[0] != 0 && numH > 0)
{
	hudSlotItem[0] += moveHPrev;
	hudBOffsetX += 28*moveHPrev;
	hudIOffsetX += 28*moveHPrev;
	numH--;
}
numH = 5;
while(!item[equipIndex[scr_wrap(hudSlotItem[1], 0, 5)]] && numH > 0)
{
	hudSlotItem[1] += moveHPrev;
	hudBOffsetX += 28*moveHPrev;
	hudIOffsetX += 28*moveHPrev;
	numH--;
}
for(var i = 0; i < array_length(hudSlotItem); i++)
{
	hudSlotItem[i] = scr_wrap(hudSlotItem[i], 0, 5);
}
*/
//rHSelect = !cHSelect;
//rHCancel = !cHCancel;
//rHRight = !cHRight;
//rHLeft = !cHLeft;
//rHUp = !cHUp;
//rHDown = !cHDown;
//rHToggle = !cHToggle;