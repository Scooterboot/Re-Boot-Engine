
if(global.pauseState == PauseState.None || global.pauseState == PauseState.RadialMenu)
{
	SetControlVars("menu radial");
	
	var player = obj_Player;
	if(!instance_exists(player))
	{
		paused = false;
		pauseAnim = 0;
		exit;
	}
	
	if(!player.visorSelected || (player.visorIndex != Visor.Scan && player.visorIndex != Visor.XRay))
	{
		if(cRadialUIOpen || state > -1)
		{
			state = RadialState.WeaponMenu;
			var _mdir = (cMenuR1 || cMenuR2) - (cMenuL1 || cMenuL2);
			if(_mdir > 0)
			{
				state = RadialState.BeamMenu;
			}
			if(_mdir < 0)
			{
				state = RadialState.VisorMenu;
			}
		}
		
		if(state == RadialState.WeaponMenu && !cRadialUIOpen)
		{
			state = -1;
		}
	}
	else
	{
		state = -1;
	}
	
	if(state > -1)
	{
		pauseAnim = min(pauseAnim + 0.2, 1);
	}
	else
	{
		pauseAnim = max(pauseAnim - 0.34, 0);
	}
	
	paused = (pauseAnim > 0);
	
	if(prevPauseState == PauseState.RadialMenu || prevPauseState == PauseState.PauseMenu)
	{
		prevPauseState = PauseState.None;
	}
	if(paused)
	{
		if(global.pauseState != PauseState.RadialMenu)
		{
			prevPauseState = global.pauseState;
			global.pauseState = PauseState.RadialMenu;
		}
	}
	else if(global.pauseState == PauseState.RadialMenu)
	{
		global.pauseState = prevPauseState;
	}
	
	curWeap = -1;
	curBeam = -1;
	curVisor = -1;
	
	if(paused)
	{
		var hMoveDir = InputDirection(0, INPUT_CLUSTER.RadialUIMove),
			hMoveDist = InputDistance(INPUT_CLUSTER.RadialUIMove);// * radialSize;
		hMoveDist = radialSize * power(hMoveDist, 2);
		
		if(state == RadialState.WeaponMenu)
		{
			if(hMoveDist >= radialMin)
			{
				var _len = ds_list_size(global.weaponRadial),
					_rad = 360/_len;
				for(var i = 0; i < _len; i++)
				{
					var wepInd = global.weaponRadial[| i];
					if(!is_undefined(wepInd) && player.HasWeapon(wepInd))
					{
						var _dir = 90 - _rad*i;
						if(abs(angle_difference(_dir,hMoveDir)) < (_rad/2))
						{
							if(player.weapIndex != wepInd)
							{
								audio_play_sound(snd_MenuTick,0,false);
							}
							player.weapIndex = wepInd;
							//player.weapSelected = player.WeaponHasAmmo(wepInd);
							curWeap = !is_undefined(wepInd) ? wepInd : -1;
						}
					}
				}
			}
		}
		
		if(state == RadialState.BeamMenu)
		{
			if(hMoveDist >= radialMin)
			{
				var _len = ds_list_size(global.beamRadial),
					_rad = 360/_len;
				for(var i = 0; i < _len; i++)
				{
					var beamInd = global.beamRadial[| i];
					if(!is_undefined(beamInd) && player.HasBeam(beamInd))
					{
						var _dir = 90 - _rad*i;
						if(abs(angle_difference(_dir,hMoveDir)) < (_rad/2))
						{
							if((cMenuAccept && rMenuAccept) || (cMenuTertiary && rMenuTertiary))
							{
								player.item[player.beam[beamInd].itemIndex] = !player.item[player.beam[beamInd].itemIndex];
								audio_play_sound(snd_MenuShwsh,0,false);
							}
							
							if(beamIndex != i)
							{
								audio_play_sound(snd_MenuTick,0,false);
								beamIndex = i;
							}
							curBeam = !is_undefined(beamInd) ? beamInd : -1;
						}
					}
				}
			}
			else
			{
				beamIndex = -1;
			}
		}
		else
		{
			beamIndex = -1;
		}
		
		if(state == RadialState.VisorMenu)
		{
			if(hMoveDist >= radialMin)
			{
				var _len = ds_list_size(global.visorRadial),
					_rad = 360/_len;
				for(var i = 0; i < _len; i++)
				{
					var visorInd = global.visorRadial[| i];
					if(!is_undefined(visorInd) && player.HasVisor(visorInd))
					{
						var _dir = 90 - _rad*i;
						if(abs(angle_difference(_dir,hMoveDir)) < (_rad/2))
						{
							if(player.visorIndex != visorInd)
							{
								audio_play_sound(snd_MenuTick,0,false);
							}
							player.visorIndex = visorInd;
							curVisor = !is_undefined(visorInd) ? visorInd : -1;
						}
					}
				}
			}
		}
	}
	
	SetReleaseVars("menu radial");
}