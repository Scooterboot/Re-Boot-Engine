/// @description Player Graphics and After Images

var liquidMovement = (liquidState > 0);

if(!global.gamePaused)
{
	beamPalIndex = 8;
	if(beamChargeAnim == sprt_IceBeamChargeAnim)
	{
		beamPalIndex = 9;
	}
	else if(beamChargeAnim == sprt_PlasmaBeamChargeAnim)
	{
		beamPalIndex = 11;
	}
	else if(beamChargeAnim == sprt_WaveBeamChargeAnim)
	{
		beamPalIndex = 10;
	}


	palShader = pal_PowerSuit;
	if(suit[Suit.Varia])
	{
		palShader = pal_VariaSuit;
	}
	if(suit[Suit.Gravity])
	{
		palShader = pal_GravitySuit;
	}
	palIndex = 1;
	palIndex2 = 1;
	palDif = 0;

	if(introAnimState != -1)
	{
		if(introAnimCounter < 245)
		{
			var introPal = lerp(1,0.5, clamp((introAnimCounter-200)/35,0,1));
			palIndex = 1 + introPal * power(abs(scr_wrap(introAnimCounter,-4,4) / 4), 2);
		}
	}
	if(saveAnimCounter > 0)
	{
		var savePal = 1;//lerp(1,0.5, clamp((saveAnimCounter-200)/35,0,1));
		palIndex = 1 + savePal * power(abs(scr_wrap(saveAnimCounter,-4,4) / 4), 2);
	}

	if(speedFXCounter > 0)
	{
		palIndex = 1+speedFXCounter;
	}


	if(morphFrame > 0)
	{
		morphPal = min(morphPal + 0.25/(1+liquidMovement),1);
	}
	else
	{
		morphPal = max(morphPal - 0.15/(1+liquidMovement),0);
	}
	if(morphPal > 0)
	{
		palIndex2 = 12;
		palDif = morphPal;
	}

	if(hyperFired > 0)
	{
		hyperPal = min(hyperPal+0.25,1);
	}
	else
	{
		hyperPal = max(hyperPal-0.1,0);
	}

	if(hyperPal > 0)
	{
		palIndex2 = 13 + obj_Main.hyperRainbowCycle;
		palDif = hyperPal;
	}
	else if(chargeReleaseFlash > 0)
	{
		palIndex2 = beamPalIndex;
		palDif = 1;
	}
	else
	{
		if(isScrewAttacking && frame[6] >= 1 && spaceJump <= 6 && wjFrame <= 0)
		{
			screwPal = clamp(screwPal + 0.25*screwPalNum, 0, 1);
			if(screwPal >= 1)
			{
				screwPalNum = -1;
			}
			if(screwPal <= 0.25)
			{
				screwPalNum = 1;
			}
			palIndex2 = 5;
			palDif = screwPal;
		}
		else
		{
			screwPal = 0;
			screwPalNum = 1;
			if(shineFXCounter > 0)
			{
				shaderFlash++;
				palIndex2 = 4;
				palDif = shineFXCounter*0.875;
				if(shaderFlash > (shaderFlashMax/2) || shineFXCounter < 1)
				{
					palDif = shineFXCounter*0.625;
				}
			}
			else
			{
				if(statCharge >= maxCharge || (state == State.Dodge && statCharge < maxCharge) || (shineCharge > 0 && state != State.Spark))
				{
					shaderFlash++;
					if(shaderFlash > (shaderFlashMax/2))
					{
						if(statCharge >= maxCharge)
						{
							if(state == State.Somersault || state == State.Dodge)
							{
								palIndex2 = beamPalIndex;
								palDif = 1;
							}
							else
							{
								palIndex2 = 6;
								palDif = 0.125;
							}
						}
						else if(state == State.Dodge)
						{
							palIndex2 = 5;
							palDif = 0.375;
						}
						else if(shineCharge > 0)
						{
							palIndex2 = 4;
							palDif = 0.35;
						}
					}
					else if((state == State.Somersault || state == State.Dodge) && statCharge >= maxCharge)
					{
						palIndex2 = beamPalIndex;
						palDif = 0.375;
					}
				}
				else
				{
					shaderFlash = shaderFlashMax/2;
				
					//if(instance_exists(obj_Heat))
					if(global.rmHeated)
					{
						palIndex2 = 3;
						if(speedFXCounter <= 0)
						{
							heatPal += 0.015 * heatPalNum;
							palDif = clamp(heatPal,0,1);
                        
							if(heatPal >= 1)
							{
								heatPalNum = -1;
							}
							else if(heatPal <= 0)
							{
								heatPalNum = 1;
							}
						}
						else
						{
							heatPal = 0;
							heatPalNum = 1;
						}
					}
					else
					{
						heatPal = 0;
						heatPalNum = 1;
					}
				
					if(debug && boots[Boots.SpeedBoost])
					{
						var num = speedCounter;
						if(((cDash || global.autoDash) && speedBuffer > 0) || speedCounter > 0)
						{
							num += 1;
						}
						/*if(speedFXCounter <= 0 && speedBuffer == speedBufferMax-2 && speedBufferCounter >= speedBufferCounterMax[num]-3 && speedBufferCounter < speedBufferCounterMax[num])
						{
							palIndex = 2;
						}*/
						if(speedFXCounter <= 0 && speedBuffer == speedBufferMax-1)
						{
							palIndex = 2;
						}
					}
				}
			}
		}
	}

	if(heatDmgPalCounter > 30)
	{
		heatDmgPal = min(heatDmgPal + 0.25, 1);
	}
	else
	{
		heatDmgPal = max(heatDmgPal - 0.25, 0);
	}
	if(heatDmgPalCounter > 34)
	{
		heatDmgPalCounter = 0;
	}
	if(heatDmgPal > 0)
	{
		palIndex2 = 6;
		palDif = heatDmgPal * 0.8;
	}

	if(shaderFlash >= shaderFlashMax)
	{
		shaderFlash = 0;
	}

	if(cFlashPal > 0)
	{
		//if(stateFrame == State.CrystalFlash && frame[Frame.CFlash] >= 5)
		if(stateFrame == State.CrystalFlash && torsoR == sprt_CrystalFlash)
		{
			palShader = pal_CrystalFlash;
		
			palIndex = clamp(cFlashPal2+1.25,1,3);
			palIndex2 = 3;
			palDif = cFlashPalDiff;
		}
		else
		{
			palIndex2 = 6;
			palDif = cFlashPal;
		}
	}
}

