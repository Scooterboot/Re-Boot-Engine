/// @description HUD & Pause Screen

xx = camera_get_view_x(view_camera[0]);
yy = camera_get_view_y(view_camera[0]);
ww = global.resWidth;
hh = global.resHeight;

if(screenfade > 0 && room != rm_MainMenu)
{
    draw_set_color(c_black);
    draw_set_alpha(screenfade*0.75);
    draw_rectangle(xx,yy,xx+ww,yy+hh,false);
    draw_set_alpha(1);
    
    if(section == 0)
    {
    }

    if(section == 1)
    {
        scr_DrawSubscreen();
    }
    else
    {
        samusScreenDesX = 0;
        samusScreenDesY = 0;
        samusScreenPosX = 0;
        samusScreenPosY = 0;
        samusFlashAnimAlpha = 1;
        selectorAlpha = 0;
        sAlphaNum = 1;
    }
    
    if(section == 2)
    {
        var space = 16;
        
        /*cursorframecounter++;
        if(cursorframecounter > 6)
        {
            cursorframe++;
            cursorframecounter = 0;
        }
        if(cursorframe > 3)
        {
            cursorframe = 0;
        }*/

        draw_set_font(GUIFont);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var mX = scr_round(xx + (ww/2) - 112),
            mY = scr_round(yy + (hh/2) - 32);
        //if(!instance_exists(obj_ControlOptions) || pause)
        //{
            for(var m = 0; m < array_length_1d(menu); m++)
            {
                if(menuPos == m)
                {
                    draw_set_color(c_white);
                    draw_set_alpha(0.15*screenfade);
                }
                else
                {
                    draw_set_color(c_black);
                    draw_set_alpha(0.5*screenfade);
                }
                var rX = mX,
                    rY = mY + (m*space);
                draw_rectangle(rX-2,rY-1,rX+string_width(string(menu[m]))+1,rY+string_height(string(menu[m])),false);

                draw_set_alpha(screenfade);

                draw_set_color(c_black);
                draw_text(mX+1,mY + (m*space)+1,string(menu[m]));
                draw_set_color(c_white);
                draw_text(mX,mY + (m*space),string(menu[m]));
            }
            //draw_sprite_ext(sprt_SelectCursor,cursorframe,scr_round(xx + (ww/2) + (mX-8)),scr_round(yy + (hh/2) + (menuPos*space) + mY+1),1,1,0,c_white,screenfade);
        //}
    }
    
    draw_set_color(c_black);
    draw_set_alpha(screenfade);
    draw_rectangle(xx,yy,xx+ww,yy+34,false);
    draw_rectangle(xx,yy+207,xx+ww,yy+hh,false);
    draw_set_alpha(1);

    draw_sprite_ext(sprt_Subscreen_Base,(section == 1),xx,yy,1,1,0,c_white,screenfade);

    draw_sprite_ext(sprt_Subscreen_Nav_Prev,(scr_wrap(section-1,0,2) == sectionAnim),xx+8,yy+217,1,1,0,c_white,screenfade);
    draw_sprite_ext(sprt_Subscreen_Nav_Text,scr_wrap(section-1,0,2),xx+41,yy+219,1,1,0,c_white,screenfade);

    draw_sprite_ext(sprt_Subscreen_Nav_Exit,(!pause),xx+128,yy+217,1,1,0,c_white,screenfade);

    draw_sprite_ext(sprt_Subscreen_Nav_Next,(scr_wrap(section+1,0,2) == sectionAnim),xx+237,yy+217,1,1,0,c_white,screenfade);
    draw_sprite_ext(sprt_Subscreen_Nav_Text,scr_wrap(section+1,0,2),xx+239,yy+219,1,1,0,c_white,screenfade);

    if(secTransitioning)
    {
        draw_set_color(c_black);
        draw_set_alpha(secFade);
        draw_rectangle(xx,yy,xx+ww,yy+hh,false);
        
        if(!secStage)
        {
            secFade = min(secFade + 0.1, 1);
            if(secFade >= 1)
            {
                section = sectionAnim;
                secStage = true;
            }
        }
        else
        {
            secFade = max(secFade - 0.1, 0);
            if(secFade <= 0)
            {
                secTransitioning = false;
            }
        }
    }
    else
    {
        secFade = 0;
        secStage = false;
    }
}

draw_set_color(c_black);
draw_set_alpha(1);

if(room != rm_MainMenu && instance_exists(obj_Player))
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

samusGlowIndPrev = samusGlowInd;