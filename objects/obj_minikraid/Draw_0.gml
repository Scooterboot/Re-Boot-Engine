/// @description 

if(dmgFlash > 4)
{
    shader_set(shd_WhiteFlash);
}
else if(frozen > 120 || (frozen&2))
{
    shader_set(shd_Frozen);
}
sprtOffsetY = -moveYOffset[walkFrame];

draw_sprite_ext(sprt_MiniKraid_Tail,tailFrame,scr_round(x-5*dir),scr_round(y+16+sprtOffsetY),dir,1,0,c_white,1);
draw_sprite_ext(sprt_MiniKraid_LowerBody,walkFrame,scr_round(x),scr_round(y),dir,1,0,c_white,1);
draw_sprite_ext(sprt_MiniKraid_UpperBody,mouthFrame,scr_round(x),scr_round(y+sprtOffsetY),dir,1,0,c_white,1);
draw_sprite_ext(sprt_MiniKraid_Hand,handFrame,scr_round(x+6*dir),scr_round(y+sprtOffsetY-4),dir,1,0,c_white,1);

shader_reset();

dmgFlash = max(dmgFlash-1,0);