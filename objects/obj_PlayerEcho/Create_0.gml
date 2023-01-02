/// @description Initialize

alpha = 1;
surfW = 80;
surfH = 80;
playerSurf = surface_create(surfW,surfH);

#region DrawEcho
function DrawEcho(posX, posY, rotation, alpha)
{
	if(surface_exists(playerSurf))
	{
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		if(stateFrame != State.Morph || morphFrame > 0 || morphAlpha < 1)
		{
			var torso = torsoR;
			if(fDir == -1)
			{
				torso = torsoL;
			}
		
			if(legs != -1)
			{
				draw_sprite_ext(legs,legFrame,scr_round(surfW/2),scr_round(surfH/2),fDir,1,0,c_white,1);
			}
			draw_sprite_ext(torso,bodyFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
		if(stateFrame == State.Morph)
		{
			var ballSprtIndex = sprt_MorphBall;
			//if(misc[Misc.Spring])
			if(misc[Misc.Spider])
			{
				ballSprtIndex = sprt_SpringBall;
			}
			draw_sprite_ext(ballSprtIndex,ballFrame,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			//if(misc[Misc.Spring])
			if(misc[Misc.Spider])
			{
				draw_sprite_ext(sprt_SpringBall_Shine,0,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			}
		}
	
		if(drawMissileArm && missileArmFrame > 0)
		{
			draw_sprite_ext(sprt_MissileArm,finalArmFrame+(9*(missileArmFrame-1)),scr_round((surfW/2)+scr_round(armOffsetX)),scr_round((surfH/2 + runYOffset)+scr_round(armOffsetY)),armDir,1,0,c_white,1);
		}
		if(!drawMissileArm)
		{
			missileArmFrame = 0;
		}
	
		if(stateFrame == State.Grip && climbIndex <= 0 && gripAimFrame == 0 && dir == -1)
		{
			draw_sprite_ext(sprt_ArmGripOverlay,gripFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
	
		surface_reset_target();
	
		if(dmgFlash <= 0 && immuneTime > 0 && (immuneTime&1))
		{
			gpu_set_blendmode(bm_add);
		}
		else
		{
			gpu_set_blendmode(bm_normal);
		}
		var sc = dcos(rotation),
			ss = dsin(rotation),
			sx = (surfW/2),
			sy = (surfH/2);
		var sxx = scr_round(posX)-sc*sx-ss*sy,
			syy = scr_round(posY)-sc*sy+ss*sx;
		draw_surface_ext(playerSurf,sxx+sprtOffsetX,syy+sprtOffsetY,1,1,rotation,c_white,alpha);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		playerSurf = surface_create(surfW,surfH);
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion