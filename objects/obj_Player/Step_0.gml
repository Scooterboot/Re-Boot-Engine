/// @description Physics, States, etc.

var xRayActive = instance_exists(XRay);

if(!global.gamePaused || (xRayActive && !global.roomTrans && !obj_PauseMenu.pause && !pauseSelect))
{
	grappleActive = instance_exists(grapple);
	
	#region Appearance Fanfare Anim & Save Anim
	if(introAnimState == 0)
	{
		if(introAnimCounter == 0)
		{
			obj_Audio.playIntroFanfare = true;
		}
		introAnimCounter++;
		if(introAnimCounter > 15)
		{
			introAnimState = 1;
			introAnimCounter = 0;
		}
	}
	else if(introAnimState == 1)
	{
		if(introAnimCounter > 330)
		{
			introAnimState = -1;
		}
		else
		{
			introAnimCounter++;
		}
		
		if(obj_Control.start)
		{
			introAnimState = -1;
			introAnimCounter = 0;
			obj_Audio.skipIntroFanfare = true;
		}
	}
	else
	{
		introAnimCounter = 0;
	}
	
	if(saveAnimCounter > 0)
	{
		saveAnimCounter--;
	}
	#endregion
	
	if(instance_exists(obj_Main))
	{
		debug = (obj_Main.debug > 0);
	}
	if(debug)
	{
		#region debug keys
		
		#region 0, 9, 8
		if(keyboard_check(ord("0")))
		{
		    energy = energyMax;
		    missileStat = missileMax;
		    superMissileStat = superMissileMax;
		    powerBombStat = powerBombMax;
		}
		if(keyboard_check(ord("9")))
		{
		    dir = 0;
		}
		if(keyboard_check(ord("8")))
		{
		    energy = 1;
			//missileStat = 1;
			//superMissileStat = 1;
			//powerBombStat = 1;
		}
		#endregion
		#region 7
		if(keyboard_check(ord("7")))
		{
			energyMax = 1499;//99 + (100 * energyTanks);
			energy = energyMax;

			missileMax = 250;//5 * missileTanks;
			missileStat = missileMax;

			superMissileMax = 50;//2 * superMissileTanks;
			superMissileStat = superMissileMax;

			powerBombMax = 50;//2 * powerBombTanks;
			powerBombStat = powerBombMax;
		
			for(var i = 0; i < array_length(suit); i++)
			{
				suit[i] = true;
				hasSuit[i] = suit[i];
			}
			for(var i = 0; i < array_length(misc); i++)
			{
				misc[i] = true;
				hasMisc[i] = misc[i];
			}
			for(var i = 0; i < array_length(boots); i++)
			{
				boots[i] = true;
				hasBoots[i] = boots[i];
			}
			for(var i = 0; i < array_length(beam); i++)
			{
				beam[i] = true;
				hasBeam[i] = beam[i];
			}
			for(var i = 0; i < array_length(item); i++)
			{
				item[i] = true;
				hasItem[i] = item[i];
			}
		}
		#endregion
		#region 6
		if(keyboard_check_pressed(ord("6")))
		{
			var rand = irandom(9);
			if(rand == 0 && energyMax < 1499)
			{
				energyMax += 100;
				energy = energyMax;
			}
			else if(rand == 1 && missileMax < 250)
			{
				missileMax += 5;
				missileStat = missileMax;
				item[Item.Missile] = true;
			}
			else if(rand == 2 && superMissileMax < 50)
			{
				superMissileMax += 5;
				superMissileStat = superMissileMax;
				item[Item.SMissile] = true;
			}
			else if(rand == 3 && powerBombMax < 50)
			{
				powerBombMax += 5;
				powerBombStat = powerBombMax;
				item[Item.PBomb] = true;
			}
			else
			{
				if(rand == 4 || rand == 0)
				{
					var ilen = array_length(beam);
					var rnum = irandom(ilen-1),
						rnum2 = ilen;
					while(rnum2 > 0)
					{
						if(!hasBeam[rnum])
						{
							beam[rnum] = true;
							break;
						}
						else
						{
							rnum = scr_wrap(rnum+1,0,ilen);
						}
						rnum2--;
					}
				}
				else if(rand == 5 || rand == 1)
				{
					if(!hasItem[Item.Grapple] && !hasItem[Item.XRay])
					{
						item[irandom_range(Item.Grapple,Item.XRay)] = true;
					}
					else if(!hasItem[Item.Grapple])
					{
						item[Item.Grapple] = true;
					}
					else
					{
						item[Item.XRay] = true;
					}
				}
				else if(rand == 6 || rand == 2)
				{
					var ilen = array_length(misc);
					var rnum = irandom(ilen-1),
						rnum2 = ilen;
					while(rnum2 > 0)
					{
						if(!hasMisc[rnum])
						{
							misc[rnum] = true;
							break;
						}
						else
						{
							rnum = scr_wrap(rnum+1,0,ilen);
						}
						rnum2--;
					}
				}
				else if(rand == 7 || rand == 3)
				{
					var ilen = array_length(boots);
					var rnum = irandom(ilen-1),
						rnum2 = ilen;
					while(rnum2 > 0)
					{
						if(!hasBoots[rnum])
						{
							boots[rnum] = true;
							break;
						}
						else
						{
							rnum = scr_wrap(rnum+1,0,ilen);
						}
						rnum2--;
					}
				}
				else if(rand >= 8)
				{
					var ilen = array_length(suit);
					var rnum = irandom(ilen-1),
						rnum2 = ilen;
					while(rnum2 > 0)
					{
						if(!hasSuit[rnum])
						{
							suit[rnum] = true;
							break;
						}
						else
						{
							rnum = scr_wrap(rnum+1,0,ilen);
						}
						rnum2--;
					}
				}
			}
		
			for(var i = 0; i < array_length(suit); i++)
			{
				if(!hasSuit[i] && suit[i])
				{
					hasSuit[i] = true;
				}
			}
			for(var i = 0; i < array_length(beam); i++)
			{
				if(!hasBeam[i] && beam[i])
				{
					hasBeam[i] = true;
				}
			}
			for(var i = 0; i < array_length(item); i++)
			{
				if(!hasItem[i] && item[i])
				{
					hasItem[i] = true;
				}
			}
			for(var i = 0; i < array_length(misc); i++)
			{
				if(!hasMisc[i] && misc[i])
				{
					hasMisc[i] = true;
				}
			}
			for(var i = 0; i < array_length(boots); i++)
			{
				if(!hasBoots[i] && boots[i])
				{
					hasBoots[i] = true;
				}
			}
		}
		#endregion
		#region 5, 4, 3
		if(keyboard_check_pressed(ord("5")))
		{
			godmode = !godmode;
		}
		if(keyboard_check_pressed(ord("4")))
		{
			hyperBeam = !hyperBeam;
		}
		//if(keyboard_check_pressed(ord("3")))
		if(keyboard_check(ord("3")))
		{
			//for(var i = 0; i < 25; i++)
			//{
				var dx = x-200+irandom(400),
					dy = y-200+irandom(400),
					itemDrop = obj_EnergyDrop;
				switch(irandom(4))
				{
					case 4:
					{
						itemDrop = obj_LargeEnergyDrop;
						break;
					}
					case 3:
					{
						itemDrop = obj_MissileDrop;
						break;
					}
					case 2:
					{
						itemDrop = obj_SuperMissileDrop;
						break;
					}
					case 1:
					{
						itemDrop = obj_PowerBombDrop;
						break;
					}
				}
				instance_create_layer(dx,dy,layer,itemDrop);
			//}
		}
		#endregion
		
		#endregion
	}
	else
	{
		godmode = false;
	}

	liquidLevel = 0;
	liquidState = 0;
	
	immune = false;
	
	lowEnergyThresh = max(30, floor(energyMax/100)*10);
	
	if(energy < lowEnergyThresh)
	{
		if(!audio_is_playing(lowEnergySnd))
		{
			lowEnergySnd = audio_play_sound(snd_LowHealthAlarm,0,true);
			audio_sound_gain(lowEnergySnd,1,0);
			audio_sound_gain(lowEnergySnd,0.25,3500);
		}
		else if(state == State.Hurt && audio_sound_get_gain(lowEnergySnd) <= 0.25)
		{
			audio_sound_gain(lowEnergySnd,1,0);
			audio_sound_gain(lowEnergySnd,0.25,2000);
		}
	}
	else
	{
		audio_stop_sound(lowEnergySnd);
		audio_stop_sound(snd_LowHealthAlarm);
	}
	
	damageReduct = 1;
	if(suit[Suit.Varia])
	{
		damageReduct *= 0.5;
	}
	if(suit[Suit.Gravity])
	{
		damageReduct *= 0.5;
	}

#region Liquid Movement
	var liquidMovement = false;
	var findLiquid = instance_place(x,y,obj_Liquid);
	if(instance_exists(findLiquid))
	{
		liquidLevel = max(bbox_bottom - findLiquid.y,0);

	    var dph = 10;
	    if(stateFrame == State.Morph)
	    {
	        dph = 3;
	    }
	    liquidMovement = (liquidLevel > dph && !suit[Suit.Gravity]);
		
		if(liquidMovement)
		{
			if(findLiquid.liquidType == LiquidType.Water)
			{
				liquidState = 1;
			}
			if(findLiquid.liquidType == LiquidType.Lava)
			{
				liquidState = 2;
			}
		}
	}
#endregion

#region Input
	cRight = obj_Control.right;
	cLeft = obj_Control.left;
	cUp = obj_Control.up;
	cDown = obj_Control.down;
	cJump = obj_Control.jump;
	cShoot = obj_Control.shoot;
	cDash = obj_Control.dash;
	cAngleUp = obj_Control.angleUp;
	cAngleDown = (obj_Control.angleDown && global.aimStyle == 0);
	cAimLock = obj_Control.aimLock;
	cMorph = obj_Control.quickMorph;

	if(state == State.Elevator || state == State.Recharge || state == State.CrystalFlash || instance_exists(obj_MainMenu) || introAnimState != -1)
	{
	    cRight = false;
	    cLeft = false;
	    cUp = false;
	    cDown = false;
	    cJump = false;
	    cShoot = false;
	    cDash = false;
	    cAngleUp = false;
	    cAngleDown = false;
	    cAimLock = false;
		cMorph = false;
	}
#endregion

	move = cRight - cLeft;
	pMove = ((cRight && rRight) - (cLeft && rLeft));
	
	//gunReady2 = ((abs(velX) > 0 || move != 0) && !ledgeFall);
	
	if(move != 0 && !brake && morphFrame <= 0 && wjFrame <= 0 && state != State.Grip && 
	(!cAimLock || cDash || state == State.Somersault || state == State.Morph || xRayActive || (global.aimStyle == 2 && cAngleUp)) && 
	!grappleActive && state != State.Spark && state != State.BallSpark && state != State.Hurt && stateFrame != State.DmgBoost && dmgBoost <= 0 && state != State.Dodge)
	{
		dir = move;
	}
	if(spiderBall && spiderEdge != Edge.None)
	{
		if(spiderMove != 0)
		{
			dir = spiderMove;
			if(spiderEdge == Edge.Top)
			{
				dir = -spiderMove;
			}
		}
	}
	
	if(dir != oldDir)
	{
		lastDir = oldDir;
		
		brake = false;
		brakeFrame = 0;
	}
	
	walkState = ((cAimLock || grappleActive) && velX != 0 && sign(velX) != dir && state == State.Stand && !xRayActive);
	
	if(dir != 0 && cMorph && rMorph && morphFrame <= 0 && state != State.Morph && stateFrame != State.Morph && misc[Misc.Morph] && state != State.Spark && state != State.BallSpark && state != State.Grip && state != State.Grapple && !xRayActive)
	{
		audio_play_sound(snd_Morph,0,false);
		if(state == State.Stand)
		{
			if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
			{
				velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
				speedCounter = 0;
			}
		}
		ChangeState(State.Morph,State.Morph,mask_Morph,grounded);
		morphFrame = 8;
	}

#region Aim Control
	prAngle = ((cAngleUp && rAngleUp) || (cAngleDown && rAngleDown));
	rlAngle = ((!cAngleUp && !rAngleUp) || (!cAngleDown && !rAngleDown));
	
	if(!grappleActive)
	{
		if((aimAngle > -2 && (aimAngle < 2 || state != State.Grip || (rlAngle && global.aimStyle != 2))) ||
			(prAngle && global.aimStyle != 2) || grounded || move != 0 || xRayActive || 
			state == State.Morph || state == State.Somersault || state == State.Spark || state == State.BallSpark)
		{
			//if(!cAimLock)
			//{
				aimAngle = 0;
			//}
		}
		if(!xRayActive)
		{
			if(!grounded && cDown && !cUp && (state != State.Somersault || rDown) && state != State.Morph)
			{
				if(aimAngle == -2 && move == 0 && rDown && morphFrame <= 0 && state != State.Morph && misc[Misc.Morph] && state != State.Spark && state != State.BallSpark && state != State.Grip && !cAngleUp && !cAngleDown)
				{
					audio_play_sound(snd_Morph,0,false);
					ChangeState(State.Morph,State.Morph,mask_Morph,false);
					morphFrame = 8;
				}
				//if(!cAimLock)
				//{
					aimAngle = -2;
				//}
			}
			
			if(((state != State.Morph && (state != State.Crouch || entity_place_collide(0,-11))) || (global.aimStyle == 2 && cAngleUp)) && morphFrame <= 0)// && !cAimLock)
			{
				if(move != 0 && (state != State.Grip || move != dir) && sign(dirFrame) == dir)
				{
					if(cUp && !cDown && aimUpDelay <= 0)
					{
						aimAngle = 1;
					}
					else if(cDown)
					{
						aimAngle = -1;
					}
				}
				else
				{
					if(cUp && !cDown && aimUpDelay <= 0)
					{
						aimAngle = 2;
					}
					if(cDown && !cUp && global.aimStyle == 2 && cAngleUp && grounded)
					{
						aimAngle = -1;//-2;
					}
				}
			}
		
			if(global.aimStyle == 0)// && !cAimLock)
			{
				if(cAngleUp)
				{
					aimAngle = cAngleUp + cAngleDown;
				}
				else if(cAngleDown)
				{
					aimAngle = -1;
				}
			
				if(cAngleUp && cAngleDown && move != 0 && grounded && !walkState && sign(velX) == dir && abs(dirFrame) >= 4)
				{
					aimAngle = 1;
				}
			}
	
			if(global.aimStyle == 1)// && !cAimLock)
			{
				if(cAngleUp)
				{
					if(cDown && !cUp)
					{
						gbaAimAngle = -1;
					}
					else if((cUp && (stateFrame != State.Morph || entity_place_collide(0,-17))) || gbaAimAngle == 0)
					{
						gbaAimAngle = 1;
					}
			
					aimAngle = gbaAimAngle;
				}
				else
				{
					gbaAimAngle = 0;
				}
			}
			else //if(!cAimLock)
			{
				gbaAimAngle = 0;
			}
	
			if(global.aimStyle == 2)
			{
				if(cAngleUp && !spiderBall)
				{
					cUp = false;
					cDown = false;
					cLeft = false;
					cRight = false;
					move = 0;
				}
			}
		}
	}
	
	if(aimAngle != prevAimAngle)
	{
		lastAimAngle = prevAimAngle;
	}
#endregion

#region Horizontal Movement

	var dash = (cDash || global.autoDash);
	
	// basically free super short charge if you uncomment this
	/*if(debug && speedBuffer >= speedBufferMax-1 && speedCounter < speedCounterMax)
	{
		dash = true;
	}*/
	
	var moveState = 0;
	if(state == State.Morph)
	{
		if(grounded)
		{
			if(mockBall)
			{
				moveState = 6;
				if(speedBoost && dash)
				{
					moveState = 2;
				}
			}
			else
			{
				moveState = 5;
			}
		}
		else
		{
			if(misc[Misc.Spring])
			{
				moveState = 8;
			}
			else
			{
				moveState = 7;
			}
		}
	}
	else if(state == State.Jump)
	{
		moveState = 3;
	}
	else if(state == State.Somersault)
	{
		moveState = 4;
	}
	else
	{
		if(dash && !liquidMovement)
		{
			if(boots[Boots.SpeedBoost])
			{
				moveState = 2;
			}
			else
			{
				moveState = 1;
			}
		}
	}
	
	fMaxSpeed = maxSpeed[moveState,liquidState];
	fMoveSpeed = moveSpeed[(state == State.Morph),liquidState];
	fFrict = frict[liquidState];
	
	if(moveState <= 2)
	{
		var runMaxSpd = maxSpeed[0,liquidState],
			dashMaxSpd = maxSpeed[1,liquidState],
			runMoveSpd = moveSpeed[0,liquidState],
			dashMoveSpd = moveSpeed[2,liquidState];

		if(abs(velX) >= runMaxSpd)
		{
			if(abs(velX) < dashMaxSpd)
			{
				fMoveSpeed = lerp(runMoveSpd,dashMoveSpd, (abs(velX)-runMaxSpd) / (dashMaxSpd-runMaxSpd));
			}
			else
			{
				fMoveSpeed = dashMoveSpd;
			}
		}
	}
	
	#region Momentum Logic
	
	if(state == State.Stand)
	{
		if(walkState && sign(velX) != dir)
		{
			fMaxSpeed = maxSpeed[11,liquidState];
			if(abs(velX) > fMaxSpeed)
			{
				if(velX > 0)
				{
					velX = min(velX - fFrict, fMaxSpeed);
				}
				if(velX < 0)
				{
					velX = max(velX + fFrict, -fMaxSpeed);
				}
			}
		}
	}
	
	maxSpeed2 = maxSpeed[1,liquidState];
	if(boots[Boots.SpeedBoost])
	{
		maxSpeed2 = maxSpeed[2,liquidState];
	}
	else if(state == State.Morph)
	{
		maxSpeed2 = maxSpeed[6,liquidState];
	}
	if(move != 0 && abs(velX) > maxSpeed2 && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Dodge && state != State.DmgBoost && (speedCounter > 0 || grounded))
	{
		if(sign(velX) == 1)
		{
			velX = min(velX - fFrict, maxSpeed2);
		}
		if(sign(velX) == -1)
		{
			velX = max(velX + fFrict, -maxSpeed2);
		}
	}
	
	if(state != State.Crouch && state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Grapple && 
	state != State.Hurt && /*state != State.DmgBoost &&*/ (!spiderBall || spiderEdge == Edge.None) && !xRayActive && state != State.Dodge)
	{
		if((move == 1 && !brake) || (state == State.Somersault && dir == 1 && velX > 1.1*moveSpeed[0,liquidState]))
		{
			if(velX <= fMaxSpeed)
			{
				if(velX < 0)
				{
					/*if(state == State.Somersault && velX > -maxSpeed[3,0] && !liquidMovement)
					{
						velX = 0;
					}
					else
					{*/
						velX = min(velX + fMoveSpeed + fFrict, 0);
					//}
				}
				else if(sign(dirFrame) != dir && sign(dirFrame) != 0 && !speedBoost && state != State.Somersault)
				{
					velX = 0;
				}
				else
				{
					velX = min(velX + fMoveSpeed, fMaxSpeed);
				}
			}
		}
		else if((move == -1 && !brake) || (state == State.Somersault && dir == -1 && velX < -1.1*moveSpeed[0,liquidState]))
		{
			if(velX >= -fMaxSpeed)
			{
				if(velX > 0)
				{
					/*if(state == State.Somersault && velX < maxSpeed[3,0] && !liquidMovement)
					{
						velX = 0;
					}
					else
					{*/
						velX = max(velX - fMoveSpeed - fFrict, 0);
					//}
				}
				else if(sign(dirFrame) != dir && sign(dirFrame) != 0 && !speedBoost && state != State.Somersault)
				{
					velX = 0;
				}
				else
				{
					velX = max(velX - fMoveSpeed, -fMaxSpeed);
				}
			}
		}
		else
		{
			//if((grounded || state != State.Somersault) && (aimAngle > -2 || !cJump) && 
			if((aimAngle > -2 || !cJump) && 
			(state != State.Morph || (state == State.Morph && abs(velX) <= maxSpeed[5,liquidState]) || grounded) && morphFrame <= 0)
			{
				if(velX > 0)
				{
					velX = max(velX - fFrict, 0);
				}
				if(velX < 0)
				{
					velX = min(velX + fFrict, 0);
				}
			}
		}
	}
	else
	{
		if(state == State.Crouch)
		{
			if(uncrouch < 7)
			{
				if(velX > 0)
				{
					velX = max(velX - fFrict*2, 0);
				}
				if(velX < 0)
				{
					velX = min(velX + fFrict*2, 0);
				}
			}
		}
		else if(state == State.Dodge && dodgeLength >= dodgeLengthMax-5 && !speedBoost)
		{
			var flag = (!liquidMovement && (move != dir || dodgeDir == -dir));
			if(velX > 0)
			{
				velX = max(velX - fFrict*(1+flag), 0);
			}
			if(velX < 0)
			{
				velX = min(velX + fFrict*(1+flag), 0);
			}
		}
	}
	
	#endregion
	
	#region Speed Booster Logic
	
	if(state == State.Stand && grounded && !liquidMovement && crouchFrame >= 5 && !brake && ((velX != 0 && sign(velX) == dir) || (prevVelX != 0 && sign(prevVelX) == dir)) && !xRayActive)
	{
		var num = speedCounter;
		if((dash && speedBuffer > 0) || speedCounter > 0)
		{
			num += 1;
		}
		
		speedBufferCounter++;
		if(speedBufferCounter >= scr_floor(speedBufferCounterMax[num]))
		{
			speedBuffer++;
			if(dash && speedBuffer >= speedBufferMax)
			{
				speedCounter = min(speedCounter+1,speedCounterMax);
			}
			speedBufferCounter -= speedBufferCounterMax[num];
		}
		if(speedBuffer >= speedBufferMax)
		{
			speedBuffer = 0;
		}
		
		if(speedCounter > 0 && move != dir)
		{
			speedCounter = 0;
		}
	}
	else
	{
		speedBuffer = 0;
		speedBufferCounter = 0;
	}
	
	var sBoostWJFlag = (speedBoost && state == State.Somersault && entity_place_collide(dir*8,0) && speedBoostWallJump);
	if(sBoostWJFlag)
	{
		speedBoostWJCounter = min(speedBoostWJCounter+1,speedBoostWJMax);
	}
	else
	{
		speedBoostWJCounter = 0;
	}
	speedBoostWJ = (sBoostWJFlag && speedBoostWJCounter < speedBoostWJMax && speedBoostWallJump);

	minBoostSpeed = maxSpeed[1,liquidState] + ((maxSpeed[2,liquidState] - maxSpeed[1,liquidState])*0.75);

	var stopBoosting = !speedBoostWJ && ((sign(velX) != dir && sign(prevVelX) != dir) || speedKillCounter >= speedKillMax || (move != dir && (aimAngle > -2 || !cJump) && ((state != State.Somersault && state != State.Morph) || (state == State.Morph && abs(velX) <= maxSpeed[5,liquidState]) || grounded) && morphFrame <= 0));
	var spiderBoosting = (SpiderActive() && sign(spiderSpeed) == spiderMove && abs(spiderSpeed) > maxSpeed[5,liquidState]);
	if(state != State.Grapple && (!boots[Boots.SpeedBoost] || abs(dirFrame) < 4 || stopBoosting) && !spiderBoosting)
	{
		speedCounter = 0;
		speedBoost = false;
	}
	/*else if((cDash || global.autoDash) && abs(fVelX) > 0 && grounded && state == State.Stand && !liquidMovement)
	{
		speedCounter = min(speedCounter+1,speedCounterMax);
	}*/
	
	if(boots[Boots.SpeedBoost])
	{
		if(speedCounter >= speedCounterMax)
		{
			speedBoost = true;
		}
		else if(!speedBoost && abs(velX) >= minBoostSpeed && state != State.Grapple && !grapBoost && state != State.Dodge)
		{
			speedCounter = speedCounterMax;
			speedBoost = true;
		}
	}
	else
	{
		speedCounter = 0;
	}
	
	if(speedBoost && state != State.Spark && state != State.BallSpark)
	{
		if(state != State.Grapple && stopBoosting && !spiderBoosting)// && landFrame <= 0)
		{
			if(state == State.Stand && abs(velX) >= minBoostSpeed-fFrict && abs(velX) > 0 && !cDown && !brake && speedKillCounter <= 0)
			{
				brake = true;
				brakeFrame = 10;
				audio_play_sound(snd_Brake,0,false);
			}
			var speedNum = minBoostSpeed-fFrict;
			if(abs(velX) > speedNum)
			{
				velX = speedNum*sign(velX);
			}
			speedCounter = 0;
		}
		speedCatchCounter = 6*grounded;
		
		if(!speedSoundPlayed)
		{
			audio_stop_sound(snd_SpeedBooster_Loop);
			audio_play_sound(snd_SpeedBooster,0,false);
			speedSoundPlayed = true;
		}
		else
		{
			if(!audio_is_playing(snd_SpeedBooster) && !audio_is_playing(snd_SpeedBooster_Loop))
			{
				audio_play_sound(snd_SpeedBooster_Loop,0,true);
			}
		}
		
		speedFXCounter = min(speedFXCounter + 0.05, 1);
	}
	else
	{
		speedSoundPlayed = false;
		audio_stop_sound(snd_SpeedBooster);
		audio_stop_sound(snd_SpeedBooster_Loop);
		
		speedFXCounter = max(speedFXCounter - 0.075, 0);
		speedCatchCounter = max(speedCatchCounter - 1, 0);
	}
	
	if(shineCharge > 0 && state != State.Spark && state != State.BallSpark)
	{
		if(!audio_is_playing(snd_ShineSpark_Charge))
		{
			audio_play_sound(snd_ShineSpark_Charge,0,true);
		}
	}
	else if(audio_is_playing(snd_ShineSpark_Charge) && state != State.Spark && state != State.BallSpark)
	{
		audio_stop_sound(snd_ShineSpark_Charge);
	}
	
	if((state == State.Stand || state == State.Crouch || state == State.Morph) && (speedBoost || speedCatchCounter > 0) && move == 0 && cDown && dir != 0 && grounded && morphFrame <= 0 && !spiderBall)
	{
		shineCharge = 300;
		speedCounter = 0;
	}
	
	if(speedCounter < speedCounterMax)
	{
		speedBoost = false;
	}
	
	#endregion
	
#endregion

#region Vertical Movement
	if(grounded)
	{
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
	}
	
	fJumpSpeed = jumpSpeed[boots[Boots.HiJump],liquidState];
	fJumpHeight = jumpHeight[boots[Boots.HiJump],liquidState];
	
	if(boots[Boots.SpeedBoost] && abs(velX) > maxSpeed[1,liquidState] && speedCounter > 0)
	{
		fJumpSpeed += max((abs(velX) - maxSpeed[1,liquidState]) / 2, 0);
	}
	
	canMorphBounce = true;
	
	#region Jump Logic
	
	var isJumping = (cJump && dir != 0 && climbIndex <= 0 && state != State.Spark && state != State.BallSpark && 
	state != State.Hurt && (!spiderBall || !sparkCancelSpiderJumpTweak) && !xRayActive && (state != State.Grapple || grapWJCounter > 0));// && state != State.Dodge);
	if(isJumping)
	{
		if(velY > 0 && !grounded)
		{
			jumping = false;
		}
		
		var sjThresh = 2;
		if(liquidTop)
		{
			sjThresh = 1;
		}
		
		if(jump <= 0)
		{
			if(shineCharge > 0 && rJump && (state != State.Crouch || !entity_place_collide(0,-11) || entity_place_collide(0,0)) && !entity_place_collide(0,-1) && 
			(move == 0 || velX == 0) && state != State.Somersault && state != State.DmgBoost && ((!cAngleDown && !cDown) || boots[Boots.ChainSpark]) && 
			(state != State.Morph || misc[Misc.Spring]) && morphFrame <= 0 && state != State.Grip)
			{
				audio_stop_sound(snd_ShineSpark_Charge);
				shineStart = 30;
				shineRestart = false;
				if(state == State.Morph)
				{
					ChangeState(State.BallSpark,State.Morph,mask_Morph,false);
				}
				else
				{
					ChangeState(State.Spark,State.Spark,mask_Jump,false);
				}
			}
			else if((rJump || (state == State.Morph && !spiderBall && rMorphJump) || bufferJump > 0) && /*!jumping &&*/ quickClimbTarget <= 0 && 
			(state != State.Morph || misc[Misc.Spring] || !entity_place_collide(0,-17)) && morphFrame <= 0 && state != State.DmgBoost)
			{
				if(grounded || bunnyJump > 0 || (canWallJump && rJump) || speedBoostWJ || (state == State.Grip && (move != dir || climbTarget == 0) && !cDown) || 
				(boots[Boots.SpaceJump] && velY >= sjThresh && state == State.Somersault && !liquidMovement && rJump))
				{
					if(!grounded && !canWallJump && !speedBoostWJ && boots[Boots.SpaceJump] && velY >= sjThresh)
					{
						spaceJump = 8;
						//frame[Frame.Somersault] = 0;
					}
					if((!grounded || grapWJCounter > 0) && ((canWallJump && rJump) || speedBoostWJ))
					{
						grapWJCounter = 0;
						instance_destroy(grapple);
						grappleDist = 0;
						grappleActive = 0;
						
						audio_stop_sound(snd_Somersault);
						audio_stop_sound(snd_Somersault_Loop);
						audio_stop_sound(snd_Somersault_SJ);
						somerSoundPlayed = false;
						somerUWSndCounter = 16;
						
						audio_stop_sound(snd_ScrewAttack);
						audio_stop_sound(snd_ScrewAttack_Loop);
						screwSoundPlayed = false;
						
						audio_play_sound(snd_WallJump,0,false);
						
						if(state == State.Grip && gripGunReady)
						{
							dir *= -1;
							dirFrame = dir;
						}
						if(speedBoostWJ)
						{
							dir *= -1;
							if(move != 0 && entity_place_collide(-move*8,0))
							{
								dir = move;
							}
							velX = abs(velX)*dir;
							dirFrame = 4*dir;
						}
						else
						{
							var m = move;
							if(move == 0 && dir != 0)
							{
								m = dir;
							}
							if(!speedBoost)
							{
								velX = maxSpeed[4,liquidState]*m;
							}
							ChangeState(State.Somersault,State.Somersault,mask_Crouch,false);
							if(move != 0)
							{
								dir = move;
							}
						}
						wjFrame = 8;
						wjAnimDelay = 10;
						
						if(dodgeRecharge >= dodgeRecharge-dodgeRechargeRate)
						{
							dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate,dodgeRechargeMax);
						}
						
						if(!liquid)
						{
							part_particles_create(obj_Particles.partSystemB,x-6*dir,y+10,obj_Particles.bDust[0],3);
						}
					}
					else if(state == State.Grip && gripGunReady)
					{
						dir *= -1;
						dirFrame = dir;
					}
					
					ledgeFall = false;
					ledgeFall2 = false;
					justFell = false;
					jump += fJumpHeight;
					if(!grounded && canWallJump && liquidMovement)
					{
						jump /= 4;
					}
					jumping = true;
					if(state == State.Crouch)
					{
						jump += 6;
					}
					if((rJump || bufferJump > 0) && state != State.Morph)// && state != State.Grip)
					{
						if(((abs(velX) > 0 && sign(velX) == dir) || (move != 0 && move == dir) || cDash || (!grounded && state != State.Grip) || (state == State.Crouch && entity_place_collide(0,-8))) && !grappleActive)
						{
							var mask = mask_Jump;
							if(entity_place_collide(0,-8))
							{
								mask = mask_Crouch;
							}
							ChangeState(State.Somersault,State.Somersault,mask,false);
						}
						else
						{
							ChangeState(State.Jump,State.Jump,mask_Jump,false);
						}
					}
					if((rJump || bufferJump > 0) && state == State.Morph && (cDash || !misc[Misc.Spring]))
					{
						morphSpinJump = true;
					}
					bunnyJump = 0;
					bufferJump = 0;
				}
				else if(rJump)
				{
					if(state != State.Morph && state != State.Grip && !grappleActive)
					{
						ChangeState(State.Somersault,State.Somersault,mask_Crouch,false);
					}
					if(state == State.Morph && cDash)
					{
						morphSpinJump = true;
					}
				}
				if(rMorphJump)
				{
					canMorphBounce = false;
				}
			}
			else
			{
				jump = 0;
			}
		}
		
		if(jump > 0)
		{
			if(spiderBall)
			{
				var jumpX = lengthdir_x(fJumpSpeed,spiderJumpDir) + spiderJump_SpeedAddX,
					jumpY = lengthdir_y(fJumpSpeed,spiderJumpDir) + spiderJump_SpeedAddY;
				if(jumpX != 0)
				{
					velX = jumpX;
					dir = sign(velX);
				}
				if(jumpY != 0)
				{
					velY = jumpY;
				}
				spiderEdge = Edge.None;
				prevSpiderEdge = Edge.None;
				notGrounded = true;
			}
			else
			{
				velY = -fJumpSpeed;
			}
			jump -= 1;
			
			ledgeFall = false;
			ledgeFall2 = false;
		}
		
		if(velY <= -(fJumpSpeed*0.3) && !liquidMovement && !outOfLiquid)
		{
			velY = max(velY*2,-fJumpSpeed*0.9);
		}
		
		bufferJump = max(bufferJump-1,0);
	}
	else
	{
		bufferJump = bufferJumpMax;
		if(spiderBall || state == State.Spark || state == State.BallSpark)
		{
			bufferJump = 0;
		}
	}
	if(grounded)
	{
		bunnyJump = bunnyJumpMax;
	}
	else if(bunnyJump > 0)
	{
		bunnyJump--;
	}
	
	if(bombJump <= 0)
	{
		if(!cJump && !rJump)
		{
			jumpStop = true;
		}
		
		if(!isJumping)
		{
			if(jumping)
			{
				if(jumpStop)
				{
					if(velY < 0)
					{
						velY -= (velY*0.9);
					}
					jumpStop = false;
				}
				jump = 0;
				jumping = false;
			}
		}
	}
	
	#endregion
	
	#region Bomb Jump Logic
	
	if(bombJumpX != 0 && (!spiderBall || spiderEdge == Edge.None) && bombJump > 0)
	{
		//bombJumpX += bombXSpeed[liquidState]*sign(bombJumpX);
		velX = bombJumpX;
		
		/*if(abs(bombJumpX) > bombXSpeedMax[liquidState])
		{
			bombJumpX = 0;
		}*/
	}
	else
	{
		bombJumpX = 0;
	}
	if(bombJump > 0)
	{
		if(spiderBall)
		{
			if(liquidState == 0)
			{
				var jumpX = lengthdir_x(bombJumpSpeed[0],spiderJumpDir) + spiderJump_SpeedAddX,
					jumpY = lengthdir_y(bombJumpSpeed[0],spiderJumpDir) + spiderJump_SpeedAddY;
				if(jumpX != 0)
				{
					velX = jumpX;
				}
				if(jumpY != 0)
				{
					velY = jumpY;
				}
			}
			else
			{
				var jumpX = lengthdir_x(bombJumpSpeed[liquidState],spiderJumpDir) + spiderJump_SpeedAddX,
					jumpY = lengthdir_y(bombJumpSpeed[liquidState],spiderJumpDir) + spiderJump_SpeedAddY;
				velX += jumpX;
				velY += jumpY;
				bombJump = 0;
				
			}
			spiderEdge = Edge.None;
		}
		else
		{
			if(liquidState == 0)
			{
				velY = -bombJumpSpeed[0];
			}
			else
			{
				velY -= bombJumpSpeed[liquidState];
				bombJump = 0;
			}
		}
		gunReady = true;
		jumping = false;
		
		bombJump--;
	}
	
	#endregion
	
	// Gravity
	var fallspd = fallSpeedMax;
	
	fGrav = grav[liquidState];
	if(jump <= 0 && !grounded && (state != State.Grip || (startClimb && climbIndex > 7)) && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Hurt && state != State.Dodge && state != State.CrystalFlash)
	{
		velY += min(fGrav,max(fallspd-velY,0));
	}
	
	if(state != State.Morph || !misc[Misc.Spring])
	{
		rMorphJump = false;
	}
	else if(!cJump)
	{
		rMorphJump = true;
	}
