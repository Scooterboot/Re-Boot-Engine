/// @description 

var pal = 0;
if(dmgFlash > 4)
{
    pal = 2;
}
else if(frozen > 120 || (frozen&2))
{
    pal = 1;
}
chameleon_set(palIndex,pal,0,0,3);
draw_sprite_ext(currentSprt,currentFrame,x,y,dir,1,0,c_white,1);
shader_reset();

dmgFlash = max(dmgFlash-1,0);