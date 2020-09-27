/// @description HUD & Pause Screen

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight;

if(room != rm_MainMenu && instance_exists(obj_Player))
{
	draw_set_color(c_black);
	draw_set_alpha(1);
	
	var P = obj_Player;
	
	with(obj_Player)
	{
		if(global.hudMap)
		{
			scr_DrawMiniMap();
		}
		if(global.hudDisplay)
		{
			scr_DrawHUD_Energy();
		}
		if(global.HUD == 2)
		{
			scr_DrawHUD_Alt();
		}
		else
		{
			scr_DrawHUD();
		}
	}
	draw_set_color(c_black);
	
	if(pauseFade > 0)
	{
		//draw_set_alpha(0.75*pauseFade);
		//draw_rectangle(xx,yy,xx+ww,yy+hh,false);
		//draw_set_alpha(1);
		
		if(currentScreen == Screen.Inventory)
		{
			//scr_DrawInventoryPlayer(xx,yy);
		}
		else
		{
			playerOffsetY = 20;
			playerGlowY = 0;
			playerFlashAlpha = 1;
			playerGlowInd = -1;
			playerGlowIndPrev = -1;
		}
		/*if(currentScreen == Screen.Options)
		{
			var space = 16;
				
			draw_set_font(GUIFont);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			var oX = scr_round(xx + ww/2 - 112),
				oY = scr_round(yy + hh/2 - 32);
				
			for(var o = 0; o < array_length_1d(option); o++)
			{
				var col = c_black,
					alph = 0.5*pauseFade;
				if(optionPos == o)
				{
					col = c_white;
					alph = 0.15*pauseFade;
				}
				var oY2 = oY + (o*space);
				scr_DrawOptionText(oX,oY2,option[o],pauseFade,string_width(option[o])+1,col,alph);
			}
		}*/
		
		if(currentScreen == Screen.Map && global.rmMapSprt != noone)
		{
			scr_DrawMap(global.rmMapSprt,0,0,0,0,sprite_get_width(global.rmMapSprt),sprite_get_height(global.rmMapSprt),false);
		}
		
	    if(surface_exists(pauseSurf))
		{
			surface_set_target(pauseSurf);
			
			draw_clear_alpha(c_black,1);
			shader_set(shd_GaussianBlur);
			shader_set_uniform_f(shader_get_uniform(shd_GaussianBlur,"size"), global.resWidth,global.resHeight,4);
			draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);
			shader_reset();
			
			draw_set_alpha(0.75);
			draw_rectangle(0,0,ww,hh,false);
			draw_set_alpha(1);
			
			#region Draw Map
			if(currentScreen == Screen.Map)
			{
				if(global.rmMapSprt != noone && surface_exists(mapSurf))
				{
					var mx = ww/2 - mapX,
						my = hh/2 - mapY;
					draw_surface_part_ext(mapSurf,0,0,sprite_get_width(global.rmMapSprt),sprite_get_height(global.rmMapSprt),scr_round(mx),scr_round(my),1,1,c_white,1);
					
					var pX = mx + (scr_floor(P.x/global.rmMapSize) + global.rmMapX) * 8,
						pY = my + (scr_floor(P.y/global.rmMapSize) + global.rmMapY) * 8;
					
					pMapIconFrameCounter++;
					if(pMapIconFrameCounter > 4)
					{
						pMapIconFrame += pMapIconFrameNum;
						pMapIconFrameCounter = 0;
					}
					if(pMapIconFrame < 0)
					{
						pMapIconFrame = 0;
						pMapIconFrameNum = 1;
					}
					if(pMapIconFrame >= 2)
					{
						pMapIconFrame = 2;
						pMapIconFrameNum = -1;
					}
					
					draw_sprite_ext(sprt_PlayerMapIcon,pMapIconFrame,scr_round(pX+4),scr_round(pY+4),1,1,0,c_white,0.6);
				}
			}
			#endregion
			#region Draw Inventory Screen
			if(currentScreen == Screen.Inventory)
			{
				scr_DrawInventoryPlayer(0,0);
				
				selectorAlpha = clamp(selectorAlpha + 0.05*sAlphaNum,0,1);
				if(selectorAlpha <= 0)
				{
					sAlphaNum = 1;
				}
				if(selectorAlpha >= 1)
				{
					sAlphaNum = -1;
				}
				textAnim = min(textAnim + 1.5, 62);
				var textH = 7;
				draw_sprite(sprt_Sub_ItemHeader,0,6,53);
				var yoff = 2;
				for(var i = 0; i < array_length_1d(P.hasBeam); i++)
				{
					if(P.hasBeam[i])
					{
						draw_sprite(sprt_Sub_ItemBox,0+2*(!P.beam[i]),7,59+10*i+yoff);
						if(beamSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,0+2*(!P.beam[i]),7,59+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,9,61+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,9,61+10*i+yoff,1,1,0,c_white,(1-selectorAlpha)*1.25);
						}
						draw_sprite_part(sprt_Sub_ItemName_Beam,i+array_length_1d(P.hasBeam)*(!P.beam[i]),0,0,textAnim,textH,15,60+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
				
				draw_sprite(sprt_Sub_ItemHeader,1,6,133);
				yoff = 2;
				for(var i = 0; i < array_length_1d(P.hasBoots); i++)
				{
					if(P.hasBoots[i])
					{
						draw_sprite(sprt_Sub_ItemBox,0+2*(!P.boots[i]),7,139+10*i+yoff);
						if(bootsSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,0+2*(!P.boots[i]),7,139+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,9,141+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,9,141+10*i+yoff,1,1,0,c_white,selectorAlpha);
						}
						draw_sprite_part(sprt_Sub_ItemName_Boots,i+array_length_1d(P.hasBoots)*(!P.boots[i]),0,0,textAnim,textH,15,140+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
				
				draw_sprite(sprt_Sub_ItemHeader,2,174,53);
				yoff = 2;
				for(var i = 0; i < array_length_1d(P.hasSuit); i++)
				{
					if(P.hasSuit[i])
					{
						draw_sprite(sprt_Sub_ItemBox,1+2*(!P.suit[i]),176,59+10*i+yoff);
						if(suitSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,1+2*(!P.suit[i]),176,59+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,178,61+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,178,61+10*i+yoff,1,1,0,c_white,selectorAlpha);
						}
						draw_sprite_part(sprt_Sub_ItemName_Suit,i+array_length_1d(P.hasSuit)*(!P.suit[i]),0,0,textAnim,textH,184,60+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
				
				draw_sprite(sprt_Sub_ItemHeader,3,174,113);
				yoff = 2;
				for(var i = 0; i < array_length_1d(P.hasMisc); i++)
				{
					if(P.hasMisc[i])
					{
						draw_sprite(sprt_Sub_ItemBox,1+2*(!P.misc[i]),176,119+10*i+yoff);
						if(miscSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,1+2*(!P.misc[i]),176,119+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,178,121+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,178,121+10*i+yoff,1,1,0,c_white,selectorAlpha);
						}
						draw_sprite_part(sprt_Sub_ItemName_Misc,i+array_length_1d(P.hasMisc)*(!P.misc[i]),0,0,textAnim,textH,184,120+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
			}
			else
			{
				selectorAlpha = 0;
				sAlphaNum = 1;
				textAnim = 0;
			}
			#endregion
			#region Draw Log Book
			if(currentScreen == Screen.LogBook)
			{
				
			}
			#endregion
			#region Draw Options
			if(currentScreen == Screen.Options)
			{
				cursorFrameCounter++;
				if(cursorFrameCounter > 5)
				{
					cursorFrame++;
					cursorFrameCounter = 0;
				}
				if(cursorFrame >= 4)
				{
					cursorFrame = 0;
				}
				
				var space = 16;
				
				draw_set_font(GUIFont);
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				var oX = scr_round(ww/2 - 96),
					oY = scr_round(hh/2 - 48);
				
				for(var o = 0; o < array_length_1d(option); o++)
				{
					var oY2 = oY + (o*space);
					
					var col = c_black,
						alph = 0.5;
					if(optionPos == o)
					{
						col = c_white;
						alph = 0.15;
			
						draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX-4,oY2+string_height(option[o])/2,1,1,0,c_white,1);
					}
					scr_DrawOptionText(oX,oY2,option[o],c_white,1,string_width(option[o])+1,col,alph);
				}
			}
			#endregion
			
			draw_set_color(c_black);
			
			if(screenSelectAnim > 0)
			{
				var anim = clamp(screenSelectAnim,0,1);
				var x1 = scr_round(ww/2),
					y1 = scr_round((hh/2)*anim),
					x2 = scr_round(ww-(ww/2)*anim),
					y2 = scr_round(hh/2),
					x3 = scr_round(ww/2),
					y3 = scr_round(hh-(hh/2)*anim),
					x4 = scr_round((ww/2)*anim),
					y4 = scr_round(hh/2);
				
				var shift = 5;
				y1 += shift;
				y2 += shift;
				y3 += shift;
				y4 += shift;
				
				draw_triangle(x1,y1,x1-ww,y1-ww,x1+ww,y1-ww,false);
				draw_triangle(x2-1,y2-1,x2+ww-2,y2-ww-1,x2+ww-2,y2+ww,false);
				draw_triangle(x3-1,y3-2,x3-ww,y3+ww-1,x3+ww,y3+ww,false);
				draw_triangle(x4,y4-1,x4-ww,y4-ww-1,x4-ww,y4+ww,false);
				
				draw_sprite(sprt_Sub_SelectArrows,4*(currentScreen == Screen.Map),x1,y1);
				draw_sprite(sprt_Sub_SelectIcons,4*(currentScreen == Screen.Map),x1,y1-55);
				
				draw_sprite(sprt_Sub_SelectArrows,1+4*(currentScreen == Screen.Inventory),x2,y2);
				draw_sprite(sprt_Sub_SelectIcons,1+4*(currentScreen == Screen.Inventory),x2+55,y2);
				
				draw_sprite(sprt_Sub_SelectArrows,2+4*(currentScreen == Screen.Options),x3,y3);
				draw_sprite(sprt_Sub_SelectIcons,2+4*(currentScreen == Screen.Options),x3,y3+55);
				
				draw_sprite(sprt_Sub_SelectArrows,3+4*(currentScreen == Screen.LogBook),x4,y4);
				draw_sprite(sprt_Sub_SelectIcons,3+4*(currentScreen == Screen.LogBook),x4-55,y4);
			}
			
			draw_sprite(sprt_Sub_Base,0,0,0);
			draw_sprite(sprt_Sub_Header,currentScreen,0,32);
			
			draw_surface_ext(application_surface,0,0,1,1,0,c_white,1-pauseFade);
			
			surface_reset_target();
			
			if(isPaused || !instance_exists(obj_ControlOptions))
			{
				gpu_set_blendenable(false);
				draw_surface_ext(pauseSurf,xx,yy,1,1,0,c_white,1);
				gpu_set_blendenable(true);
			}
		}
		else
		{
			pauseSurf = surface_create(global.resWidth,global.resHeight);
		}
	}
}