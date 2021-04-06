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
		if(currentScreen != Screen.Inventory)
		{
			playerOffsetY = 20;
			playerGlowY = 0;
			playerFlashAlpha = 1;
			playerGlowInd = -1;
			playerGlowIndPrev = -1;
		}
		
	    if(surface_exists(pauseSurf))
		{
			surface_resize(pauseSurf,global.resWidth,global.resHeight);
			surface_set_target(pauseSurf);
			
			draw_clear_alpha(c_black,1);
			shader_set(shd_GaussianBlur);
			shader_set_uniform_f(shader_get_uniform(shd_GaussianBlur,"size"), global.resWidth,global.resHeight,4);
			draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);
			shader_reset();
			
			draw_set_alpha(0.25);
			draw_rectangle(0,0,ww,hh,false);
			draw_set_alpha(1);
			
			#region Draw Map
			if(currentScreen == Screen.Map)
			{
				// now we're actually drawing the map
				if(global.rmMapSprt != noone)// && surface_exists(mapSurf))
				{
					var mx = ww/2 - mapX,
						my = hh/2 - mapY;
					scr_DrawMap(global.rmMapSprt,scr_round(mx),scr_round(my),0,0,sprite_get_width(global.rmMapSprt),sprite_get_height(global.rmMapSprt));
					
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
				DrawInventoryPlayer();
				
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
				var xL1 = global.resWidth/2 - 121,
					xL2 = global.resWidth/2 - 119,
					xL3 = global.resWidth/2 - 113,
					xR1 = global.resWidth/2 + 48,
					xR2 = global.resWidth/2 + 50,
					xR3 = global.resWidth/2 + 56;
				var textH = 7;
				draw_sprite(sprt_Sub_ItemHeader,0,xL1-1,53);
				var yoff = 2;
				for(var i = 0; i < array_length(P.hasBeam); i++)
				{
					if(P.hasBeam[i])
					{
						draw_sprite(sprt_Sub_ItemBox,0+2*(!P.beam[i]),xL1,59+10*i+yoff);
						if(beamSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,0+2*(!P.beam[i]),xL1,59+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,xL2,61+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,xL2,61+10*i+yoff,1,1,0,c_white,(1-selectorAlpha)*1.25);
						}
						draw_sprite_part(sprt_Sub_ItemName_Beam,i+array_length(P.hasBeam)*(!P.beam[i]),0,0,textAnim,textH,xL3,60+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
				
				draw_sprite(sprt_Sub_ItemHeader,1,xL1-1,133);
				yoff = 2;
				for(var i = 0; i < array_length(P.hasBoots); i++)
				{
					if(P.hasBoots[i])
					{
						draw_sprite(sprt_Sub_ItemBox,0+2*(!P.boots[i]),xL1,139+10*i+yoff);
						if(bootsSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,0+2*(!P.boots[i]),xL1,139+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,xL2,141+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,xL2,141+10*i+yoff,1,1,0,c_white,selectorAlpha);
						}
						draw_sprite_part(sprt_Sub_ItemName_Boots,i+array_length(P.hasBoots)*(!P.boots[i]),0,0,textAnim,textH,xL3,140+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
				
				draw_sprite(sprt_Sub_ItemHeader,2,xR1-2,53);
				yoff = 2;
				for(var i = 0; i < array_length(P.hasSuit); i++)
				{
					if(P.hasSuit[i])
					{
						draw_sprite(sprt_Sub_ItemBox,1+2*(!P.suit[i]),xR1,59+10*i+yoff);
						if(suitSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,1+2*(!P.suit[i]),xR1,59+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,xR2,61+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,xR2,61+10*i+yoff,1,1,0,c_white,selectorAlpha);
						}
						draw_sprite_part(sprt_Sub_ItemName_Suit,i+array_length(P.hasSuit)*(!P.suit[i]),0,0,textAnim,textH,xR3,60+10*i+yoff);
					}
					else
					{
						yoff -= 10;
					}
				}
				
				draw_sprite(sprt_Sub_ItemHeader,3,xR1-2,113);
				yoff = 2;
				for(var i = 0; i < array_length(P.hasMisc); i++)
				{
					if(P.hasMisc[i])
					{
						draw_sprite(sprt_Sub_ItemBox,1+2*(!P.misc[i]),xR1,119+10*i+yoff);
						if(miscSelect == i)
						{
							gpu_set_blendmode(bm_add);
							draw_sprite_ext(sprt_Sub_ItemNav_Box,1+2*(!P.misc[i]),xR1,119+10*i+yoff,1,1,0,c_white,selectorAlpha*1.25);
							gpu_set_blendmode(bm_normal);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,xR2,121+10*i+yoff,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,xR2,121+10*i+yoff,1,1,0,c_white,selectorAlpha);
						}
						draw_sprite_part(sprt_Sub_ItemName_Misc,i+array_length(P.hasMisc)*(!P.misc[i]),0,0,textAnim,textH,xR3,120+10*i+yoff);
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
				
				if(confirmRestart == -1 && confirmQuitMM == -1 && confirmQuitDT == -1)
				{
					var oX = scr_round(ww/2 - 96),
						oY = scr_round(hh/2 - 48);
					
					for(var o = 0; o < array_length(option); o++)
					{
						var oY2 = oY + (o*space);
						
						var col = c_black,
							alph = 0.5,
							indent = 0;
						if(optionPos == o)
						{
							col = c_white;
							alph = 0.15;
							indent = 4;
							
							draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX+indent-4,oY2+string_height(option[o])/2,1,1,0,c_white,1);
						}
						scr_DrawOptionText(oX+indent,oY2,option[o],c_white,1,string_width(option[o])+1,col,alph);
					}
				}
				else
				{
					var oX = scr_round(ww/2),
						oY = scr_round(hh/2 - space*2);
					
					var text = option[optionPos];
					scr_DrawOptionText(scr_round(oX-string_width(text)/2),oY,text,c_white,1,string_width(text)+1,c_black,0.5);
					text = confirmText[0];
					scr_DrawOptionText(scr_round(oX-string_width(text)/2),oY+space*1.5,text,c_white,1,string_width(text)+1,c_black,0.5);
					
					var oY2 = scr_round(hh/2 + space);
					for(var i = 0; i < 2; i++)
					{
						text = confirmText[1+i];
						
						//var oX2 = scr_round(oX - space*1.5 + i*space*3 - string_width(text)/2),
						var oX2 = scr_round((oX + space*1.5 - i*space*3) - string_width(text)/2),
							col = c_black,
							alph = 0.5,
							indent = 0;
						if(confirmPos == i)
						{
							col = c_white;
							alph = 0.15;
							indent = 4;
							
							draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX2-4,oY2+string_height(text)/2,1,1,0,c_white,1);
						}
						scr_DrawOptionText(oX2,oY2,text,c_white,1,string_width(text)+1,col,alph);
					}
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
			
			draw_sprite(sprt_Sub_Base,0,global.resWidth/2,0);
			draw_sprite(sprt_Sub_Header,currentScreen,global.resWidth/2,32);
			
			draw_surface_ext(application_surface,0,0,1,1,0,c_white,1-pauseFade);
			
			surface_reset_target();
			
			//if(isPaused || !instance_exists(obj_ControlOptions))
			//{
				gpu_set_blendenable(false);
				draw_surface_ext(pauseSurf,xx,yy,1,1,0,c_white,1);
				gpu_set_blendenable(true);
			//}
		}
		else
		{
			pauseSurf = surface_create(global.resWidth,global.resHeight);
		}
	}
	if(loadFade > 0)
	{
		draw_set_color(c_black);
		draw_set_alpha(min(loadFade,1));
		draw_rectangle(xx,yy,xx+ww,yy+hh,false);
		draw_set_alpha(1);
	}
}