#endregion

#region Spider Ball Movement
	if(spiderBall)
	{
		if(spiderEdge != Edge.None &&
		!entity_place_collide(2,0) && !entity_place_collide(-2,0) && !entity_place_collide(0,2) && !entity_place_collide(0,-2) &&
		!entity_place_collide(2,2) && !entity_place_collide(-2,2) && !entity_place_collide(2,-2) && !entity_place_collide(-2,-2))
		{
			spiderEdge = Edge.None;
		}
		
		if(state == State.BallSpark)// && shineRestart)
		{
			spiderEdge = Edge.None;
		}
		
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = 0;
			
			var dcheck = 2,
				ucheck = -2,
				rcheck = 2,
				lcheck = -2;
			if(velX != 0)
			{
				rcheck = 0;
				lcheck = 0;
			}
			if(velY != 0)
			{
				ucheck = 0;
				dcheck = 0;
			}
			
			if(state != State.BallSpark || shineEnd > 0)// || !shineRestart)
			{
				if(entity_place_collide(0,dcheck))// && !colSpeed_Bottom)
				{
					spiderEdge = Edge.Bottom;
					spiderSpeed = velX;
					spiderMove = sign(spiderSpeed);
				}
				else if(entity_place_collide(0,ucheck))// && !colSpeed_Top)
				{
					spiderEdge = Edge.Top;
					spiderSpeed = -velX;
					spiderMove = sign(spiderSpeed);
				}
				else if(entity_place_collide(rcheck,0))// && !colSpeed_Right)
				{
					spiderEdge = Edge.Right;
					spiderSpeed = -velY;
					spiderMove = sign(spiderSpeed);
				}
				else if(entity_place_collide(lcheck,0))// && !colSpeed_Left)
				{
					spiderEdge = Edge.Left;
					spiderSpeed = velY;
					spiderMove = sign(spiderSpeed);
				}
			}
		}
		else
		{
			//shineRampFix = 4;
			canMorphBounce = false;
			
			var moveX = (cRight-cLeft),
		        moveY = (cDown-cUp);
			if(moveX == 0 && moveY == 0)
		    {
		        spiderMove = 0;
		    }
		    if(spiderMove == 0)
		    {
		        //if(spiderEdge == Edge.Bottom)
				if(entity_place_collide(0,1) && moveX != 0)
		        {
		            spiderMove = moveX;
		        }
		        //if(spiderEdge == Edge.Top)
				if(entity_place_collide(0,-1) && moveX != 0)
		        {
		            spiderMove = -moveX;
		        }
		        //if(spiderEdge == Edge.Left)
				if(entity_place_collide(-1,0) && moveY != 0)
		        {
		            spiderMove = moveY;
		        }
		        //if(spiderEdge == Edge.Right)
				if(entity_place_collide(1,0) && moveY != 0)
		        {
		            spiderMove = -moveY;
		        }
		    }
			
			var fMaxSpeed2 = fMaxSpeed;
			if(speedBoost)
			{
				fMaxSpeed2 = maxSpeed[2,liquidState];
			}
			if(spiderMove > 0)
			{
				if(spiderSpeed < fMaxSpeed2)
				{
					if(spiderSpeed < 0)
					{
						spiderSpeed += fFrict;
					}
					spiderSpeed = min(spiderSpeed+fMoveSpeed,fMaxSpeed2);
				}
			}
			else if(spiderMove < 0)
			{
				if(spiderSpeed > -fMaxSpeed2)
				{
					if(spiderSpeed > 0)
					{
						spiderSpeed -= fFrict;
					}
					spiderSpeed = max(spiderSpeed-fMoveSpeed,-fMaxSpeed2);
				}
			}
			else
			{
				if(spiderSpeed > 0)
				{
					spiderSpeed = max(spiderSpeed-fFrict,0);
				}
				else
				{
					spiderSpeed = min(spiderSpeed+fFrict,0);
				}
			}
			
			if(abs(spiderSpeed) > maxSpeed2)
			{
				if(sign(spiderSpeed) == 1)
				{
					spiderSpeed = min(spiderSpeed - fFrict, maxSpeed2);
				}
				if(sign(spiderSpeed) == -1)
				{
					spiderSpeed = max(spiderSpeed + fFrict, -maxSpeed2);
				}
			}
			
			var sAngle = 0;
			var bottom_rot = 0,
				left_rot = 270,
				top_rot = 180,
				right_rot = 90;
			switch(spiderEdge)
			{
				case Edge.Bottom:
				{
					velX = spiderSpeed;
					velY = 1;
					
					spiderJump_SpeedAddX = velX;
					spiderJump_SpeedAddY = 0;
					sAngle = bottom_rot;
					break;
				}
				case Edge.Left:
				{
					velX = -1;
					velY = spiderSpeed;
					
					spiderJump_SpeedAddX = 0;
					spiderJump_SpeedAddY = velY;
					sAngle = left_rot;
					break;
				}
				case Edge.Top:
				{
					velX = -spiderSpeed;
					velY = -1;
					
					spiderJump_SpeedAddX = velX;
					spiderJump_SpeedAddY = 0;
					sAngle = top_rot;
					break;
				}
				case Edge.Right:
				{
					velX = 1;
					velY = -spiderSpeed;
					
					spiderJump_SpeedAddX = 0;
					spiderJump_SpeedAddY = velY;
					sAngle = right_rot;
					break;
				}
			}
			
			var sAngle2 = 0;
			var slope = GetEdgeSlope(colEdge);
			if(instance_exists(slope))
			{
				if(Crawler_SlopeCheck(slope))
				{
					sAngle2 = angle_difference(GetSlopeAngle(slope),sAngle);
				}
			}
			
			spiderJumpDir = sAngle + sAngle2 + 90;
			
			if(shineEnd > 0)
			{
				velX = 0;
				velY = 0;
				spiderSpeed = 0;
			}
		}
	}
	else
	{
		spiderJumpDir = 90;
		spiderJump_SpeedAddX = 0;
		spiderJump_SpeedAddY = 0;
	}