var hurtflag = false;
if(dmgFlash > 0)
{
	palIndex2 = 6;
	palDif = 0.8;
}
else if(immuneTime > 0 && (immuneTime&1) && !global.roomTrans)
{
	palIndex2 = 7;
	palDif = 1;
	hurtflag = true;
}

UpdatePlayerSurface(palShader,palIndex,palIndex2,palDif);

if(drawAfterImage && !global.gamePaused)
{
	var aftImg = new AfterImage(id,afterImgAlphaMult,afterImageNum);
	ds_list_add(afterImageList, aftImg);
}
for(var i = 0; i < ds_list_size(afterImageList); i++)
{
	var aftImg = afterImageList[| i];
	aftImg.Update();
		
	if(aftImg._delete)
	{
		ds_list_delete(afterImageList,i);
	}
	else
	{
		aftImg.Draw();
	}
}

PreDrawPlayer(x,y,0,1);

if(liquid && !liquidMovement && suit[Suit.Gravity])
{
	gravGlowAlpha += 0.01*gravGlowNum*(!global.gamePaused);
	if(gravGlowAlpha <= 0.75)
	{
		gravGlowNum = max(gravGlowNum,1);
	}
	if(gravGlowAlpha >= 1)
	{
		gravGlowNum = -1;
	}
}
else
{
	gravGlowAlpha = max(gravGlowAlpha - 0.05*(!global.gamePaused),0);
	gravGlowNum = 10;
}
if(gravGlowAlpha > 0 && !hurtflag)
{
	var col = c_fuchsia,
		alp = gravGlowAlpha;
	gpu_set_fog(true,col,0,0);
	gpu_set_blendmode(bm_add);
	for(var i = 0; i < 360; i += 45)
	{
		for(var j = 1; j < 3; j++)
		{
			var gx = x+scr_ceil(lengthdir_x(1,i)*j),
			gy = y+scr_ceil(lengthdir_y(1,i)*j);
			DrawPlayer(gx,gy,rotation,alp*(0.5*(1/6)));
		}
	}
	gpu_set_blendmode(bm_normal);
	gpu_set_fog(false,0,0,0);
}

if((state == State.Spark || state == State.BallSpark) && shineEnd > 0)
{
	var sEnd = abs(shineEnd-shineEndMax),
		sEndMax = shineEndMax-7;
	var dist = abs(scr_wrap(sEnd/sEndMax,-0.5,0.5)) * 20;
	if(dist > 0 && sEnd < sEndMax)
	{
		for(var i = 0; i < 2; i++)
		{
			var edir = -45*shineDir + (sEnd/sEndMax * 360) + 180*i;
		
			//pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
			DrawPlayer(x+lengthdir_x(dist,edir),y+lengthdir_y(dist,edir),rotation,0.5);
			//shader_reset();
		}
	}
}

//pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
DrawPlayer(x,y,rotation,1);
//shader_reset();

PostDrawPlayer(x,y,0,1);

if(!global.gamePaused)
{
	chargeReleaseFlash = max(chargeReleaseFlash - 1, 0);
}
dmgFlash = max(dmgFlash - 1, 0);