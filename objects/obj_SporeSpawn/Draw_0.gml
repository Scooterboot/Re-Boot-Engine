/// @description 

if(dmgFlash > 4)
{
    shader_set(shd_WhiteFlash);
}

for(var i = 0; i < 4; i++)
{
	var stemX = lerp(xstart,x,i/4),
		stemY = lerp(ystart,y-48,i/4);
	draw_sprite_ext(sprt_SporeSpawn_Stem,0,stemX,stemY,1,1,0,c_white,1);
}

draw_sprite_ext(sprt_SporeSpawn,coreFrameSeq[coreFrame],x,y,1,1,0,c_white,1);

draw_sprite_ext(sprt_SporeSpawn_Bottom,0,mouthBottom.x,mouthBottom.y,1,1,0,c_white,1);
draw_sprite_ext(sprt_SporeSpawn_Top,0,mouthTop.x,mouthTop.y,1,1,0,c_white,1);

shader_reset();

dmgFlash = max(dmgFlash-1,0);