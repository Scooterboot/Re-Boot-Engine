/// @description scr_PostDrawPlayer(x,y,rot,alpha)

var xx = scr_round(argument0),
	yy = scr_round(argument1),
	rot = argument2,
	alph = argument3;

if(misc[3] && stateFrame == State.Morph)
{
	var glowSpeed = 0.25;
	if(state == State.BallSpark)
	{
		glowSpeed = 0.375;
	}
	else if(shineCharge > 0)
	{
		glowSpeed = -0.45;
	}
	var palSet = pal_BallGlow;
	if(suit[0])
	{
		palSet = pal_BallGlow_Varia;
	}
	if(suit[1])
	{
		palSet = pal_BallGlow_Gravity;
	}
	ballGlowIndex = scr_wrap(ballGlowIndex + glowSpeed*(!global.gamePaused), 1, 10);
	pal_swap_set(palSet,ballGlowIndex,0,0,false);
	draw_sprite_ext(sprt_SpringBall_Glow,ballFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,morphAlpha*alph);
	shader_reset();
}
else
{
	ballGlowIndex = 1;
}

if(isScrewAttacking && frame[6] >= 2 && !canWallJump && wjFrame <= 0)
{
	screwFrameCounter += 1*(!global.gamePaused);
	if(screwFrameCounter >= 2)
	{
		screwFrame = scr_wrap(screwFrame+1,0,3);
		screwFrameCounter = 0;
	}
	var a = 0.9;
	if(screwFrameCounter mod 2 != 0)
	{
		a = 0.5;
	}
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(sprt_ScrewAttackFX,screwFrame,xx,yy,dir,1,0,make_color_rgb(0,248,112),alph*a);
	gpu_set_blendmode(bm_normal);
}
else
{
	screwFrame = 0;
	screwFrameCounter = 0;
}


particleFrameMax = floor((maxCharge - statCharge) / 10);
if(statCharge >= 10)
{
	if(!global.gamePaused)
	{
		chargeFrameCounter += 1;
		if(chargeFrameCounter == 1 || chargeFrameCounter == 3)
		{
			particleFrame++;
		}
		if(chargeFrameCounter > 1)
		{
			chargeFrame++;
			chargeFrameCounter = 0;
		}
	}
	chargeSetFrame = 0;
	if(statCharge >= maxCharge*0.25 && statCharge < maxCharge*0.5)
	{
		chargeSetFrame = 1;
	}
	if(statCharge >= maxCharge*0.5 && statCharge < maxCharge*0.75)
	{
		chargeSetFrame = 2;
	}
	if(statCharge >= maxCharge*0.75 && statCharge < maxCharge)
	{
		chargeSetFrame = 3;
	}
	if(statCharge >= maxCharge)
	{
		chargeSetFrame = 4;
	}
	
	if(chargeFrame >= 2)
	{
		chargeFrame = 0;
	}
	chargeSetFrame += chargeFrame;
	
	var isIce = (beamChargeAnim == sprt_IceBeamChargeAnim),
		isWave = (beamChargeAnim == sprt_WaveBeamChargeAnim),
		isSpazer = (beamChargeAnim == sprt_SpazerChargeAnim),
		isPlasma = (beamChargeAnim == sprt_PlasmaBeamChargeAnim);
	
	var partSys = obj_Particles.partSystemB;
	if(string_count("Wave",object_get_name(beamShot)) > 0)
	{
		partSys = obj_Particles.partSystemA;
	}
	if(particleFrame >= particleFrameMax && !global.roomTrans && !global.gamePaused)
	{
		var color1 = c_red, color2 = c_yellow;
		var partType = 0;
		if(isIce)
		{
			color1 = c_blue;
			color2 = c_aqua;
			partType = 1;
		}
		else if(isWave)
		{
			color1 = c_purple;
			color2 = c_fuchsia;
			partType = 2;
		}
		else if(isSpazer)
		{
			color1 = c_red;
			color2 = c_yellow;
			partType = 3;
		}
		else if(isPlasma)
		{
			color1 = c_green;
			color2 = c_lime;
			partType = 4;
		}
		
		var partRange = 24;
		var pX = xx+sprtOffsetX+armOffsetX, pY = yy+sprtOffsetY+runYOffset+armOffsetY;
		var part = instance_create_layer(pX+random_range(-partRange,partRange),pY+random_range(-partRange,partRange),"Player",obj_ChargeParticle);
		part.color1 = color1;
		part.color2 = color2;
		
		var x1 = pX-8,
			x2 = pX+8,
			y1 = pY-8,
			y2 = pY+8;
		chargeEmit = part_emitter_create(partSys);
		part_emitter_region(partSys,chargeEmit,x1,x2,y1,y2,ps_shape_ellipse,ps_distr_gaussian);
		part_emitter_burst(partSys,chargeEmit,obj_Particles.bTrails[partType],2+(statCharge >= maxCharge));
		
		particleFrame = 0;
	}
	else if(part_emitter_exists(partSys,chargeEmit))
	{
		part_emitter_destroy(partSys,chargeEmit);
	}
	if(stateFrame != State.Morph)
	{
		draw_sprite_ext(beamChargeAnim,chargeSetFrame,xx+sprtOffsetX+armOffsetX,yy+sprtOffsetY+runYOffset+armOffsetY,image_xscale,image_yscale,0,c_white,alph);
	}
}
else
{
	chargeSetFrame = 0;
	chargeFrame = 0;
	chargeFrameCounter = 0;
	particleFrame = 0;
}