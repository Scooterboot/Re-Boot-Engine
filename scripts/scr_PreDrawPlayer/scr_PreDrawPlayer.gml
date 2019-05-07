/// @description PreDrawPlayer

var xx = argument0,
	yy = argument1,
	rot = argument2,
	alpha = argument3;

if(stateFrame == State.Morph)
{
	if(state == State.Morph && morphFrame <= 0 && spiderBall)
	{
		spiderGlowAlpha += 0.02 * spiderGlowNum * (!global.gamePaused);
		if(spiderGlowAlpha <= 0.1)
		{
			spiderGlowNum = max(spiderGlowNum,1);
		}
		if(spiderGlowAlpha >= 0.75)
		{
			spiderGlowNum = -1;
		}
	}
	else
	{
		spiderGlowAlpha = max(spiderGlowAlpha - (0.1*(!global.gamePaused)), 0);
		spiderGlowNum = 2;
	}
	if(spiderGlowAlpha > 0)
	{
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_SpiderBallFX,0,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,min(spiderGlowAlpha,0.5)*alpha);
		gpu_set_blendmode(bm_normal);
	}
}
else
{
	spiderGlowAlpha = 0;
	spiderGlowNum = 2;
}