#endregion

	isChargeSomersaulting = (statCharge >= maxCharge && (state == State.Somersault || state == State.Dodge));
	isSpeedBoosting = (speedBoost || state == State.Spark || state == State.BallSpark);
	isScrewAttacking = (misc[Misc.ScrewAttack] && !liquidMovement && state == State.Somersault && stateFrame == State.Somersault);
	
	if(debug)
	{
		// -- debug: noclip --
		if(keyboard_check(vk_numpad6) || keyboard_check(vk_numpad4))
		{
			position.X += (keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4)) * 3;
			velX = 0;
			x = scr_round(position.X);
		}
		if(keyboard_check(vk_numpad5) || keyboard_check(vk_numpad8))
		{
			position.Y += (keyboard_check(vk_numpad5) - keyboard_check(vk_numpad8)) * 3;
			velY = -fGrav;
			y = scr_round(position.Y);
		}
	}

#region Collision
	
	colEdge = Edge.Bottom;
	if(spiderBall)
	{
		colEdge = spiderEdge;
	}
	
	if(state != State.Elevator && state != State.Recharge)// && state != State.CrystalFlash)
	{
		if(dir != 0 && state != State.CrystalFlash)
		{
			fVelX = velX;// + carryVelX;
	
			if(!SpiderActive())
			{
				if(armPumping && prAngle && fVelX != 0 && move == dir && grounded && state == State.Stand)
				{
					fVelX += move;
				}
				if(globalSpeedMod > 0 && fVelX != 0 && move == dir)
				{
					fVelX += globalSpeedMod*move;
				}
			}
	
			if(state == State.Grapple)
			{
				fVelX += grappleVelX;
			}
	
			if(state == State.Hurt)
			{
				fVelX = hurtSpeedX;
			}
			
			DestroyBlock(x+fVelX,y);
		}
		else
		{
			fVelX = 0;
		}
		
		if(state != State.Grip)
		{
			fVelY = velY;// + carryVelY;
	
			if(state == State.Grapple)
			{
				fVelY += grappleVelY;
			}
	
			if(state == State.Hurt)
			{
				fVelY = hurtSpeedY;
			}
			
			DestroyBlock(x,y+fVelY);
		}
		else
		{
			fVelY = 0;
		}
	}
	else
	{
		fVelX = 0;
		fVelY = 0;
	}
	
	speedKill = false;
	
	fVelX += shiftX;
	fVelY += shiftY;
	
	//var vstepx = (bbox_right-bbox_left)/2 - 1,
	//	vstepy = (bbox_bottom-bbox_top)/2 - 1;
	var vstepx = 1,
		vstepy = 1;
	if(spiderBall)
	{
		//vstepx = 3;
		//vstepy = 3;
		Collision_Crawler(fVelX,fVelY,vstepx,vstepy,true);
	}
	else
	{
		Collision_Normal(fVelX,fVelY,vstepx,vstepy,true);
	}
	
	shiftX = 0;
	shiftY = 0;
	
	if(!grounded && velY == 0 && PlayerGrounded())
	{
		grounded = true;
	}
	if(!onPlatform && velY == 0 && PlayerOnPlatform())
	{
		onPlatform = true;
	}
	
	var downSlope = GetEdgeSlope(Edge.Bottom);
	var downSlopeFlag = (place_meeting(x,y+2,downSlope) && downSlope.image_yscale > 1 && 
						((downSlope.image_xscale > 0 && bbox_left > downSlope.bbox_left) || (downSlope.image_xscale < 0 && bbox_right < downSlope.bbox_right)));
	var downNum = instance_place_list(x,y+2,all,blockList,true);
	for(var i = 0; i < downNum; i++)
	{
		if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,solids,asset_object) && !asset_has_any_tag(blockList[| i].object_index,"ISlope",asset_object))
		{
			downSlopeFlag = false;
			break;
		}
	}
	ds_list_clear(blockList);
	if((!PlayerGrounded() || (downSlopeFlag && !speedBoost)) && !PlayerOnPlatform())
	{
		grounded = false;
	}
	
	if(speedKill)
	{
		speedKillCounter = min(speedKillCounter+1,speedKillMax);
	}
	else
	{
		speedKillCounter = 0;
	}
	
	if(spiderBall)
	{
		if(jump > 0)
		{
			colEdge = Edge.None;
		}
		spiderEdge = colEdge;
		if(spiderEdge != Edge.None)
		{
			grounded = true;
		}
	}
	
	if(state != State.Elevator)
	{
		position.X = clamp(position.X,0,room_width);
		position.Y = clamp(position.Y,0,room_height);
	}
	
	if((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineEnd <= 0 && 
	(x <= 0 || x >= room_width || y <= 0 || y >= room_height))
	{
		if((x <= 0 || x >= room_width) && boots[Boots.ChainSpark])
		{
			shineRestart = true;
			audio_play_sound(snd_ShineSpark_Charge,0,false);
		}
		else if(shineEnd <= 0)
		{
			audio_play_sound(snd_Hurt,0,false);
		}
		shineEnd = shineEndMax;
	}
	
	if(y+fVelY < 0)
	{
		fVelY = 0;
		velY = 0;
		jump = 0;
	}
	
	var colL = lhc_collision_line(bbox_left+1,bbox_top,bbox_left+1,bbox_bottom,"IMovingSolid",true,true),
		colR = lhc_collision_line(bbox_right-1,bbox_top,bbox_right-1,bbox_bottom,"IMovingSolid",true,true),
		colT = lhc_collision_line(bbox_left,bbox_top+1,bbox_right,bbox_top+1,"IMovingSolid",true,true),
		colB = lhc_collision_line(bbox_left,bbox_bottom-1,bbox_right,bbox_bottom-1,"IMovingSolid",true,true);
	if (lhc_place_meeting(x,y,"IMovingSolid") && (state != State.Grip || !startClimb) && colL+colR+colT+colB >= 4)
	{
		passthru = min(passthru+1,passthruMax);
	}
	else
	{
		passthru = 0;
	}
	passthroughMovingSolids = (passthru >= passthruMax);
	if(passthroughMovingSolids)
	{
		array_resize(solids,1);
		solids[0] = "ISolid";
	}
	else
	{
		solids[0] = "ISolid";
		solids[1] = "IMovingSolid";
	}
	
#endregion
	
	move2 = cRight - cLeft;

#region Grip Collision

	if(misc[Misc.PowerGrip] && (state == State.Jump || state == State.Somersault) && morphFrame <= 0 && !grounded && abs(dirFrame) >= 4 && fVelY >= 0)
	{
		if(!entity_place_collide(0,-4) && ((state == State.Jump && !entity_place_collide(0,3)) || (state == State.Somersault && !entity_place_collide(0,11))))
		{
			var num = instance_place_list(x+move2,y,all,blockList,true);
				num += instance_position_list(x+6*move2,y-17,all,blockList,true);
			for(var i = 0; i < num; i++)
			{
				if (instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,solids,asset_object) && 
					(!asset_has_any_tag(blockList[| i].object_index,"ISlope",asset_object) || sign(blockList[| i].image_xscale) == dir))
				{
					var block = blockList[| i];
					var canGrip = true;
					if (block.object_index == obj_Tile || object_is_ancestor(block.object_index,obj_Tile) ||
						block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
					{
						canGrip = block.canGrip;
					}
					var slope = instance_position(x+8*move2,block.bbox_top-2,all)
					if(instance_exists(slope) && asset_has_any_tag(slope.object_index,solids,asset_object) && asset_has_any_tag(slope.object_index,"ISlope",asset_object) && slope.image_yscale > 1)
					{
						canGrip = false;
					}
					if(canGrip && lhc_position_meeting(x+6*move2,y-17,solids) && !lhc_collision_line(x+6*move2,y-22,x+6*move2,y-26,solids,true,true) && lhc_place_meeting(x+move2,y,solids) && dir == move2)
					{
						audio_play_sound(snd_Grip,0,false);
						jump = 0;
						fVelY = 0;
						velY = 0;
						dir = move2;
				
						ChangeState(State.Grip,State.Grip,mask_Jump,false);
						
						position.Y = scr_ceil(position.Y);
						for(var j = 10; j > 0; j--)
						{
							if(lhc_position_meeting(x+6*move2,position.Y-18,solids))
							{
								position.Y -= 1;
							}
						}
						y = scr_round(position.Y);
				
						instance_destroy(grapple);
						
						ds_list_clear(blockList);
						break;
					}
				}
			}
			ds_list_clear(blockList);
		}
	}
#endregion

#region Quick Climb
	if(global.quickClimb && state != State.Grip && state != State.Morph && morphFrame <= 0 && grounded && abs(dirFrame) >= 4 && entity_place_collide(move2,0) && !entity_place_collide(0,0))
	{
		var qcHeight = 0;
		var bbottom = scr_round(bbox_bottom);
		var heightMax = 47;//50;
		if(state == State.Crouch)
		{
			heightMax = 34;
		}
		if(state == State.Stand || (state == State.Crouch && crouchFrame <= 0))
		{
			// using a for loop to cut down on duplicate code like this is probably pretty stupid.
			// then again, 'if it looks stupid, but works, it isn't stupid.'
			for(var i = 0; i < 2; i++)
			{
				if(i == 0 && lhc_collision_rectangle(x,bbottom-8,x+6*dir,bbottom-5,solids,true,true))
				{
					while(qcHeight > -heightMax && lhc_collision_line(x,bbottom+qcHeight,x+6*dir,bbottom+qcHeight,solids,true,true))
					{
						qcHeight--;
					}
					qcHeight += 1;
				}
				else if(i == 1)
				{
					qcHeight = -heightMax;
					while(qcHeight < -5 && !lhc_collision_line(x,bbottom+qcHeight,x+6*dir,bbottom+qcHeight,solids,true,true))
					{
						qcHeight++;
					}
				}
				
				quickClimbTarget = 0;
				if(qcHeight <= -7)
				{
					var yHeight = bbottom+qcHeight;
			
					var slopeOffset = 0;
					while(slopeOffset > -16 && collision_rectangle(x+6*dir,yHeight+slopeOffset-8,x+16*dir,yHeight+slopeOffset,obj_Slope,true,true))
					{
						var slopeCol = collision_rectangle(x+6*dir,yHeight+slopeOffset-8,x+16*dir,yHeight+slopeOffset,obj_Slope,true,true);
						if(slopeCol != noone && slopeCol.image_yscale > 0 && slopeCol.image_yscale <= 1 && sign(slopeCol.image_xscale) == -dir)
						{
							slopeOffset -= 1;
						}
						else
						{
							break;
						}
					}
			
					yHeight += slopeOffset;
			
					if(!lhc_collision_rectangle(x+6*dir,yHeight-15,x+16*dir,yHeight-2,solids,true,true))
					{
						if(!lhc_collision_rectangle(x+6*dir,yHeight-31,x+16*dir,yHeight-2,solids,true,true))
						{
							quickClimbTarget = 2;
						}
						else if(misc[Misc.Morph])
						{
							quickClimbTarget = 1;
						}
					}
				}
				if(quickClimbTarget > 0)
				{
					break;
				}
			}
		}
			
		if(qcHeight <= -7 && quickClimbTarget > 0 && move2 == dir && cJump && rJump)
		{
			jump = 0;
			fVelY = 0;
			velY = 0;
			
			stateFrame = State.Grip;
			mask_index = mask_Crouch;
			
			audio_play_sound(snd_Climb,0,false);
			gripGunReady = false;
			gripGunCounter = 0;
			startClimb = true;
			
			var _h = 0;
			if(state == State.Stand)
			{
				_h = -11;
			}
			for(var i = 8; i > 0; i--)
			{
				_h -= climbY[i];
				if(_h <= qcHeight)
				{
					climbIndex = i+1;
					break;
				}
			}
			position.Y -= (abs(qcHeight) - abs(_h));
			y = scr_round(position.Y);
			
			climbTarget = quickClimbTarget;
			
			state = State.Grip;
			climbFrame = climbSequence[climbIndex];
			dir = move2;
			
			instance_destroy(grapple);
		}
	}
	else
	{
		quickClimbTarget = 0;
	}
#endregion

#region Stand, Walk, Run, Dash, Brake
	if(state == State.Stand)
	{
		stateFrame = State.Stand;
		mask_index = mask_Stand;
		
		if(crouchFrame >= 5)
		{
			var velMove = (velX != 0 && sign(velX) == dir) || (prevVelX != 0 && sign(prevVelX) == dir),// && (!lhc_place_collide(sign(velX),0) || !lhc_place_collide(sign(velX),-3))),
				moveMove = (move != 0 && (move == dir || walkState));// && (!lhc_place_collide(move,0) || !lhc_place_collide(move,-3)));
			if(brake)
			{
				stateFrame = State.Brake;
			}
			else if((velMove || moveMove) && landFrame <= 0 && !xRayActive)
			{
				//if(walkState || (cAimLock && sign(velX) != dir && sign(velX) != 0))
				if((walkState && sign(velX) != dir))// || (sign(velX) != dir && move2 != dir))
				{
					stateFrame = State.Walk;
				}
				else
				{
					stateFrame = State.Run;
				}
			}
		}
		
		var canCrouch = true;
		if(instance_exists(obj_Elevator))
		{
			var ele = instance_position(x,bbox_bottom+1,obj_Elevator);
			if(instance_exists(ele))
			{
				if(ele.dir == 1)
				{
					canCrouch = false;
				}
				if(ele.activeDir == 0 && ele.dir != 0 && (cDown-cUp) == ele.dir && (gbaAimPreAngle == gbaAimAngle || global.aimStyle != 1) && move2 == 0 && velX == 0 && dir != 0 && grounded && !xRayActive)
				{
					ele.activeDir = (cDown-cUp);
					state = State.Elevator;
					dir = 0;
					aimAngle = 0;
				}
			}
		}
		if(canCrouch && move2 == 0 && cDown && (gbaAimPreAngle == gbaAimAngle || global.aimStyle != 1) && dir != 0 && grounded && !xRayActive)
		{
			crouchFrame = 5;
			ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
		}
		if(!grounded && dir != 0)
		{
			ChangeState(State.Jump,State.Jump,mask_Jump,ledgeFall);
		}
		
		isPushing = false;
		pushBlock = instance_place(x+3*move2,y,obj_PushBlock);
		if(move2 == dir && grounded && !xRayActive && !place_meeting(x-move2,y+2,pushBlock))
		{
		    isPushing = (instance_exists(pushBlock) && pushBlock.grounded);
		}
		
		if(instance_exists(pushBlock) && isPushing)
		{
			stateFrame = State.Push;
			
			var vX = 1;
            if(liquidMovement)
            {
                vX *= 0.75;
            }
            else if(pushBlock.liquid)
            {
                vX *= 0.9;
            }
            
			var animRate = 0.275 / (1+liquidMovement);
			if(cDash || global.autoDash)
			{
				animRate = 0.375 / (1+liquidMovement);
			}
            velX = pushMove[pushFrameSequence[scr_floor(frame[Frame.Push])]]*animRate * vX * move2;
            pushBlock.velX = velX;
			pushBlock.pushState = PushState.Push;
		}
		else if(frame[Frame.Push] > 0)
		{
			stateFrame = State.Push;
		}
		
		if (instance_exists(grapple) && grapple.grappleState == GrappleState.PushBlock && 
			instance_exists(grapple.grapBlock) && (grapple.grapBlock.object_index == obj_PushBlock || object_is_ancestor(grapple.grapBlock.object_index,obj_PushBlock)) &&
			!place_meeting(x,y+2,grapple.grapBlock) && aimAngle < 2)
		{
			var grapPushBlock = grapple.grapBlock;
			if(point_distance(x, y, grapple.x, grapple.y) > grappleDist && move2 == -dir)
			{
				grapPushBlock.velX = velX;
				grapPushBlock.pushState = PushState.Grapple;
			}
		}
	}
	else
	{
		brake = false;
		brakeFrame = 0;
		
		isPushing = false;
		pushBlock = noone;
	}
#endregion
#region Elevator
	if(state == State.Elevator)
	{
		dir = 0;
		stateFrame = State.Stand;
		mask_index = mask_Stand;
		velX = 0;
		velY = 0;
		aimAngle = 0;
		
		var flag = true;
		if(instance_exists(obj_Elevator) && obj_Elevator.activeDir != 0)
		{
			flag = false;
		}
		if(instance_exists(obj_SaveStation) && obj_SaveStation.saving > 0)
		{
			flag = false;
		}
		if(instance_exists(obj_Item_SuitPickupAnim))
		{
			flag = false;
		}
		
		if(flag)
		{
			state = State.Stand;
		}
	}
#endregion
#region Recharge
	if(state == State.Recharge)
	{
		stateFrame = State.Stand;
		mask_index = mask_Stand;
		velX = 0;
		velY = 0;
		aimAngle = 0;
		
		var flag = true;
		if(instance_exists(obj_EnergyStation) && obj_EnergyStation.activeDir != 0)
		{
			flag = false;
		}
		if(instance_exists(obj_MissileStation) && obj_MissileStation.activeDir != 0)
		{
			flag = false;
		}
		
		if(flag)
		{
			state = State.Stand;
		}
	}
#endregion
#region Crouch
	if(state == State.Crouch)
	{
		stateFrame = State.Crouch;
		mask_index = mask_Crouch;
		landFrame = 0;
		if(uncrouch < 7)
		{
			speedCounter = 0;
		}
		if(move2 != 0 && !entity_place_collide(0,-11))
		{
			uncrouch += 1;
		}
		else
		{
			uncrouch = 0;
		}
		if(((cUp && rUp && (gbaAimPreAngle == gbaAimAngle || global.aimStyle != 1)) || uncrouch >= 7) && !entity_place_collide(0,-11) && crouchFrame <= 0 && !xRayActive)
		{
			aimUpDelay = 10;
			ChangeState(State.Stand,State.Stand,mask_Stand,true);
		}
		if(crouchFrame <= 0 && cDown && (gbaAimAngle == gbaAimPreAngle || global.aimStyle != 1) && (rDown || entity_place_collide(0,-11)) && move2 == 0 && misc[Misc.Morph] && !xRayActive && stateFrame != State.Morph && morphFrame <= 0)
		{
			audio_play_sound(snd_Morph,0,false);
			ChangeState(State.Morph,State.Morph,mask_Morph,true);
			morphFrame = 8;
		}
		else if(!grounded && (!entity_place_collide(0,-8) || (!entity_place_collide(0,8) && (!onPlatform || !lhc_place_meeting(x,y+8,"IPlatform")))))
		{
			ChangeState(State.Jump,State.Jump,mask_Jump,false);
		}
	}
	else
	{
		uncrouch = 0;
	}
#endregion
#region Morph Ball
	if(state == State.Morph)
	{
		stateFrame = State.Morph;
		mask_index = mask_Morph;
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
		landFrame = 0;
		if(grounded)
		{
			if(mockBall)
			{
				if(move2 == 0 || move2 != sign(velX) || liquidMovement)
				{
					mockBall = false;
				}
			}
		}
		else
		{
			mockBall = false;
		}
		if(grounded && notGrounded)
		{
			if(morphFrame <= 0 && shineRampFix <= 0)
			{
				if(!spiderBall)
				{
					audio_stop_sound(snd_Land);
					audio_play_sound(snd_Land,0,false);
					
					if((speedKeep == 0 || (speedKeep == 2 && liquidMovement)) && canMorphBounce)
					{
						velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
						speedCounter = 0;
					}
				}
			}
			else
			{
				if(abs(velX) > maxSpeed[5,liquidState])
				{
					mockBall = true;
				}
			}
		}
		
		if(((cUp && rUp) || (cJump && rJump && (!misc[Misc.Spring] || morphSpinJump)) || (cMorph && rMorph)) && !unmorphing && morphFrame <= 0 && !spiderBall)
		{
			if(!entity_place_collide(0,-17))
			{
				audio_play_sound(snd_Morph,0,false);
				unmorphing = true;
				morphFrame = 8;
				aimUpDelay = 10;
			}
			else
			{
				morphPal = 0.75;
				if(!audio_is_playing(snd_MorphLocked))
				{
					audio_play_sound(snd_MorphLocked,0,false);
				}
			}
		}
		if(unmorphing)
		{
			mask_index = mask_Crouch;
			aimUpDelay = 10;
			if(morphFrame <= 0)
			{
				if(morphSpinJump)
				{
					ChangeState(State.Somersault,State.Somersault,mask_Crouch,false);
					frame[Frame.Somersault] = 2;
					morphSpinJump = false;
				}
				else
				{
					ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
					crouchFrame = 0;
					if(velX != 0)
					{
						uncrouch = 7;
						if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
						{
							velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
							speedCounter = 0;
						}
					}
				}
			}
		}
		else
		{
			morphSpinJump = false;
		}
		
		var ammo = missileStat+superMissileStat+powerBombStat;
		if((!entity_place_collide(0,-11) || crystalClip) && energy < lowEnergyThresh && ammo > 0 && cFlashStartCounter > 0 && cShoot && cDown)// && (cAngleUp || (cAngleDown && global.aimStyle == 0)))
		{
			cFlashStartCounter++;
			
			if(cFlashStartCounter > 70+60)
			{
				ChangeState(State.CrystalFlash,State.CrystalFlash,mask_Crouch,true);
			}
		}
		else
		{
			cFlashStartCounter = 0;
		}
	}
	else
	{
		ballBounce = 0;
		unmorphing = false;
		mockBall = false;
		cFlashStartCounter = 0;
	}
	
	if((state == State.Morph || state == State.BallSpark) && misc[Misc.Spider] && !unmorphing)// && bombJump <= 0)
	{
		if(global.spiderBallStyle == 0)
		{
			if(prAngle)
			{
				SpiderEnable(!spiderBall);
			}
		}
		if(global.spiderBallStyle == 1)
		{
			SpiderEnable(cAngleUp || cAngleDown);
		}
		if(global.spiderBallStyle == 2)
		{
			if(cDown && rDown && morphFrame <= 0)
			{
				SpiderEnable(true);
			}
			if(cJump && rJump)
			{
				SpiderEnable(false);
			}
		}

		if(!spiderBall)
		{
			spiderEdge = Edge.None;
			spiderMove = 0;
			spiderSpeed = 0;
			audio_stop_sound(snd_SpiderLoop);
		}
		else if(state == State.Morph)
		{
			if(spiderEdge != Edge.None && prevSpiderEdge == Edge.None && grounded && notGrounded)
			{
				if(morphFrame <= 0 && shineRampFix <= 0)
				{
					audio_play_sound(snd_SpiderStick,0,false);
					
					audio_stop_sound(snd_SpiderLand);
					audio_play_sound(snd_SpiderLand,0,false);
					
					if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
					{
						spiderSpeed = min(abs(spiderSpeed),maxSpeed[0,liquidState])*sign(spiderSpeed);
						speedCounter = 0;
					}
					jump = 0;
				}
				else
				{
					if(abs(spiderSpeed) > maxSpeed[5,liquidState])
					{
						mockBall = true;
					}
				}
			}
		}
	}
	else
	{
		SpiderEnable(false);
		spiderEdge = Edge.None;
		spiderMove = 0;
		spiderSpeed = 0;
		audio_stop_sound(snd_SpiderLoop);
	}
#endregion
#region Jump
	if(state == State.Jump)
	{
		if(dBoostFrame <= 0 || dBoostFrame >= 19)
		{
			stateFrame = State.Jump;
		}
		
		//mask_index = mask_Jump;
		if(aimAngle == -2 || aimFrame <= -3)
		{
			mask_index = mask_Crouch;
		}
		else
		{
			ChangeState(State.Jump,State.Jump,mask_Jump,false);
		}
		
		canWallJump = false;
		if ((entity_place_collide(-8*move2,0) && entity_place_collide(-8*move2,8)) || 
			(lhc_place_meeting(x-8*move2,y,"IPlatform") && lhc_place_meeting(x-8*move2,y+8,"IPlatform")))
		{
			if(!lhc_collision_line(x-4*move2,y+9,x-4*move2,y+25,solids,true,true) && wallJumpDelay <= 0 && move2 != 0 && wjFrame <= 0)
			{
				canWallJump = true;
			}
		}
		wallJumpDelay = max(wallJumpDelay - 1, 0);
		if(grounded)
		{
			if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
			{
				//velX = min(abs(velX)*0.1,maxSpeed[0,liquidState])*sign(velX);
				velX = min(abs(velX) * (power(abs(velX),0.1) - 1),maxSpeed[0,liquidState])*sign(velX);
				speedCounter = 0;
			}
			audio_play_sound(snd_Land,0,false);
			if(mask_index == mask_Crouch)
			{
				if(entity_place_collide(0,-11))
				{
					ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
					crouchFrame = 0;
				}
				else
				{
					ChangeState(State.Stand,State.Stand,mask_Stand,true);
					landFrame = 7;
					smallLand = false;
				}
			}
			else
			{
				if(entity_place_collide(0,-3) && !entity_place_collide(0,0))
				{
					crouchFrame = 5;
					ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
				}
				else
				{
					if(smallLand)
					{
						landFrame = 6;
					}
					else
					{
						landFrame = 9;
					}
					ChangeState(State.Stand,State.Stand,mask_Stand,true);
				}
			}
		}
		else
		{
			landFrame = 0;
			smallLand = (velY <= 3);
		}
	}
#endregion
#region Somersault
	if(state == State.Somersault)
	{
		stateFrame = State.Somersault;
		mask_index = mask_Crouch;
		gunReady = true;
		ledgeFall = false;
		ledgeFall2 = false;
		
		if(!liquidMovement)
		{
			if(!audio_is_playing(snd_Charge) && !audio_is_playing(snd_Charge_Loop))
			{
				if(!somerSoundPlayed)
				{
					if(boots[Boots.SpaceJump])
					{
						audio_play_sound(snd_Somersault_SJ,0,false);
					}
					else
					{
						audio_play_sound(snd_Somersault,0,false);
					}
					somerSoundPlayed = true;
				}
				else if(!audio_is_playing(snd_Somersault) && !audio_is_playing(snd_Somersault_SJ) && !audio_is_playing(snd_Somersault_Loop))
				{
					audio_play_sound(snd_Somersault_Loop,0,true);
				}
			}
			else
			{
				audio_stop_sound(snd_Somersault);
				audio_stop_sound(snd_Somersault_SJ);
				audio_stop_sound(snd_Somersault_Loop);
				somerSoundPlayed = false;
			}
			if(misc[Misc.ScrewAttack])
			{
				if(!screwSoundPlayed)
				{
					audio_play_sound(snd_ScrewAttack,0,false);
					screwSoundPlayed = true;
				}
				else if(!audio_is_playing(snd_ScrewAttack) && !audio_is_playing(snd_ScrewAttack_Loop))
				{
					audio_play_sound(snd_ScrewAttack_Loop,0,true);
				}
			}
			if(oldDir != dir && boots[Boots.SpaceJump] && !misc[Misc.ScrewAttack] && wjAnimDelay <= 0)
			{
				audio_stop_sound(snd_Somersault);
				audio_stop_sound(snd_Somersault_SJ);
				audio_stop_sound(snd_Somersault_Loop);
				somerSoundPlayed = false;
			}
		}
		else
		{
			if(audio_is_playing(snd_Somersault_Loop) && somerSoundPlayed)
			{
				audio_stop_sound(snd_Somersault_Loop);
			}
			audio_stop_sound(snd_Somersault);
			audio_stop_sound(snd_Somersault_SJ);
			somerSoundPlayed = false;
			
			if(!audio_is_playing(snd_Charge) && !audio_is_playing(snd_Charge_Loop))
			{
				somerUWSndCounter--;
				if(somerUWSndCounter < 0)
				{
					audio_play_sound(snd_Somersault_Loop,0,false);
					somerUWSndCounter = 33;
				}
			}
		}
		
		canWallJump = false;
		if ((entity_place_collide(-8*move2,0) && entity_place_collide(-8*move2,8)) || 
			(lhc_place_meeting(x-8*move2,y,"IPlatform") && lhc_place_meeting(x-8*move2,y+8,"IPlatform")))
		{
			if(!lhc_collision_line(x-4*move2,y+9,x-4*move2,y+25,solids,true,true) && wallJumpDelay <= 0 && move2 != 0 && wjFrame <= 0)
			{
				canWallJump = true;
			}
		}
		
		wallJumpDelay = max(wallJumpDelay - 1, 0);
		/*if(velX < maxSpeed[3,liquidState] && velX > 0 && dir == 1)
		{
			velX = maxSpeed[3,liquidState];
		}
		else if(velX > -maxSpeed[3,liquidState] && velX < 0 && dir == -1)
		{
			velX = -maxSpeed[3,liquidState];
		}*/
		
		if(grounded)
		{
			if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
			{
				//velX = min(abs(velX)*0.1,maxSpeed[0,liquidState])*sign(velX);
				velX = min(abs(velX) * (power(abs(velX),0.1) - 1),maxSpeed[0,liquidState])*sign(velX);
				speedCounter = 0;
			}
			audio_play_sound(snd_Land,0,false);
			if(entity_place_collide(0,-11))
			{
				ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
				crouchFrame = 0;
			}
			else
			{
				ChangeState(State.Stand,State.Stand,mask_Stand,true);
				landFrame = 7;
				smallLand = false;
			}
		}
		else
		{
			landFrame = 0;
			var unchargeable = ((itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3)) || xRayActive || hyperBeam);
			if(prAngle || (cUp && rUp) || (cDown && rDown) || (cShoot && rShoot) || (!cShoot && !rShoot && !unchargeable))
			{
				if(entity_place_collide(0,-8))
				{
					ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
					crouchFrame = 0;
				}
				else
				{
					ChangeState(State.Jump,State.Jump,mask_Jump,false);
				}
			}
		}
	}
	else
	{
		if(state != State.Jump && state != State.Grip)
		{
			canWallJump = false;
		}
		//if(state != State.Dodge)
		//{
			audio_stop_sound(snd_Somersault_Loop);
		//}
		audio_stop_sound(snd_Somersault);
		audio_stop_sound(snd_Somersault_SJ);
		somerSoundPlayed = false;
		somerUWSndCounter = 16;
	}
	
	if(state != State.Somersault && state != State.Jump)
	{
		wallJumpDelay = 6;
	}
