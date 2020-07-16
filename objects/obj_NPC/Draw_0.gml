/// @description Draw

if(dmgFlash > 2)
{
    shader_set(shd_WhiteFlash);
}
else if(frozen > 120 || (frozen&2))
{
    shader_set(shd_Frozen);
}

var xx = x + lengthdir_x(offsetX,rotation) + lengthdir_x(offsetY,rotation-90);
var yy = y + lengthdir_y(offsetX,rotation) + lengthdir_y(offsetY,rotation-90);

draw_sprite_ext(sprite_index,image_index,xx,yy,image_xscale,image_yscale,rotation,c_white,image_alpha);
shader_reset();

dmgFlash = max(dmgFlash-1,0);