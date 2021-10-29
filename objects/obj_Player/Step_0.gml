/// @description Physics

var xRayActive = instance_exists(XRay);

if(!global.gamePaused || (xRayActive && !global.roomTrans && !obj_PauseMenu.pause && !pauseSelect))
{
	grappleActive = instance_exists(grapple);
	
	//debug keys
	#region debug keys
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
	    energy = 10;
	}
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
						rnum = scr_wrap(rnum+1,0,ilen-1);
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
						rnum = scr_wrap(rnum+1,0,ilen-1);
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
						rnum = scr_wrap(rnum+1,0,ilen-1);
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
						rnum = scr_wrap(rnum+1,0,ilen-1);
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
	
	afterImageNum = 10;
	drawAfterImage = false;

	liquidLevel = 0;
	liquidState = 0;
	
	immune = false;

// ----- Liquid Movement
#region Liquid Movement
	var liquidMovement = false;
	if(instance_exists(obj_Liquid))
	{
	    liquidLevel = max(bbox_bottom - obj_Liquid.y,0);

	    var dph = 10;
	    if(stateFrame == State.Morph)
	    {
	        dph = 3;
	    }
	    liquidMovement = (liquidLevel > dph && !suit[Suit.Gravity]);
		
		if(liquidMovement)
		{
			if(instance_exists(obj_Water))
			{
				liquidState = 1;
			}
			if(instance_exists(obj_Lava))
			{
				liquidState = 2;
			}
		}
	}
#endregion
	
// ----- Get Input -----
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

	if(state == State.Elevator || state == State.Recharge)
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
	
	//grounded = PlayerGrounded();
	grounded = PlayerGrounded(2);
	
	onPlatform = PlayerOnPlatform();
	
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
	
	if(cAimLock && sign(velX) != dir && state == State.Stand)
	{
		walkState = true;
	}
	if(sign(velX) == dir || velX == 0 || state != State.Stand || xRayActive)
	{
		walkState = false;
	}
	
	if(cMorph && rMorph && morphFrame <= 0 && state != State.Morph && stateFrame != State.Morph && misc[Misc.Morph] && state != State.Spark && state != State.BallSpark && state != State.Grip && !xRayActive)
	{
		audio_play_sound(snd_Morph,0,false);
		mask_index = mask_Morph;
		if(state == State.Stand)
		{
			for(var i = 11; i > 0; i--)
			{
				if(!place_collide(0,1) && (!onPlatform || !place_meeting(x,y+1,obj_Platform)))
				{
					y += 1;
				}
			}
			//velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
			//speedCounter = 0;
		}
		state = State.Morph;
		stateFrame = State.Morph;
		morphFrame = 8;
	}
	
