var subSamusX = 160,
    subSamusY = 36;

samusScreenDesX = 0;
samusScreenDesY = 0;

samusGlowInd = -1;

if(suitSelect != -1)
{
    if(global.suit[suitSelect])
    {
        samusGlowInd = 0;
    }
}

if(beamSelect != -1)
{
    if(global.beam[beamSelect])
    {
        samusGlowInd = 1;
    }
    samusScreenDesX = 10;
    samusScreenDesY = -20;
}
if(miscSelect != -1)
{
    if(global.misc[miscSelect])
    {
        samusGlowInd = 3;
        if(miscSelect == 2)
        {
            samusGlowInd = 2;
        }
    }
    samusScreenDesX = -10;
    samusScreenDesY = -20;
}
if(bootsSelect != -1)
{
    if(global.boots[bootsSelect])
    {
        samusGlowInd = 6;
        if(bootsSelect == 1)
        {
            samusGlowInd = 5;
        }
        if(bootsSelect == 2)
        {
            samusGlowInd = 4;
        }
    }
    samusScreenDesY = -145;
}

var sDist = point_distance(samusScreenPosX,samusScreenPosY,samusScreenDesX,samusScreenDesY),
    sAngl = point_direction(samusScreenPosX,samusScreenPosY,samusScreenDesX,samusScreenDesY);

if(sDist > 0)
{
    samusScreenPosX += lengthdir_x(max(sDist/6,min(sDist,0.25)),sAngl);
    samusScreenPosY += lengthdir_y(max(sDist/6,min(sDist,0.25)),sAngl);
}

draw_sprite_ext(sprt_SubscreenShadow_Samus,obj_Player.suit[0],xx+subSamusX+samusScreenPosX,yy+subSamusY+samusScreenPosY,1,1,0,c_white,screenfade);

/*var sprtInd = sprt_SubscreenGlow_Samus;
if(obj_Player.suit[0])
{
    sprtInd = sprt_SubscreenGlow_SamusVaria;
}
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprtInd,samusGlowInd,xx+subSamusX+samusScreenPosX,yy+subSamusY+samusScreenPosY,1,1,0,make_colour_rgb(136,232,16),screenfade);
draw_set_blend_mode(bm_normal);*/


var j = 0;
if(obj_Player.suit[0])
{
    j = 1;
}
if(obj_Player.suit[1])
{
    j = 2;
}
/*if(obj_Player.suit[2])
{
    j = 3;
}*/
draw_sprite_ext(sprt_Subscreen_Samus,clamp(((j*2)-2)+obj_Player.suit[0],0,5),xx+subSamusX+samusScreenPosX,yy+subSamusY+samusScreenPosY,1,1,0,c_white,screenfade);
if(obj_Player.misc[2])
{
    draw_sprite_ext(sprt_Subscreen_SamusArm,j,xx+subSamusX+46+samusScreenPosX,yy+subSamusY+93+samusScreenPosY,1,1,0,c_white,screenfade);
}
if(obj_Player.boots[1])
{
    draw_sprite_ext(sprt_Subscreen_SamusBoots2,j,xx+subSamusX+samusScreenPosX,yy+subSamusY+221+samusScreenPosY,1,1,0,c_white,screenfade);
}
if(obj_Player.boots[0])
{
    draw_sprite_ext(sprt_Subscreen_SamusBoots,j,xx+subSamusX+samusScreenPosX,yy+subSamusY+268+samusScreenPosY,1,1,0,c_white,screenfade);
}
for(var i = 0; i < 4; i++)
{
    if(obj_Player.beam[i+1])
    {
        draw_sprite_ext(sprt_Subscreen_SamusGunLights,i,xx+subSamusX-62+samusScreenPosX,yy+subSamusY+93+samusScreenPosY,1,1,0,c_white,screenfade);
    }
}

if(samusGlowInd != -1)
{
    
    if(samusGlowInd != samusGlowIndPrev)
    {
         samusFlashAnimAlpha = 0.75;
    }
    if(toggleItem)
    {
        samusFlashAnimAlpha = 1;
    }

    if(!surface_exists(samusGlowSurf))
    {
        samusGlowSurf = surface_create(ww,hh);
    }
    else
    {
        surface_set_target(samusGlowSurf);
        draw_clear_alpha(0,0);

        var sprtInd = sprt_SubscreenGlow_Samus;
        if(obj_Player.suit[0])
        {
            sprtInd = sprt_SubscreenGlow_SamusVaria;
        }
    
        gpu_set_colorwriteenable(0,0,0,1);
        var height = 20;
        var totHeight = sprite_get_height(sprtInd)+(height*2);
        samusGlowY = scr_wrap(samusGlowY + 1, 0, totHeight);
        
        for(var i = -height; i < height; i++)
        {
            var ly = (subSamusY - sprite_get_yoffset(sprtInd))+samusScreenPosY+samusGlowY-height + i,
                lx1 = (subSamusX - sprite_get_xoffset(sprtInd))+samusScreenPosX,
                lx2 = (subSamusX + (sprite_get_width(sprtInd)-sprite_get_xoffset(sprtInd)))+samusScreenPosX;
            
            draw_set_color(c_white);
            draw_set_alpha((1-(abs(i)/height))*0.75);
            draw_line(lx1,ly,lx2,ly);
            
            var ly2 = scr_wrap(ly + (totHeight/3),0,totHeight);
            draw_line(lx1,ly2,lx2,ly2);
            
            var ly3 = scr_wrap(ly + ((totHeight/3)*2),0,totHeight);
            draw_line(lx1,ly3,lx2,ly3);
    
            draw_set_color(c_black);
            draw_set_alpha(1);
        }
        gpu_set_colorwriteenable(1,1,1,0);
        draw_sprite_ext(sprtInd,samusGlowInd,subSamusX+samusScreenPosX,subSamusY+samusScreenPosY,1,1,0,make_colour_rgb(136,232,16),1);
        gpu_set_colorwriteenable(1,1,1,1);
        
        if(samusFlashAnimAlpha > 0)
        {
            draw_sprite_ext(sprtInd,samusGlowInd,subSamusX+samusScreenPosX,subSamusY+samusScreenPosY,1,1,0,make_colour_rgb(136,232,16),samusFlashAnimAlpha);
        }
        
        surface_reset_target();
        
        gpu_set_blendmode(bm_add);
        draw_surface_ext(samusGlowSurf,xx,yy,1,1,0,c_white,screenfade);
        gpu_set_blendmode(bm_normal);
        
        samusFlashAnimAlpha = max(samusFlashAnimAlpha-0.075,0);
    }
}
else
{
    samusGlowY = 0;
}

