/// @description 

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
			ww = mapWidth + 2,
			hh = mapHeight + 2;
		draw_rectangle(xx,yy,ww+xx,hh+yy,false);
		draw_set_color(c_white);
		draw_set_alpha(1);
		surface_reset_target();
		
		if(room != rm_MainMenu && global.rmMapArea != noone && (!instance_exists(obj_Transition) || obj_Transition.transitionComplete))
		{
			currentMap = global.rmMapArea;
			
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
			prevArea = currentMap;
		}
		
		if(currentMap != noone)
		{
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
		draw_rectangle(rectX,rectY,rectX+msSizeW,rectY+msSizeH,false);
		draw_set_alpha(1);
		
		surface_reset_target();
		
		if(hudMapFlashAlpha <= 0)
		{
			hudMapFlashNum = 1;
		}
		if(hudMapFlashAlpha >= 1 || (global.GamePaused()))
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
				ww = 50,
				hh = 9;
			draw_set_color(bgCol);
			draw_set_alpha(bgAlph);
			
			draw_rectangle(x2, y2+yDiff, x2+ww, y2+yDiff+hh, false);
			
			if(energyTanks > 0)
			{
				draw_rectangle(x2, y2, x2+ww, y2+yDiff, false);
				
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
			//if(item[Item.SpeedBooster] || (animState == AnimState.Morph && item[Item.BoostBall]))
			//{
				var _sprt = sprt_HUD_Speedometer;
				var spdMax = maxSpeed[MaxSpeed.Sprint, 0];
				//if(item[Item.SpeedBooster] || (animState == AnimState.Morph && item[Item.BoostBall]))
				//{
					_sprt = sprt_HUD_Speedometer_SB;
					spdMax = self.MinimumBoostSpeed();
				//}
				
				var _meterY = yy+yDiff+8;
				var width = sprite_get_width(_sprt);
				var height = sprite_get_height(_sprt);
				
				var x2 = xx-1, y2 = _meterY,
					ww = width+1, hh = height;
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_rectangle(x2, y2, x2+ww+1, y2+hh+1, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(_sprt,0,xx,_meterY,1,1,0,c_white,1);
				
				if(shineCharge > 0)
				{
					width = sprite_get_width(_sprt) * (shineCharge / shineChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(_sprt,1,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				var _spdScale = power((abs(velX) / spdMax),2);
				if(SpiderActive())
				{
					_spdScale = power((abs(spiderSpeed) / spdMax),2);
				}
				
				if(animState == AnimState.Morph && item[Item.BoostBall] && boostBallCharge > 0)
				{
					width = sprite_get_width(_sprt) * _spdScale;
						
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(_sprt,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				
					width = sprite_get_width(_sprt) * (boostBallCharge / boostBallChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(_sprt,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
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
				
					if(item[Item.SpeedBooster] && speedCounter < 4 && (state == State.Stand || _SPEED_KEEP == 1 || (_SPEED_KEEP == 2 && liquidState <= 0)))
					{
						width = _prevWidth + _widths[speedCounter] * ((speedBuffer+1) / speedBufferMax);
						for(var j = 0; j < height; j++)
						{
							var rw = min(width-j+1,width);
							if(rw > 0)
							{
								draw_sprite_part_ext(_sprt,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
							}
						}
					}
					
					width = sprite_get_width(_sprt) * _spdScale;
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(_sprt,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				if(speedCounter >= 4 || state == State.Spark || state == State.BallSpark)
				{
					draw_sprite_ext(_sprt,3,xx,_meterY,1,1,0,c_white,1);
					
					width = sprite_get_width(_sprt) * _spdScale;
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(_sprt,4,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				yDiff += 5;
			//}
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
				draw_rectangle(x2, y2, x2+ww+1, y2+hh+1, false);
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
			
			var _equipIndex = equipIndex;
			if(state == State.Morph && item[Item.PowerBomb])
			{
				_equipIndex = Equipment.PowerBomb;
			}
			
			#region Visor Icon
			
			if(HasVisor(visorIndex))
			{
				var hItem = visor[visorIndex],
					hSprt = hItem.hudIconSprt;
				
				var ww = sprite_get_width(hSprt),
					hh = sprite_get_height(hSprt);
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_roundrect_ext(iX-1, iY-1, iX+ww+1, iY+hh+1, 8, 8, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(hSprt, visorSelected, iX+sprite_get_xoffset(hSprt), iY+sprite_get_yoffset(hSprt), 1,1,0,c_white,1);
				
				iX += 22;
			}
			
			#endregion
			#region Equipment Icon
			
			if(HasEquipment(_equipIndex))
			{
				var hItem = equip[_equipIndex],
					hSprt = hItem.hudIconSprt;
				
				var ww = sprite_get_width(hSprt),
					hh = sprite_get_height(hSprt);
				draw_set_color(bgCol);
				draw_set_alpha(bgAlph);
				draw_roundrect_ext(iX-1, iY-1, iX+ww+1, iY+hh+1, 8, 8, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				
				draw_sprite_ext(hSprt, equipSelected, iX+sprite_get_xoffset(hSprt), iY+sprite_get_yoffset(hSprt), 1,1,0,c_white,1);
				
				iX += 22;
			}
			
			#endregion
			#region Ammo Icons
			
			for(var i = 0; i < EquipAmmoType._Length; i++)
			{
				var aIcon = equipAmmoIcon[i];
				
				var hasEquip = false;
				var eqSelected = false;
				for(var j = 0; j < array_length(aIcon.equipIndexes); j++)
				{
					var eqInd = aIcon.equipIndexes[j];
					if(self.HasEquipment(eqInd) && aIcon.GetAmmo != undefined)
					{
						hasEquip = true;
						if(_equipIndex == eqInd && equipSelected)
						{
							eqSelected = true;
							break;
						}
					}
				}
				if(hasEquip)
				{
					var hSprt = aIcon.ammoIconSprt,
						ww = sprite_get_width(hSprt),
						hh = sprite_get_height(hSprt),
						backW = ww+5 + 6*aIcon.ammoDigits;
					
					draw_set_color(bgCol);
					draw_set_alpha(bgAlph);
					draw_roundrect_ext(iX-1, iY-1, iX+backW+1, iY+hh+1, 4, 4, false);
					draw_set_color(c_black);
					draw_set_alpha(1);
					draw_roundrect_ext(iX, iY, iX+backW, iY+hh, 4, 4, false);
					draw_set_color(c_white);
					
					draw_sprite_ext(hSprt, eqSelected, iX+sprite_get_xoffset(hSprt), iY+sprite_get_yoffset(hSprt), 1,1,0,c_white,1);
					
					var ammo = aIcon.GetAmmo(),
						aX = iX+backW-9,
						aY = iY+1;
					var col2 = c_white;
					if(ammo >= aIcon.GetAmmoMax())
					{
						col2 = c_lime;
					}
					
					draw_sprite_ext(sprt_HUD_NumFont2, ammo, aX, aY, 1,1,0,col2,1);
					if(aIcon.ammoDigits > 1)
					{
						aX -= 6;
						var ammo2 = floor(ammo/10);
						draw_sprite_ext(sprt_HUD_NumFont2, ammo2, aX, aY, 1,1,0,col2,1);
					}
					if(aIcon.ammoDigits > 2)
					{
						aX -= 6;
						var ammo3 = floor(ammo/100);
						draw_sprite_ext(sprt_HUD_NumFont2, ammo3, aX, aY, 1,1,0,col2,1);
					}
					
					iX += backW+4;
				}
			}
			
			#endregion
		}
		
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
	}
}