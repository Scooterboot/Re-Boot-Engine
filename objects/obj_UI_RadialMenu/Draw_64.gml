
if(room != rm_MainMenu && pauseAnim > 0)
{
	var player = obj_Player;
	if(!instance_exists(player))
	{
		paused = false;
		pauseAnim = 0;
		exit;
	}
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	draw_set_color(c_black);
	draw_set_alpha(0.75*pauseAnim);
	draw_rectangle(-1, -1, global.resWidth+1, global.resHeight+1, false);
	
	var centX = global.resWidth/2,
		centY = global.resHeight/2;
	
	var alph = pauseAnim,
		scale = lerp(0.5, 1, pauseAnim);
	
	draw_set_color(c_black);
	draw_set_alpha(0.375*pauseAnim);
	draw_circle(centX-1, centY-1, 64*scale, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	if(state > -1)
	{
		stateAnim[state] = min(stateAnim[state] + 0.15, 1);
	}
	for(var i = 0; i < array_length(stateAnim); i++)
	{
		if(state != i && state != -1)
		{
			stateAnim[i] = max(stateAnim[i] - 0.15, 0);
		}
	}
	
	#region Base
	
	draw_sprite_ext(sprt_UI_Radial_BG, 0, scr_round(centX), scr_round(centY), 1, 1, 0, c_white, 0.5*alph*stateAnim[RadialState.EquipMenu]);
	draw_sprite_ext(sprt_UI_Radial_BG, 1, scr_round(centX), scr_round(centY), 1, 1, 0, c_white, 0.5*alph*stateAnim[RadialState.BeamMenu]);
	draw_sprite_ext(sprt_UI_Radial_BG, 2, scr_round(centX), scr_round(centY), 1, 1, 0, c_white, 0.5*alph*stateAnim[RadialState.VisorMenu]);
	
	var sflag = (state != RadialState.VisorMenu);
	var lstr = obj_UI.InsertIconsIntoString(changeMenuText_L);
	if(changeMenuScrib_L.get_text() != lstr)
	{
		changeMenuScrib_L.overwrite(lstr);
	}
	var _ww = 38,
		_hh = 16;
	var lButtonPosX = centX - 68 - (_ww/2), lButtonPosY = centY;
	
	draw_sprite_stretched_ext(sprt_UI_GenericButton,1+2*sflag, lButtonPosX-(_ww/2)-3,lButtonPosY-_hh/2-3,_ww+6,_hh+6, c_white,alph);
	draw_sprite_stretched_ext(sprt_UI_GenericButton,0+2*sflag, lButtonPosX-(_ww/2)-3,lButtonPosY-_hh/2-3,_ww+6,_hh+6, c_white,alph);
	
	changeMenuScrib_L.blend(c_black, alph);
	changeMenuScrib_L.draw(lButtonPosX-1+1,lButtonPosY+1+1);
	changeMenuScrib_L.blend(c_white, alph);
	changeMenuScrib_L.draw(lButtonPosX-1,lButtonPosY+1);
	
	sflag = (state != RadialState.BeamMenu);
	var rstr = obj_UI.InsertIconsIntoString(changeMenuText_R);
	if(changeMenuScrib_R.get_text() != rstr)
	{
		changeMenuScrib_R.overwrite(rstr);
	}
	lButtonPosX = centX + 68 + (_ww/2);
	
	draw_sprite_stretched_ext(sprt_UI_GenericButton,1+2*sflag, lButtonPosX-(_ww/2)-3,lButtonPosY-_hh/2-3,_ww+6,_hh+6, c_white,alph);
	draw_sprite_stretched_ext(sprt_UI_GenericButton,0+2*sflag, lButtonPosX-(_ww/2)-3,lButtonPosY-_hh/2-3,_ww+6,_hh+6, c_white,alph);
	
	changeMenuScrib_R.blend(c_black, alph);
	changeMenuScrib_R.draw(lButtonPosX-1+1,lButtonPosY+1+1);
	changeMenuScrib_R.blend(c_white, alph);
	changeMenuScrib_R.draw(lButtonPosX-1,lButtonPosY+1);
	
	#endregion
	
	slotAnim = scr_wrap(slotAnim+0.5, 0, 2);
	
	var dist = radialSize * scale;
	var hMoveDir = InputDirection(0, INPUT_CLUSTER.RadialUIMove),
		hMoveDist = InputDistance(INPUT_CLUSTER.RadialUIMove) * radialSize,
		cursorAnimFlag = false;
	
	draw_set_font(fnt_Menu);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	#region Equipment Menu
	if(stateAnim[RadialState.EquipMenu] > 0)
	{
		var anim = stateAnim[RadialState.EquipMenu],
			anim2 = stateAnim[RadialState.BeamMenu],
			anim3 = stateAnim[RadialState.VisorMenu];
		
		if(player.HasEquipment(curEquip))
		{
			draw_set_alpha(anim*alph);
			draw_set_color(c_black);
			draw_text_ext(centX+1,centY+1, equipName[curEquip], 10,64);
			draw_set_color(c_white);
			draw_text_ext(centX,centY, equipName[curEquip], 10,64);
			draw_set_alpha(1);
		}
		
		var _len = ds_list_size(global.equipRadial),
			_rad = 360/_len;
		
		for(var i = 0; i < _len; i++)
		{
			var wepInd = global.equipRadial[| i];
			if(!is_undefined(wepInd))
			{
				var dir = 90 - _rad*i - 120*(anim2 - anim3);
				var itemX = centX + lengthdir_x(dist*anim,dir),
					itemY = centY + lengthdir_y(dist*anim,dir);
				
				var subImg = 0;
				if(player.HasEquipment(wepInd) && hMoveDist >= radialMin && abs(angle_difference(dir,hMoveDir)) < (_rad/2))
				{
					subImg = 1 + floor(slotAnim);
					cursorAnimFlag = true;
				}
				draw_sprite_ext(sprt_UI_Radial_Slot, subImg, scr_round(itemX), scr_round(itemY), 1, 1, 0, c_white, 0.9*alph*anim);
				
				if(player.HasEquipment(wepInd))
				{
					subImg = 0;
					if(player.equipIndex == wepInd)
					{
						subImg = 2;
						if(player.equipSelected)
						{
							subImg = 1;
						}
					}
					draw_sprite_ext(player.equip[wepInd].selectIconSprt, subImg, scr_round(itemX), scr_round(itemY), 1, 1, 0, c_white, alph*anim);
				}
			}
		}
	}
	#endregion
	#region Beam Menu
	if(stateAnim[RadialState.BeamMenu] > 0)
	{
		var anim = stateAnim[RadialState.BeamMenu];
		
		if(player.HasBeam(curBeam))
		{
			draw_set_alpha(anim*alph);
			draw_set_color(c_black);
			draw_text_ext(centX+1,centY-4+1, beamName[curBeam], 10,64);
			draw_set_color(c_white);
			draw_text_ext(centX,centY-4, beamName[curBeam], 10,64);
			draw_set_alpha(1);
		}
		
		var btStr = obj_UI.InsertIconsIntoString(beamToggleText);
		if(beamToggleScrib.get_text() != btStr)
		{
			beamToggleScrib.overwrite(btStr);
		}
		beamToggleScrib.blend(c_black, anim*alph);
		beamToggleScrib.draw(centX+1,centY+1 + 14);
		beamToggleScrib.blend(c_white, anim*alph);
		beamToggleScrib.draw(centX,centY + 14);
		
		var _len = ds_list_size(global.beamRadial),
			_rad = 360/_len;
		
		for(var i = 0; i < _len; i++)
		{
			var beamInd = global.beamRadial[| i];
			if(!is_undefined(beamInd))
			{
				var dir = 90 - _rad*i + 120*(1-anim);
				var itemX = centX + lengthdir_x(dist*anim,dir),
					itemY = centY + lengthdir_y(dist*anim,dir);
				
				var subImg = 0;
				if(player.HasBeam(beamInd) && hMoveDist >= radialMin && abs(angle_difference(dir,hMoveDir)) < (_rad/2))
				{
					subImg = 1 + floor(slotAnim);
					cursorAnimFlag = true;
				}
				draw_sprite_ext(sprt_UI_Radial_Slot, subImg, scr_round(itemX), scr_round(itemY), 1, 1, 0, c_white, 0.9*alph*anim);
				
				if(player.HasBeam(beamInd))
				{
					subImg = 0;
					if(player.item[player.beam[beamInd].itemIndex])
					{
						subImg = 1;
					}
					draw_sprite_ext(player.beam[beamInd].selectIconSprt, subImg, scr_round(itemX), scr_round(itemY), 1, 1, 0, c_white, alph*anim);
				}
			}
		}
	}
	#endregion
	#region Visor Menu
	if(stateAnim[RadialState.VisorMenu] > 0)
	{
		var anim = stateAnim[RadialState.VisorMenu];
		
		if(player.HasVisor(curVisor))
		{
			draw_set_alpha(anim*alph);
			draw_set_color(c_black);
			draw_text_ext(centX+1,centY+1, visorName[curVisor], 10,64);
			draw_set_color(c_white);
			draw_text_ext(centX,centY, visorName[curVisor], 10,64);
			draw_set_alpha(1);
		}
		
		var _len = ds_list_size(global.visorRadial),
			_rad = 360/_len;
		
		for(var i = 0; i < _len; i++)
		{
			var visInd = global.visorRadial[| i];
			if(!is_undefined(visInd))
			{
				var dir = 90 - _rad*i - 120*(1-anim);
				var itemX = centX + lengthdir_x(dist*anim,dir),
					itemY = centY + lengthdir_y(dist*anim,dir);
				
				var subImg = 0;
				if(player.HasVisor(visInd) && hMoveDist >= radialMin && abs(angle_difference(dir,hMoveDir)) < (_rad/2))
				{
					subImg = 1 + floor(slotAnim);
					cursorAnimFlag = true;
				}
				draw_sprite_ext(sprt_UI_Radial_Slot, subImg, scr_round(itemX), scr_round(itemY), 1, 1, 0, c_white, 0.9*alph*anim);
				
				if(player.HasVisor(visInd))
				{
					subImg = 0;
					if(player.visorIndex == visInd)
					{
						subImg = 2;
						if(player.visorSelected)
						{
							subImg = 1;
						}
					}
					draw_sprite_ext(player.visor[visInd].selectIconSprt, subImg, scr_round(itemX), scr_round(itemY), 1, 1, 0, c_white, alph*anim);
				}
			}
		}
	}
	#endregion
	
	if(cursorAnimFlag)
	{
		cursorAnim = min(cursorAnim+0.25,1);
	}
	else
	{
		cursorAnim = max(cursorAnim-0.25,0);
	}
	
	var cx = centX + lengthdir_x(hMoveDist,hMoveDir),
		cy = centY + lengthdir_y(hMoveDist,hMoveDir);
	
	var sO = lerp(8, 10, cursorAnim),
		sI = lerp(4, 2, cursorAnim);
	draw_set_color(c_aqua);
	draw_set_alpha(0.3*pauseAnim);
	draw_circle(cx, cy, sO, false);
	draw_set_color(c_white);
	draw_set_alpha(0.4*pauseAnim);
	draw_circle(cx, cy, sI, false);
	draw_circle(cx, cy, sO, true);
	draw_set_alpha(1);
	
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
}
else
{
	for(var i = 0; i < array_length(stateAnim); i++)
	{
		stateAnim[i] = 0;
	}
	stateAnim[RadialState.EquipMenu] = 1;
	slotAnim = 0;
	cursorAnim = 0;
}