#endregion
#region Power Grip
	if(state == State.Grip)
	{
		gunReady = false;
		ledgeFall = false;
		ledgeFall2 = false;
		//canWallJump = (move2 != 0 && move2 != dir);
		canWallJump = ((gripGunReady && move2 != dir && !cDown) || (move2 != 0 && move2 != dir));
		velX = 0;
		velY = 0;
		
		if(startClimb)
		{
			if(climbIndex > 0)
			{
				var cX = climbX[climbIndex] / (1+liquidMovement) * dir,
					cY = climbY[climbIndex] / (1+liquidMovement);
				//y -= cY;
				//x += cX;
				position.X += cX;
				position.Y -= cY;
				
				if(climbIndex >= 8 && move == dir)
				{
					velX += max((1+(stateFrame == State.Morph)) / (1+liquidMovement) - abs(cX),0)*move;
				}
				
				var cynum = 2,
					cyframe = 8;
				if(stateFrame == State.Morph)
				{
					cynum = 4+abs(velX)+abs(cX);
					cyframe = 6;
				}
				for(var i = cynum; i > 0; i--)
				{
					if(climbIndex > cyframe && entity_place_collide(0,0) && !entity_position_collide(5*dir,bbox_top-scr_round(position.Y)-1))
					{
						position.Y -= 1;
					}
				}
				
				for(var i = 8; i > 0; i--)
				{
					if(climbIndex > 8 && !entity_place_collide(0,1))
					{
						position.Y += 1;
					}
				}
				
				x = scr_round(position.X);
				y = scr_round(position.Y);
				
				if(stateFrame != State.Morph)
				{
					stateFrame = State.Grip;
					mask_index = mask_Crouch;
					if(climbIndex >= 3 && climbTarget == 1)
					{
						mask_index = mask_Morph;
						morphFrame = 8;
						if(stateFrame != State.Morph)
						{
							audio_play_sound(snd_Morph,0,false);
						}
						stateFrame = State.Morph;
					}
					else if(climbIndex > 17)
					{
						if(!entity_place_collide(0,-11))
						{
							ChangeState(State.Stand,State.Stand,mask_Stand,true);
							//landFrame = 7;
							//smallLand = false;
							crouchFrame = 2;
						}
						else
						{
							ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
							crouchFrame = 0;
						}
					}
				}
				else if(climbIndex > 9)//17)
				{
					ChangeState(State.Morph,State.Morph,mask_Morph,true);
					if(move == dir)
					{
						velX += cX;
					}
				}
			}
		}
		else
		{
			stateFrame = State.Grip;
			mask_index = mask_Jump;
			if(move2 != 0 && (!gripGunReady || gripGunCounter <= 0))
			{
				gripGunReady = (move2 != dir);
			}
			if(aimAngle != 0)
			{
				gripGunReady = true;
			}
			
			/*climbTarget = 0;
			
			var slopeOffset = 0;
			while(slopeOffset > -16 && collision_rectangle(x+6*dir,y-32+slopeOffset,x+16*dir,y-18+slopeOffset,obj_Slope,true,true))
			{
				var slopeCol = collision_rectangle(x+6*dir,y-32+slopeOffset,x+16*dir,y-18+slopeOffset,obj_Slope,true,true);
				if(slopeCol != noone && slopeCol.image_yscale > 0 && slopeCol.image_yscale <= 1 && sign(slopeCol.image_xscale) == -dir)
				{
					slopeOffset -= 1;
				}
				else
				{
					break;
				}
			}
			
			if(!lhc_collision_rectangle(x+6*dir,y-30+slopeOffset,x+16*dir,y-18+slopeOffset,solids,true,true))
			{
				if(!lhc_collision_rectangle(x+6*dir,y-46+slopeOffset,x+16*dir,y-34+slopeOffset,solids,true,true))
				{
					climbTarget = 2;
				}
				else if(misc[Misc.Morph])
				{
					climbTarget = 1;
				}
			}*/
			
			climbTarget = 0;
			var ctStart = 0;
			while(ctStart >= -16 && lhc_collision_line(x,bbox_top+ctStart,x+18*dir,bbox_top+ctStart,solids,true,true))
			{
				ctStart--;
			}
			if(ctStart >= -16)
			{
				var morphH = 12,
					crouchH = 29;
				
				var ctHeight = -(crouchH+1);
				while(ctHeight <= -morphH && lhc_collision_line(x,bbox_top+ctStart+ctHeight,x+18*dir,bbox_top+ctStart+ctHeight,solids,true,true))
				{
					ctHeight++;
				}
				if(ctHeight <= -crouchH)
				{
					climbTarget = 2;
				}
				else if(ctHeight <= -morphH && misc[Misc.Morph])
				{
					climbTarget = 1;
				}
			}
			
			if(climbTarget > 0)
			{
				if(((move2 == dir || (move2 != -dir && global.gripStyle == 2)) && cJump && rJump && !cDown) || (upClimbCounter >= 25 && cUp && !cDown && move != -dir && (global.gripStyle == 0 || global.gripStyle == 2)))
				{
					audio_play_sound(snd_Climb,0,false);
					gripGunReady = false;
					gripGunCounter = 0;
					startClimb = true;
					climbIndexCounter += 2;
				}
			}
			if(cUp && move != -dir && (global.gripStyle == 0 || global.gripStyle == 2))
			{
				upClimbCounter = min(upClimbCounter+1,25);
			}
			else
			{
				upClimbCounter = 0;
			}
			
			if(grounded)
			{
				ChangeState(State.Jump,State.Jump,mask_Jump,true);
			}
		}
		
		/*var sCol = collision_point(x+6*dir,y-18,obj_Slope,true,true),
			colFlag = instance_exists(sCol);
		if(sCol != noone && ((sCol.image_yscale > 0 && sCol.image_yscale <= 1) || sCol.image_yscale <= -0.5))
		{
			colFlag = false;
		}*/
		var colFlag = false;
		var sColNum = collision_point_list(x+6*dir,y-18,obj_Slope,true,true,blockList,true);
		for(var i = 0; i < sColNum; i++)
		{
			if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,solids,asset_object) && asset_has_any_tag(blockList[| i].object_index,"ISlope",asset_object))
			{
				colFlag = true;
				var sCol = blockList[| i];
				if((sCol.image_yscale > 0 && sCol.image_yscale <= 1) || sCol.image_yscale <= -0.5)
				{
					colFlag = false;
				}
			}
		}
		ds_list_clear(blockList);
		
		if((!entity_place_collide(2*dir,0) && !entity_place_collide(2*dir,8)) || (colFlag && !startClimb) || (cDown && cJump && rJump) || (lhc_place_meeting(x,y,"IMovingSolid") && !startClimb))
		{
			if(stateFrame == State.Morph)
			{
				state = State.Morph;
			}
			else
			{
				ChangeState(State.Jump,State.Jump,mask_Jump,true);
				if((!cJump || cDown) && gripGunReady)
				{
					dir *= -1;
					dirFrame = dir;
				}
				gunReady = false;
				ledgeFall = true;
				ledgeFall2 = true;
			}
			if(cDown && cJump && rJump)
			{
				velY += 1;
			}
		}
	}
	else
	{
		gripGunReady = false;
		gripFrame = 0;
		gripAimFrame = 0;
		gripGunCounter = 0;
		upClimbCounter = 0;
		startClimb = false;
		climbTarget = 0;
		climbIndex = 0;
		climbFrame = 0;
	}
