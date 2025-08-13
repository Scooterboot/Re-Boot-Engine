///scr_DrawHUD_Alt
/*function scr_DrawHUD_Alt() {

	var vX = camera_get_view_x(view_camera[0]),
		vY = camera_get_view_y(view_camera[0]);

	var col = c_black, alpha = 0.4;

	var selecting = (cHSelect && !global.roomTrans && !obj_PauseMenu.pause);

	if(global.hudDisplay || selecting)
	{
		var eOffX = 0;
		var energyTanks = floor(energyMax / 100);
		if(energyTanks > 14)
		{
			eOffX = 7*scr_floor((energyTanks-13)/2);
		}
		var vX2 = vX+eOffX;

	    var itemNum = (item[Item.Missile]+item[Item.SuperMissile]+item[Item.PowerBomb]+item[Item.GrappleBeam]+item[Item.XRayVisor]);
    
	    if(selecting)
	    {
	        draw_set_color(c_black);
	        draw_set_alpha(0.5);
	        draw_rectangle(vX,vY,vX+global.resWidth,vY+global.resHeight,false);
	        draw_set_alpha(0.75);
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
    
	    draw_sprite_ext(sprt_UI_HWepSlot,(hudSlot == 0),floor(vX2+66),floor(vY+10),1,1,0,c_white,1);
	    draw_sprite_ext(sprt_UI_HBeamIcon,beamIconIndex,floor(vX2+66),floor(vY+10),1,1,0,c_white,1);
    
	    if(itemNum > 0)
	    {
	        draw_sprite_ext(sprt_UI_HWepSlot,(hudSlot == 1),floor(vX2+94),floor(vY+10),1,1,0,c_white,1);
	        var iconIndex = hudSlotItem[1];
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
	        if(hudSlot == 0)
	        {
	            strg = beamName[hudSlotItem[0]];
	            tX = scr_round(95 - (string_width(strg) / 2));
	            draw_text_transformed(vX+tX,vY+tY,beamName[hudSlotItem[0]],1,1,0);
            
	            var xBPos = 94 + hudBOffsetX,
	                xBOffset = 28,
	                yBPos = 38;
	            for(var i = 0; i < 5; i += 1)
	            {
	                var j = i;
	                if(hasItem[j] || i == 0)
	                {
	                    comboNum = 10*(item[j] && i != 0);
	                    if(i == hudSlotItem[0])
	                    {
	                        draw_sprite_ext(sprt_UI_HItemBeam,i+5+(5*(item[j] && i != 0)),vX+xBPos,vY+yBPos,1,1,0,c_white,1);
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
	            strg = itemName[hudSlotItem[1]];
	            tX = scr_round(95 - (string_width(strg) / 2));
	            draw_text_transformed(vX+tX,vY+tY,itemName[hudSlotItem[1]],1,1,0);
            
	            var xIPos = 94 + hudIOffsetX,
	                xIOffset = 28,
	                yIPos = 38;
	            for(var i = 0; i < 5; i += 1)
	            {
	                if(item[i])
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
    
	    if(item[0])
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
	    if(item[1])
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
	    if(item[2])
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


}
*/