/// @description scr_DrawPlayer(x,y,rotation,alpha,isNotAfterImage=true)

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
			draw_sprite_ext(legs,legFrame,scr_round((surfW/2)+sprtOffsetX),scr_round((surfH/2)+sprtOffsetY),fDir,1,0,c_white,1);
		}
		draw_sprite_ext(torso,bodyFrame,scr_round((surfW/2)+sprtOffsetX),scr_round((surfH/2)+sprtOffsetY+runYOffset),fDir,1,0,c_white,1);
	}
	if(stateFrame == State.Morph)
	{
		if(!global.gamePaused && (argument_count <= 4 || argument[4]))
		{
			/*if(unmorphing)
			{
				morphAlpha = max(morphAlpha - 0.175/(1+liquidMovement), 0);
			}
			else if(morphFrame < 6)
			{
				morphAlpha = min(morphAlpha + 0.075/(1+liquidMovement), 1);
			}*/
			if(morphFrame < 4)
			{
				if(unmorphing)
				{
					morphAlpha = 0;
				}
				else
				{
					morphAlpha = 1;
				}
			}
		}
		var ballSprtIndex = sprt_MorphBall;
		if(misc[3])
		{
			ballSprtIndex = sprt_SpringBall;
		}
		draw_sprite_ext(ballSprtIndex,ballFrame,scr_round((surfW/2)+sprtOffsetX),scr_round((surfH/2)+sprtOffsetY),1,1,0,c_white,morphAlpha);
		if(misc[3])
		{
			draw_sprite_ext(sprt_SpringBall_Shine,0,scr_round((surfW/2)+sprtOffsetX),scr_round((surfH/2)+sprtOffsetY),1,1,0,c_white,morphAlpha);
		}
	}
	
	if(argument_count <= 4 || argument[4])
	{
		if(itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3))
		{
			missileArmFrame = min(missileArmFrame + 1, 4);
		}
		else
		{
			missileArmFrame = max(missileArmFrame - 1, 0);
		}
	}
	if(drawMissileArm && missileArmFrame > 0)
	{
		draw_sprite_ext(sprt_MissileArm,finalArmFrame+(9*(missileArmFrame-1)),scr_round((surfW/2)+sprtOffsetX+scr_round(armOffsetX)),scr_round((surfH/2)+sprtOffsetY+runYOffset+scr_round(armOffsetY)),armDir,1,0,c_white,1);
	}
	if(!drawMissileArm)
	{
		missileArmFrame = 0;
	}
	
	if(stateFrame == State.Grip && climbIndex <= 0 && gripAimFrame == 0 && dir == -1)
	{
		draw_sprite_ext(sprt_ArmGripOverlay,gripFrame,scr_round((surfW/2)+sprtOffsetX),scr_round((surfH/2)+sprtOffsetY+runYOffset),fDir,1,0,c_white,1);
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
	var rot = argument[2],
		sc = dcos(argument[2]),
		ss = dsin(argument[2]),
		sx = (surfW/2),
		sy = (surfH/2);
	draw_surface_ext(playerSurf,scr_round(argument[0])-sc*sx-ss*sy,scr_round(argument[1])-sc*sy-ss*sx,1,1,rot,c_white,argument[3]);
	gpu_set_blendmode(bm_normal);
}
else
{
	playerSurf = surface_create(surfW,surfH);
	surface_set_target(playerSurf);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}