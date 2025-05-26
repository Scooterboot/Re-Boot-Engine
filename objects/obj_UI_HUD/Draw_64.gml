/// @description 

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
			ui_blendmode();
			
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
			ui_blendmode();
			
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
				}*/
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
			if(boots[Boots.Dodge])
			{
				var _meterY = yy+yDiff+8;
				if(boots[Boots.SpeedBoost] || (stateFrame == State.Morph && misc[Misc.Boost]))
				{
					_meterY += 5;
				}
				for(var i = 0; i < 2; i += 1)
				{
					draw_sprite_ext(sprt_UI_DodgeMeter,0,xx+14*i,_meterY,1,1,0,c_white,1);
		
					var recharge = clamp((dodgeRecharge / (dodgeRechargeMax/2)) - i,0,1);
					var width = sprite_get_width(sprt_UI_DodgeMeter)*recharge;
					var height = sprite_get_height(sprt_UI_DodgeMeter);
					var imgInd = 1 + (canDodge && recharge >= 1);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_DodgeMeter,imgInd,0,j,rw,1,xx+14*i,_meterY+j,1,1,c_white,1);
						}
					}
				}
			}
			
			if(boots[Boots.SpeedBoost] || (stateFrame == State.Morph && misc[Misc.Boost]))
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
				
				if(stateFrame == State.Morph && misc[Misc.Boost] && boostBallCharge > 0)
				{
					width = sprite_get_width(sprt_UI_SpeedMeter) * (boostBallCharge / boostBallChargeMax);
					for(var j = 0; j < height; j++)
					{
						var rw = min(width-j+1,width);
						if(rw > 0)
						{
							draw_sprite_part_ext(sprt_UI_SpeedMeter,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
						}
					}
				}
				
				var _widths = [12,15,19,23];
				var _prevWidth = 0;
				for(var i = 0; i < speedCounter; i++)
				{
					_prevWidth += _widths[i];
				}
				
				if(speedCounter < 4 && (state == State.Stand || speedKeep == 1 || (speedKeep == 2 && liquidState <= 0)))
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
				
				//if(!walkState && (state == State.Stand || !restrictSBToRun))
				//{
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
				//}
				
				if(speedCounter >= 4 || state == State.Spark || state == State.BallSpark)
				{
					draw_sprite_ext(sprt_UI_SpeedMeter,4,xx,_meterY,1,1,0,c_white,1);
				}
			}
			
			#endregion
			
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

				    var itemNum = (item[Item.Missile]+item[Item.SMissile]+item[Item.PBomb]+item[Item.Grapple]+item[Item.XRay]);
    
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
    
				    var xx = 52,
				        yy = 0,
				        ww = 26,
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
    
				    if(item[0])
				    {
				        xx = 108;
				        yy = 2;
				        ww = 38;
				        hh = 10;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,4,4,false);
				    }
				    if(item[1])
				    {
				        xx = 148;
				        yy = 2;
				        ww = 32;
				        hh = 10;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,4,4,false);
				    }
				    if(item[2])
				    {
				        xx = 182;
				        yy = 2;
				        ww = 26;
				        hh = 10;
				        draw_roundrect_ext(vX2+xx,vY+yy,vX2+ww+xx,vY+hh+yy,4,4,false);
				    }
				    draw_set_color(c_white);
				    draw_set_alpha(1);
    
				    draw_sprite_ext(sprt_UI_HWepSlot,(itemSelected == 0),floor(vX2+66),floor(vY+10),1,1,0,c_white,1);
				    draw_sprite_ext(sprt_UI_HBeamIcon,beamIconIndex,floor(vX2+66),floor(vY+10),1,1,0,c_white,1);
    
				    if(itemNum > 0)
				    {
				        draw_sprite_ext(sprt_UI_HWepSlot,(itemSelected == 1),floor(vX2+94),floor(vY+10),1,1,0,c_white,1);
				        var iconIndex = itemHighlighted[1];
				        if(stateFrame == State.Morph && item[2])
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
				        if(itemSelected == 0)
				        {
				            var strg = beamName[itemHighlighted[0]];
				            tX = scr_round(95 - (string_width(strg) / 2));
				            draw_text_transformed(vX+tX,vY+tY,beamName[itemHighlighted[0]],1,1,0);
            
				            var xBPos = 94 + hudBOffsetX,
				                xBOffset = 28,
				                yBPos = 38;
				            for(var i = 0; i < 5; i += 1)
				            {
				                var j = i;
				                if(hasBeam[j] || i == 0)
				                {
				                    comboNum = 10*(beam[j] && i != 0);
				                    if(i == itemHighlighted[0])
				                    {
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+5+(5*(beam[j] && i != 0)),vX+xBPos,vY+yBPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(itemHighlighted[0]-1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos-xBOffset),vY+yBPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(itemHighlighted[0]-2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudBOffsetX < 0)
				                        {
				                            a = clamp(1-(abs(hudBOffsetX)/xBOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos-xBOffset*2),vY+yBPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(itemHighlighted[0]-3, 0, 5) && hudBOffsetX > 0)
				                    {
				                        var a = clamp(abs(hudBOffsetX)/xBOffset,0,1);
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos-xBOffset*3),vY+yBPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(itemHighlighted[0]+1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos+xBOffset),vY+yBPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(itemHighlighted[0]+2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudBOffsetX > 0)
				                        {
				                            a = clamp(1-(abs(hudBOffsetX)/xBOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemBeam,i+comboNum,vX+(xBPos+xBOffset*2),vY+yBPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(itemHighlighted[0]+3, 0, 5) && hudBOffsetX < 0)
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
				        if(itemSelected == 1)
				        {
				            var strg = itemName[itemHighlighted[1]];
				            tX = scr_round(95 - (string_width(strg) / 2));
				            draw_text_transformed(vX+tX,vY+tY,itemName[itemHighlighted[1]],1,1,0);
            
				            var xIPos = 94 + hudIOffsetX,
				                xIOffset = 28,
				                yIPos = 38;
				            for(var i = 0; i < 5; i += 1)
				            {
				                if(item[i])
				                {
				                    if(i == itemHighlighted[1])
				                    {
				                        draw_sprite_ext(sprt_UI_HItemMisc,i+5,vX+xIPos,vY+yIPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(itemHighlighted[1]-1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos-xIOffset),vY+yIPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(itemHighlighted[1]-2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudIOffsetX < 0)
				                        {
				                            a = clamp(1-(abs(hudIOffsetX)/xIOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos-xIOffset*2),vY+yIPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(itemHighlighted[1]-3, 0, 5) && hudIOffsetX > 0)
				                    {
				                        var a = clamp(abs(hudIOffsetX)/xIOffset,0,1);
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos-xIOffset*3),vY+yIPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(itemHighlighted[1]+1, 0, 5))
				                    {
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos+xIOffset),vY+yIPos,1,1,0,c_white,1);
				                    }
				                    if(i == scr_wrap(itemHighlighted[1]+2, 0, 5))
				                    {
				                        var a = 1;
				                        if(hudIOffsetX > 0)
				                        {
				                            a = clamp(1-(abs(hudIOffsetX)/xIOffset),0,1);
				                        }
				                        draw_sprite_ext(sprt_UI_HItemMisc,i,vX+(xIPos+xIOffset*2),vY+yIPos,1,1,0,c_white,a);
				                    }
				                    if(i == scr_wrap(itemHighlighted[1]+3, 0, 5) && hudIOffsetX < 0)
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
    
				    if(item[0])
				    {
				        draw_sprite_ext(sprt_UI_HAmmoIcon,(itemSelected == 1 && itemHighlighted[1] == 0 && stateFrame != State.Morph),floor(vX2+110),floor(vY+4),1,1,0,c_white,1);
			
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
				    if(item[1])
				    {
				        draw_sprite_ext(sprt_UI_HAmmoIcon,2+(itemSelected == 1 && itemHighlighted[1] == 1 && stateFrame != State.Morph),floor(vX2+150),floor(vY+4),1,1,0,c_white,1);
    
				        var col2 = c_white;
						if(superMissileStat >= superMissileMax)
						{
							col2 = c_lime;
						}
			
						draw_sprite_ext(sprt_UI_HNumFont2,superMissileStat,floor(vX2+171),floor(vY+5),1,1,0,col2,1);
				        var superMissileNum = floor(superMissileStat/10);
				        draw_sprite_ext(sprt_UI_HNumFont2,superMissileNum,floor(vX2+165),floor(vY+5),1,1,0,col2,1);
				    }
				    if(item[2])
				    {
				        draw_sprite_ext(sprt_UI_HAmmoIcon,4+(itemSelected == 1 && (itemHighlighted[1] == 2 || stateFrame == State.Morph)),floor(vX2+184),floor(vY+4),1,1,0,c_white,1);
    
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

				var itemNum = (item[Item.Missile]+item[Item.SMissile]+item[Item.PBomb]+item[Item.Grapple]+item[Item.XRay]);

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

				    for(var i = 0; i < array_length(item); i++)
				    {
				        if(item[i])
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
				
							var xx = 57,
								yy = 4,
								ww = 39,
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
							if((itemHighlighted[1] == i && (global.HUD == 0 || stateFrame != State.Morph)) || (global.HUD == 1 && stateFrame == State.Morph && i == 2))
							{
								if(global.HUD == 1)
								{
									index = 2;
								}
								if(itemSelected == 1)
								{
									index = 1;
								}
							}
							var x2 = xx-2, y2 = yy-2;
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
						var strg = itemName[itemHighlighted[1]],
				        tX = 123 - scr_round(string_width(strg) / 2);
				        draw_text_transformed(vX+tX,vY+21,itemName[itemHighlighted[1]],1,1,0);
						var xx = 69,
							yy = 38;
						for(var i = 0; i < array_length(item); i++)
						{
							xx = 50 + 36*i;
							if(item[i])
							{
								draw_sprite_ext(sprt_UI_HItemMisc,i+5*(itemHighlighted[1] == i),vX+xx,vY+yy,1,1,0,c_white,1);
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
}