draw_set_color(c_black);
draw_set_alpha(screenfade);
draw_rectangle(xx+7,yy+53,xx+87,yy+95,false);
draw_rectangle(xx+7,yy+115,xx+87,yy+187,false);
draw_rectangle(xx+232,yy+53,xx+312,yy+125,false);
draw_rectangle(xx+232,yy+145,xx+312,yy+187,false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_sprite_ext(sprt_Subscreen_ItemBase,0,xx+8,yy+54,1,1,0,c_white,screenfade);
draw_sprite_ext(sprt_Subscreen_ItemBase,1,xx+8,yy+116,1,1,0,c_white,screenfade);
draw_sprite_ext(sprt_Subscreen_ItemBase,2,xx+233,yy+54,1,1,0,c_white,screenfade);
draw_sprite_ext(sprt_Subscreen_ItemBase,3,xx+233,yy+146,1,1,0,c_white,screenfade);

selectorAlpha = clamp(selectorAlpha + 0.05*sAlphaNum,0,1);
if(selectorAlpha <= 0)
{
    sAlphaNum = 1;
}
if(selectorAlpha >= 1)
{
    sAlphaNum = -1;
}

var itemInd = 0;

//Suits
for(i = 0; i < array_length_1d(global.suit); i++)
{
    if(global.suit[i])
    {
        draw_sprite_ext(sprt_Subscreen_Item_Suits,i+(3*obj_Player.suit[i]),xx+11,yy+(63+(10*i)),1,1,0,c_white,screenfade);
    }
}
if(suitSelect != -1)
{
    for(i = 0; i < array_length_1d(global.suit); i++)
    {
        if(i == suitSelect)
        {
            draw_sprite_ext(sprt_Subscreen_SelectorDot,0,xx+13,yy+(65+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorDot,1,xx+13,yy+(65+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,0,xx+11,yy+(63+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,1,xx+11,yy+(63+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
        }
    }
}

//Beams
for(i = 0; i < array_length_1d(global.beam); i++)
{
    if(global.beam[i])
    {
        draw_sprite_ext(sprt_Subscreen_Item_Beams,i+(6*obj_Player.beam[i]),xx+11,yy+(125+(10*i)),1,1,0,c_white,screenfade);
    }
}
if(beamSelect != -1)
{
    itemInd = 1;
    for(i = 0; i < array_length_1d(global.beam); i++)
    {
        if(i == beamSelect)
        {
            draw_sprite_ext(sprt_Subscreen_SelectorDot,0,xx+13,yy+(127+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorDot,1,xx+13,yy+(127+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,0,xx+11,yy+(125+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,1,xx+11,yy+(125+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
        }
    }
}

//Misc
for(i = 0; i < array_length_1d(global.misc); i++)
{
    if(global.misc[i])
    {
        draw_sprite_ext(sprt_Subscreen_Item_Misc,i+(6*obj_Player.misc[i]),xx+236,yy+(63+(10*i)),1,1,0,c_white,screenfade);
    }
}
if(miscSelect != -1)
{
    itemInd = 2;
    for(i = 0; i < array_length_1d(global.misc); i++)
    {
        if(i == miscSelect)
        {
            draw_sprite_ext(sprt_Subscreen_SelectorDot,0,xx+238,yy+(65+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorDot,1,xx+238,yy+(65+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,0,xx+236,yy+(63+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,1,xx+236,yy+(63+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
        }
    }
}

//Boots
for(i = 0; i < array_length_1d(global.boots); i++)
{
    if(global.boots[i])
    {
        draw_sprite_ext(sprt_Subscreen_Item_Boots,i+(3*obj_Player.boots[i]),xx+236,yy+(155+(10*i)),1,1,0,c_white,screenfade);
    }
}
if(bootsSelect != -1)
{
    itemInd = 3;
    for(i = 0; i < array_length_1d(global.boots); i++)
    {
        if(i == bootsSelect)
        {
            draw_sprite_ext(sprt_Subscreen_SelectorDot,0,xx+238,yy+(157+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorDot,1,xx+238,yy+(157+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,0,xx+236,yy+(155+(10*i)),1,1,0,c_white,screenfade);
            draw_sprite_ext(sprt_Subscreen_SelectorBox,1,xx+236,yy+(155+(10*i)),1,1,0,c_white,selectorAlpha*screenfade);
        }
    }
}


//draw_sprite_ext(sprt_SubscreenShadow_ItemIndicators,itemInd,xx+96,yy+57,1,1,0,c_white,screenfade);
//draw_sprite_ext(sprt_Subscreen_ItemIndicators,itemInd,xx+96,yy+57,1,1,0,c_white,screenfade);