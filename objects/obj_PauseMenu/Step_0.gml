/// @description Menus
cRight = obj_Control.mRight;
cLeft = obj_Control.mLeft;
cUp = obj_Control.mUp;
cDown = obj_Control.mDown;
cSelect = obj_Control.mSelect;
cBack = obj_Control.mCancel;
cStart = obj_Control.start;
cNext = obj_Control.mNext;
cPrev = obj_Control.mPrev;

if(global.roomTrans)// || instance_exists(obj_DeathAnim))
{
    screenfade = 0;
    exit;
}

if(cStart && rStart && room != rm_MainMenu && (screenfade == 0 || screenfade == 1) && (!instance_exists(obj_ControlOptions) ))// || obj_ControlOptions.keySelectDelay <= 0))
{
    /*if(pause)
    {
        //audio_play_sound(snd_MenuBoop,0,false);
        audio_play_sound(snd_Menu_Cancel,0,false);
    }
    else
    {
        audio_play_sound(snd_Menu_Map,0,false);
    }*/
    if(!secTransitioning)
    {
        pause = !pause;
    }
}

if(pause)
{
    screenfade = min(screenfade + 0.1, 1);
    global.gamePaused = true;
    if(room == rm_MainMenu)
    {
        global.gamePaused = false;
        pause = false;
    }
}
else
{
    screenfade = max(screenfade - 0.1, 0);
    if(!rStart)
    {
        global.gamePaused = false;
    }
}

if(screenfade >= 1 && room != rm_MainMenu && !instance_exists(obj_DisplayOptions) && !instance_exists(obj_AudioOptions) && !instance_exists(obj_ControlOptions))
{
    if(!secTransitioning)
    {
        changeSection = (cNext && rNext) - (cPrev && rPrev);
        sectionAnim = scr_wrap(sectionAnim + changeSection, 0, 2);
        if(changeSection != 0)
        {
            audio_play_sound(snd_MenuBoop,0,false);
            secTransitioning = true;
        }
    }
    section = scr_wrap(section, 0, 2);
    if(section == 0 && !secTransitioning)
    {
        px = global.screenX + (surface_get_width(application_surface)/2);
        py = global.screenY + (surface_get_height(application_surface)/2);
    }
    if(section == 1 && instance_exists(obj_Player))
    {
        if(!secTransitioning)
        {
            moveX = (cRight && rRight) - (cLeft && rLeft);
            moveY = (cDown && rDown) - (cUp && rUp);
            toggleItem = (cSelect && rSelect);
        }
        if(moveX != 0 || moveY != 0)
        {
            audio_play_sound(snd_MenuTick,0,false);
        }

        beamSelect = -1;
        suitSelect = -1;
        miscSelect = -1;
        bootsSelect = -1;

        /*if(itemNav >= 0 && itemNav <= 6)
        {
            itemNav = scr_wrap(itemNav+moveY,0,6);
            if(moveX != 0)
            {
                itemNav = clamp(itemNav+9,9,17);
            }
        }
        else if(itemNav >= 9 && itemNav <= 17)
        {
            itemNav = scr_wrap(itemNav+moveY,9,17);
            if(moveX != 0)
            {
                itemNav = clamp(itemNav-9,0,8);
            }
        }*/
		if(itemNav >= 0 && itemNav <= 6)
        {
            itemNav = scr_wrap(itemNav+moveY,0,6);
            if(moveX != 0)
            {
                if(itemNav <= 1)
				{
					itemNav = 7;
				}
				else
				{
					itemNav = 13;
				}
            }
        }
        else if(itemNav >= 7 && itemNav <= 15)
		{
			itemNav = scr_wrap(itemNav+moveY,7,15);
			if(moveX != 0)
            {
                if(itemNav <= 12)
				{
					itemNav = 0;
				}
				else
				{
					itemNav = 2;
				}
            }
		}

        if(itemNav >= 0 && itemNav <= 1)
        {
            suitSelect = clamp(itemNav,0,2);
            if(toggleItem && global.suit[suitSelect])
            {
                obj_Player.suit[suitSelect] = !obj_Player.suit[suitSelect];
                audio_play_sound(snd_MenuBoop,0,false);
                with(obj_Player)
                {
                    if(torsoR == sprt_StandCenter)
                    {
                        bodyFrame = suit[0];
                    }
                }
            }
        }
        if(itemNav >= 2 && itemNav <= 6)
        {
            beamSelect = clamp(itemNav - 2,0,4);
            if(toggleItem && global.beam[beamSelect])
            {
                obj_Player.beam[beamSelect] = !obj_Player.beam[beamSelect];
                audio_play_sound(snd_MenuBoop,0,false);
            }
        }
        if(itemNav >= 7 && itemNav <= 12)
        {
            miscSelect = clamp(itemNav - 7,0,5);
            if(toggleItem && global.misc[miscSelect])
            {
                obj_Player.misc[miscSelect] = !obj_Player.misc[miscSelect];
                audio_play_sound(snd_MenuBoop,0,false);
            }
        }
        if(itemNav >= 13 && itemNav <= 15)
        {
            bootsSelect = clamp(itemNav - 13,0,2);
            if(toggleItem && global.boots[bootsSelect])
            {
                obj_Player.boots[bootsSelect] = !obj_Player.boots[bootsSelect];
                audio_play_sound(snd_MenuBoop,0,false);
            }
        }
    }
    else
    {
        itemNav = 0;
    }
    if((section == 2 && !secTransitioning))
    {
        var move = (cDown && rDown) - (cUp && rUp),
            select = (cSelect && rSelect),
            back = (cBack && rBack);
        
        if(move != 0)
        {
            menuPos += move;
            audio_play_sound(snd_MenuTick,0,false);
        }
        if(optMenuState <= 0)
        {
            if(menuPos < 0)
            {
                menuPos = array_length_1d(menu) - 1;
            }
            if(menuPos > array_length_1d(menu) - 1)
            {
                menuPos = 0;
            }
            if(select)
            {
                select = false;
                if(menuPos < 3)
                {
                    audio_play_sound(snd_MenuBoop,0,false);
                }
                switch(menuPos)
                {
                    case 0:
                    {
                        instance_create_depth(0,0,-1,obj_DisplayOptions);
                        break;
                    }
                    case 1:
                    {
                        instance_create_depth(0,0,-1,obj_AudioOptions);
                        break;
                    }
                    case 2:
                    {
                        instance_create_depth(0,0,-1,obj_ControlOptions);
                        break;
                    }
                    case 3:
                    {
                        room_goto(rm_MainMenu);
                        global.gamePaused = false;
                        game_restart();
                        break;
                    }
                    case 4:
                    {
                        game_end();
                        break;
                    }
                }
            }
        }
    }
    else if(!secTransitioning)
    {
        optMenuState = -1;
        menuPos = 0;
    }
}

if(screenfade <= 0)
{
    menuPos = 0;
    section = 0;
    sectionAnim = false;
    itemNav = 0;
    optMenuState = -1;
    surface_free(samusGlowSurf);
}

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rBack = !cBack;
rStart = !cStart;
rNext = !cNext;
rPrev = !cPrev;