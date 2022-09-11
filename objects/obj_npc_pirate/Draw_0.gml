/// @description 

var pal = 1;
if(dmgFlash > 4)
{
    pal = 3;
}
else if(frozen > 120 || (frozen&2))
{
    pal = 2;
}
pal_swap_set(palIndex,pal,0,0,false);
draw_sprite_ext(currentSprt,currentFrame,x,y,dir,1,0,c_white,1);
shader_reset();

dmgFlash = max(dmgFlash-1,0);