#endregion
#region Shine Spark
	if(state == State.Spark || state == State.BallSpark)
	{
		if(state == State.BallSpark)
		{
			stateFrame = State.Morph;
			mask_index = mask_Morph;
		}
		else
		{
			stateFrame = State.Spark;
			mask_index = mask_Jump;//mask_Stand;
		}
		speedCounter = 0;
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
		shineRampFix = 4;
		shineFXCounter = min(shineFXCounter + 0.05, 1);
		
		var aUp = (cAngleUp && (global.aimStyle != 1 || gbaAimAngle == 1) && global.aimStyle != 2) && ((move2 == 0 && !cUp && !cDown) || !spiderBall),
			aDown = (cAngleDown || (cAngleUp && global.aimStyle == 1 && gbaAimAngle == -1)) && ((move2 == 0 && !cUp && !cDown) || !spiderBall);
		
		if(shineStart > 0)
		{
			if(move2 != 0 || aUp || (aDown && boots[Boots.ChainSpark]))
			{
				if(aUp || cUp)
				{
					if(move2 != 0)
					{
						shineDir = move2;
					}
					else
					{
						shineDir = dir;
					}
				}
				else if((aDown || cDown) && boots[Boots.ChainSpark])
				{
					if(move2 != 0)
					{
						shineDir = 3*move2;
					}
					else
					{
						shineDir = 3*dir;
					}
				}
				else
				{
					shineDir = 2*move2;
				}
			}
			else
			{
				if(cDown && boots[Boots.ChainSpark])
				{
					shineDir = 4;
				}
				else
				{
					shineDir = 0;
				}
			}
			if((entity_place_collide(0,4) || (onPlatform && lhc_place_meeting(x,y+4,"IPlatform"))) && (!entity_place_collide(0,-1) || entity_place_collide(0,0)))
			{
				//y -= 1;
				position.Y -= 1;
				y = scr_round(position.Y);
			}
			velX = 0;
			velY = 0;
			shineCharge = 0;
			shineSparkSpeed = shineSparkStartSpeed;
			
			if(cDash && (move2 != 0 || cUp || cDown || aUp || aDown))
			{
				shineStart = min(shineStart, 1);
			}
			
			if(shineStart == 1)
			{
				audio_play_sound(snd_ShineSpark,0,false);
				if(move2 != 0)
				{
					dir = move2;
					dirFrame = 4*dir;
				}
			}
		}
		else if(shineEnd > 0)
		{
			if(shineEnd == shineEndMax)
			{
				scr_PlayExplodeSnd(0,false);
				audio_stop_sound(snd_ShineSpark);
			}
			velX = 0;
			velY = 0;
			shineSparkSpeed = shineSparkStartSpeed;
			if(shineRestart && boots[Boots.ChainSpark])
			{
				if(dir == sign(shineDir))
				{
					dir *= -1;
					dirFrame = dir;
				}
				else if(move2 == dir)
				{
					if(aUp || cUp)
					{
						shineDir = move2;
					}
					else if(aDown || cDown)
					{
						shineDir = 3*move2;
					}
					else
					{
						shineDir = 2*move2;
					}
					audio_play_sound(snd_ShineSpark,0,false);
					dir = move2;
					dirFrame = 4*dir;
					shineRestarted = true;
					shineRestart = false;
					shineEnd = 0;
				}
				else if(cDown && move2 == -dir)
				{
					shineCharge = 300;
					shineEnd = 1;
					shineRestart = false;
				}
			}
			if(shineEnd == 1)
			{
				if(shineCharge <= 0)
				{
					for(var i = 0; i < 2; i++)
					{
						var sdir = -45*shineDir + 180*i;
						var swave = instance_create_layer(x+sprtOffsetX,y+sprtOffsetY,layer_get_id("Projectiles"),obj_SparkShockwave);
						swave.damage = 2000;
						swave.velX = lengthdir_x(3,sdir);
						swave.velY = lengthdir_y(3,sdir);
						swave.direction = sdir;
						swave.image_angle = sdir;
						swave.creator = id;
					}
					audio_play_sound(snd_SparkShockwave,0,false);
				}
				
				if(state == State.BallSpark)
				{
					state = State.Morph;
					stateFrame = State.Morph;
				}
				else
				{
					stateFrame = State.Somersault;
					state = State.Somersault;
				}
			}
		}
		else
		{
			var oldSDir = shineDir;
			if(cDash && rDash && canDodge && shineSparkRedirect)
			{
				if(move2 != 0 || aUp || (aDown && boots[Boots.ChainSpark]))
				{
					if(aUp || cUp)
					{
						if(move2 != 0)
						{
							shineDir = move2;
						}
						else
						{
							shineDir = dir;
						}
					}
					else if((aDown || cDown) && boots[Boots.ChainSpark])
					{
						if(move2 != 0)
						{
							shineDir = 3*move2;
						}
						else
						{
							shineDir = 3*dir;
						}
					}
					else
					{
						shineDir = 2*move2;
					}
				}
				else if(cDown && boots[Boots.ChainSpark])
				{
					shineDir = 4;
				}
				else if(cUp)
				{
					shineDir = 0;
				}
				if(shineDir != oldSDir)
				{
					if(dodgeRecharge >= dodgeRechargeMax)
					{
						dodgeRecharge = dodgeRechargeMax/2;
					}
					else
					{
						dodgeRecharge = 0;
					}
					audio_play_sound(snd_ShineSpark_Charge,0,false);
				}
			}
			if(shineDir != 0 && shineDir != 4)
			{
				dir = sign(shineDir);
			}
			shineCharge = 0;
			
			shineSparkSpeed = min(shineSparkSpeed+moveSpeed[3,liquidState], shineSparkSpeedMax);
			
			var shineAng = 90;
			var shineSpeedX = shineSparkSpeed;
			switch(abs(shineDir))
			{
				case 1:
				{
					shineAng = 45;
					shineSpeedX *= sign(shineDir);
					break;
				}
				case 2:
				{
					shineAng = 0;
					shineSpeedX *= sign(shineDir);
					break;
				}
				case 3:
				{
					shineAng = -45;
					shineSpeedX *= sign(shineDir);
					break;
				}
				case 4:
				{
					shineAng = -90;
					break;
				}
			}
			
			if(shineSparkFlightAdjust)
			{
				var moveY = (cDown-cUp);
				moveY = clamp(moveY+(aDown-aUp),-1,1);
				
				var angleChange = 11.25;
				
				if(shineDir == 0 || shineDir == 4)
				{
					shineAng -= angleChange*move2 * ((shineDir == 0) - (shineDir == 4));
				}
				if(abs(shineDir) == 1 || abs(shineDir) == 3)
				{
					var sdir = (abs(shineDir) == 1) - (abs(shineDir) == 3);
					shineAng -= angleChange*clamp(move2*sign(shineDir)*sdir + moveY,-1,1);
				}
				if(abs(shineDir) == 2)
				{
					shineAng -= angleChange*moveY;
				}
			}
			
			velX = lengthdir_x(shineSpeedX,shineAng);
			velY = lengthdir_y(shineSparkSpeed,shineAng);
        
			if(cJump && rJump && shineSparkCancel)
			{
				if(state == State.BallSpark)
				{
					state = State.Morph;
				}
				else
				{
					//stateFrame = State.Somersault;
					//mask_index = mask_Crouch;
					//state = State.Somersault;
					ChangeState(State.Somersault,State.Somersault,mask_Crouch,false);
				}
				if(abs(shineDir) == 2)
				{
					if(boots[Boots.SpaceJump] && state != State.Morph)
					{
						velY = -jumpSpeed[boots[Boots.HiJump],liquidState];
						jumping = true;
					}
					else
					{
						velY = -jumpSpeed[0,liquidState]*0.25;
					}
				}
				if(shineDir != 0 && shineDir != 4)
				{
					speedCounter = speedCounterMax;
					speedFXCounter = 1;
					audio_stop_sound(snd_ShineSpark);
				}
			}
		}
		
		sparkCancelSpiderJumpTweak = true;
	}
	else
	{
		if(speedFXCounter >= 1)
		{
			shineFXCounter = max(shineFXCounter - 0.05, 0);
		}
		else
		{
			shineFXCounter = max(shineFXCounter - 0.075, 0);
		}
		shineRampFix = max(shineRampFix - 1, 0);
		shineRestart = false;
		shineRestarted = false;
		
		shineSparkSpeed = shineSparkStartSpeed;
		
		if(!cJump)
		{
			sparkCancelSpiderJumpTweak = false;
		}
	}
