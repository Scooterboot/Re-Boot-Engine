/// @description Draw

if(dmgFlash > 2)
{
    shader_set(shd_WhiteFlash);
}
else if(frozen > 120 || (frozen&2))
{
    shader_set(shd_Frozen);
}

var rot = scr_round(rotation/2.5)*2.5;

var xx = x + lengthdir_x(offsetX,rot) + lengthdir_x(offsetY,rot-90);
var yy = y + lengthdir_y(offsetX,rot) + lengthdir_y(offsetY,rot-90);

draw_sprite_ext(sprite_index,image_index,xx,yy,image_xscale,image_yscale,rot,c_white,image_alpha);
shader_reset();

dmgFlash = max(dmgFlash-1,0);