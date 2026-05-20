
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
	
	var _openRadial = cRadialUIOpen;
	// if global open radial with any stick movement
	//{
		var _device = InputPlayerGetDevice();
		if(InputDeviceIsGamepad(_device))
		{
			if(state == -1)
			{
				_openRadial |= (global.controlDistance[INPUT_CLUSTER.RadialUIMove] > 0.25);
			}
			else
			{
				_openRadial |= (global.controlDistance[INPUT_CLUSTER.RadialUIMove] > 0);
			}
		}
	//}
	
	if(!player.visorSelected || (player.visorIndex != Visor.Scan && player.visorIndex != Visor.XRay))
	{
		if(_openRadial || state > -1)
		{
			state = RadialState.EquipMenu;
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
		
		if(state == RadialState.EquipMenu && !_openRadial)
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
	
	if(paused)
	{
		var hMoveDir = global.controlDirection[INPUT_CLUSTER.RadialUIMove],
			hMoveDist = global.controlDistance[INPUT_CLUSTER.RadialUIMove] * radialMax;
		var _rMin = radialMin;
		
		#region Equipment Menu
		if(state == RadialState.EquipMenu)
		{
			if(curEquip != -1)
			{
				_rMin *= 0.9;
			}
			if(hMoveDist > _rMin)
			{
				var _len = ds_list_size(global.equipRadial),
					_rad = 360/_len,
					_flag = false;
				for(var i = 0; i < _len; i++)
				{
					var wepInd = global.equipRadial[| i];
					var _rad2 = 180/max(_len,4);
					if(curEquip != wepInd)
					{
						_rad2 *= 0.9;
					}
					
					var _dir = 90 - _rad*i;
					if(abs(angle_difference(_dir,hMoveDir)) < _rad2)
					{
						if(!is_undefined(wepInd) && player.HasEquipment(wepInd))
						{
							if(player.equipIndex != wepInd || curEquip != wepInd)
							{
								audio_stop_sound(snd_MenuTick);
								audio_play_sound(snd_MenuTick,0,false);
								player.equipSelected = player.EquipmentHasAmmo(wepInd);
							}
							player.equipIndex = wepInd;
							curEquip = wepInd;
							_flag = true;
						}
					}
				}
				if(!_flag)
				{
					curEquip = -1;
				}
			}
			else
			{
				curEquip = -1;
			}
		}
		else
		{
			curEquip = -1;
		}
		#endregion
		#region Beam Menu
		if(state == RadialState.BeamMenu)
		{
			if(curBeam != -1)
			{
				_rMin *= 0.9;
			}
			if(hMoveDist > _rMin)
			{
				var _len = ds_list_size(global.beamRadial),
					_rad = 360/_len,
					_flag = false;
				for(var i = 0; i < _len; i++)
				{
					var beamInd = global.beamRadial[| i];
					var _rad2 = 180/max(_len,4);
					if(curBeam != beamInd)
					{
						_rad2 *= 0.9;
					}
					
					var _dir = 90 - _rad*i;
					if(abs(angle_difference(_dir,hMoveDir)) < _rad2)
					{
						if(!is_undefined(beamInd) && player.HasBeam(beamInd))
						{
							if((cMenuAccept && rMenuAccept) || (cMenuTertiary && rMenuTertiary))
							{
								player.item[player.beam[beamInd].itemIndex] = !player.item[player.beam[beamInd].itemIndex];
								audio_play_sound(snd_MenuShwsh,0,false);
							}
							
							if(curBeam != beamInd)
							{
								audio_stop_sound(snd_MenuTick);
								audio_play_sound(snd_MenuTick,0,false);
							}
							curBeam = beamInd;
							_flag = true;
						}
					}
				}
				if(!_flag)
				{
					curBeam = -1;
				}
			}
			else
			{
				curBeam = -1;
			}
		}
		else
		{
			curBeam = -1;
		}
		#endregion
		#region Visor Menu
		if(state == RadialState.VisorMenu)
		{
			if(curVisor != -1)
			{
				_rMin *= 0.9;
			}
			if(hMoveDist > _rMin)
			{
				var _len = ds_list_size(global.visorRadial),
					_rad = 360/_len,
					_flag = false;
				for(var i = 0; i < _len; i++)
				{
					var visorInd = global.visorRadial[| i];
					var _rad2 = 180/max(_len,4);
					if(curVisor != visorInd)
					{
						_rad2 *= 0.9;
					}
					
					var _dir = 90 - _rad*i;
					if(abs(angle_difference(_dir,hMoveDir)) < _rad2)
					{
						if(!is_undefined(visorInd) && player.HasVisor(visorInd))
						{
							if(player.visorIndex != visorInd || curVisor != visorInd)
							{
								audio_stop_sound(snd_MenuTick);
								audio_play_sound(snd_MenuTick,0,false);
							}
							player.visorIndex = visorInd;
							curVisor = visorInd;
							_flag = true;
						}
					}
				}
				if(!_flag)
				{
					curVisor = -1;
				}
			}
			else
			{
				curVisor = -1;
			}
		}
		else
		{
			curVisor = -1;
		}
		#endregion
		
		if(updateText || obj_UI_Controller.updateText)
		{
			changeMenuScrib_L.overwrite(UI_InsertIconsIntoString(changeMenuText_L));
			changeMenuScrib_R.overwrite(UI_InsertIconsIntoString(changeMenuText_R));
			beamToggleScrib.overwrite(UI_InsertIconsIntoString(beamToggleText));
			
			updateText = false;
		}
	}
	else
	{
		curEquip = -1;
		curBeam = -1;
		curVisor = -1;
		
		updateText = true;
	}
	
	SetReleaseVars("menu radial");
}