#endregion
#region Grapple
	if(state == State.Grapple)
	{
		stateFrame = State.Grapple;
		mask_index = mask_Crouch;
		if(!grappleActive)
		{
			stateFrame = State.Somersault;
			state = State.Somersault;
			var signx = (move2 != 0) ? move2 : sign(x - xprevious);
			if(signx != 0)
			{
				dir = signx;
				dirFrame = 4*dir;
			}
			if(frame[Frame.Somersault] <= 0)
			{
				frame[Frame.Somersault] = 1;
			}
		}
		else
		{
			if(/*velX == 0 &&*/ grappleVelX == 0 && abs(x - grapple.x) > 11 && abs(x - grapple.x) < 25 && ((entity_place_collide(10,0) && x < grapple.x) || (entity_place_collide(-10,0) && x > grapple.x)) && (grapAngle <= 45 || grapAngle >= 315) && grappleDist <= 33)
			{
			    if(sign(x-grapple.x) != 0)
			    {
			        dir = sign(x-grapple.x);
			    }
			    velX = 0;
				velY = 0;
			    grapDisVel = 0;
			    speedBoost = false;
			    speedCounter = 0;

			    grapAngle = scr_wrap(34*dir,0,360);
			    grappleDist = 31;
			    //x = grapple.x + lengthdir_x(grappleDist, grapAngle - 90);
			    //y = grapple.y + lengthdir_y(grappleDist, grapAngle - 90);
				var destX = grapple.x + lengthdir_x(grappleDist, grapAngle - 90),
					destY = grapple.y + lengthdir_y(grappleDist, grapAngle - 90);
				velX = destX-position.X;
				velY = destY-position.Y;

			    dirFrame = 4*dir;
			    canWallJump = (move != -dir);//place_collide(-10*move,0);
			    if(cShoot)
			    {
			        grapWJCounter = 60;
			    }
				
				grappleVelX = 0;
				grappleVelY = 0;
			}
			else
			{
			    canWallJump = false;
			    grapWJCounter = 0;
				
				/*if(abs(velX) <= 0.0025 && place_collide(dir,0) && ((dir == 1 && x < grapple.x) || (dir == -1 && x > grapple.x)) && (grapAngle < 25 || grapAngle > 335) && grappleDist > 43)
			    {
			        if(cJump && rJump)
			        {
						var kickSpeed = maxSpeed[1,liquidState];
						if(liquidMovement)
						{
							kickSpeed *= 0.75;
						}
			            if(place_collide(1,0))
			            {
			                velX = -kickSpeed;
			            }
			            if(place_collide(-1,0))
			            {
			                velX = kickSpeed;
			            }
			            audio_play_sound(snd_WallJump,0,false);
			            grapWallBounceFrame = 15;
			        }
			    }*/
				
				grapAngle = point_direction(position.X, position.Y, grapple.x, grapple.y) - 90;
				
				var grapAngVel = angle_difference(point_direction(position.X+velX,position.Y+velY,grapple.x,grapple.y),point_direction(position.X,position.Y,grapple.x,grapple.y));
				
				if(!speedBoost)
				{
					//var grapMoveSpeed = fMoveSpeed / (2-liquidMovement);
					//grapMoveSpeed *= (1 + (grappleDist/grappleMaxDist));
					
					//var angleGrav = fGrav*1.75 * dcos(grapAngle+90);
					//var angleGrav = fGrav*1.5 * dcos(grapAngle+90);
					
					var grapMoveSpeed = fMoveSpeed / 1.25,
						angleGrav = fGrav*2 * dcos(grapAngle+90);
					
					if(liquidMovement)
					{
						grapMoveSpeed = fMoveSpeed*1.5;
						angleGrav = fGrav*1.75 * dcos(grapAngle+90);
					}
					
					velX += lengthdir_x(grapMoveSpeed * move + angleGrav,grapAngle);
					velY += lengthdir_y(grapMoveSpeed * move + angleGrav,grapAngle);
					velX *= (0.99 + 0.007*liquidMovement);
					velY *= (0.99 + 0.007*liquidMovement);
				}
				else
				{
					if(point_distance(x,y,xprevious,yprevious) >= minBoostSpeed*0.75)
					{
						if(point_distance(x,y,xprevious,yprevious) < maxSpeed[2,liquidState]*1.25)
						{
							velX += lengthdir_x(moveSpeed[0,liquidState]*sign(grapAngVel),grapAngle);
							velY += lengthdir_y(moveSpeed[0,liquidState]*sign(grapAngVel),grapAngle);
						}
					}
					else
					{
						speedBoost = false;
						speedCounter = 0;
					}
				}
				
				var kickDir = move2;
				if(move2 == 0)
				{
					if(sign(grapAngVel) == 0)
					{
						kickDir = dir;
					}
					else
					{
						kickDir = sign(grapAngVel);
					}
				}
				var grapVelocity = point_distance(x,y,xprevious,yprevious),
				kickCheckX = lengthdir_x(kickDir*max(grapVelocity,2),grapAngle),
				kickCheckY = lengthdir_y(kickDir*max(grapVelocity,2),grapAngle),
				kickBaseX1 = x+lengthdir_x(-2,grapAngle-90),
				kickBaseY1 = y+lengthdir_y(-2,grapAngle-90),
				kickBaseX2 = x+lengthdir_x(2,grapAngle-90),
				kickBaseY2 = y+lengthdir_y(2,grapAngle-90);
				if(entity_place_collide(kickCheckX,kickCheckY,kickBaseX1,kickBaseY1) && entity_place_collide(kickCheckX,kickCheckY,kickBaseX2,kickBaseY2))
				{
					grapWallBounceCounter = -10*kickDir;
					prevGrapVelocity = grapVelocity;
				}
				if(grapWallBounceCounter != 0)
				{
					if(cJump && rJump)
			        {
						var kickSpeed = maxSpeed[1,liquidState];
						if(liquidMovement)
						{
							kickSpeed *= 0.75;
						}
						kickSpeed = max(kickSpeed,prevGrapVelocity);
			            velX = lengthdir_x(kickSpeed * sign(grapWallBounceCounter),grapAngle);
						velY = lengthdir_y(kickSpeed * sign(grapWallBounceCounter),grapAngle);
			            audio_play_sound(snd_WallJump,0,false);
			            grapWallBounceFrame = 15;
						
						if(!liquid)
						{
							var partLen = 20;
							if(sign(grapWallBounceCounter) == -dir)
							{
								partLen = 25;
							}
							var gAngle = grapAngle-90,
								gnum = 45;
							while(gnum > 0 && entity_position_collide(lengthdir_x(partLen,gAngle)-velX,y+lengthdir_y(partLen,gAngle)-velY))
							{
								gAngle -= dir;
								gnum--;
							}
							
							var partX = x+lengthdir_x(partLen,gAngle)-velX,
								partY = y+lengthdir_y(partLen,gAngle)-velY;
							part_particles_create(obj_Particles.partSystemB,partX,partY,obj_Particles.bDust[0],3);
						}
			        }
				}
				else
				{
					prevGrapVelocity = 0;
				}
			
				var dist = point_distance(position.X,position.Y,grapple.x,grapple.y);
				var reel = 0;
			
				var up = (cUp), down = (cDown && grappleDist < grappleMaxDist);
				if(global.grappleStyle == 1 && move != 0)
				{
					up = false;
					down = false;
				}
				var reelSpeed = 6 / (1+liquidMovement);
				if(dist < 31)
				{
					reel = min(reelSpeed,31-dist);
					grappleDist = min(dist,grappleMaxDist);
				}
				if(up)
				{
					reel = max(-reelSpeed,scr_round(31-dist));
					grappleDist = min(dist,grappleMaxDist);
				}
				if(down)
				{
					reel = min(reelSpeed,grappleMaxDist-dist);
					grappleDist = min(dist,grappleMaxDist);
				}
				if(grappleDist > grappleMaxDist)
				{
					reel = max(-reelSpeed/2,scr_round(grappleMaxDist-dist)-1);
					grappleDist = dist;
				}
	
				var vX = position.X - grapple.x,
					vY = position.Y - grapple.y;
			
				var ndist = point_distance(position.X+velX,position.Y+velY,grapple.x,grapple.y);
				var ddist = ndist - dist;
				vX /= dist;
				vY /= dist;
				velX -= vX * ddist;
				velY -= vY * ddist;
				vX *= (grappleDist + reel);
				vY *= (grappleDist + reel);
				grappleVelX = (grapple.x + vX) - position.X;
				grappleVelY = (grapple.y + vY) - position.Y;
	
				grapDisVel = reel;
				
				grapBoost = true;
			}
		}
	}
	else
	{
		if(grounded || abs(x - xprevious) <= maxSpeed[4,liquidState])
		{
			grapBoost = false;
		}
		
		if(!grappleActive)
		{
			grappleDist = 0;
		}
		
		grapAngle = 0;
		grappleVelX = 0;
		grappleVelY = 0;
		grapWJCounter = 0;
		grapWallBounceCounter = 0;
		prevGrapVelocity = 0;
		
		
		grapMoveAnim = 0;
	}
