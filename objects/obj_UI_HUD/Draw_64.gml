/// @description TODO: Rewrite

if(room != rm_MainMenu && instance_exists(obj_Player))
{
	if(global.hudMap)
	{
		#region Minimap
		
		var msSizeW = global.mapSquareSizeW,
			msSizeH = global.mapSquareSizeH;
		
		var mapSqNumX = global.miniMapSizeX,
			mapSqNumY = global.miniMapSizeY,
			playerSqNumX = floor(global.miniMapSizeX/2),
			playerSqNumY = floor(global.miniMapSizeY/2);
		
		var mapWidth = msSizeW*mapSqNumX,
			mapHeight = msSizeH*mapSqNumY,
			mapDifX = msSizeW*playerSqNumX,
			mapDifY = msSizeH*playerSqNumY,
			mapX = global.resWidth-2-mapWidth,
			mapY = 2;
		
		bm_set_one();
		surface_set_target(obj_Display.surfUI);
		
		draw_set_color(c_black);
		draw_set_alpha(0.6);
		var xx = mapX-1,
			yy = mapY-1,
			ww = mapWidth + 1,
			hh = mapHeight + 1;
		draw_rectangle(xx,yy,ww+xx,hh+yy,false);
		draw_set_color(c_white);
		draw_set_alpha(1);
		surface_reset_target();
		
		if(global.rmMapArea != noone)
		{
			currentMap = global.rmMapArea;
			if(!instance_exists(obj_Transition) || obj_Transition.transitionComplete || prevArea != global.rmMapArea)
			{
				playerMapX = obj_Map.playerMapX * msSizeW;
				playerMapY = obj_Map.playerMapY * msSizeH;
				if(prevArea == noone)
				{
					prevPlayerMapX = playerMapX;
					prevPlayerMapY = playerMapY;
				}
				
				if(prevArea == global.rmMapArea)
				{
					if(playerMapX != prevPlayerMapX)
					{
						pMapOffsetX = -msSizeW*sign(playerMapX-prevPlayerMapX);
					}
					if(playerMapY != prevPlayerMapY)
					{
						pMapOffsetY = -msSizeH*sign(playerMapY-prevPlayerMapY);
					}
				}
				else
				{
					pMapOffsetX = 0;
					pMapOffsetY = 0;
				}
				
				prevPlayerMapX = playerMapX;
				prevPlayerMapY = playerMapY;
				prevArea = global.rmMapArea;
			}
			
			obj_Map.PrepareMapSurf(currentMap, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY, mapWidth,mapHeight, true,0.75);
			
			surface_set_target(obj_Display.surfUI);
			obj_Map.DrawMap(mapX,mapY, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY);
			surface_reset_target();
			
			if(pMapOffsetX > 0)
			{
				pMapOffsetX = max((pMapOffsetX - 0.75)*0.9,0);
			}
			if(pMapOffsetX < 0)
			{
				pMapOffsetX = min((pMapOffsetX + 0.75)*0.9,0);
			}
			if(pMapOffsetY > 0)
			{
				pMapOffsetY = max((pMapOffsetY - 0.75)*0.9,0);
			}
			if(pMapOffsetY < 0)
			{
				pMapOffsetY = min((pMapOffsetY + 0.75)*0.9,0);
			}
		}
		else
		{
			pMapOffsetX = 0;
			pMapOffsetY = 0;
			prevArea = noone;
			
			surface_set_target(obj_Display.surfUI);
			draw_sprite_ext(sprt_HUD_MapBase,0,mapX,mapY,1,1,0,c_white,0.75);
			surface_reset_target();
		}
		
		surface_set_target(obj_Display.surfUI);
		
		draw_set_color(c_white);
		draw_set_alpha(hudMapFlashAlpha);
		var rectX = mapX+mapDifX,//-pMapOffsetX,
			rectY = mapY+mapDifY;//-pMapOffsetY;
		draw_rectangle(rectX,rectY,rectX+msSizeW-1,rectY+msSizeH-1,false);
		draw_set_alpha(1);
		
		surface_reset_target();
		
		if(hudMapFlashAlpha <= 0)
		{
			hudMapFlashNum = 1;
		}
		if(hudMapFlashAlpha >= 1 || (global.gamePaused))
		{
			hudMapFlashNum = -1;
		}
		hudMapFlashAlpha = clamp(hudMapFlashAlpha + (0.1*hudMapFlashNum),0,1);
		
		gpu_set_blendmode(bm_normal);
		
		#endregion
	}
	if(global.hudDisplay)
	{
		var xx = 2,
			yy = 2;
		var xDiff = 0,
			yDiff = 0;
		
		var bgCol = c_black,
			bgAlph = 0.6;
		
		surface_set_target(obj_Display.surfUI);
		bm_set_one();
		
		#region Energy
		
		with(obj_Player)
		{
			var energyTanks = floor(energyMax / 100);
			var statEnergyTanks = floor(energy / 100);
			
			var defaultETankRowNum = 7;
			var etDiv = max(ceil(energyTanks/2), defaultETankRowNum);
			var etW = sprite_get_width(sprt_HUD_ETank)+1,
				etH = sprite_get_height(sprt_HUD_ETank)+1;
			
			if(energyTanks > 0)
			{
				yDiff += etH;
				if(energyTanks > etDiv)
				{
					yDiff += etH;
				}
			}
			
			var x2 = xx-1,
				y2 = yy-1,
				ww = 49,
				hh = 8;
			draw_set_color(bgCol);
			draw_set_alpha(bgAlph);
			
			draw_rectangle(x2, y2+yDiff, x2+ww, y2+yDiff+hh, false);
			
			if(energyTanks > 0)
			{
				draw_rectangle(x2, y2, x2+ww, y2+yDiff-1, false);
				
				if(energyTanks > defaultETankRowNum*2)
				{
					xDiff += etW * (ceil(energyTanks/2)-defaultETankRowNum);
					draw_rectangle(x2+ww+1, y2, x2+ww+xDiff, y2+yDiff, false);
				}
			}
			
			draw_set_color(c_white);
			draw_set_alpha(1);
			
			draw_sprite_ext(sprt_HUD_EnergyText,0,floor(xx),floor(yy+yDiff),1,1,0,c_white,1);
			
			draw_sprite_ext(sprt_HUD_NumFont1,energy,floor(xx+41),floor(yy+yDiff),1,1,0,c_white,1);
			var energyNum = floor(energy/10);
			draw_sprite_ext(sprt_HUD_NumFont1,energyNum,floor(xx+35),floor(yy+yDiff),1,1,0,c_white,1);
			
			if(energyTanks > 0)
			{
				for(var i = 0; i < energyTanks; i++)
				{
					var eX = xx + (etW*i),
						eY = yy;
					if(energyTanks > etDiv)
					{
						eY = yy+etH;
					}
					if(i >= etDiv)
					{
						eX = xx + (etW*(i-etDiv));
						eY = yy;
					}
					draw_sprite_ext(sprt_HUD_ETank,(statEnergyTanks > i),floor(eX),floor(eY),1,1,0,c_white,1);
				}
			}
		}
		
		#endregion
		#region Speedometer
		
		with(obj_Player)
		{
			if(item[Item.SpeedBooster] || (stateFrame == State.Morph && item[Item.BoostBall]))
			{
				var _meterY = yy+yDiff+8;
				var width = sprite_get_width(sprt_HUD_SpeedMeter);
				var height = sprite_get_height(sprt_HUD_SpeedMeter);
				
				var x2 = xx-1, y2 = _meterY,
					ww = width+1, hh = height;
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_rectangle(x2, y2, x2+ww, y2+hh, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(sprt_HUD_SpeedMeter,0,xx,_meterY,1,1,0,c_white,1);
				
				if(shineCharge > 0)
				{
					width = sprite_get_width(sprt_HUD_SpeedMeter) * (shineCharge / shineChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_HUD_SpeedMeter,1,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				if(stateFrame == State.Morph && item[Item.BoostBall] && boostBallCharge > 0)
				{
					width = sprite_get_width(sprt_HUD_SpeedMeter);
					if(SpiderActive())
					{
						width *= power((abs(spiderSpeed) / minBoostSpeed),2);
					}
					else
					{
						width *= power((abs(velX) / minBoostSpeed),2);
					}
						
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_HUD_SpeedMeter,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				
					width = sprite_get_width(sprt_HUD_SpeedMeter) * (boostBallCharge / boostBallChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_HUD_SpeedMeter,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				else
				{
					var _widths = [12,12,12,12];
					var _prevWidth = 0;
					for(var i = 0; i < speedCounter; i++)
					{
						_prevWidth += _widths[i];
					}
				
					if(speedCounter < 4 && (state == State.Stand || _SPEED_KEEP == 1 || (_SPEED_KEEP == 2 && liquidState <= 0)))
					{
						width = _prevWidth + _widths[speedCounter] * ((speedBuffer+1) / speedBufferMax);
						for(var j = 0; j < height; j++)
						{
							var rw = min(width-j+1,width);
							if(rw > 0)
							{
								draw_sprite_part_ext(sprt_HUD_SpeedMeter,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
							}
						}
					}
					
					width = sprite_get_width(sprt_HUD_SpeedMeter);
					if(SpiderActive())
					{
						width *= power((abs(spiderSpeed) / minBoostSpeed),2);
					}
					else
					{
						width *= power((abs(velX) / minBoostSpeed),2);
					}
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_HUD_SpeedMeter,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				if(speedCounter >= 4 || state == State.Spark || state == State.BallSpark)
				{
					draw_sprite_ext(sprt_HUD_SpeedMeter,3,xx,_meterY,1,1,0,c_white,1);
					
					width = sprite_get_width(sprt_HUD_SpeedMeter);
					if(SpiderActive())
					{
						width *= power((abs(spiderSpeed) / minBoostSpeed),2);
					}
					else
					{
						width *= power((abs(velX) / minBoostSpeed),2);
					}
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_HUD_SpeedMeter,4,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				yDiff += 5;
			}
		}
		#endregion
		#region Dash Charges
		
		with(obj_Player)
		{
			if(item[Item.AccelDash])
			{
				var _meterY = yy+yDiff+8;
				var sprInd = sprt_HUD_DodgeMeter,
					width = sprite_get_width(sprInd),
					height = sprite_get_height(sprInd);
				
				var x2 = xx-1, y2 = _meterY,
					ww = (width-1)*dodgeChargeCells+2, hh = height;
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_rectangle(x2, y2, x2+ww, y2+hh, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				for(var i = 0; i < dodgeChargeCells; i += 1)
				{
					var _meterX = xx+14*i;
					
					draw_sprite_ext(sprInd,0,_meterX,_meterY,1,1,0,c_white,1);
					
					var recharge = clamp((dodgeRecharge / dodgeChargeCellSize) - i,0,1);
					width *= recharge;
					var charge = clamp((dodgeCharge / dodgeChargeCellSize) - i,0,1);
					var width2 = sprite_get_width(sprInd)*charge;
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprInd,1,0,j,rw,1,_meterX,_meterY+j,1,1,c_white,1);
						}
						rw = min(width2-j+1,width2);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprInd,2,0,j,rw,1,_meterX,_meterY+j,1,1,c_white,1);
						}
					}
				}
			}
		}
		
		#endregion
		
		with(obj_Player)
		{
			var iX = 57 + xDiff,
				iY = 4;
			
			#region Visor Icon
			
			if(HasHUDVisor(hudAltVisorIndex))
			{
				var hItem = hudVisor[hudAltVisorIndex],
					hSprt = hItem.hudIconSprt;
				
				var ww = sprite_get_width(hSprt),
					hh = sprite_get_height(hSprt);
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_roundrect_ext(iX-2, iY-2, iX+ww, iY+hh, 8, 8, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(hSprt, (hudVisorIndex == hudAltVisorIndex), iX, iY, 1,1,0,c_white,1);
				
				iX += 22;
			}
			
			#endregion
			#region Weapon Icon
			
			var _weapIndex = hudWeaponIndex,
				_weapAltIndex = hudAltWeaponIndex;
			if(state == State.Morph && item[Item.PowerBomb])
			{
				_weapAltIndex = HUDWeapon.PowerBomb;
				if(hudWeaponIndex != -1)
				{
					_weapIndex = _weapAltIndex;
				}
			}
				
			if(HasHUDWeapon(_weapAltIndex))
			{
				var hItem = hudWeapon[_weapAltIndex],
					hSprt = hItem.hudIconSprt;
				
				var ww = sprite_get_width(hSprt),
					hh = sprite_get_height(hSprt);
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_roundrect_ext(iX-2, iY-2, iX+ww, iY+hh, 8, 8, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(hSprt, (_weapIndex == _weapAltIndex), iX, iY, 1,1,0,c_white,1);
				
				iX += 22;
			}
			
			#endregion
			#region Ammo Icons
			
			for(var i = 0; i < array_length(hudWeapon); i++)
			{
				if(HasHUDWeapon(i) && hudWeapon[i].GetAmmo != undefined)
				{
					var hItem = hudWeapon[i],
						hSprt = hItem.ammoIconSprt,
						ww = sprite_get_width(hSprt),
						hh = sprite_get_height(hSprt),
						backW = ww+5 + 6*hudWeapon[i].ammoDigits;
					
					draw_set_color(bgCol);
					draw_set_alpha(bgAlph);
					draw_roundrect_ext(iX-2, iY-2, iX+backW, iY+hh, 4, 4, false);
					draw_set_color(c_black);
					draw_set_alpha(1);
					draw_roundrect_ext(iX-1, iY-1, iX+backW-1, iY+hh-1, 4, 4, false);
					draw_set_color(c_white);
					
					draw_sprite_ext(hSprt, (_weapIndex == i), iX, iY, 1,1,0,c_white,1);
					
					var ammo = hItem.GetAmmo(),
						aX = iX+backW-9,
						aY = iY+1;
					var col2 = c_white;
					if(ammo >= hItem.GetAmmoMax())
					{
						col2 = c_lime;
					}
					
					draw_sprite_ext(sprt_HUD_NumFont2, ammo, aX, aY, 1,1,0,col2,1);
					if(hItem.ammoDigits > 1)
					{
						aX -= 6;
						ammo = floor(ammo/10);
						draw_sprite_ext(sprt_HUD_NumFont2, ammo, aX, aY, 1,1,0,col2,1);
					}
					if(hItem.ammoDigits > 2)
					{
						aX -= 6;
						ammo = floor(ammo/100);
						draw_sprite_ext(sprt_HUD_NumFont2, ammo, aX, aY, 1,1,0,col2,1);
					}
					
					iX += backW+4;
				}
			}
			
			#endregion
			#region Item Wheel
			
			if(hudPauseAnim > 0)
			{
				draw_set_color(c_black);
				draw_set_alpha(0.75*hudPauseAnim);
				draw_rectangle(-1, -1, global.resWidth+1, global.resHeight+1, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				var centX = global.resWidth/2,
					centY = global.resHeight/2;
				
				var alph = hudPauseAnim,
					scale = lerp(0.5, 1, hudPauseAnim);
				
				draw_set_color(c_black);
				draw_set_alpha(0.375*hudPauseAnim);
				draw_circle(centX-1, centY-1, 64*scale, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(sprt_UI_ItemWheel_BG, 0, scr_round(centX), scr_round(centY), scale, scale, 0, c_white, alph*0.5);
				
				var dist = hudSelectWheelSize * scale;
				hudSlotAnim = scr_wrap(hudSlotAnim+0.5,0,2);
				
				var hMoveDir,
					hMoveDist,
					cursorAnimFlag = false;
				if(uiState == PlayerUIState.VisorWheel)
				{
					var _len = array_length(hudVisor),
						_rad = 360/_len;
					
					hMoveDir = InputDirection(0, INPUT_CLUSTER.VisorHUDMove);
					hMoveDist = InputDistance(INPUT_CLUSTER.VisorHUDMove) * dist;
					
					for(var i = 0; i < _len; i++)
					{
						var dir = 90 - _rad*i;
						var itemX = centX + lengthdir_x(dist,dir),
							itemY = centY + lengthdir_y(dist,dir);
						
						var subImg = 0;
						if(hMoveDist >= hudSelectWheelMin && HasHUDVisor(i) && abs(angle_difference(dir,hMoveDir)) < (_rad/2))
						{
							subImg = 1 + floor(hudSlotAnim);
							cursorAnimFlag = true;
						}
						draw_sprite_ext(sprt_UI_ItemWheel_Slot, subImg, scr_round(itemX), scr_round(itemY), scale, scale, 0, c_white, alph*0.8);
						
						if(HasHUDVisor(i))
						{
							subImg = 0;
							if(hudAltVisorIndex == i)
							{
								subImg = 1;
							}
							draw_sprite_ext(hudVisor[i].selectIconSprt, subImg, scr_round(itemX), scr_round(itemY), scale, scale, 0, c_white, alph);
						}
					}
				}
				if(uiState == PlayerUIState.WeapWheel)
				{
					var _len = array_length(hudWeapon),
						_rad = 360/_len;
					
					hMoveDir = InputDirection(0, INPUT_CLUSTER.WeapHUDMove);
					hMoveDist = InputDistance(INPUT_CLUSTER.WeapHUDMove) * dist;
					
					for(var i = 0; i < _len; i++)
					{
						var dir = 90 - _rad*i;
						var itemX = centX + lengthdir_x(dist,dir),
							itemY = centY + lengthdir_y(dist,dir);
						
						var subImg = 0;
						if(hMoveDist >= hudSelectWheelMin && HasHUDWeapon(i) && abs(angle_difference(dir,hMoveDir)) < (_rad/2))
						{
							subImg = 1 + floor(hudSlotAnim);
							cursorAnimFlag = true;
						}
						draw_sprite_ext(sprt_UI_ItemWheel_Slot, subImg, scr_round(itemX), scr_round(itemY), scale, scale, 0, c_white, alph*0.8);
						
						if(HasHUDWeapon(i))
						{
							subImg = 0;
							if(hudWeaponIndex == i)
							{
								subImg = 1;
							}
							else if(hudAltWeaponIndex == i)
							{
								subImg = 2;
							}
							draw_sprite_ext(hudWeapon[i].selectIconSprt, subImg, scr_round(itemX), scr_round(itemY), scale, scale, 0, c_white, alph);
						}
					}
				}
				
				if(cursorAnimFlag)
				{
					hudCursorAnim = min(hudCursorAnim+0.25,1);
				}
				else
				{
					hudCursorAnim = max(hudCursorAnim-0.25,0);
				}
				
				var cx = centX + lengthdir_x(hMoveDist,hMoveDir),
					cy = centY + lengthdir_y(hMoveDist,hMoveDir);
				
				var sO = lerp(8, 10, hudCursorAnim),
					sI = lerp(4, 2, hudCursorAnim);
				draw_set_color(c_aqua);
				draw_set_alpha(0.3*hudPauseAnim);
				draw_circle(cx, cy, sO, false);
				draw_set_color(c_white);
				draw_set_alpha(0.4*hudPauseAnim);
				draw_circle(cx, cy, sI, false);
				draw_circle(cx, cy, sO, true);
				draw_set_alpha(1);
			}
			else
			{
				hudCursorAnim = 0;
			}
			
			#endregion
		}
		
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
	}
}

#region old code
/*
if(room != rm_MainMenu && instance_exists(obj_Player))
{
	with(obj_Player)
	{
		if(global.hudMap)
		{
			#region HUD Minimap
			
			var vX = 0,//camera_get_view_x(view_camera[0]),
				vY = 0,//camera_get_view_y(view_camera[0]),
				vW = global.resWidth;
	
			var msSizeW = global.mapSquareSizeW,
				msSizeH = global.mapSquareSizeH;

			var mapX = floor(vX+vW-2-(msSizeW*5)),
			    mapY = floor(vY+2),
				mapWidth = msSizeW*5,
				mapHeight = msSizeH*3,
				mapDifX = msSizeW*2,
				mapDifY = msSizeH;
			
			//gpu_set_blendmode_ext_sepalpha(bm_src_alpha,bm_inv_src_alpha,bm_src_alpha,bm_one);
			bm_set_one();
			
			surface_set_target(obj_Display.surfUI);
			draw_set_color(c_black);
			//draw_set_alpha(0.25);
			draw_set_alpha(0.6);
			var xx = mapX-1,
				yy = mapY-1,
				ww = mapWidth + 1,
				hh = mapHeight + 1;
			draw_rectangle(xx,yy,ww+xx,hh+yy,false);
			draw_set_color(c_white);
			draw_set_alpha(1);
			surface_reset_target();
	
			if(global.rmMapArea != noone)
			{
				currentMap = global.rmMapArea;
				playerMapX = obj_Map.playerMapX * msSizeW;
				playerMapY = obj_Map.playerMapY * msSizeH;
		
				obj_Map.PrepareMapSurf(currentMap, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY, mapWidth,mapHeight, true,0.75);
				
				surface_set_target(obj_Display.surfUI);
				
				obj_Map.DrawMap(mapX,mapY, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY);
				
				surface_reset_target();
		
				if(pMapOffsetX > 0)
				{
					pMapOffsetX = max((pMapOffsetX - 0.75)*0.9,0);
				}
				if(pMapOffsetX < 0)
				{
					pMapOffsetX = min((pMapOffsetX + 0.75)*0.9,0);
				}
				if(pMapOffsetY > 0)
				{
					pMapOffsetY = max((pMapOffsetY - 0.75)*0.9,0);
				}
				if(pMapOffsetY < 0)
				{
					pMapOffsetY = min((pMapOffsetY + 0.75)*0.9,0);
				}
			}
			else
			{
				pMapOffsetX = 0;
				pMapOffsetY = 0;
				
				surface_set_target(obj_Display.surfUI);
				draw_sprite_ext(sprt_UI_HMapBase,0,mapX,mapY,1,1,0,c_white,0.75);
				surface_reset_target();
			}
			
			surface_set_target(obj_Display.surfUI);
			
			draw_set_color(c_white);
			draw_set_alpha(hudMapFlashAlpha);
			var rectX = mapX+mapDifX,//-pMapOffsetX,
				rectY = mapY+mapDifY;//-pMapOffsetY;
			draw_rectangle(rectX,rectY,rectX+msSizeW-1,rectY+msSizeH-1,false);
			draw_set_alpha(1);
			
			surface_reset_target();
    
			if(hudMapFlashAlpha <= 0)
			{
			    hudMapFlashNum = 1;
			}
			if(hudMapFlashAlpha >= 1 || (global.gamePaused))
			{
			    hudMapFlashNum = -1;
			}
			hudMapFlashAlpha = clamp(hudMapFlashAlpha + (0.1*hudMapFlashNum),0,1);
			
			gpu_set_blendmode(bm_normal);
			
			#endregion
		}
		if(global.hudDisplay)
		{
			surface_set_target(obj_Display.surfUI);
			//gpu_set_blendmode_ext_sepalpha(bm_src_alpha,bm_inv_src_alpha,bm_src_alpha,bm_one);
			bm_set_one();
			
			#region HUD Energy
			
			var vX = 0,//camera_get_view_x(view_camera[0]),
				vY = 0;//camera_get_view_y(view_camera[0]);
			
			var col = c_black, alpha = 0.6;//0.4;
			
			var xx = vX+2,
				yy = vY+2,
				ww = 49,
				hh = 8,
				yDiff = 0;
			
			var energyTanks = floor(energyMax / 100);
			
			if(energyTanks > 0)
			{
				yDiff = 7;
				if(energyTanks > 1)//7)
				{
					yDiff = 14;
				}
			}
			
			draw_set_color(col);
			draw_set_alpha(alpha);
			
			var x2 = xx-1,
				y2 = yy-1;
			
			//draw_rectangle(x2,y2,x2+ww,y2+hh+yDiff,false);
			if(energyTanks <= 14)
			{
				var ww2 = 0;
				if(energyTanks > 0)
				{
					ww2 = 7 * scr_ceil(energyTanks/2);
					draw_rectangle(x2,y2,x2+ww2,y2+hh+yDiff,false);
					
					ww2 += 1;
				}
				draw_rectangle(x2+ww2,y2+yDiff,x2+ww,y2+hh+yDiff,false);
			}
			else
			{
				if(energyTanks > 0)
				{
					var ww2 = 7 * scr_ceil(energyTanks/2);
					draw_rectangle(x2,y2,x2+ww2,y2+yDiff,false);
				}
				draw_rectangle(x2,y2+yDiff+1,x2+ww,y2+hh+yDiff,false);
			}
			
			draw_set_color(c_white);
			draw_set_alpha(1);
			
			statEnergyTanks = floor(energy / 100);
			
			draw_sprite_ext(sprt_UI_HEnergyText,0,floor(xx),floor(yy+yDiff),1,1,0,c_white,1);
			
			draw_sprite_ext(sprt_UI_HNumFont1,energy,floor(xx+41),floor(yy+yDiff),1,1,0,c_white,1);
			var energyNum = floor(energy/10);
			draw_sprite_ext(sprt_UI_HNumFont1,energyNum,floor(xx+35),floor(yy+yDiff),1,1,0,c_white,1);
			
			if(energyTanks > 0)
			{
				/*for(var i = 0; i < energyTanks; i++)
				{
					var eX = xx + (7*i),
					eY = yy;
					if(energyTanks > 7)
					{
						eY = yy+7;
					}
					if(i >= 7)
					{
						eX = xx + (7*(i-7));
						eY = yy;
					}
					draw_sprite_ext(sprt_HETank,(statEnergyTanks > i),floor(eX),floor(eY),1,1,0,c_white,1);
				}//
				for(var i = 0; i < energyTanks; i++)
				{
					var eX = xx + (7*i)/2,
						eY = yy;
					if(i%2 != 0)
					{
						eX = xx + (7*(i-1))/2;
						eY = yy+7;
					}
					draw_sprite_ext(sprt_UI_HETank,(statEnergyTanks > i),floor(eX),floor(eY),1,1,0,c_white,1);
				}
			}
			
			if(global.HUD == 2)
			{
				yDiff = max(yDiff,10);
			}
			else if(item[Item.Missile])
			{
				yDiff = max(yDiff,7);
			}
			if(item[Item.AccelDash])
			{
				var _meterY = yy+yDiff+8;
				if(item[Item.SpeedBooster] || (stateFrame == State.Morph && item[Item.BoostBall]))
				{
					_meterY += 5;
				}
				for(var i = 0; i < dodgeChargeCells; i += 1)
				{
					var _meterX = xx+14*i;
					var sprInd = sprt_UI_DodgeMeter;
					draw_sprite_ext(sprInd,0,_meterX,_meterY,1,1,0,c_white,1);
					
					var height = sprite_get_height(sprInd);
					var recharge = clamp((dodgeRecharge / dodgeChargeCellSize) - i,0,1);
					var width = sprite_get_width(sprInd)*recharge;
					var charge = clamp((dodgeCharge / dodgeChargeCellSize) - i,0,1);
					var width2 = sprite_get_width(sprInd)*charge;
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprInd,1,0,j,rw,1,_meterX,_meterY+j,1,1,c_white,1);
						}
						rw = min(width2-j+1,width2);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprInd,2,0,j,rw,1,_meterX,_meterY+j,1,1,c_white,1);
						}
					}
				}
			}
			
			if(item[Item.SpeedBooster] || (stateFrame == State.Morph && item[Item.BoostBall]))
			{
				var _meterY = yy+yDiff+8;
				var width = sprite_get_width(sprt_UI_SpeedMeter);
				var height = sprite_get_height(sprt_UI_SpeedMeter);
				
				draw_sprite_ext(sprt_UI_SpeedMeter,0,xx,_meterY,1,1,0,c_white,1);
				
				if(shineCharge > 0)
				{
					width = sprite_get_width(sprt_UI_SpeedMeter) * (shineCharge / shineChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_SpeedMeter,1,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				if(stateFrame == State.Morph && item[Item.BoostBall] && boostBallCharge > 0)
				{
					width = sprite_get_width(sprt_UI_SpeedMeter);
					if(SpiderActive())
					{
						width *= power((abs(spiderSpeed) / minBoostSpeed),2);
					}
					else
					{
						width *= power((abs(velX) / minBoostSpeed),2);
					}
						
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_SpeedMeter,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				
					width = sprite_get_width(sprt_UI_SpeedMeter) * (boostBallCharge / boostBallChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_SpeedMeter,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				else
				{
					var _widths = [12,15,19,23];
					var _prevWidth = 0;
					for(var i = 0; i < speedCounter; i++)
					{
						_prevWidth += _widths[i];
					}
				
					if(speedCounter < 4 && (state == State.Stand || _SPEED_KEEP == 1 || (_SPEED_KEEP == 2 && liquidState <= 0)))
					{
						width = _prevWidth + _widths[speedCounter] * ((speedBuffer+1) / speedBufferMax);
						for(var j = 0; j < height; j++)
						{
							var rw = min(width-j+1,width);
							if(rw > 0)
							{
								draw_sprite_part_ext(sprt_UI_SpeedMeter,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
							}
						}
					}
					
					width = sprite_get_width(sprt_UI_SpeedMeter);
					if(SpiderActive())
					{
						width *= power((abs(spiderSpeed) / minBoostSpeed),2);
					}
					else
					{
						width *= power((abs(velX) / minBoostSpeed),2);
					}
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_SpeedMeter,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				if(speedCounter >= 4 || state == State.Spark || state == State.BallSpark)
				{
					draw_sprite_ext(sprt_UI_SpeedMeter,3,xx,_meterY,1,1,0,c_white,1);
					
					width = sprite_get_width(sprt_UI_SpeedMeter);
					if(SpiderActive())
					{
						width *= power((abs(spiderSpeed) / minBoostSpeed),2);
					}
					else
					{
						width *= power((abs(velX) / minBoostSpeed),2);
					}
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_SpeedMeter,4,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
			}
			
			#endregion
			
			var beam = [],
				hasBeam = [],
				equip = [];
			for(var i = 0; i < array_length(beamIndex); i++)
			{
				beam[i] = item[beamIndex[i]];
				hasBeam[i] = hasItem[beamIndex[i]];
			}
			for(var i = 0; i < array_length(equipIndex); i++)
			{
				equip[i] = item[equipIndex[i]];
			}
			
			if(global.HUD == 2)
			{
				#region HUD Alt
				
				//var vX = camera_get_view_x(view_camera[0]),
				//	vY = camera_get_view_y(view_camera[0]);

				//var col = c_black, alpha = 0.4;

				var selecting = (cHSelect && !global.roomTrans && !obj_PauseMenu.pause);

				if(global.hudDisplay || selecting)
				{
					var eOffX = 0;
					//var energyTanks = floor(energyMax / 100);
					if(energyTanks > 14)
					{
						eOffX = 7*scr_floor((energyTanks-13)/2);
					}
					var vX2 = vX+eOffX;

				    var itemNum = (item[Item.Missile]+item[Item.SuperMissile]+item[Item.PowerBomb]+item[Item.GrappleBeam]+item[Item.XRayVisor]);
    
				    if(selecting)
				    {
				        draw_set_color(c_black);
				        draw_set_alpha(0.75);
				        draw_rectangle(vX,vY,vX+global.resWidth,vY+global.resHeight,false);
				        draw_set_alpha(0.5);
				        draw_rectangle(vX,vY,vX+global.resWidth,vY+48,false);
				        draw_set_alpha(1);
				    }
    
				    draw_set_color(col);
				    draw_set_alpha(alpha);
    
					//var xx = 52,
					//	yy = 0,
					//	ww = 26,
					//	hh = 18;
					xx = 52;
					yy = 0;
					ww = 26;
					hh = 18;
				    draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,8,8,false);
    
				    if(itemNum > 0)
				    {
				        xx = 80;
				        yy = 0;
				        ww = 26;
				        hh = 18;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,8,8,false);
				    }
    
				    if(item[Item.Missile])
				    {
				        xx = 108;
				        yy = 2;
				        ww = 38;
				        hh = 10;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,4,4,false);
				    }
				    if(item[Item.SuperMissile])
				    {
				        xx = 148;
				        yy = 2;
				        ww = 32;
				        hh = 10;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,4,4,false);
				    }
				    if(item[Item.PowerBomb])
				    {
				        xx = 182;
				        yy = 2;
				        ww = 26;
				        hh = 10;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,4,4,false);
				    }
				    draw_set_color(c_white);
				    draw_set_alpha(1);
    
				    draw_sprite_ext(sprt_UI_HWepSlot,(hudSlot == 0),floor(vX2+66),floor(vY+10),1,1,0,c_white,1);
				    draw_sprite_ext(sprt_UI_HBeamIcon,beamIconIndex,floor(vX2+66),floor(vY+10),1,1,0,c_white,1);
    
				    if(itemNum > 0)
				    {
				        draw_sprite_ext(sprt_UI_HWepSlot,(hudSlot == 1),floor(vX2+94),floor(vY+10),1,1,0,c_white,1);
				        var iconIndex = hudSlotItem[1];
				        if(stateFrame == State.Morph && item[Item.PowerBomb])
				        {
				            iconIndex = 2;
				        }
				        draw_sprite_ext(sprt_UI_HItemIcon,iconIndex,floor(vX2+94),floor(vY+10),1,1,0,c_white,1);
				    }
					
					if(selecting)
				    {
				        draw_set_color(c_white);
				        draw_set_font(fnt_Menu2);
						draw_set_halign(fa_left);
						draw_set_valign(fa_top);
				        var tX = 0,
				            tY = 21;
				        if(hudSlot == 0)
				        {
				            var strg = beamName[hudSlotItem[0]];
				            tX = scr_round(95 - (string_width(strg) / 2));
				            draw_text_transformed(vX+tX,vY+tY,beamName[hudSlotItem[0]],1,1,0);
            
				            var xBPos = 94 + hudBOffsetX,
				                xBOffset = 28,
				                yBPos = 38;
				            for(var i = 0; i < 5; i += 1)
				            {
				                var j = i;
				                if(hasBeam[j] || i == 0)
				                {
				                    comboNum = 10*(beam[j] && i != 0);
				                    if(i == hudSlotItem[0])
				                    {
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+5+(5*(beam[j] && i != 0)),vX+xBPos,vY+yBPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(hudSlotItem[0]-1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos-xBOffset),vY+yBPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(hudSlotItem[0]-2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudBOffsetX < 0)
				                        {
				                            a = clamp(1-(abs(hudBOffsetX)/xBOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos-xBOffset*2),vY+yBPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(hudSlotItem[0]-3, 0, 5) && hudBOffsetX > 0)
				                    {
				                        var a = clamp(abs(hudBOffsetX)/xBOffset,0,1);
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos-xBOffset*3),vY+yBPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(hudSlotItem[0]+1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos+xBOffset),vY+yBPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(hudSlotItem[0]+2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudBOffsetX > 0)
				                        {
				                            a = clamp(1-(abs(hudBOffsetX)/xBOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos+xBOffset*2),vY+yBPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(hudSlotItem[0]+3, 0, 5) && hudBOffsetX < 0)
				                    {
				                        var a = clamp(abs(hudBOffsetX)/xBOffset,0,1);
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos+xBOffset*3),vY+yBPos,1,1,0,c_white,a);
				                    }
				                }
				            }
				            if(hudBOffsetX > 0)
				            {
				                hudBOffsetX = max(hudBOffsetX - (3.5 + (abs(hudBOffsetX) > 28)),0);
				            }
				            if(hudBOffsetX < 0)
				            {
				                hudBOffsetX = min(hudBOffsetX + (3.5 + (abs(hudBOffsetX) > 28)),0);
				            }
				            hudIOffsetX = 0;
				        }
				        if(hudSlot == 1)
				        {
				            var strg = itemName[hudSlotItem[1]];
				            tX = scr_round(95 - (string_width(strg) / 2));
				            draw_text_transformed(vX+tX,vY+tY,itemName[hudSlotItem[1]],1,1,0);
            
				            var xIPos = 94 + hudIOffsetX,
				                xIOffset = 28,
				                yIPos = 38;
				            for(var i = 0; i < 5; i += 1)
				            {
				                if(equip[i])
				                {
				                    if(i == hudSlotItem[1])
				                    {
				                        draw_sprite_ext(sprt_UI_HItemMisc,i+5,vX+xIPos,vY+yIPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(hudSlotItem[1]-1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos-xIOffset),vY+yIPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(hudSlotItem[1]-2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudIOffsetX < 0)
				                        {
				                            a = clamp(1-(abs(hudIOffsetX)/xIOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos-xIOffset*2),vY+yIPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(hudSlotItem[1]-3, 0, 5) && hudIOffsetX > 0)
				                    {
				                        var a = clamp(abs(hudIOffsetX)/xIOffset,0,1);
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos-xIOffset*3),vY+yIPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(hudSlotItem[1]+1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos+xIOffset),vY+yIPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(hudSlotItem[1]+2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudIOffsetX > 0)
				                        {
				                            a = clamp(1-(abs(hudIOffsetX)/xIOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos+xIOffset*2),vY+yIPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(hudSlotItem[1]+3, 0, 5) && hudIOffsetX < 0)
				                    {
				                        var a = clamp(abs(hudIOffsetX)/xIOffset,0,1);
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos+xIOffset*3),vY+yIPos,1,1,0,c_white,a);
				                    }
				                }
				            }
				            hudBOffsetX = 0;
				            if(hudIOffsetX > 0)
				            {
				                hudIOffsetX = max(hudIOffsetX - (3.5 + (abs(hudBOffsetX) > 28)),0);
				            }
				            if(hudIOffsetX < 0)
				            {
				                hudIOffsetX = min(hudIOffsetX + (3.5 + (abs(hudBOffsetX) > 28)),0);
				            }
				        }
				    }
				    else
				    {
				        hudBOffsetX = 0;
				        hudIOffsetX = 0;
				    }
    
				    if(item[Item.Missile])
				    {
				        draw_sprite_ext(sprt_UI_HAmmoIcon,(hudSlot == 1 && hudSlotItem[1] == 0 && stateFrame != State.Morph),floor(vX2+110),floor(vY+4),1,1,0,c_white,1);
			
						var col2 = c_white;
						if(missileStat >= missileMax)
						{
							col2 = c_lime;
						}
    
				        draw_sprite_ext(sprt_UI_HNumFont2,missileStat,floor(vX2+137),floor(vY+5),1,1,0,col2,1);
				        var missileNum = floor(missileStat/10);
				        draw_sprite_ext(sprt_UI_HNumFont2,missileNum,floor(vX2+131),floor(vY+5),1,1,0,col2,1);
				        var missileNum2 = floor(missileStat/100);
				        draw_sprite_ext(sprt_UI_HNumFont2,missileNum2,floor(vX2+125),floor(vY+5),1,1,0,col2,1);
				    }
				    if(item[Item.SuperMissile])
				    {
				        draw_sprite_ext(sprt_UI_HAmmoIcon,2+(hudSlot == 1 && hudSlotItem[1] == 1 && stateFrame != State.Morph),floor(vX2+150),floor(vY+4),1,1,0,c_white,1);
    
				        var col2 = c_white;
						if(superMissileStat >= superMissileMax)
						{
							col2 = c_lime;
						}
			
						draw_sprite_ext(sprt_UI_HNumFont2,superMissileStat,floor(vX2+171),floor(vY+5),1,1,0,col2,1);
				        var superMissileNum = floor(superMissileStat/10);
				        draw_sprite_ext(sprt_UI_HNumFont2,superMissileNum,floor(vX2+165),floor(vY+5),1,1,0,col2,1);
				    }
				    if(item[Item.PowerBomb])
				    {
				        draw_sprite_ext(sprt_UI_HAmmoIcon,4+(hudSlot == 1 && (hudSlotItem[1] == 2 || stateFrame == State.Morph)),floor(vX2+184),floor(vY+4),1,1,0,c_white,1);
    
						var col2 = c_white;
						if(powerBombStat >= powerBombMax)
						{
							col2 = c_lime;
						}
			
				        draw_sprite_ext(sprt_UI_HNumFont2,powerBombStat,floor(vX2+199),floor(vY+5),1,1,0,col2,1);
				        var powerBombNum = floor(powerBombStat/10);
				        draw_sprite_ext(sprt_UI_HNumFont2,powerBombNum,floor(vX2+193),floor(vY+5),1,1,0,col2,1);
				    }
				}
				
				#endregion
			}
			else
			{
				#region HUD
			
				//var vX = camera_get_view_x(view_camera[0]),
				//	vY = camera_get_view_y(view_camera[0]);

				//var col = c_black, alpha = 0.4;

				var itemNum = (item[Item.Missile]+item[Item.SuperMissile]+item[Item.PowerBomb]+item[Item.GrappleBeam]+item[Item.XRayVisor]);

				var selecting = (pauseSelect && !global.roomTrans && !obj_PauseMenu.pause);
    
				if(global.hudDisplay && itemNum > 0)
				{
					if(selecting)
				    {
				        draw_set_color(c_black);
				        draw_set_alpha(0.75);
				        draw_rectangle(vX,vY,vX+global.resWidth,vY+global.resHeight,false);
				        draw_set_alpha(0.5);
				        draw_rectangle(vX,vY,vX+global.resWidth,vY+48,false);
				        draw_set_alpha(1);
				    }

				    for(var i = 0; i < array_length(equip); i++)
				    {
				        if(equip[i])
				        {
				            draw_set_color(col);
				            draw_set_alpha(alpha);
				
							var eOffX = 0;
							//var energyTanks = floor(energyMax / 100);
							if(energyTanks > 14)
							{
								eOffX = 7*scr_floor((energyTanks-13)/2);
							}
							var vX2 = vX+eOffX;
				
							//var xx = 57,
							//	yy = 4,
							//	ww = 39,
							//	hh = 14;
							xx = 57;
							yy = 4;
							ww = 39;
							hh = 14;
							if(i == 1)
							{
								xx = 101;
								ww = 33;
							}
							if(i == 2)
							{
								xx = 139;
								ww = 30;
							}
							if(i >= 3)
							{
								xx = 174;
								ww = 14;
								if(i == 4)
								{
									xx = 193;
								}
							}
							var index = 0;
							if((hudSlotItem[1] == i && (global.HUD == 0 || stateFrame != State.Morph)) || (global.HUD == 1 && stateFrame == State.Morph && i == 2))
							{
								if(global.HUD == 1)
								{
									index = 2;
								}
								if(hudSlot == 1)
								{
									index = 1;
								}
							}
							//var x2 = xx-2, y2 = yy-2;
							x2 = xx-2;
							y2 = yy-2;
							draw_roundrect_ext(vX2+x2,vY+y2,vX2+x2+ww,vY+y2+hh,8,8,false);
				
							draw_set_alpha(1);
				            draw_set_color(c_white);
				
							draw_sprite_ext(sprt_UI_HItem,index+3*i,floor(vX2+xx),floor(vY+yy),1,1,0,c_white,1);
				
							if(i == 0)
							{
								var col2 = c_white;
								if(missileStat >= missileMax)
								{
									col2 = c_lime;
								}
					
								draw_sprite_ext(sprt_UI_HNumFont2,missileStat,floor(vX2+85),floor(vY+7),1,1,0,col2,1);
				                var missileNum = floor(missileStat/10);
				                draw_sprite_ext(sprt_UI_HNumFont2,missileNum,floor(vX2+79),floor(vY+7),1,1,0,col2,1);
				                missileNum = floor(missileStat/100);
				                draw_sprite_ext(sprt_UI_HNumFont2,missileNum,floor(vX2+73),floor(vY+7),1,1,0,col2,1);
							}
							if(i == 1)
							{
								var col2 = c_white;
								if(superMissileStat >= superMissileMax)
								{
									col2 = c_lime;
								}
					
								draw_sprite_ext(sprt_UI_HNumFont2,superMissileStat,floor(vX2+123),floor(vY+7),1,1,0,col2,1);
				                var superMissileNum = floor(superMissileStat/10);
				                draw_sprite_ext(sprt_UI_HNumFont2,superMissileNum,floor(vX2+117),floor(vY+7),1,1,0,col2,1);
							}
							if(i == 2)
							{
								var col2 = c_white;
								if(powerBombStat >= powerBombMax)
								{
									col2 = c_lime;
								}
					
								draw_sprite_ext(sprt_UI_HNumFont2,powerBombStat,floor(vX2+158),floor(vY+7),1,1,0,col2,1);
				                var powerBombNum = floor(powerBombStat/10);
				                draw_sprite_ext(sprt_UI_HNumFont2,powerBombNum,floor(vX2+152),floor(vY+7),1,1,0,col2,1);
							}
				        }
				    }
		
					draw_set_color(c_white);
	
					if(selecting)
					{
						draw_set_font(fnt_Menu2);
						draw_set_halign(fa_left);
						draw_set_valign(fa_top);
						var strg = itemName[hudSlotItem[1]],
				        tX = 123 - scr_round(string_width(strg) / 2);
				        draw_text_transformed(vX+tX,vY+21,itemName[hudSlotItem[1]],1,1,0);
						//var xx = 69,
						//	yy = 38;
						xx = 69;
						yy = 38;
						for(var i = 0; i < array_length(equip); i++)
						{
							xx = 50 + 36*i;
							if(equip[i])
							{
								draw_sprite_ext(sprt_UI_HItemMisc,i+5*(hudSlotItem[1] == i),vX+xx,vY+yy,1,1,0,c_white,1);
							}
						}
					}
				}
			
				#endregion
			}
			
			gpu_set_blendmode(bm_normal);
			surface_reset_target();
		}
	}
}*/
#endregion