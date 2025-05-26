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
	
	/*with(obj_Player)
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
	draw_set_color(c_black);*/
	
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
			shader_set(shd_PauseBlur);
			var tex = surface_get_texture(application_surface),
				texel_x = texture_get_texel_width(tex),
				texel_y = texture_get_texel_height(tex);
			shader_set_uniform_f(shader_get_uniform(shd_PauseBlur,"texelSize"),texel_x,texel_y);
			gpu_set_blendenable(false);
			draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);
			gpu_set_blendenable(true);
			shader_reset();
			
			draw_set_alpha(0.25);
			draw_rectangle(0,0,ww,hh,false);
			draw_set_alpha(1);
			
			#region Draw Map
			if(currentScreen == Screen.Map)
			{
				// now we're actually drawing the map
				if(global.rmMapArea != noone)
				{
					var msSizeW = global.mapSquareSizeW,
						msSizeH = global.mapSquareSizeH;
					
					var mx = ww/2 - mapX,
						my = hh/2 - mapY;
					
					var bgx = -msSizeW + scr_wrap(scr_round(mx),0,msSizeW),
						bgy = -msSizeH + scr_wrap(scr_round(my),0,msSizeH);
					draw_sprite_stretched_ext(sprt_UI_HMapBase,0,bgx,bgy,ww+(msSizeW*2),hh+(msSizeH*2),c_white,0.25);
					
					//obj_Map.DrawMap(global.rmMapArea,0,0,-scr_round(mx),-scr_round(my),global.resWidth,global.resHeight);
					obj_Map.PrepareMapSurf(global.rmMapArea,-scr_round(mx),-scr_round(my),global.resWidth,global.resHeight);
					obj_Map.DrawMap(0,0,-scr_round(mx),-scr_round(my));
					
					var pX = mx + obj_Map.playerMapX * msSizeW + (msSizeW/2),
						pY = my + obj_Map.playerMapY * msSizeH + (msSizeH/2);
					
					pMapIconFrameCounter++;
					if(pMapIconFrameCounter > pMapIconNumSeq[pMapIconFrame])
					{
						pMapIconFrame = scr_wrap(pMapIconFrame+1,0,array_length(pMapIconSeq));
						pMapIconFrameCounter = 0;
					}
					
					draw_sprite_ext(sprt_MapIcon_Player,pMapIconSeq[pMapIconFrame],scr_round(pX),scr_round(pY),1,1,0,c_white,1);
				}
			}
			#endregion
			#region Draw Inventory Screen
			if(currentScreen == Screen.Inventory)
			{
				if(useRetroPlayer)
				{
					DrawInventoryPlayer_Retro();
				}
				else
				{
					DrawInventoryPlayer();
				}
				
				selectorAlpha = clamp(selectorAlpha + 0.05*sAlphaNum,0,1);
				if(selectorAlpha <= 0)
				{
					sAlphaNum = 1;
				}
				if(selectorAlpha >= 1)
				{
					sAlphaNum = -1;
				}
				textAnim = min(textAnim + 0.5, 16);
				
				var suitMax = 0,
					beamMax = 0,
					itemMax = 0;
				for(var i = 0; i < ds_list_size(invListL); i++)
				{
					if(string_pos("Suit",ds_list_find_value(invListL,i)) != 0)
					{
						suitMax++;
					}
					if(string_pos("Beam",ds_list_find_value(invListL,i)) != 0)
					{
						beamMax++;
					}
					if(string_pos("Item",ds_list_find_value(invListL,i)) != 0)
					{
						itemMax++;
					}
				}
				DrawItemHeader(ww/2 - 152,46,itemHeaderText[0],suitMax,1);
				DrawItemHeader(ww/2 - 152,84,itemHeaderText[1],beamMax,1);
				DrawItemHeader(ww/2 - 152,152,itemHeaderText[2],itemMax,1);
				
				for(var i = 0; i < ds_list_size(invListL); i++)
				{
					var ability = invListL[| i];
					var index = string_digits(ability);
					
					var iBoxX = ww/2 - 149,
						iBoxY = 54+10*i;
					var text = "";
					var enabled = false;
					var isItem = false;
					if(i < suitMax)
					{
						text = suitName[index];
						enabled = P.suit[index];
					}
					else if(i-suitMax < beamMax)
					{
						iBoxY = 92+10*(i-suitMax);
						text = beamName[index];
						enabled = P.beam[index];
					}
					else if(i-suitMax-beamMax < itemMax)
					{
						iBoxY = 160+10*(i-suitMax-beamMax);
						text = itemName[index];
						enabled = P.item[index];
						isItem = true;
						if(text == itemName[0])
						{
							text = string(P.missileStat)+"/"+string(P.missileMax);
						}
						if(text == itemName[1])
						{
							text = string(P.superMissileStat)+"/"+string(P.superMissileMax);
						}
						if(text == itemName[2])
						{
							text = string(P.powerBombStat)+"/"+string(P.powerBombMax);
						}
					}
					
					draw_sprite_ext(sprt_Sub_ItemBox,!enabled,iBoxX,iBoxY,1,1,0,c_white,1);
					if(isItem)
					{
						draw_sprite_ext(sprt_Sub_ItemIcons,index,iBoxX+2,iBoxY+1,1,1,0,c_white,1);
					}
					else
					{
						draw_sprite_ext(sprt_Sub_ItemDot,!enabled,iBoxX+2,iBoxY+2,1,1,0,c_white,1);
					}
					if(invPos == i && invPosX == 0)
					{
						gpu_set_blendmode(bm_add);
						draw_sprite_ext(sprt_Sub_ItemNav_Box,!enabled,iBoxX,iBoxY,1,1,0,c_white,selectorAlpha*1.25);
						gpu_set_blendmode(bm_normal);
						if(!isItem)
						{
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,iBoxX+2,iBoxY+2,1,1,0,c_white,1);
							draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,iBoxX+2,iBoxY+2,1,1,0,c_white,(1-selectorAlpha)*1.25);
						}
					}
					draw_set_alpha(1);
					draw_set_halign(fa_left);
					draw_set_valign(fa_top);
					draw_set_font(fnt_GUI_Small2);
					var subTxt = string_copy(text,1,scr_floor(textAnim));
					var xoffset = 8;
					if(isItem)
					{
						xoffset = 15;
						if(index == Item.PBomb)
						{
							xoffset = 11;
						}
						if(index == Item.Grapple || index == Item.XRay)
						{
							xoffset = 12;
						}
					}
					TextOutlineSurface(subTxt);
					draw_set_color(c_white);
					var textBGColor = make_color_rgb(0,96,107);
					if(!enabled)
					{
						draw_set_color(c_gray);
						textBGColor = make_color_rgb(53,101,107);
					}
					draw_surface_ext(textSurface,iBoxX+xoffset-1,iBoxY,1,1,0,textBGColor,0.5);
					draw_text(iBoxX+xoffset,iBoxY+1,subTxt);
				}
				
				var miscMax = 0,
					bootsMax = 0;
				for(var i = 0; i < ds_list_size(invListR); i++)
				{
					if(string_pos("Misc",ds_list_find_value(invListR,i)) != 0)
					{
						miscMax++;
					}
					if(string_pos("Boots",ds_list_find_value(invListR,i)) != 0)
					{
						bootsMax++;
					}
				}
				DrawItemHeader(ww/2 + 152,64,itemHeaderText[3],miscMax,-1);
				DrawItemHeader(ww/2 + 152,152,itemHeaderText[4],bootsMax,-1);
				
				for(var i = 0; i < ds_list_size(invListR); i++)
				{
					var ability = invListR[| i];
					var index = string_digits(ability);
					
					var iBoxX = ww/2 + 149,
						iBoxY = 72+10*i;
					var text = "";
					var enabled = false;
					if(i < miscMax)
					{
						text = miscName[index];
						enabled = P.misc[index];
					}
					else if(i-miscMax < bootsMax)
					{
						iBoxY = 160+10*(i-miscMax);
						text = bootsName[index];
						enabled = P.boots[index];
					}
					
					draw_sprite_ext(sprt_Sub_ItemBox,!enabled,iBoxX,iBoxY,-1,1,0,c_white,1);
					draw_sprite_ext(sprt_Sub_ItemDot,!enabled,iBoxX-71,iBoxY+2,1,1,0,c_white,1);
					if(invPos == i && invPosX == 1)
					{
						gpu_set_blendmode(bm_add);
						draw_sprite_ext(sprt_Sub_ItemNav_Box,!enabled,iBoxX,iBoxY,-1,1,0,c_white,selectorAlpha*1.25);
						gpu_set_blendmode(bm_normal);
						draw_sprite_ext(sprt_Sub_ItemNav_Dot,0,iBoxX-71,iBoxY+2,1,1,0,c_white,1);
						draw_sprite_ext(sprt_Sub_ItemNav_Dot,1,iBoxX-71,iBoxY+2,1,1,0,c_white,(1-selectorAlpha)*1.25);
					}
					draw_set_alpha(1);
					draw_set_halign(fa_left);
					draw_set_valign(fa_top);
					draw_set_font(fnt_GUI_Small2);
					var subTxt = string_copy(text,1,scr_floor(textAnim));
					
					TextOutlineSurface(subTxt);
					draw_set_color(c_white);
					var textBGColor = make_color_rgb(0,96,107);
					if(!enabled)
					{
						draw_set_color(c_gray);
						textBGColor = make_color_rgb(53,101,107);
					}
					draw_surface_ext(textSurface,iBoxX-66,iBoxY,1,1,0,textBGColor,0.5);
					draw_text(iBoxX-65,iBoxY+1,subTxt);
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
					
				draw_set_font(fnt_GUI);
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				
				//if(confirmRestart == -1 && confirmQuitMM == -1 && confirmQuitDT == -1)
				if(!confirmRestart && !confirmQuitMM && !confirmQuitDT)
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
							
							draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oY2+string_height(option[o])/2,1,1,0,c_white,1);
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
							
							draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX2-4,oY2+string_height(text)/2,1,1,0,c_white,1);
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
			
			#region Draw Header
			draw_sprite(sprt_Sub_Header,currentScreen,global.resWidth/2,29);//32);
			draw_set_color(c_white);
			draw_set_alpha(1);
			if(currentScreen == Screen.Inventory)
			{
				draw_sprite_ext(sprt_Sub_SamusText,0,ww/2,35,1,1,0,c_white,1);
			}
			else
			{
				draw_set_halign(fa_center);
				draw_set_valign(fa_top);
				draw_set_font(fnt_Menu);
				
				var headText = headerText[currentScreen];
				if(currentScreen == Screen.Map && global.rmMapIndex >= 0)
				{
					headText = mapAreaText[global.rmMapIndex];
				}
				draw_text(global.resWidth/2,36,headText);
			}
			
			draw_sprite_ext(sprt_Sub_Clock,0,global.resWidth/2-117,31,1,1,0,c_white,1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_font(fnt_GUI_Small2);
			var second = floor(global.currentPlayTime);
			var minute = floor(second / 60);
			var hour = floor(minute / 60);
			while(second >= 60)
			{
				second -= 60;
			}
			while(minute >= 60)
			{
				minute -= 60;
			}
			var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0)+":"+string_format(second,2,0);
			tStr = string_replace_all(tStr," ","0");
			draw_text(ww/2-110,30,tStr);
			
			draw_set_halign(fa_right);
			var percent = (ds_list_size(global.collectedItemList) / global.totalItems) * 100;
			var pStr = string_format(percent,2,0)+"%";
			pStr = string_replace_all(pStr," ","0");
			draw_text(ww/2+118,30,"ITEMS: "+pStr);
			#endregion
			#region Draw Footer
			//draw_sprite(sprt_Sub_Footer,currentScreen,global.resWidth/2,global.resHeight-36);
			
			var fText = footerText[currentScreen];
			if(screenSelect)
			{
				fText = footerText[4];
			}
			var str = InsertIconsIntoString(fText),
				strX = scr_round(ww/2),
				strY = scr_round(hh-23);//scr_round(global.resHeight-36+sprite_get_height(sprt_Sub_Footer)/2);
			if(footerScrib.get_text() != str)
			{
				footerScrib.overwrite(str);
			}
			
			var footerSprt = sprt_Sub_Footer;
			var footerW = sprite_get_width(footerSprt),
				footerH = sprite_get_height(footerSprt),
				strW = footerScrib.get_width(),
				strH = footerScrib.get_height();
			var roundMarginX = footerW/2,
				roundMarginY = footerH/2;
				
			var footerScaleX = max(scr_round(roundMarginX*(footerW+strW-2)/footerW)/roundMarginX,4),
				footerScaleY = max(scr_round(roundMarginY*(footerH+strH-16)/footerH)/roundMarginY,1.2);
			draw_sprite_ext(sprt_Sub_Footer,1,strX,strY,footerScaleX,footerScaleY,0,c_white,0.5);
			draw_sprite_ext(sprt_Sub_Footer,0,strX,strY,footerScaleX,footerScaleY,0,c_white,1);
			
			footerScrib.blend(c_black,1);
			footerScrib.draw(strX+1,strY+1);
			footerScrib.blend(c_white,1);
			footerScrib.draw(strX,strY);
			#endregion
			
			//scr_DrawMouse(mouse_x-xx,mouse_y-yy);
			
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