#endregion
#region Hurt
	if(state == State.Hurt)
	{
		if(stateFrame != State.Morph)
		{
			stateFrame = State.Hurt;
		}
		if(hurtTime <= 0)
		{
			if(lastState == State.Grip || lastState == State.Spark)
			{
				state = State.Jump;
			}
			else if(lastState == State.Dodge || lastState == State.Grapple)
			{
				state = State.Somersault;
			}
			else if(lastState == State.BallSpark)
			{
				state = State.Morph;
			}
			else
			{
				state = lastState;
				if(stateFrame != State.Morph)
				{
					stateFrame = lastStateFrame;
				}
			}
		}
		else
		{
			dmgBoost = 5;
			velX = 0;
			velY = 0;
			//if(move2 == dir)
			//{
			//	hurtTime = max(hurtTime - 1, 0);
			//}
			hurtTime = max(hurtTime - 1, 0);
		}
	}
	else
	{
		hurtTime = 0;
		hurtSpeedX = 0;
		hurtSpeedY = 0;
		hurtFrame = 0;
		
		dmgBoost = max(dmgBoost - 1, 0);
	}
	
	if(state == State.Hurt || state == State.Stand || (state == State.Crouch && !entity_place_collide(0,-11)) || state == State.Jump || state == State.Somersault)
	{
		if(dmgBoost > 0 && stateFrame != State.Morph && cJump && move2 == -dir)
		{
			ChangeState(State.DmgBoost,State.DmgBoost,mask_Jump,false);
			dmgBoost = 0;
		}
	}
	else
	{
		//dmgBoost = max(dmgBoost - 1, 0);
		dmgBoost = 0;
	}
