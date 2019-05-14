///scr_DrawHUD

var vX = camera_get_view_x(view_camera[0]),
	vY = camera_get_view_y(view_camera[0]);

var col = c_black, alpha = 0.4;

var itemNum = (item[Item.Missile]+item[Item.SMissile]+item[Item.PBomb]+item[Item.Grapple]+item[Item.XRay]);

var selecting = (pauseSelect && !global.roomTrans && !obj_PauseMenu.pause);
    
if(global.hudDisplay && itemNum > 0)
{
	if(selecting)
    {
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(vX,vY,vX+global.resWidth,vY+global.resHeight,false);
        draw_set_alpha(0.75);
        draw_rectangle(vX,vY,vX+global.resWidth,vY+48,false);
        draw_set_alpha(1);
    }

    for(var i = 0; i < array_length_1d(item); i++)
    {
        if(item[i])
        {
            draw_set_color(col);
            draw_set_alpha(alpha);
				
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
			draw_roundrect_ext(vX+x2,vY+y2,vX+x2+ww,vY+y2+hh,8,8,false);
				
			draw_set_alpha(1);
            draw_set_color(c_white);
				
			draw_sprite_ext(sprt_HItem,index+3*i,floor(vX+xx),floor(vY+yy),1,1,0,c_white,1);
				
			if(i == 0)
			{
				draw_sprite_ext(sprt_HNumFont2,missileStat,floor(vX+85),floor(vY+7),1,1,0,c_white,1);
                var missileNum = floor(missileStat/10);
                draw_sprite_ext(sprt_HNumFont2,missileNum,floor(vX+79),floor(vY+7),1,1,0,c_white,1);
                missileNum = floor(missileStat/100);
                draw_sprite_ext(sprt_HNumFont2,missileNum,floor(vX+73),floor(vY+7),1,1,0,c_white,1);
			}
			if(i == 1)
			{
				draw_sprite_ext(sprt_HNumFont2,superMissileStat,floor(vX+123),floor(vY+7),1,1,0,c_white,1);
                var superMissileNum = floor(superMissileStat/10);
                draw_sprite_ext(sprt_HNumFont2,superMissileNum,floor(vX+117),floor(vY+7),1,1,0,c_white,1);
			}
			if(i == 2)
			{
				draw_sprite_ext(sprt_HNumFont2,powerBombStat,floor(vX+158),floor(vY+7),1,1,0,c_white,1);
                var powerBombNum = floor(powerBombStat/10);
                draw_sprite_ext(sprt_HNumFont2,powerBombNum,floor(vX+152),floor(vY+7),1,1,0,c_white,1);
			}
        }
    }
	
	if(selecting)
	{
		draw_set_color(c_white);
        draw_set_font(MenuFont);
		var strg = itemName[itemHighlighted[1]],
        tX = 123 - scr_round(string_width(strg) / 2);
        draw_text_transformed(vX+tX,vY+21,itemName[itemHighlighted[1]],1,1,0);
		var xx = 69,
			yy = 38;
		for(var i = 0; i < array_length_1d(item); i++)
		{
			xx = 50 + 36*i;
			if(item[i])
			{
				draw_sprite_ext(sprt_HItemMisc,i+5*(itemHighlighted[1] == i),vX+xx,vY+yy,1,1,0,c_white,1);
			}
		}
	}
}