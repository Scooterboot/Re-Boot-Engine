/// @description 

/*if(dmgFlash > 4)
{
    shader_set(shd_WhiteFlash);
}
else if(frozen > 120 || (frozen&2))
{
    shader_set(shd_Frozen);
}*/

var palIndex = realLife.palIndex,
	palIndex2 = realLife.palIndex2,
	palDif = realLife.palDif;

if(ai[0] == 1 && (ai[1] % 2) == 0)
{
	palIndex = 8;
	palDif = 0;
}

pal_swap_set(pal_Kraid,palIndex,palIndex2,palDif,false);
draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),image_xscale,image_yscale,rotation,c_white,image_alpha);
shader_reset();

dmgFlash = max(dmgFlash-1,0);