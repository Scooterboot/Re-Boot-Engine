
var glowMin = 0,
	glowMax = 0.375,
	glowRate = 0.0125;
glowAlpha = clamp(glowAlpha + glowRate*glowNum, glowMin, glowMax);
if(glowAlpha <= glowMin)
{
	glowNum = 1;
}
if(glowAlpha >= glowMax)
{
	glowNum = -1;
}

draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha);

gpu_set_blendmode(bm_add);
draw_sprite_ext(sprite_index,1,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha*glowAlpha);
bm_reset();
