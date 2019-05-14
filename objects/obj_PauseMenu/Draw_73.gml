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
	
	if(pauseFade > 0)
	{
		draw_set_alpha(0.75*pauseFade);
		draw_rectangle(xx,yy,xx+ww,yy+hh,false);
		draw_set_alpha(1);
		
		if(currentScreen == Screen.Inventory)
		{
			scr_DrawStatusPlayer(xx,yy);
		}
		else
		{
			playerOffsetY = 20;
			playerGlowY = 0;
			playerFlashAlpha = 1;
			playerGlowInd = -1;
			playerGlowIndPrev = -1;
		}
		
	    if(surface_exists(pauseSurf))
		{
			surface_set_target(pauseSurf);
			draw_clear_alpha(c_black,0);
			
			#region Draw Map
			if(currentScreen == Screen.Map)
			{
				
			}
			#endregion
			#region Draw Inventory Screen
			if(currentScreen == Screen.Inventory)
			{
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
				draw_sprite(sprt_Sub_ItemHeader,0,6,51);
				var yoff = 0;
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
				
				draw_sprite(sprt_Sub_ItemHeader,1,6,131);
				yoff = 0;
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
				
				draw_sprite(sprt_Sub_ItemHeader,2,174,51);
				yoff = 0;
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
				
				draw_sprite(sprt_Sub_ItemHeader,3,174,111);
				yoff = 0;
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
				
			}
			#endregion
			
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
			draw_sprite(sprt_Sub_Header,currentScreen,0,0);
			
			surface_reset_target();
			
			draw_surface_ext(pauseSurf,xx,yy,1,1,0,c_white,pauseFade);
		}
		else
		{
			pauseSurf = surface_create(global.resWidth,global.resHeight);
		}
	}
	
	if(instance_exists(obj_Player))
	{
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
	}
}