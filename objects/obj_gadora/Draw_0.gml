/// @description 

if(dmgFlash > 4 || (deathTimer > 0 && floor(deathTimer/4) % 2 == 0))
{
    shader_set(shd_WhiteFlash);
}

draw_sprite_ext(sprite_index,frame+3*eyeFrame,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);
shader_reset();

dmgFlash = max(dmgFlash-1,0);