/// @description HUD & Visor Control

SetControlVars("menu hud visor");

var numWeaps = WeapIndexNum();
var numVisors = VisorIndexNum();

if(global.pauseState == PauseState.None || global.pauseState == PauseState.RadialMenu || global.pauseState == PauseState.XRay)
{
	#region Toggle current weapon
	if(numWeaps > 0 && weapIndex >= 0 && WeaponHasAmmo(weapIndex))
	{
		if(!visorSelected || (visorIndex != Visor.Scan && visorIndex != Visor.XRay))
		{
			if(cWeapToggle && rWeapToggle)
			{
				weapSelected = !weapSelected;
				audio_play_sound(snd_MenuTick,0,false);
			}
		}
	}
	#endregion
	#region Toggle current visor
	
	var _tVisorOn = (cVisorToggle && rVisorToggle),
		_tVisorOff = (cVisorToggle && rVisorToggle) || (cVisorCycle && rVisorCycle);
	if(visorIndex == Visor.Scan)
	{
		_tVisorOn &= !cFire;
		_tVisorOff |= cFire;
	}
	var _tvoff = false;
	
	if(numVisors > 0 && visorIndex >= 0 && global.pauseState != PauseState.RadialMenu)
	{
		var canUseVisor = true;
		if(visorIndex == Visor.XRay)
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
					platform = collision_line(bb_left(), bb_bottom()+1, bb_right(), bb_bottom()+1, obj_Platform,true,true);
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
			if(!visorSelected)
			{
				if(_tVisorOn)
				{
					visorSelected = true;
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			else if(_tVisorOff)
			{
				visorSelected = false;
				audio_play_sound(snd_MenuTick,0,false);
				_tvoff = true;
			}
		}
		else
		{
			visorSelected = false;
		}
	}
	
	#endregion
	#region Cycle Visors
	
	if(numVisors > 1 && visorIndex >= 0 && !visorSelected && !_tvoff && global.pauseState == PauseState.None)
	{
		if(cVisorCycle && rVisorCycle)
		{
			var _len = ds_list_size(global.visorRadial),
				_ind = -1;
			for(var i = 0; i < _len; i++)
			{
				var _vInd = global.visorRadial[| i];
				if(!is_undefined(_vInd) && visorIndex == _vInd)
				{
					_ind = i;
					break;
				}
			}
			var _dir = 1;
			for(var i = 0; i < _len; i++)
			{
				var _index = scr_wrap(_ind+i + _dir, 0, _len);
				var _vInd = global.visorRadial[| _index];
				if(!is_undefined(_vInd) && HasVisor(_vInd))
				{
					visorIndex = _vInd;
					visorSelected = false;
					break;
				}
			}
			audio_play_sound(snd_MenuTick,0,false);
		}
	}
	
	#endregion
	
	#region Scan Visor control
	
	if(visorIndex == Visor.Scan && visorSelected)
	{
		if(instance_exists(scanVisor))
		{
			if(global.pauseState == PauseState.None)
			{
				if(InputPlayerGetDevice() == INPUT_KBM) // && visor uses mouse for control == true
				{
					var _mp = MousePos();
					scanVisor.x = _mp.X;
					scanVisor.y = _mp.Y;
				}
				else
				{
					var moveX = InputX(INPUT_CLUSTER.VisorMove),
						moveY = InputY(INPUT_CLUSTER.VisorMove);
					var mspd = 5;
					scanVisor.x += moveX*mspd;
					scanVisor.y += moveY*mspd;
				}
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
	
	if(visorIndex == Visor.XRay && visorSelected)
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
			
			if(global.pauseState == PauseState.XRay)
			{
				var _moveX = clamp(InputX(INPUT_CLUSTER.VisorMove) + InputX(INPUT_CLUSTER.PlayerMove), -1,1),
					_moveY = clamp(InputY(INPUT_CLUSTER.VisorMove) + InputY(INPUT_CLUSTER.PlayerMove), -1,1);
				var moveDir = point_direction(0,0, _moveX,_moveY),//InputDirection(0,INPUT_CLUSTER.VisorMove),
					moveDist = point_distance(0,0, _moveX,_moveY);//InputDistance(INPUT_CLUSTER.VisorMove);
				if(InputPlayerGetDevice() == INPUT_KBM) // && visor uses mouse for control == true
				{
					var _mp = MousePos_Room();
					moveDir = point_direction(x,y, _mp.X,_mp.Y);
					moveDist = 1;
				}
				
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
			global.pauseState = PauseState.XRay;
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