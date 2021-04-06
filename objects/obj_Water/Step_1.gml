/// -- Water Movement

if(!global.gamePaused)
{
    if (btm <= abs(bspd))
    {
        acc *= -1;
    }
    
    if (Move)
    {
        bspd += acc;
        y += bspd;
    }
    
    if(sign(MoveX) == 1)
    {
        x = scr_wrap(x+MoveX,0,sprite_width);
    }
    if(sign(MoveX) == -1)
    {
        x = scr_wrap(x+MoveX,-sprite_width,0);
    }
}