// ----- Aim Control -----
#region Aim Control
	prAngle = ((cAngleUp && rAngleUp) || (cAngleDown && rAngleDown));
	rlAngle = ((!cAngleUp && !rAngleUp) || (!cAngleDown && !rAngleDown));
	
	if(!grappleActive)
	{
		if((aimAngle > -2 && (aimAngle < 2 || state != State.Grip || (rlAngle && global.aimStyle != 2))) ||
			(prAngle && global.aimStyle != 2) || grounded || move != 0 || xRayActive || 
			state == State.Morph || state == State.Somersault || state == State.Spark || state == State.BallSpark)
		{
			aimAngle = 0;
		}
		if(!xRayActive)
		{
			if(!grounded && cDown && !cUp && (state != State.Somersault || rDown) && state != State.Morph)
			{
				if(aimAngle == -2 && move == 0 && rDown && morphFrame <= 0 && state != State.Morph && misc[Misc.Morph] && state != State.Spark && state != State.BallSpark && state != State.Grip && !cAngleUp && !cAngleDown)
				{
					audio_play_sound(snd_Morph,0,false);
					mask_index = mask_Morph;
					state = State.Morph;
					morphFrame = 8;
				}
				aimAngle = -2;
			}
			
			if(((state != State.Morph && (state != State.Crouch || place_collide(0,-11))) || (global.aimStyle == 2 && cAngleUp)) && morphFrame <= 0)
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
						aimAngle = -2;
					}
				}
			}
		
			if(global.aimStyle == 0)
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
	
			if(global.aimStyle == 1)
			{
				if(cAngleUp)
				{
					if(cDown && !cUp)
					{
						gbaAimAngle = -1;
					}
					else if((cUp && (stateFrame != State.Morph || place_collide(0,-17))) || gbaAimAngle == 0)
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
			else
			{
				gbaAimAngle = 0;
			}
	
			if(global.aimStyle == 2)
			{
				if(cAngleUp)
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

// ----- Horizontal Movement -----
#region Horizontal Movement
	var sBoostWJFlag = (speedBoost && state == State.Somersault && place_collide(sign(velX),0));
	if(sBoostWJFlag)
	{
		speedBoostWJCounter++;
	}
	else
	{
		speedBoostWJCounter = 0;
	}
	var speedBoostWJ = (sBoostWJFlag && speedBoostWJCounter < 20);

	fFrict = frict[liquidState];
	minBoostSpeed = maxSpeed[1,liquidState] + ((maxSpeed[2,liquidState] - maxSpeed[1,liquidState])*0.75);

	/*if(state != State.Grapple && (sign(velX) != dir || abs(dirFrame) < 4 || !boots[Boots.SpeedBoost] || brake || 
	(move != dir && (grounded || !grapBoost) && (aimAngle > -2 || !cJump) && (state != State.Morph || (state == State.Morph && abs(velX) < 1) || grounded) && morphFrame <= 0)))*/
	var stopBoosting = !speedBoostWJ && (sign(velX) != dir || (move != dir && (aimAngle > -2 || !cJump) && ((state != State.Somersault && state != State.Morph) || (state == State.Morph && abs(velX) <= maxSpeed[5,liquidState]) || grounded) && morphFrame <= 0));
	if(state != State.Grapple && (!boots[Boots.SpeedBoost] || abs(dirFrame) < 4 || stopBoosting))
	{
		speedCounter = 0;
	}
	else if((cDash || global.autoDash) && abs(fVelX) > 0 && grounded && state == State.Stand && !liquidMovement)
	{
		speedCounter = min(speedCounter+1,speedCounterMax);
	}
	
	if(boots[Boots.SpeedBoost])
	{
		//speedBoost = (speedCounter >= speedCounterMax || (abs(velX) >= minBoostSpeed && state != State.Grapple && !grapBoost && state != State.Dodge));
		if(speedCounter >= speedCounterMax)
		{
			speedBoost = true;
		}
		else if(!speedBoost && abs(velX) >= minBoostSpeed && state != State.Grapple && !grapBoost && state != State.Dodge)
		{
			speedCounter = speedCounterMax;
			speedBoost = true;
		}
		/*else if(speedCounter <= 0)
		{
			speedBoost = false;
		}*/
	}
	else
	{
		speedCounter = 0;
	}
	
	if(speedBoost && state != State.Spark && state != State.BallSpark)
	{
		//if((sign(velX) != dir || move != dir) && state != State.Grapple && grounded && (aimAngle > -2 || !cJump) && (state != State.Morph || (state == State.Morph && abs(velX) < 1) || grounded) && morphFrame <= 0)
		if(state != State.Grapple && stopBoosting)// && landFrame <= 0)
		{
			if(state == State.Stand && abs(velX) >= minBoostSpeed-fFrict && abs(fVelX) > 0 && !cDown && !brake)
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
		afterImageNum = (10 * speedFXCounter);
		drawAfterImage = true;
	}
	else
	{
		speedSoundPlayed = false;
		audio_stop_sound(snd_SpeedBooster);
		audio_stop_sound(snd_SpeedBooster_Loop);
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
		
		speedFXCounter = max(speedFXCounter - 0.075, 0);
		speedCatchCounter = max(speedCatchCounter - 1, 0);
	}
	
	if((state == State.Stand || state == State.Crouch || state == State.Morph) && (speedBoost || speedCatchCounter > 0) && move == 0 && cDown && dir != 0 && grounded && morphFrame <= 0)
	{
		shineCharge = 300;
		speedCounter = 0;
	}
	
	if(speedCounter <= 0)
	{
		speedBoost = false;
	}
	
	var moveState = 0;
	if(state == State.Morph)
	{
		if(grounded)
		{
			if(mockBall)
			{
				moveState = 6;
				if(speedBoost && (cDash || global.autoDash))
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
		if((cDash || global.autoDash) && !liquidMovement)
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
	/*if(moveState == 2)
	{
		fMaxSpeed = lerp(maxSpeed[1,liquidState],maxSpeed[2,liquidState], speedCounter / speedCounterMax);
	}*/
	fMoveSpeed = moveSpeed[(state == State.Morph),liquidState];
	/*if(speedCounter > 0 && boots[Boots.SpeedBoost])
	{
		fMoveSpeed *= clamp((maxSpeed[2,liquidState] - abs(velX))*0.2, 0.25, 1);
	}*/
	if(moveState == 2)
	{
		fMoveSpeed *= lerp(1, 0.1, speedCounter / speedCounterMax);
	}
	
	if(state == State.Stand)
	{
		if(cAimLock && move != dir && sign(velX) != dir)
		{
			fMaxSpeed = 1.25;
			if(liquidMovement)
			{
				fMaxSpeed = 0.75;
			}
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
	if(move != 0 && abs(velX) > maxSpeed2 && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Dodge && (speedCounter > 0 || grounded))
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
	state != State.Hurt && state != State.DmgBoost && (!spiderBall || spiderEdge == Edge.None) && !xRayActive && state != State.Dodge)
	{
		if((move == 1 && !brake) || (state == State.Somersault && dir == 1 && velX < 0))
		{
			if(velX <= fMaxSpeed)
			{
				if(velX < 0)
				{
					if(state == State.Somersault && velX > -maxSpeed[3,0] && !liquidMovement)
					{
						velX = 0;
					}
					else
					{
						velX = min(velX + fMoveSpeed + fFrict, 0);
					}
				}
				else if(sign(dirFrame) != dir && sign(dirFrame) != 0 && !speedBoost && state != State.Somersault)
				{
					velX = 0;
				}
				else
				{
					/*if(velX < minSpeed && state != State.Morph && abs(dirFrame) >= 4 && liquidState == 0)
					{
						velX = minSpeed;
					}
					else
					{*/
						velX = min(velX + fMoveSpeed, fMaxSpeed);
					//}
				}
			}
		}
		else if((move == -1 && !brake) || (state == State.Somersault && dir == -1 && velX > 0))
		{
			if(velX >= -fMaxSpeed)
			{
				if(velX > 0)
				{
					if(state == State.Somersault && velX < maxSpeed[3,0] && !liquidMovement)
					{
						velX = 0;
					}
					else
					{
						velX = max(velX - fMoveSpeed - fFrict, 0);
					}
				}
				else if(sign(dirFrame) != dir && sign(dirFrame) != 0 && !speedBoost && state != State.Somersault)
				{
					velX = 0;
				}
				else
				{
					/*if(velX > - minSpeed && state != State.Morph && abs(dirFrame) >= 4 && liquidState == 0)
					{
						velX = minSpeed;
					}
					else
					{*/
						velX = max(velX - fMoveSpeed, -fMaxSpeed);
					//}
				}
			}
		}
		else
		{
			if((grounded || state != State.Somersault) && (aimAngle > -2 || !cJump) && 
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
		//uncrouch = 0;
		//uncrouching = false;
	}
	else
	{
		if(state == State.Crouch)
		{
			/*if(!misc[Misc.Morph] && move == 1 && place_collide(0,-11) && (!collision_line(bbox_right,bbox_top,bbox_right,bbox_top-11,obj_Tile,true,true) || !collision_line(bbox_right+16,bbox_top,bbox_right+16,bbox_top-11,obj_Tile,true,true)))
			{
				velX = 0.5;
			}
			else if(!misc[Misc.Morph] && move == -1 && place_collide(0,-11) && (!collision_line(bbox_left,bbox_top,bbox_left,bbox_top-11,obj_Tile,true,true) || !collision_line(bbox_left-16,bbox_top,bbox_left-16,bbox_top-11,obj_Tile,true,true)))
			{
				velX = -0.5;
			}
			else*/
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
		else if(state == State.Dodge && dodgeLength >= dodgeLengthMax-5 && !speedBoost)// && (dodgeDir == -dir || (move != dir && grounded) || liquidMovement))//!speedBoost)
		{
			var flag = (!liquidMovement && move != dir);
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

// ----- Vertical Movement -----
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
		//fJumpSpeed *= max(abs(velX)/5.375, 1);
		fJumpSpeed *= lerp(1,1.5,abs(velX)/maxSpeed[2,liquidState]);
	}
	
	var isJumping = (cJump && dir != 0 && climbIndex <= 0 && quickClimbTarget <= 0 && state != State.Spark && state != State.BallSpark && 
	state != State.Hurt && (!spiderBall || spiderEdge == Edge.None) && !xRayActive);// && state != State.Dodge);
	if(isJumping)
	{
		if(jump > 0)
		{
			if(state != State.Somersault && state != State.Morph)
			{
				if(cDash && jump >= fJumpHeight-1 && !grappleActive)
				{
					state = State.Somersault;
				}
				else
				{
					mask_index = mask_Jump;
					if(state == State.Crouch)
					{
						for(var i = 8; i > 0; i--)
						{
							if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
							{
								y -= 1;
							}
						}
					}
					state = State.Jump;
				}
			}
			velY = -fJumpSpeed;
			jump -= 1;
			
			ledgeFall = false;
			ledgeFall2 = false;
		}
		
		if(velY > 0 && !grounded)
		{
			jumping = false;
		}
		
		if(jump <= 0)
		{
			if(shineCharge > 0 && rJump && (state != State.Crouch || !place_collide(0,-11) || place_collide(0,0)) && !place_collide(0,-1) && 
			(move == 0 || velX == 0) && state != State.Somersault && state != State.DmgBoost && ((!cAngleDown && !cDown) || boots[Boots.ChainSpark]) && 
			(state != State.Morph || misc[Misc.Spring]) && morphFrame <= 0 && state != State.Grip)
			{
				audio_stop_sound(snd_ShineSpark_Charge);
				shineStart = 30;
				shineRestart = false;
				if(state == State.Morph)
				{
					stateFrame = State.Morph;
					state = State.BallSpark;
				}
				else
				{
					stateFrame = State.Spark;
					mask_index = mask_Jump;
					for(var i = 11; i > 0; i--)
					{
						if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
						{
							y -= 1;
						}
					}
					state = State.Spark;
				}
			}
			else if((rJump || (state == State.Morph && rMorphJump)) && 
			//(state != State.Crouch || !place_collide(0,-11) || place_collide(0,0) || state == State.Morph) && 
			(state != State.Morph || misc[Misc.Spring] || (cDash && !place_collide(0,-28))) && morphFrame <= 0 && state != State.DmgBoost)
			{
				if(grounded || canWallJump || speedBoostWJ || (state == State.Grip && (move != dir || climbTarget == 0) && !cDown) || 
				(boots[Boots.SpaceJump] && velY >= (2-InWaterTop) && state == State.Somersault && !liquidMovement))
				{
					if(!grounded && !canWallJump && !speedBoostWJ && boots[Boots.SpaceJump] && velY >= (2-InWaterTop))
					{
						spaceJump = 8;
						//frame[6] = 0;
					}
					if((!grounded || grapWJCounter > 0) && (canWallJump || speedBoostWJ))
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
						
						if(speedBoostWJ)
						{
							dir *= -1;
							velX *= -1;
							dirFrame = 4*dir;
							wjFrame = 8;
							wjAnimDelay = 10;
						}
						else
						{
							var m = move;
							if(move == 0 && dir != 0)
							{
								m = dir;
							}
							velX = maxSpeed[4,liquidState]*m;
							state = State.Somersault;
							wjFrame = 8;
							wjAnimDelay = 10;
							if(move != 0)
							{
								dir = move;
							}
						}
						
						if(dodgeRecharge >= dodgeRecharge-dodgeRechargeRate)
						{
							dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate,dodgeRechargeMax);
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
					if(rJump && state != State.Morph && state != State.Grip)
					{
						if(((abs(velX) > 0 && sign(velX) == dir) || (move != 0 && move == dir) || !grounded || (state == State.Crouch && place_collide(0,-8))) && !grappleActive)
						{
							state = State.Somersault;
						}
					}
					if(rJump && state == State.Morph && cDash)
					{
						morphSpinJump = true;
					}
				}
				else if(rJump)
				{
					/*if(state == State.Somersault)
					{
						if(boots[Boots.SpaceJump] && liquidMovement && velY >= 1)
						{
							velY = max(-velY,-fJumpSpeed*0.75);
						}
					}
					else*/ if(state != State.Morph && state != State.Grip && !grappleActive)
					{
						state = State.Somersault;
					}
					if(state == State.Morph && cDash)
					{
						morphSpinJump = true;
					}
				}
			}
			else
			{
				jump = 0;
			}
		}
		if(velY <= -(fJumpSpeed*0.3) && !liquidMovement && !outOfLiquid)
		{
			//jump += 1;
			//velY = min(velY,-fJumpSpeed*0.9);
			velY = max(velY*2,-fJumpSpeed*0.9);
		}
	}
	
	if(bombJump > 0 && (!place_collide(0,-11) || ((state != State.Crouch || !grounded) && morphFrame <= 0)))
	{
		velY = -bombJumpSpeed[liquidState];
		if(bombJumpX != 0)
		{
			velX = bombJumpX;
		}
		gunReady = true;
		jumping = false;
	}
	else
	{
		bombJump = 0;
		bombJumpX = 0;
		
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
	
	bombJump = max(bombJump - 1, 0);
	
	// Gravity
	fGrav = grav[liquidState];
	if(jump <= 0 && !grounded && (state != State.Grip || (startClimb && climbIndex > 7)) && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Hurt && state != State.Dodge)
	{
		velY += min(fGrav,max(fallSpeedMax-velY,0));
	}
	
	if(state != State.Morph || !misc[Misc.Spring])
	{
		rMorphJump = false;
	}
	else if(grounded && !cJump)
	{
		rMorphJump = true;
	}
	
	// Ball Bounce
	if((place_collide(0,velY) || place_meeting(x,y+velY,obj_Platform)) && velY >= (1.5 + fGrav) && state == State.Morph && morphFrame <= 0 && shineRampFix <= 0 && !spiderBall)
	{
		audio_stop_sound(snd_Land);
		audio_play_sound(snd_Land,0,false);
		if(!cJump || !rMorphJump)
		{
			velY = min(-velY*0.25,0);
		}
		ballBounce = ceil(abs(velY)/fGrav)*(2.1 / (1+liquidMovement));
	}
#endregion

	isChargeSomersaulting = (statCharge >= maxCharge && (state == State.Somersault || state == State.Dodge));
	isSpeedBoosting = (speedBoost || state == State.Spark || state == State.BallSpark);
	isScrewAttacking = (misc[Misc.ScrewAttack] && !liquidMovement && state == State.Somersault && stateFrame == State.Somersault);
	
	// -- debug: noclip --
	if(keyboard_check(vk_numpad6) || keyboard_check(vk_numpad4))
	{
		x += (keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4)) * 3;
		velX = 0;
	}
	if(keyboard_check(vk_numpad5) || keyboard_check(vk_numpad8))
	{
		y += (keyboard_check(vk_numpad5) - keyboard_check(vk_numpad8)) * 3;
		velY = -fGrav;
	}
	
// ----- Collision -----
#region Collision
	var ynum = max(ceil(abs(velX)),1);
	var grounded2 = (place_collide(0,ynum) || (bbox_bottom+ynum) >= room_height);
	
	var ynum2 = max(ceil(abs(velX)),8);
	var grounded3 = (place_collide(0,ynum2) || (bbox_bottom+ynum2) >= room_height);
	
	// Slope Speed Adjustment
	var yplus3Max = max(ceil(abs(velX)),4);
	sAngle = 90 - 90*sign(velX);
	
	if(abs(velX) >= 1 && grounded)// && state != State.Grip)
	{
		var checkValX = min(abs(velX),4)*sign(velX);
		if(place_collide(checkValX,0))
		{
			var yplus3 = 0;
			while(place_collide(checkValX,-yplus3) && yplus3 <= yplus3Max)
			{
				yplus3 = min(yplus3 + 1, yplus3Max+1);
			}
			if(!place_collide(checkValX,-yplus3) && grounded)
			{
				sAngle = point_direction(scr_round(x),scr_round(y), scr_round(x+checkValX),scr_round(y)-yplus3);
			}
		}
	}
	var downHill = false;
	
	cosX = lengthdir_x(abs(velX),sAngle);
	sinX = lengthdir_y(abs(velX),sAngle);
	
	fVelX = cosX;
	
	if(prAngle && fVelX != 0 && move == dir)
	{
		fVelX += move;
	}
	
	if(state == State.Grapple)
	{
		fVelX += grappleVelX;
	}
	
	if(state == State.Hurt)
	{
		fVelX = hurtSpeedX;
	}
	
	if(isSpeedBoosting)
	{
		scr_BreakBlock(x+fVelX,y,5);
	}
	if(isScrewAttacking)
	{
		scr_BreakBlock(x+fVelX,y,6);
	}
	
	var yplusMax = max(ceil(abs(velX)),3);
	
	// X Collision
	var colR = collision_line(bbox_right+fVelX,bbox_top,bbox_right+fVelX,bbox_bottom,obj_Tile,true,true),
		colL = collision_line(bbox_left+fVelX,bbox_top,bbox_left+fVelX,bbox_bottom,obj_Tile,true,true);
	var xspeed = abs(fVelX);
	if(place_collide(max(abs(fVelX),1)*sign(fVelX),0) && (!place_collide(0,0) || (fVelX > 0 && colR) || (fVelX < 0 && colL)))
	{
		var yplus = 0;
		while(place_collide(fVelX,-yplus) && yplus <= yplusMax && grounded2)
		{
			yplus++;
			if(isSpeedBoosting)
			{
				scr_BreakBlock(x,y-max(yplus,3),5);
				scr_BreakBlock(x+fVelX,y-max(yplus,3),5);
			}
			if(isScrewAttacking)
			{
				scr_BreakBlock(x,y-max(yplus,3),6);
				scr_BreakBlock(x+fVelX,y-max(yplus,3),6);
			}
		}
		
		var xnum = 0;
		while(!place_collide(xnum*sign(fVelX),0) && xnum <= xspeed)
		{
			xnum++;
		}
		
		var walkUpSlope = (!place_collide(xnum*sign(fVelX),-3) && (velY >= 0 || jumping || ((state == State.Spark || state == State.BallSpark) && abs(shineDir) == 1) || state == State.Dodge));
		
		if(place_collide(fVelX,-yplus) || !walkUpSlope || (state == State.Grip && stateFrame != State.Morph) || !grounded2)
		{
			if(fVelX > 0)
			{
				x = scr_floor(x);
			}
			if(fVelX < 0)
			{
				x = scr_ceil(x);
			}
			var xnum2 = xspeed+2;
			while(!place_collide(sign(fVelX),0) && xnum2 > 0)
			{
				x += sign(fVelX);
				xnum2--;
			}
			
			if(!speedBoost || speedCounter <= 0)
			{
				velX = 0;
			}
			else if(!speedBoostWJ)//if(state != State.Somersault)
			{
				speedCounter = max(speedCounter-(speedCounterMax/5),0);
			}
			else if(speedBoost && speedBoostWJ)
			{
				speedCounter = speedCounterMax;
			}
			fVelX = 0;
			if(place_collide(move,-yplus) || (!walkUpSlope && place_collide(move,-3)))
			{
				move = 0;
			}
			bombJumpX = 0;
			if((state == State.Spark || state == State.BallSpark) && shineStart <= 0)
			{
				if(boots[Boots.ChainSpark])
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
		}
		else if(grounded2)
		{
			if((state == State.Spark || state == State.BallSpark) && abs(shineDir) == 2 && shineStart <= 0)
			{
				shineEnd = 0;
				shineDir = 0;
				if(state == State.BallSpark)
				{
					state = State.Morph;
					mockBall = true;
				}
				else
				{
					stateFrame = State.Stand;
					mask_index = mask_Stand;
					for(var i = 3+yplus; i > 0; i--)
					{
						if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
						{
							y -= 1;
						}
					}
					state = State.Stand;
				}
				speedFXCounter = 1;
				speedCounter = speedCounterMax;
				speedCatchCounter = 6;
				audio_stop_sound(snd_ShineSpark);
			}
			//y -= yplus;
			y = scr_round(y - yplus);
		}
	}
	else if(!place_collide(0,0) && (!spiderBall || spiderEdge == Edge.None))
	{
		if(isSpeedBoosting)
		{
			scr_BreakBlock(x+fVelX,y+min(abs(fVelX),4),5);
		}
		if(isScrewAttacking)
		{
			scr_BreakBlock(x+fVelX,y+min(abs(fVelX),4),6);
		}
		
		var xnum3 = 0;
		while(place_collide(xnum3*sign(fVelX),1) && xnum3 <= xspeed)
		{
			xnum3++;
		}
		
		var walkDownSlope = (place_collide(xnum3*sign(fVelX),4));
		
		if(walkDownSlope && /*state != State.Grip &&*/ state != State.Spark && state != State.BallSpark && grounded3 && ballBounce <= 0 && velY >= 0 && velY <= fGrav && jump <= 0 && bombJump <= 0)
		{
			var yplus2 = 0;
			while(!place_collide(fVelX,1+yplus2) && yplus2 <= yplusMax)
			{
				yplus2++;
			}
			
			if(isSpeedBoosting)
			{
				scr_BreakBlock(x+fVelX,y+yplus2+1,5);
			}
			if(isScrewAttacking)
			{
				scr_BreakBlock(x+fVelX,y+yplus2+1,6);
			}
			
			if(!place_collide(fVelX,yplus2))
			{
				if(place_collide(fVelX,yplus2+1) && jump <= 0)
				{
					//y += yplus2;
					y = scr_round(y + yplus2);
					downHill = true;
				}
			}
		}
	}
	
	if(dir != 0 && /*state != State.Grip &&*/ (!spiderBall || spiderEdge == Edge.None) && state != State.Elevator && state != State.Recharge)
	{
		x += fVelX;
	}
	else
	{
		velX = 0;
		fVelX = 0;
	}
	
	/*if(state == State.Morph)
	{
		if(spiderBall && spiderEdge != Edge.None)
		{
			fellVel = 0;
		}
		else
		{
			fellVel = min(abs(velX),3);
		}
	}
	else if(place_meeting(x,y+fVelY+1,obj_CrumbleBlock))
	{
		fellVel = 1;
	}
	else
	{
		fellVel = 4;
	}*/
	fellVel = 1;
	fVelY = velY;
	var shouldForceDown = (state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge);
	if((place_collide(0,fVelY+fellVel) || (bbox_bottom+fVelY+fellVel) >= room_height) && fVelY >= 0 && jump <= 0 && bombJump <= 0 && ballBounce <= 0)
	{
		justFell = shouldForceDown;
	}
	else if(!grounded)
	{
		if(justFell && ledgeFall && fVelY >= 0 && fVelY <= fGrav)
		{
			fVelY += fellVel;
		}
		justFell = false;
	}
	
	if(state == State.Grapple)
	{
		fVelY += grappleVelY;
	}
	
	if(state == State.Hurt)
	{
		fVelY = hurtSpeedY;
	}
	
	if(isSpeedBoosting)
	{
		scr_BreakBlock(x,y+fVelY,5);
	}
	if(isScrewAttacking)
	{
		scr_BreakBlock(x,y+fVelY,6);
	}
	
	// Y Collision
	var colB = collision_line(bbox_left,bbox_bottom+fVelY,bbox_right,bbox_bottom+fVelY,obj_Tile,true,true),
		colT = collision_line(bbox_left,bbox_top+fVelY,bbox_right,bbox_top+fVelY,obj_Tile,true,true);
	if(place_collide(0,max(abs(fVelY),1)*sign(fVelY)) && (!place_collide(0,0) || (fVelY > 0 && colB) || (fVelY < 0 && colT)))
	{
		if(fVelY > 0)
		{
			y = scr_floor(y);
		}
		if(fVelY < 0)
		{
			y = scr_ceil(y);
		}
		var yspeed = abs(fVelY)+2;
		while(!place_collide(0,sign(fVelY)) && yspeed > 0)
		{
			y += sign(fVelY);
			yspeed--;
		}
		if((state == State.Spark || state == State.BallSpark) && shineStart <= 0)
		{
			if((abs(shineDir) == 2 || abs(shineDir) == 3) && fVelY >= 0 && !place_collide(fVelX,0))
			{
				shineEnd = 0;
				shineDir = 0;
				if(state == State.BallSpark)
				{
					state = State.Morph;
					mockBall = true;
				}
				else
				{
					stateFrame = State.Stand;
					mask_index = mask_Stand;
					for(var i = 3; i > 0; i--)
					{
						if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
						{
							y -= 1;
						}
					}
					state = State.Stand;
				}
				speedFXCounter = 0;
				speedCounter = speedCounterMax;
				speedCatchCounter = 6;
				audio_stop_sound(snd_ShineSpark);
			}
			else
			{
				if(shineEnd <= 0)
				{
					audio_play_sound(snd_Hurt,0,false);
				}
				shineEnd = shineEndMax;
			}
		}
		fVelY = 0;
		velY = 0;
		//jump = 0;
	}
	
	// Platform Collision
	if(place_meeting(x,y+max(abs(fVelY),1)*sign(fVelY),obj_Platform) && !place_meeting(x,y,obj_Platform) && fVelY >= 0 && state != State.Spark && state != State.BallSpark)
	{
		if(fVelY > 0)
		{
			y = scr_floor(y);
		}
		var yspeed = abs(fVelY)+2;
		while(!place_meeting(x,y+sign(fVelY),obj_Platform) && yspeed > 0)
		{
			y += sign(fVelY);
			yspeed--;
		}
		
		fVelY = 0;
		velY = 0;
		jump = 0;
	}
	
	if(state != State.Grip && (!spiderBall || spiderEdge == Edge.None) && state != State.Elevator && state != State.Recharge)
	{
		y += fVelY;
	}
	else
	{
		velY = 0;
		fVelY = 0;
	}
	
	if(state != State.Elevator)
	{
		//x = clamp(x,x-bbox_left,room_width-(bbox_right-x));
		//y = clamp(y,y-bbox_top,room_height-(bbox_bottom-y));
		x = clamp(x,0,room_width);
		y = clamp(y,0,room_height);
	}
	
	if((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineEnd <= 0 && 
	//(bbox_left <= 0 || bbox_right >= room_width || bbox_top <= 0 || bbox_bottom >= room_height))
	(x <= 0 || x >= room_width || y <= 0 || y >= room_height))
	{
		//if((bbox_left <= 0 || bbox_right >= room_width) && boots[Boots.ChainSpark])
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
	
	//if(bbox_top+fVelY < 0)
	if(y+fVelY < 0)
	{
		fVelY = 0;
		velY = 0;
		jump = 0;
	}
#endregion
	
	// Update grounded variables
	//grounded = PlayerGrounded();
	grounded = PlayerGrounded(2);
	onPlatform = PlayerOnPlatform();
	
	move2 = cRight - cLeft;
	
// ----- Grip Collision -----
#region Grip Collision
	var colSpeed = (isSpeedBoosting && (place_meeting(x+move2,y,obj_ShotBlock) || place_meeting(x+move2,y,obj_BombBlock) || place_meeting(x+move2,y,obj_SpeedBlock))),
		colScrew = (isScrewAttacking && (place_meeting(x+move2,y,obj_ShotBlock) || place_meeting(x+move2,y,obj_BombBlock) || place_meeting(x+move2,y,obj_ScrewBlock)));
	if(misc[Misc.PowerGrip] && (state == State.Jump || state == State.Somersault) && morphFrame <= 0 && !grounded && abs(dirFrame) >= 4 && fVelY >= 0 && !colSpeed && !colScrew)
	{
		if(!place_collide(0,-4) && ((state == State.Jump && !place_collide(0,3)) || (state == State.Somersault && !place_collide(0,11))))//19))
		{
			var colSlope = collision_line(x+6*move2,y-22,x+10*move2,y-22,obj_Slope,true,true);
			if(position_collide(6*move2,-17) && !collision_line(x+6*move2,y-22,x+6*move2,y-26,obj_Tile,true,true) && 
			(!colSlope || (colSlope.image_yscale <= 1 && sign(colSlope.image_xscale) == -dir)) && place_collide(move2,0) && dir == move2)
			{
				var colLine = collision_line(x,bbox_top,x+16*move2,bbox_top,obj_Tile,true,true);
				if(colLine == colSlope && sign(colSlope.image_xscale) == -dir)
				{
					y = colLine.bbox_bottom+17;
				}
				else
				{
					y = colLine.bbox_top+17;
				}
				
				for(var i = 10; i > 0; i--)
				{
					if(position_collide(6*move2,-18))
					{
						y -= 1;
					}
				}
				
				audio_play_sound(snd_Grip,0,false);
				jump = 0;
				fVelY = 0;
				velY = 0;
				
				stateFrame = State.Grip;
				mask_index = mask_Jump;
				for(var i = 9; i > 0; i--)
				{
					if(place_collide(0,0) && !position_collide(0,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				state = State.Grip;
				dir = move2;
			}
		}
	}
#endregion
	
// ----- Quick Climb -----
#region Quick Climb
	if(global.quickClimb && state != State.Grip && state != State.Morph && morphFrame <= 0 && grounded && abs(dirFrame) >= 4 && place_collide(move2,0))
	{
		quickClimbHeight = 0;
		
		if(state == State.Stand)
		{
			var tile0 = collide_rect(x, (bbox_top+17)-4, x+6*dir, (bbox_bottom-11)-4),
				tile1 = collide_rect(x, (bbox_top+17)-6, x+6*dir, (bbox_bottom-11)-7),
				
				tile2 = collide_rect(x, (bbox_top+17)-20, x+6*dir, (bbox_bottom-11)-20),
				tile3 = collide_rect(x, (bbox_top+17)-22, x+6*dir, (bbox_bottom-11)-23),
				
				tile4 = collide_rect(x, (bbox_top+17)-36, x+6*dir, (bbox_bottom-11)-36),
				tile5 = collide_rect(x, (bbox_top+17)-38, x+6*dir, (bbox_bottom-11)-39);
			
			if(tile0 && !tile1)
			{
				quickClimbHeight = 1;
			}
			else if(tile2 && !tile3)
			{
				quickClimbHeight = 2;
			}
			else if(tile4 && !tile5)
			{
				quickClimbHeight = 3;
			}
		}
		else if(state == State.Crouch && crouchFrame <= 0)// && !uncrouching)
		{
			var tile0 = collide_rect(x, (bbox_top+17)-15, x+6*dir, bbox_bottom-15),
				tile1 = collide_rect(x, (bbox_top+17)-17, x+6*dir, bbox_bottom-18),
				
				tile2 = collide_rect(x, (bbox_top+17)-31, x+6*dir, bbox_bottom-31),
				tile3 = collide_rect(x, (bbox_top+17)-33, x+6*dir, bbox_bottom-34);
			
			if(tile0 && !tile1)
			{
				quickClimbHeight = 1;
			}
			else if(tile2 && !tile3)
			{
				quickClimbHeight = 2;
			}
		}
		
		quickClimbTarget = 0;
		if(quickClimbHeight > 0)
		{
			var ch = quickClimbHeight*16,
				slopeOffset = 0,
				slopeCol = collision_rectangle(x+6*dir,y+11-ch,x+14*dir,y+25-ch,obj_Slope,true,true);
			if(slopeCol != noone && slopeCol.image_yscale > 0 && slopeCol.image_yscale <= 1)
			{
				slopeOffset = -16;
			}
			var crOffset = 0;
			if(state == State.Stand)
			{
				crOffset = 11;
			}
			if(!collide_rect(bbox_left+13*dir,(bbox_top+17+crOffset)+slopeOffset-ch,bbox_right+13*dir,bbox_bottom+slopeOffset-ch))
			{
				if(!collide_rect(bbox_left+13*dir,(bbox_top+crOffset)+slopeOffset-ch,bbox_right+13*dir,bbox_bottom+slopeOffset-ch))
				{
					quickClimbTarget = 2;
				}
				else if(misc[Misc.Morph])
				{
					quickClimbTarget = 1;
				}
			}
			
			if(quickClimbTarget > 0 && move2 == dir && cJump && rJump)
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
				if(quickClimbHeight == 3)
				{
					y -= 5;
				}
				if(quickClimbHeight == 2)
				{
					if(state != State.Crouch)
					{
						y -= 1;
						climbIndex = 4;
						climbFrame = 2;
					}
				}
				if(quickClimbHeight == 1)
				{
					if(state == State.Crouch)
					{
						y -= 1;
						climbIndex = 5;
						climbFrame = 3;
					}
					else
					{
						y -= 1;
						x += 1*dir;
						climbIndex = 7;
						climbFrame = 5;
					}
				}
				climbTarget = quickClimbTarget;
				
				state = State.Grip;
				dir = move2;
			}
		}
	}
	else
	{
		quickClimbTarget = 0;
		quickClimbHeight = 0;
	}
#endregion

// ----- States -----
#region Stand, Walk, Run, Dash, Brake
	if(state == State.Stand)
	{
		stateFrame = State.Stand;
		mask_index = mask_Stand;
		
		if(crouchFrame >= 5)
		{
			if(brake)
			{
				stateFrame = State.Brake;
			}
			else if((velX != 0 || move != 0) && landFrame <= 0 && !xRayActive)
			{
				if(walkState || (cAimLock && sign(velX) != dir))
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
			stateFrame = State.Crouch;
			mask_index = mask_Crouch;
			for(var i = 11; i > 0; i--)
			{
				if(!place_collide(0,1) && (!onPlatform || !place_meeting(x,y+1,obj_Platform)))
				{
					y += 1;
				}
			}
			//uncrouching = false;
			crouchFrame = 5;
			state = State.Crouch;
		}
		if(!grounded && dir != 0)
		{
			stateFrame = State.Jump;
			mask_index = mask_Jump;
			if(ledgeFall)
			{
				for(var i = 3; i > 0; i--)
				{
					if(!place_collide(0,1) && (!onPlatform || !place_meeting(x,y+1,obj_Platform)))
					{
						y += 1;
					}
				}
			}
			state = State.Jump;
		}
	}
	else
	{
		brake = false;
		brakeFrame = 0;
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
		//if(!instance_exists(obj_Elevator) || obj_Elevator.activeDir == 0)
		/*if(!instance_exists(obj_SaveStation) || obj_SaveStation.saving <= 0)
		{
			state = State.Stand;
		}*/
		
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
		if(move2 != 0 && !place_collide(0,-11))
		{
			uncrouch += 1;
		}
		else
		{
			uncrouch = 0;
		}
		if(((cUp && rUp && (gbaAimPreAngle == gbaAimAngle || global.aimStyle != 1)) || uncrouch >= 7) && !place_collide(0,-11) && crouchFrame <= 0 /*&& !uncrouching*/ && !xRayActive)
		{
			//uncrouching = true;
			aimUpDelay = 10;
		/*}
		if(place_collide(0,-11))
		{
			uncrouching = false;
		}
		if(uncrouching && crouchFrame >= 5)
		{*/
			stateFrame = State.Stand;
			mask_index = mask_Stand;
			for(var i = 11; i > 0; i--)
			{
				if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
				{
					y -= 1;
				}
			}
			state = State.Stand;
		}
		if(crouchFrame <= 0 && cDown && (gbaAimAngle == gbaAimPreAngle || global.aimStyle != 1) && (rDown || place_collide(0,-11)) && move2 == 0 && misc[Misc.Morph] && !xRayActive && stateFrame != State.Morph && morphFrame <= 0)
		{
			stateFrame = State.Morph;
			mask_index = mask_Morph;
			audio_play_sound(snd_Morph,0,false);
			state = State.Morph;
			morphFrame = 8;
		}
		if(!grounded && !place_collide(0,5) && (!onPlatform || !place_meeting(x,y+5,obj_Platform)))
		{
			stateFrame = State.Jump;
			mask_index = mask_Jump;
			for(var i = 8; i > 0; i--)
			{
				if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
				{
					y -= 1;
				}
			}
			state = State.Jump;
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
			if(morphFrame <= 0 && shineRampFix <= 0 && (!cJump || !rMorphJump))
			{
				if(!spiderBall)
				{
					//if(!instance_exists(obj_Liquid) || bbox_bottom <= obj_Liquid.y+3)
					//{
						audio_stop_sound(snd_Land);
						audio_play_sound(snd_Land,0,false);
					//}
				}
				if(liquidMovement)
				{
					velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
				}
				//velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
				//speedCounter = 0;
			}
			else
			{
				if(abs(velX) > maxSpeed[5,liquidState])
				{
					mockBall = true;
				}
			}
		}
		
		if(((cUp && rUp) || (cJump && rJump && (!misc[Misc.Spring] || morphSpinJump)) || (cMorph && rMorph)) && !place_collide(0,-17) && !unmorphing && morphFrame <= 0 && !spiderBall)
		{
			audio_play_sound(snd_Morph,0,false);
			unmorphing = true;
			morphFrame = 8;
			aimUpDelay = 10;
		}
		if(unmorphing)
		{
			mask_index = mask_Crouch;
			aimUpDelay = 10;
			if(morphFrame <= 0)
			{
				if(morphSpinJump)
				{
					stateFrame = State.Somersault;
					state = State.Somersault;
					frame[6] = 2;
					morphSpinJump = false;
				}
				else
				{
					stateFrame = State.Crouch;
					state = State.Crouch;
					crouchFrame = 0;
					if(velX != 0)
					{
						uncrouch = 7;
						//velX = min(abs(velX),maxSpeed[0,liquidState])*sign(velX);
						//speedCounter = 0;
					}
				}
			}
		}
		
		if(misc[Misc.Spider] && bombJump <= 0)
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

	        if(spiderBall)
	        {
	            SpiderBall();
	        }
	        else
	        {
	            spiderEdge = Edge.None;
	            spiderMove = 0;
	            spiderSpeed = 0;
	            audio_stop_sound(snd_SpiderLoop);
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
	}
	else
	{
		ballBounce = 0;
		unmorphing = false;
		mockBall = false;
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
		mask_index = mask_Jump;
		
		var colSpeed = (isSpeedBoosting && (place_meeting(x-8*move,y,obj_ShotBlock) || place_meeting(x-8*move,y,obj_BombBlock) || place_meeting(x-8*move,y,obj_SpeedBlock)));
		canWallJump = (((place_collide(-8*move,0) && place_collide(-8*move,8)) || (place_meeting(x-8*move,y,obj_Platform) && place_meeting(x-8*move,y+8,obj_Platform))) && !collision_line(x-4*move,y+9,x-4*move,y+25,obj_Tile,true,true) && wallJumpDelay <= 0 && move != 0 && !colSpeed);
		wallJumpDelay = max(wallJumpDelay - 1, 0);
		if(grounded)
		{
			if(liquidMovement)
			{
				velX = min(abs(velX)*0.5,maxSpeed[0,liquidState]*0.25)*sign(velX);
			}
			//velX = 0;
			//speedCounter = 0;
			audio_play_sound(snd_Land,0,false);
			if(place_collide(0,-3) && !place_collide(0,0))
			{
				stateFrame = State.Crouch;
				mask_index = mask_Crouch;
				for(var i = 8; i > 0; i--)
				{
					if(!place_collide(0,1) && (!onPlatform || !place_meeting(x,y+1,obj_Platform)))
					{
						y += 1;
					}
				}
				//uncrouching = false;
				crouchFrame = 5;
				state = State.Crouch;
			}
			else
			{
				stateFrame = State.Stand;
				mask_index = mask_Stand;
				for(var i = 3; i > 0; i--)
				{
					if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				if(smallLand)
				{
					landFrame = 6;
				}
				else
				{
					landFrame = 9;
				}
				state = State.Stand;
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
			
			somerUWSndCounter--;
			/*if(oldDir != dir)
			{
				somerUWSndCounter = 33;
			}*/
			if(somerUWSndCounter < 0)
			{
				audio_play_sound(snd_Somersault_Loop,0,false);
				somerUWSndCounter = 33;
			}
		}
		
		var colSpeed = (isSpeedBoosting && (place_meeting(x-8*move,y,obj_ShotBlock) || place_meeting(x-8*move,y,obj_BombBlock) || place_meeting(x-8*move,y,obj_SpeedBlock))),
			colScrew = (isScrewAttacking && (place_meeting(x-8*move,y,obj_ShotBlock) || place_meeting(x-8*move,y,obj_BombBlock) || place_meeting(x-8*move,y,obj_ScrewBlock)));
		
		canWallJump = (((place_collide(-8*move,0) && place_collide(-8*move,8)) || (place_meeting(x-8*move,y,obj_Platform) && place_meeting(x-8*move,y+8,obj_Platform))) && !place_collide(0,16) && wallJumpDelay <= 0 && move != 0 && !colSpeed && !colScrew);
		
		wallJumpDelay = max(wallJumpDelay - 1, 0);
		if(velX < maxSpeed[3,liquidState] && velX > 0 && dir == 1)
		{
			velX = maxSpeed[3,liquidState];
		}
		else if(velX > -maxSpeed[3,liquidState] && velX < 0 && dir == -1)
		{
			velX = -maxSpeed[3,liquidState];
		}
		
		if(grounded)
		{
			if(liquidMovement)
			{
				velX = min(abs(velX)*0.5,maxSpeed[0,liquidState]*0.25)*sign(velX);
			}
			//velX = 0;
			//speedCounter = 0;
			audio_play_sound(snd_Land,0,false);
			if(place_collide(0,-11))
			{
				stateFrame = State.Crouch;
				state = State.Crouch;
				crouchFrame = 0;
			}
			else
			{
				stateFrame = State.Stand;
				mask_index = mask_Stand;
				for(var i = 11; i > 0; i--)
				{
					if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				state = State.Stand;
				landFrame = 7;
				smallLand = false;
			}
		}
		else
		{
			landFrame = 0;
			var unchargeable = ((itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3)) || xRayActive);
			if(prAngle || (cUp && rUp) || (cDown && rDown) || (cShoot && rShoot) || (!cShoot && !rShoot && !unchargeable))
			{
				stateFrame = State.Jump;
				mask_index = mask_Jump;
				for(var i = 9; i > 0; i--)
				{
					if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				state = State.Jump;
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
		canWallJump = (move2 != 0 && move2 != dir);
		velX = 0;
		velY = 0;
		
		if(startClimb)
		{
			if(climbIndex > 0)
			{
				var cX = climbX[climbIndex] / (1+liquidMovement) * dir,
					cY = climbY[climbIndex] / (1+liquidMovement);
				y -= cY;
				x += cX;
				
				if(climbIndex >= 8 && move == dir)
				{
					velX += max((1+(stateFrame == State.Morph)) / (1+liquidMovement) - abs(cX),0)*move;
				}
				
				var cynum = 2;
				if(stateFrame == State.Morph)
				{
					cynum = 2+abs(velX)+abs(cX);
				}
				for(var i = cynum; i > 0; i--)
				{
					if(climbIndex > 8 && place_collide(0,0) && !position_collide(5*dir,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				
				for(var i = 8; i > 0; i--)
				{
					if(climbIndex > 8 && !place_collide(0,1))
					{
						y += 1;
					}
				}
				
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
						/*stateFrame = State.Crouch;
						if(!place_collide(0,-11))
						{
							uncrouching = true;
							aimUpDelay = 10;
						}
						state = State.Crouch;*/
						if(!place_collide(0,-11))
						{
							stateFrame = State.Stand;
							mask_index = mask_Stand;
							for(var i = 11; i > 0; i--)
							{
								if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
								{
									y -= 1;
								}
							}
							state = State.Stand;
							//landFrame = 7;
							//smallLand = false;
							crouchFrame = 2;
						}
						else
						{
							stateFrame = State.Crouch;
							state = State.Crouch;
							crouchFrame = 0;
						}
					}
				}
				else if(climbIndex > 9)//17)
				{
					state = State.Morph;
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
			climbTarget = 0;
			slopeOffset = 0;
			var slopeCol = collision_rectangle(x+6*dir,y-32,x+19*dir,y-18,obj_Slope,true,true);
			if(slopeCol != noone && slopeCol.image_yscale > 0 && slopeCol.image_yscale <= 1)
			{
				slopeOffset = -16;
			}
			if(!collision_rectangle(x+6*dir,y-30+slopeOffset,x+19*dir,y-18+slopeOffset,obj_Tile,true,true))
			{
				if(!collision_rectangle(x+6*dir,y-46+slopeOffset,x+19*dir,y-34+slopeOffset,obj_Tile,true,true))
				{
					climbTarget = 2;
				}
				else if(misc[Misc.Morph])
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
		}
		var sCol = collision_point(x+6*dir,y-18,obj_Slope,true,true),
			tCol = collision_point(x+6*dir,y-18,obj_Slope,true,true);
		if(sCol != noone && ((sCol.image_yscale > 0 && sCol.image_yscale <= 1) || sCol.image_yscale <= -0.5))
		{
			tCol = noone;
		}
		if((!place_collide(2*dir,0) && !place_collide(2*dir,8)) || (tCol != noone && !startClimb) || (cDown && cJump && rJump))
		{
			if(stateFrame == State.Morph)
			{
				state = State.Morph;
			}
			else
			{
				stateFrame = State.Jump;
				mask_index = mask_Jump;
				for(var i = 9; i > 0; i--)
				{
					if(place_collide(0,0) && !position_collide(0,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				state = State.Jump;
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
		
		var aUp = (cAngleUp && (global.aimStyle != 1 || gbaAimAngle == 1) && global.aimStyle != 2),
			aDown = (cAngleDown || (cAngleUp && global.aimStyle == 1 && gbaAimAngle == -1));
		
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
			if((place_collide(0,4) || (onPlatform && place_meeting(x,y+4,obj_Platform))) && (!place_collide(0,-1) || place_collide(0,0)))
			{
				y -= 1;
			}
			velX = 0;
			velY = 0;
			shineCharge = 0;
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
			if(cDash && canDodge)
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
			
			/*
			var moveY = (cDown-cUp);
			moveY = clamp(moveY+(aDown-aUp),-1,1);
			var shineAng = 90;
			if(shineDir == 0)
			{
				shineAng -= 12.25*move2;
				velX = lengthdir_x(shineSparkSpeed,shineAng);
				velY = lengthdir_y(shineSparkSpeed,shineAng);
			}
			shineAng = 45;
			if(abs(shineDir) == 1)
			{
				shineAng -= 12.25*clamp(move2*sign(shineDir)+moveY,-1,1);
				velX = lengthdir_x(shineSparkSpeed*sign(shineDir),shineAng);
				velY = lengthdir_y(shineSparkSpeed,shineAng);
			}
			shineAng = 0;
			if(abs(shineDir) == 2)
			{
				shineAng -= 12.25*moveY;
				velX = lengthdir_x(shineSparkSpeed*sign(shineDir),shineAng);
				velY = lengthdir_y(shineSparkSpeed,shineAng);
			}
			shineAng = -45;
			if(abs(shineDir) == 3)
			{
				shineAng -= 12.25*clamp(-move2*sign(shineDir)+moveY,-1,1);
				velX = lengthdir_x(shineSparkSpeed*sign(shineDir),shineAng);
				velY = lengthdir_y(shineSparkSpeed,shineAng);
			}
			shineAng = -90;
			if(shineDir == 4)
			{
				shineAng += 12.25*move2;
				velX = lengthdir_x(shineSparkSpeed,shineAng);
				velY = lengthdir_y(shineSparkSpeed,shineAng);
			}
			*/
			
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
			velX = lengthdir_x(shineSpeedX,shineAng);
			velY = lengthdir_y(shineSparkSpeed,shineAng);
        
			if(cJump && rJump)
			{
				if(state == State.BallSpark)
				{
					state = State.Morph;
				}
				else
				{
					stateFrame = State.Somersault;
					mask_index = mask_Crouch;
					state = State.Somersault;
				}
				if(abs(shineDir) == 2)
				{
					if(boots[Boots.SpaceJump])
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
		drawAfterImage = true;
		afterImageNum = 10*shineFXCounter;
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
			var signx = sign(x - xprevious);
			if(signx != 0)
			{
				dir = signx;
				dirFrame = 4*dir;
			}
		}
		else
		{
			if(abs(x - grapple.x) > 11 && abs(x - grapple.x) < 25 && ((place_collide(10,0) && x < grapple.x) || (place_collide(-10,0) && x > grapple.x)) && (grapAngle <= 45 || grapAngle >= 315) && grappleDist <= 47)
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
			    x = grapple.x + lengthdir_x(grappleDist, grapAngle - 90);
			    y = grapple.y + lengthdir_y(grappleDist, grapAngle - 90);

			    dirFrame = 4*dir;
			    canWallJump = (move != -dir);//place_collide(-10*move,0);
			    if(cShoot)
			    {
			        grapWJCounter = 60;
			    }
			}
			else
			{
			    canWallJump = false;
			    grapWJCounter = 0;
				
				if(abs(velX) <= 0.0025 && place_collide(dir,0) && ((dir == 1 && x < grapple.x) || (dir == -1 && x > grapple.x)) && (grapAngle < 25 || grapAngle > 335) && grappleDist > 43)
			    {
			        if(cJump && rJump)
			        {
			            if(place_collide(1,0))
			            {
			                velX = -maxSpeed[1,liquidState];
			            }
			            if(place_collide(-1,0))
			            {
			                velX = maxSpeed[1,liquidState];
			            }
			            audio_play_sound(snd_WallJump,0,false);
			            grapWallBounceFrame = 15;
			        }
			    }
				
				grapAngle = point_direction(x, y, grapple.x, grapple.y) - 90;
				
				if(!speedBoost)
				{
					var angleGrav = fGrav*1.75 * dcos(grapAngle+90);
					velX += lengthdir_x(fMoveSpeed/(2-liquidMovement) * move + angleGrav,grapAngle);
					velY += lengthdir_y(fMoveSpeed/(2-liquidMovement) * move + angleGrav,grapAngle);
					velX *= (0.99 + 0.007*liquidMovement);
					velY *= (0.99 + 0.007*liquidMovement);
				}
				else
				{
					var grapAngVel = angle_difference(point_direction(x+velX,y+velY,grapple.x,grapple.y),point_direction(x,y,grapple.x,grapple.y));
					
					if(point_distance(x,y,xprevious,yprevious) >= minBoostSpeed*0.75)
					{
						if(point_distance(x,y,xprevious,yprevious) < maxSpeed[2,liquidState])
						{
							velX += lengthdir_x(fMoveSpeed*sign(grapAngVel),grapAngle);
							velY += lengthdir_y(fMoveSpeed*sign(grapAngVel),grapAngle);
						}
					}
					else
					{
						speedBoost = false;
						speedCounter = 0;
					}
				}
	
				var vX = x - grapple.x,
					vY = y - grapple.y;
				var dist = point_distance(x,y,grapple.x,grapple.y);
				var up = (cUp), down = (cDown && grappleDist < grappleMaxDist);
				if(global.grappleStyle == 1 && move != 0)
				{
					up = false;
					down = false;
				}
				var reelSpeed = 6 / (1+liquidMovement);
	
				var reel = 0;
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
				var ndist = point_distance(x+velX,y+velY,grapple.x,grapple.y);
				var ddist = ndist - dist;
				vX /= dist;
				vY /= dist;
				velX -= vX * ddist;
				velY -= vY * ddist;
				vX *= (grappleDist + reel);
				vY *= (grappleDist + reel);
				grappleVelX = (grapple.x + vX) - x;
				grappleVelY = (grapple.y + vY) - y;
	
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
		
		grapAngle = 0;
		grappleVelX = 0;
		grappleVelY = 0;
		grappleDist = 0;
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
			state = lastState;
		}
		else
		{
			dmgBoost = 5;
			velX = 0;
			velY = 0;
			if(move2 == dir)
			{
				hurtTime = max(hurtTime - 1, 0);
			}
			hurtTime = max(hurtTime - 1, 0);
		}
	}
	else
	{
		hurtTime = 0;
		hurtSpeedX = 0;
		hurtSpeedY = 0;
		hurtFrame = 0;
	}
	
	if(state == State.Hurt || state == State.Jump || state == State.Somersault)
	{
		if(dmgBoost > 0 && stateFrame != State.Morph && cJump && move2 == -dir)
		{
			stateFrame = State.DmgBoost;
			mask_index = mask_Jump;
			for(var i = 11; i > 0; i--)
			{
				if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
				{
					y -= 1;
				}
			}
			state = State.DmgBoost;
			dmgBoost = 0;
		}
	}
	else
	{
		dmgBoost = max(dmgBoost - 1, 0);
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
		if(cJump && move2 == -dir && !grounded)
		{
			velX = maxSpeed[9,liquidState]*move2;
			if(!dmgBoostJump)
			{
				velY = -fJumpSpeed;
				
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
				velX = 0;
				speedCounter = 0;
				audio_play_sound(snd_Land,0,false);
				if(place_collide(0,-3) && !place_collide(0,0))
				{
					stateFrame = State.Crouch;
					mask_index = mask_Crouch;
					for(var i = 8; i > 0; i--)
					{
						if(!place_collide(0,1) && (!onPlatform || !place_meeting(x,y+1,obj_Platform)))
						{
							y += 1;
						}
					}
					//uncrouching = false;
					crouchFrame = 3;
					state = State.Crouch;
				}
				else
				{
					stateFrame = State.Stand;
					mask_index = mask_Stand;
					for(var i = 3; i > 0; i--)
					{
						if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
						{
							y -= 1;
						}
					}
					if(smallLand)
					{
						landFrame = 6;
					}
					else
					{
						landFrame = 9;
					}
					state = State.Stand;
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
	if(boots[Boots.Dodge] && (state == State.Stand || state == State.Crouch || state == State.Jump || state == State.Somersault || state == State.Grip))
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
				mask_index = mask_Crouch;
				if(groundedDodge = 1)
				{
					for(var i = 11; i > 0; i--)
					{
						if(!place_collide(0,1) && (!onPlatform || !place_meeting(x,y+1,obj_Platform)))
						{
							y += 1;
						}
					}
				}
				if(state == State.Grip && gripGunReady)
				{
					dir = -dir;
					move2 = dir;
				}
				state = State.Dodge;
				stateFrame = State.Dodge;
				/*if(groundedDodge > 0)
				{
					velY = -jumpSpeed[4,liquidState];
				
					grounded = false;
				}
				else
				{
					velY *= 0.1;
				}*/
				velY = 0;
				if(move2 == dir)
				{
					dodgeDir = dir;
					//speedCounter = max(speedCounter,65);
				}
				else
				{
					dodgeDir = -dir;
				}
				
				/*if(!speedBoost)
				{
					speedCounter = 0;
				}*/
				
				//audio_stop_sound(snd_Somersault);
				//audio_stop_sound(snd_Somersault_SJ);
				//audio_stop_sound(snd_Somersault_Loop);
				//somerSoundPlayed = false;
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
		if(dodgeLength < dodgeLengthMax)// && !grounded)
		{
			//if(!dodged)
			if(dodgeLength < dodgeLengthMax-5)
			{
				velX = max(maxSpeed[10,liquidState],abs(velX))*dodgeDir;
				//dodged = true;
			}
			dodgeLength += 1 / (1+liquidMovement);
			var unchargeable = ((itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3)) || xRayActive);
			if((cShoot && rShoot) || (!cShoot && !rShoot && !unchargeable))
			{
				dodgeLength = max(dodgeLength, dodgeLengthMax);
			}
			
			/*if(!audio_is_playing(snd_Charge) && !audio_is_playing(snd_Charge_Loop))
			{
				if(!audio_is_playing(snd_Somersault_Loop))
				{
					audio_play_sound(snd_Somersault_Loop,0,true);
				}
			}
			else
			{
				audio_stop_sound(snd_Somersault_Loop);
			}*/
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
		else
		{
			audio_stop_sound(snd_Somersault_Loop);
			if(grounded)
			{
				//velX = 0;
				//speedCounter = 0;
				//audio_play_sound(snd_Land,0,false);
				if(place_collide(0,-11) || groundedDodge == 2)
				{
					stateFrame = State.Crouch;
					state = State.Crouch;
					crouchFrame = 0;
				}
				else
				{
					stateFrame = State.Stand;
					mask_index = mask_Stand;
					for(var i = 11; i > 0; i--)
					{
						if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
						{
							y -= 1;
						}
					}
					state = State.Stand;
					if(dodgeDir == dir)
					{
						landFrame = 7;
						smallLand = false;
					}
					else
					{
						landFrame = 6;
						smallLand = true;
					}
				}
			}
			/*else if(dodgeDir != dir)
			{
				stateFrame = State.Jump;
				mask_index = mask_Jump;
				for(var i = 9; i > 0; i--)
				{
					if((place_collide(0,0) || (onPlatform && place_meeting(x,y,obj_Platform))) && !position_collide(0,bbox_top-y-1))
					{
						y -= 1;
					}
				}
				state = State.Jump;
			}*/
			else
			{
				state = State.Somersault;
			}
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
	
	if(state != prevState)
	{
		lastState = prevState;
	}
	
	dmgBoost = max(dmgBoost - 1, 0);
	
	aimUpDelay = max(aimUpDelay - 1, 0);
	ballBounce = max(ballBounce - 1, 0);
	
	shineCharge = max(shineCharge - 1, 0);
	shineStart = max(shineStart - 1, 0);
	shineEnd = max(shineEnd - 1, 0);
	
	notGrounded = !grounded;
	
	if(((!cUp && !cDown) || (move != 0 && state == State.Stand)) && aimAngle == gbaAimAngle)
	{
		gbaAimPreAngle = gbaAimAngle;
	}
	
	afterImgAlphaMult = 0.625;
	if(!speedBoost && state != State.Spark && state != State.BallSpark)
	{
		afterImgAlphaMult = 0.375;
		if(state == State.Dodge)
		{
			drawAfterImage = true;
			afterImageNum = min(abs(fVelX), 10);
		}
		else if(state == State.Grapple || (grapBoost && !boots[Boots.SpaceJump]))
		{
			if(point_distance(xprevious,yprevious,x,y) >= 3)
			{
				drawAfterImage = true;
				afterImageNum = min((point_distance(xprevious,yprevious,x,y)-3),10);
			}
		}
		else if(notGrounded && boots[Boots.SpaceJump] && state == State.Somersault && !liquidMovement)
		{
			drawAfterImage = true;
			afterImageNum = 10;
		}
		else if(notGrounded && fVelY < 0)
		{
			drawAfterImage = true;
			afterImageNum = min(abs(fVelY)*1.5, 10);
		}
		else if(notGrounded && fVelY >= 3)
		{
			drawAfterImage = true;
			afterImageNum = min((abs(fVelY)-3),10);
		}
	}
	
	player_water();
	
	if(isChargeSomersaulting)
	{
		immune = true;
	}
	if(isSpeedBoosting)
	{
		immune = true;
		var xv = fVelX;
		if(fVelX == 0)
		{
			xv = move2;
		}
		scr_BreakBlock(x+xv,y+fVelY,5);
	}
	if(isScrewAttacking)
	{
		immune = true;
		var xv = fVelX;
		if(fVelX == 0)
		{
			xv = move2;
		}
		scr_BreakBlock(x+xv,y+fVelY,6);
	}
}