#endregion
#region Damage Boost
	if(state == State.DmgBoost)
	{
		stateFrame = State.DmgBoost;
		mask_index = mask_Jump;
		gunReady = false;//true;
		ledgeFall = true;
		ledgeFall2 = true;
		if(((cJump && move2 == -dir) || velY < 0) && !grounded)
		{
			if(move2 == -dir)
			{
				velX = maxSpeed[9,liquidState]*move2;
			}
			if(!dmgBoostJump)
			{
				//velY = -fJumpSpeed;
				velY = -jumpSpeed[4,liquidState];
				
				jumping = true;
				dmgBoostJump = true;
			}
			
			landFrame = 0;
			smallLand = (velY <= 3);
		}
		else
		{
			if(grounded)
			{
				velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
				speedCounter = 0;
				audio_play_sound(snd_Land,0,false);
				if(entity_place_collide(0,-3) && !entity_place_collide(0,0))
				{
					crouchFrame = 3;
					ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
				}
				else
				{
					if(smallLand)
					{
						landFrame = 6;
					}
					else
					{
						landFrame = 9;
					}
					ChangeState(State.Stand,State.Stand,mask_Stand,true);
				}
			}
			else
			{
				state = State.Jump;
			}
		}
	}
	else
	{
		dmgBoostJump = false;
	}
#endregion
#region Death
	if(state == State.Death)
	{
		var d = instance_create_depth(x,y,-1,obj_DeathAnim);
		d.posX = x-camera_get_view_x(view_camera[0]);
		d.posY = y-camera_get_view_y(view_camera[0]);
		d.dir = dir;
		global.gamePaused = true;
	}
#endregion
#region Dodge
	if(boots[Boots.Dodge] && dir != 0 && (state == State.Stand || state == State.Crouch || state == State.Jump || state == State.Somersault || state == State.Grip))
	{
		if(cDash && !global.autoDash)
		{
			dodgePress++;
			if(xRayActive || prevState == State.Morph)
			{
				dodgePress = 16;
			}
		}
		else if(canDodge)
		{
			if((!rDash && dodgePress <= 15 && !global.autoDash) || (cDash && rDash && global.autoDash))
			{
				groundedDodge = 0;
				if(state == State.Stand)
				{
					groundedDodge = 1;
				}
				if(state == State.Crouch)
				{
					groundedDodge = 2;
				}
				if(state == State.Grip && gripGunReady)
				{
					dir = -dir;
					move2 = dir;
				}
				ChangeState(State.Dodge,State.Dodge,mask_Crouch,(groundedDodge == 1));
				velY = 0;
				if(move2 == dir)
				{
					dodgeDir = dir;
				}
				else
				{
					dodgeDir = -dir;
				}
			}
			dodgePress = 0;
		}
	}
	if(state == State.Dodge)
	{
		stateFrame = State.Dodge;
		mask_index = mask_Crouch;
		gunReady = true;
		ledgeFall = true;
		ledgeFall2 = true;
		
		var unchargeable = ((itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3)) || xRayActive || hyperBeam);
		var shoot = (cShoot && rShoot) || (!cShoot && !rShoot && !unchargeable);
		if(dodgeLength >= dodgeLengthMax || shoot)
		{
			if(grounded)
			{
				if(entity_place_collide(0,-11) || groundedDodge == 2)
				{
					stateFrame = State.Crouch;
					state = State.Crouch;
					crouchFrame = 0;
				}
				else
				{
					ChangeState(State.Stand,State.Stand,mask_Stand,true);
					landFrame = 7;
					smallLand = false;
				}
			}
			else if(shoot)
			{
				ChangeState(State.Jump,State.Jump,mask_Jump,false);
			}
			else
			{
				state = State.Somersault;
			}
		}
		else
		{
			if(dodgeLength < dodgeLengthMax-5)
			{
				velX = max(maxSpeed[10,liquidState],abs(velX))*dodgeDir;
			}
			dodgeLength += (1 / (1+liquidMovement));
			
			if(!dodged)
			{
				if(dodgeRecharge >= dodgeRechargeMax)
				{
					dodgeRecharge = dodgeRechargeMax/2;
				}
				else
				{
					dodgeRecharge = 0;
				}
				audio_play_sound(snd_Dodge,0,false);
				dodged = true;
			}
			
			immune = true;
		}
	}
	else
	{
		dodged = false;
		dodgeLength = 0;
		
		//if(state != State.Spark && state != State.BallSpark)
		//{
			if(dodgeRecharge < dodgeRechargeMax-dodgeRechargeRate)
			{
				dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate,dodgeRechargeMax-dodgeRechargeRate);
			}
			else if(grounded || state == State.Grip || state == State.Grapple || ((state == State.Spark || state == State.BallSpark) && shineEnd > 0))
			{
				dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate,dodgeRechargeMax);
				if(shineEnd > 0)
				{
					dodgeRecharge = dodgeRechargeMax;
				}
			}
		//}
		if(dodgeRecharge >= dodgeRechargeMax)
		{
			canDodge = boots[Boots.Dodge];
		}
		else if(dodgeRecharge < dodgeRechargeMax/2)
		{
			canDodge = false;
		}
	}
#endregion
#region CrystalFlash
	if(state == State.CrystalFlash)
	{
		stateFrame = State.CrystalFlash;
		mask_index = mask_Crouch;
		immune = true;
		
		velX = 0;
		velY = 0;
		
		if(cFlashStartMove < 16)
		{
			cFlashStartMove++;
			
			if(crystalClip)
			{
				//y -= 2;
				position.Y -= 2;
				y = scr_round(position.Y);
			}
			else
			{
				velY = -2;
			}
		}
		
		var ammo = missileStat+superMissileStat+powerBombStat;
		if(ammo > 0 && energy < energyMax && cFlashDuration < cFlashDurationMax)
		{
			var energyPerAmmo = 50;
			
			var eMax = min(cFlashLastEnergy+energyPerAmmo, energyMax);
			if(energy < eMax)
			{
				energy = min(energy+scr_round(energyPerAmmo/cFlashStep), eMax);
			}
			if(energy >= eMax)
			{
				while(ammo > 0 && ((cFlashAmmoUse == 0 && missileStat <= 0) || (cFlashAmmoUse == 1 && superMissileStat <= 0) || (cFlashAmmoUse == 2 && powerBombStat <= 0)))
				{
					cFlashAmmoUse = scr_wrap(cFlashAmmoUse+1,0,3);
				}
				switch(cFlashAmmoUse)
				{
					case 0:
					{
						missileStat -= 1;
						break;
					}
					case 1:
					{
						superMissileStat -= 1;
						break;
					}
					case 2:
					{
						powerBombStat -= 1;
						break;
					}
				}
				cFlashAmmoUse = scr_wrap(cFlashAmmoUse+1,0,3);
				cFlashLastEnergy = energy;
				cFlashDuration++;
			}
		}
		else
		{
			if(entity_place_collide(0,-11))
			{
				ChangeState(State.Crouch,State.Crouch,mask_Crouch,true);
				crouchFrame = 0;
			}
			else
			{
				ChangeState(State.Jump,State.Jump,mask_Jump,false);
			}
		}
		
		if(cFlashPal >= 1)
		{
			if(cFlashPalDiff <= 0)
			{
				/*cFlashPal2 = clamp(cFlashPal2+0.025*cFlashPalNum,0,1.5);
				if(cFlashPal2 <= 0)
				{
					cFlashPalNum = 1;
				}
				if(cFlashPal2 >= 1.5)
				{
					cFlashPalNum = -1;
				}*/
				
				cFlashPal2 = clamp(cFlashPal2+0.025*cFlashPalNum,0,1);
				if(cFlashPal2 <= 0)
				{
					cFlashPalNum = 1;
				}
				if(cFlashPal2 >= 1)
				{
					cFlashPalNum = -1;
				}
			}
			cFlashPalDiff = max(cFlashPalDiff-0.05,0);
		}
		cFlashPal = min(cFlashPal+0.2,1);
		
		cBubbleScale = min(cBubbleScale+0.075,1);
	}
	else
	{
		cFlashStartMove = 0;
		cFlashDuration = 0;
		cFlashLastEnergy = energy;
		cFlashAmmoUse = 0;
		
		cFlashPal = max(cFlashPal-0.075,0);
		cFlashPal2 = 0;
		cFlashPalDiff = 1;
		cFlashPalNum = 1;
		
		cBubbleScale = max(cBubbleScale-0.075,0);
	}
#endregion

	x = scr_round(position.X);
	y = scr_round(position.Y);
	
	if(!misc[Misc.ScrewAttack] || state != State.Somersault || liquidMovement)
	{
		audio_stop_sound(snd_ScrewAttack);
		audio_stop_sound(snd_ScrewAttack_Loop);
		screwSoundPlayed = false;
		screwFrame = 0;
		screwFrameCounter = 0;
		screwPal = 0;
		screwPalNum = 1;
	}
	
	prevVelX = velX;
	
	aimUpDelay = max(aimUpDelay - 1, 0);
	ballBounce = max(ballBounce - 1, 0);
	
	shineCharge = max(shineCharge - 1, 0);
	shineStart = max(shineStart - 1, 0);
	shineEnd = max(shineEnd - 1, 0);
	if(grapWallBounceCounter > 0)
	{
		grapWallBounceCounter = max(grapWallBounceCounter-1,0);
	}
	else
	{
		grapWallBounceCounter = min(grapWallBounceCounter+1,0);
	}
	
	prevSpiderEdge = spiderEdge;
	
	if(!PlayerOnPlatform())
	{
		onPlatform = false;
	}
	
	notGrounded = !grounded;
	
	if(((!cUp && !cDown) || (move != 0 && state == State.Stand)) && aimAngle == gbaAimAngle)
	{
		gbaAimPreAngle = gbaAimAngle;
	}
	
	var xVel = x - xprevious,
		yVel = y - yprevious;
	if(justFell)
	{
		yVel = velY;
	}
	EntityLiquid_Large(xVel,yVel)
	
	if(isChargeSomersaulting)
	{
		immune = true;
	}
	if(isSpeedBoosting || isScrewAttacking)
	{
		immune = true;
		var xv = fVelX;
		if(fVelX == 0)
		{
			xv = move2;
		}
		DestroyBlock(x+xv,y+fVelY);
	}
}
else
{
	dodgePress = 16;
}
