/// @description 

if(dmgFlash > 4)
{
    shader_set(shd_WhiteFlash);
}
else if(frozen > 120 || (frozen&2))
{
    shader_set(shd_Frozen);
}

var rot = rotation; //scr_round(rotation/5.625)*5.625;

var xx = x + lengthdir_x(sprtOffsetX,rot) + lengthdir_x(sprtOffsetY,rot-90);
var yy = y + lengthdir_y(sprtOffsetX,rot) + lengthdir_y(sprtOffsetY,rot-90);

draw_sprite_ext(sprite_index,image_index,xx,yy,image_xscale,image_yscale,rot,c_white,image_alpha);
if(jetFlameSprt != noone && frozen <= 0)
{
	draw_sprite_ext(jetFlameSprt,jetFrame,xx,yy,image_xscale,image_yscale,rot,c_white,image_alpha);
}
shader_reset();

dmgFlash = max(dmgFlash-1,0);