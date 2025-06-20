/// @description Physics, States, etc.

if(!global.gamePaused || (instance_exists(XRay) && !global.roomTrans && !obj_PauseMenu.pause && !pauseSelect))
{
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
	
	if(instance_exists(obj_Display))
	{
		debug = (obj_Display.debug > 0);
	}
	#region debug keys
	if(debug)
	{
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
	}
	else
	{
		godmode = false;
	}
	
	#region meme dance (press 1)
	if(state == State.Stand && stateFrame == State.Stand)
	{
		if(debug && keyboard_check(ord("1")))
		{
			memeDance = true;
		}
	}
	else
	{
		memeDance = false;
		memeDanceFrame = 0;
	}
	#endregion
	
	#endregion

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
	else if(audio_is_playing(snd_LowHealthAlarm))
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
	var findLiquid = liquid_place();
	if(instance_exists(findLiquid))
	{
		liquidLevel = max(bb_bottom() - findLiquid.y,0);

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
			if(findLiquid.liquidType == LiquidType.Lava || findLiquid.liquidType == LiquidType.Acid)
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
	cSprint = obj_Control.sprint;
	cAngleUp = obj_Control.angleUp;
	cAngleDown = (obj_Control.angleDown && global.aimStyle == 0);
	cAimLock = obj_Control.aimLock;
	cMorph = obj_Control.quickMorph;

	if(state == State.Elevator || state == State.Recharge || state == State.CrystalFlash || introAnimState != -1)
	{
	    cRight = false;
	    cLeft = false;
	    cUp = false;
	    cDown = false;
	    cJump = false;
	    cShoot = false;
	    cSprint = false;
	    cAngleUp = false;
	    cAngleDown = false;
	    cAimLock = false;
		cMorph = false;
	}
#endregion

	move = cRight - cLeft;
	move2 = cRight - cLeft;
	pMove = ((cRight && rRight) - (cLeft && rLeft));
	
	if(move != 0 && !brake && morphFrame <= 0 && wjFrame <= 0 && state != State.Grip && 
	(!cAimLock /*|| cSprint*/ || state == State.Somersault || state == State.Morph || instance_exists(XRay) || (global.aimStyle == 2 && cAngleUp)) && 
	!instance_exists(grapple) && state != State.Spark && state != State.BallSpark && state != State.Hurt && stateFrame != State.DmgBoost && dmgBoost <= 0 && state != State.Dodge)
	{
		dir = move;
	}
	if(SpiderActive())
	{
		if(spiderMove != 0)
		{
			dir = spiderMove;
			/*if(spiderEdge == Edge.Top)
			{
				dir = -spiderMove;
			}*/
		}
	}
	
	if(dir != oldDir)
	{
		lastDir = oldDir;
		
		brake = false;
		brakeFrame = 0;
	}
	
	walkState = ((cAimLock || instance_exists(grapple)) && velX != 0 && sign(velX) != dir && state == State.Stand && !instance_exists(XRay));
	
	if(dir != 0 && cMorph && rMorph && morphFrame <= 0 && state != State.Crouch && state != State.Morph && stateFrame != State.Morph && misc[Misc.Morph] && state != State.Spark && state != State.BallSpark && state != State.Grip && !instance_exists(XRay))
	{
		audio_play_sound(snd_Morph,0,false);
		if(state == State.Stand)
		{
			if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
			{
				velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
				speedCounter = 0;
				speedBoost = false;
			}
		}
		ChangeState(State.Morph,State.Morph,mask_Player_Morph,grounded);
		groundedMorph = grounded;
		morphFrame = 8;
		
		if(GrappleActive() && (misc[Misc.MagBall] || misc[Misc.Spider]) && unmorphing == 0 && global.spiderBallStyle == 0)
		{
			SpiderEnable(true);
		}
	}
	
	dir2 = dir;
	if(stateFrame == State.Grip)
	{
		dir2 = -dir;
	}

#region Aim Control
	prAngle = ((cAngleUp && rAngleUp) || (cAngleDown && rAngleDown));
	rlAngle = ((!cAngleUp && !rAngleUp) || (!cAngleDown && !rAngleDown));
	
	if(!instance_exists(grapple))
	{
		if((aimAngle > -2 && (aimAngle < 2 || state != State.Grip || (rlAngle && global.aimStyle != 2))) ||
			(prAngle && global.aimStyle != 2) || grounded || move != 0 || instance_exists(XRay) || 
			state == State.Morph || state == State.Somersault || state == State.Spark || state == State.BallSpark)
		{
			aimAngle = 0;
		}
		if(!instance_exists(XRay))
		{
			if(!grounded && cDown && !cUp && state != State.Morph)
			{
				if(aimAngle == -2 && move == 0 && rDown && morphFrame <= 0 && state != State.Morph && misc[Misc.Morph] && state != State.Somersault && state != State.Spark && state != State.BallSpark && state != State.Grip && !cAngleUp && !cAngleDown)
				{
					audio_play_sound(snd_Morph,0,false);
					ChangeState(State.Morph,State.Morph,mask_Player_Morph,false);
					groundedMorph = false;
					morphFrame = 8;
				}
				
				aimAngle = -2;
			}
			
			if(((state != State.Morph && (state != State.Crouch || entity_place_collide(0,-11))) || (global.aimStyle == 2 && cAngleUp)) && morphFrame <= 0)
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
			
			if(!spiderBall)
			{
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
					
					if(!allowMovingVertAim && cAngleUp && cAngleDown && move != 0 && grounded && !walkState && sign(velX) == dir && abs(dirFrame) >= 4)
					{
						aimAngle = 1;
					}
					
					/*if(cAngleUp)
					{
						if(extAimAngle == 0 || !cAngleDown)
						{
							extAimAngle = 1;
						}
						else if(cAngleDown && extAimAngle > 0)
						{
							extAimAngle = 2;
						}
					}
					if(cAngleDown)
					{
						if(extAimAngle == 0 || !cAngleUp)
						{
							extAimAngle = -1;
						}
						else if(cAngleDown && extAimAngle < 0)
						{
							extAimAngle = -2;
						}
					}
					
					if(!cAngleUp && !cAngleDown)
					{
						extAimAngle = 0;
						extAimPreAngle = 0;
					}
					else
					{
						if((extAimAngle >= 2 && cDown && rDown) || (extAimAngle <= -2 && cUp && rUp))
						{
							extAimAngle *= -1;
						}
						
						aimAngle = extAimAngle;
						
						if(!cUp && !cDown)
						{
							extAimPreAngle = extAimAngle;
						}
						
						if(extAimAngle != extAimPreAngle && abs(extAimAngle) >= 2)
						{
							cUp = false;
							cDown = false;
						}
					}*/
				}
				
				if(global.aimStyle == 1)
				{
					if(cAngleUp)
					{
						if(extAimAngle == 0)
						{
							extAimAngle = 1;
						}
						
						if(extAimAngle == extAimPreAngle)
						{
							if(cUp && rUp)
							{
								extAimAngle = min(extAimAngle+1,2);
								if(extAimAngle == 0)
								{
									extAimAngle++;
								}
							}
							if(cDown && rDown)
							{
								extAimAngle = max(extAimAngle-1,-1);
								if(extAimAngle == 0)
								{
									extAimAngle--;
								}
							}
						}
						
						aimAngle = extAimAngle;
						
						if(!cUp && !cDown)
						{
							extAimPreAngle = extAimAngle;
						}
						
						if(extAimAngle != extAimPreAngle && abs(extAimAngle) >= 1)
						{
							cUp = false;
							cDown = false;
						}
					}
					else
					{
						extAimAngle = 0;
						extAimPreAngle = 0;
					}
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
						move2 = 0;
					}
				}
			}
		}
	}
	
	if(aimAngle != prevAimAngle)
	{
		lastAimAngle = prevAimAngle;
	}
#endregion

if(instance_exists(XRay))
{
	exit;
}

#region Shoot direction
	shootDir = GetShootDirection(aimAngle,dir2);
	
	if(instance_exists(grapReticle) && grapReticle.adjustedShootDir != 0)
	{
		shootDir += grapReticle.adjustedShootDir;
	}
#endregion

#region Horizontal Movement

	var sprint = (cSprint || global.autoSprint);
	
	// basically free super short charge if you uncomment this
	/*if(debug && speedBuffer >= speedBufferMax-1 && speedCounter < speedCounterMax)
	{
		sprint = true;
	}*/
	
	var moveState = MaxSpeed.Run;
	if(state == State.Morph)
	{
		if(grounded)
		{
			if(abs(velX) > maxSpeed[MaxSpeed.MorphBall,liquidState] && liquidState <= 0)
			{
				moveState = MaxSpeed.MockBall;
				//if(speedBoost && sprint)
				//{
				//	moveState = MaxSpeed.SpeedBoost;
				//}
			}
			else
			{
				moveState = MaxSpeed.MorphBall;
			}
		}
		else
		{
			if(misc[Misc.Spring])
			{
				moveState = MaxSpeed.AirSpring;
			}
			else
			{
				moveState = MaxSpeed.AirMorph;
			}
		}
	}
	else if(state == State.Jump)
	{
		moveState = MaxSpeed.Jump;
		if(stateFrame == State.DmgBoost)
		{
			moveState = MaxSpeed.Somersault;
		}
	}
	else if(state == State.Somersault)
	{
		moveState = MaxSpeed.Somersault;
	}
	else
	{
		if(sprint && !liquidMovement)
		{
			if(boots[Boots.SpeedBoost])
			{
				moveState = MaxSpeed.SpeedBoost;
			}
			else
			{
				moveState = MaxSpeed.Sprint;
			}
		}
	}
	
	fMaxSpeed = maxSpeed[moveState,liquidState];
	fMoveSpeed = moveSpeed[MoveSpeed.Normal,liquidState];
	if(state == State.Morph)
	{
		fMoveSpeed = moveSpeed[MoveSpeed.MorphBall,liquidState];
	}
	fFrict = frict[!grounded,liquidState];
	
	if(moveState == MaxSpeed.Sprint || moveState == MaxSpeed.SpeedBoost)
	{
		var runMaxSpd = maxSpeed[MaxSpeed.Run,liquidState],
			sprintMaxSpd = maxSpeed[MaxSpeed.Sprint,liquidState],
			runMoveSpd = moveSpeed[MoveSpeed.Normal,liquidState],
			sprintMoveSpd = moveSpeed[MoveSpeed.Sprint,liquidState],
			spd = abs(velX);
		
		if(spd < runMaxSpd)
		{
			fMoveSpeed = lerp(runMoveSpd+sprintMoveSpd,runMoveSpd, clamp(spd / runMaxSpd,0,1));
		}
		else if(spd < sprintMaxSpd)
		{
			fMoveSpeed = lerp(runMoveSpd,sprintMoveSpd, (abs(velX)-runMaxSpd) / (sprintMaxSpd-runMaxSpd));
		}
		else
		{
			fMoveSpeed = sprintMoveSpd;
		}
	}
	
	#region Momentum Logic
	
	if(state == State.Stand)
	{
		if((walkState && sign(velX) != dir) || moonFallState)
		{
			fMaxSpeed = maxSpeed[MaxSpeed.MoonWalk,liquidState];
			if(sprint)
			{
				fMaxSpeed = maxSpeed[MaxSpeed.MoonSprint,liquidState];
			}
			var _frict = fFrict*0.25;
			if(moonFallState)
			{
				fMaxSpeed = 0;
				_frict = fFrict*2;
			}
			if(abs(velX) > fMaxSpeed)
			{
				if(velX > 0)
				{
					velX = max(velX - _frict, fMaxSpeed);
				}
				if(velX < 0)
				{
					velX = min(velX + _frict, -fMaxSpeed);
				}
			}
		}
	}
	else if(moonFall && !grounded)
	{
		fMaxSpeed = maxSpeed[MaxSpeed.MoonFall,liquidState];
	}
	
	var maxSpeed2 = maxSpeed[MaxSpeed.SpeedBoost,liquidState];
	if(abs(velX) > maxSpeed2 && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Dodge && state != State.DmgBoost && (speedCounter > 0 || grounded))
	{
		if(sign(velX) == 1)
		{
			velX = max(velX - fFrict*0.25, maxSpeed2);
		}
		if(sign(velX) == -1)
		{
			velX = min(velX + fFrict*0.25, -maxSpeed2);
		}
	}
	var turnaroundSpd = fMoveSpeed + fFrict;
	if(sprint && state == State.Stand)
	{
		turnaroundSpd += sprintTurnSpeed[liquidState];
	}
	
	if(state != State.Crouch && (state != State.Grip || startClimb) && state != State.Spark && state != State.BallSpark && state != State.Grapple && 
	state != State.Hurt && !SpiderActive() && !GrappleActive() && state != State.Dodge)
	{
		var moveflag = false;
		if((move == 1 && !brake) || (state == State.Somersault && dir == 1 && velX > 1.1*moveSpeed[MoveSpeed.Normal,liquidState]))
		{
			moveflag = true;
			if(velX <= fMaxSpeed)
			{
				if(velX < 0)
				{
					velX = min(velX + turnaroundSpd, 0);
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
		if((move == -1 && !brake) || (state == State.Somersault && dir == -1 && velX < -1.1*moveSpeed[MoveSpeed.Normal,liquidState]))
		{
			moveflag = true;
			if(velX >= -fMaxSpeed)
			{
				if(velX > 0)
				{
					velX = max(velX - turnaroundSpd, 0);
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
		
		if(fastWJGrace && move != -sign(velX))
		{
			var fwjFrict = turnaroundSpd;//max(fastWJGraceVel*0.34,turnaroundSpd);
			if(velX > 0)
			{
				velX = max(velX - fwjFrict, 0);
			}
			if(velX < 0)
			{
				velX = min(velX + fwjFrict, 0);
			}
		}
		else if(!moveflag)
		{
			if((aimAngle > -2 /*|| !cJump*/) && 
			(state != State.Morph || (state == State.Morph && abs(velX) <= maxSpeed[MaxSpeed.MorphBall,liquidState]) || grounded) && morphFrame <= 0)
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
	
	minBoostSpeed = maxSpeed[MaxSpeed.Sprint,liquidState] + ((maxSpeed[MaxSpeed.SpeedBoost,liquidState] - maxSpeed[MaxSpeed.Sprint,liquidState])*0.75);
	
	if(fastWallJump && speedBoostWallJump)
	{
		var sBoostWJFlag = (speedBoost && state == State.Somersault && !grounded && sign(prevVelX) != dir && abs(prevVelX) >= maxSpeed[MaxSpeed.Sprint,liquidState]);
		if(sBoostWJFlag)
		{
			speedBoostWJCounter = min(speedBoostWJCounter+1,speedBoostWJMax);
		}
		else
		{
			speedBoostWJCounter = 0;
		}
		speedBoostWJ = (sBoostWJFlag && speedBoostWJCounter < speedBoostWJMax);
	}
	else
	{
		speedBoostWJ = false;
	}
	
	var spiderBoosting = (SpiderActive() && sign(spiderSpeed) == spiderMove && abs(spiderSpeed) > maxSpeed[MaxSpeed.MorphBall,liquidState]);
	var stopBoosting = false;
	
	if(state == State.Grapple)
	{
		if(!speedBoost)
		{
			speedCounter = 0;
			speedBuffer = 0;
			speedBufferCounter = 0;
		}
	}
	else if(!speedBoostWJ)
	{
		if(state == State.Stand && grounded && !liquidMovement && crouchFrame >= 5 && !brake && ((velX != 0 && sign(velX) == dir) || (prevVelX != 0 && sign(prevVelX) == dir)))
		{
			var num = speedCounter;
			if((sprint && speedBuffer > 0) || speedCounter > 0)
			{
				num += 1;
			}
			
			speedBufferCounter++;
			if(speedBufferCounter >= scr_floor(speedBufferCounterMax[num]))
			{
				speedBuffer++;
				if(sprint && speedBuffer >= speedBufferMax)
				{
					speedCounter = min(speedCounter+1,speedCounterMax);
				}
				speedBufferCounter -= speedBufferCounterMax[num];
			}
			if(speedBuffer >= speedBufferMax)
			{
				speedBuffer = 0;
			}
		}
		else
		{
			speedBuffer = 0;
			speedBufferCounter = 0;
			//if(!speedBoost && (speedKeep == 0 || (speedKeep == 2 && liquidMovement)))
			//{
			//	speedCounter = 0;
			//}
		}
		
		
		if(sign(velX) != dir && sign(prevVelX) != dir)
		{
			stopBoosting = true;
			if(!spiderBoosting)
			{
				speedCounter = 0;
			}
		}
		if(move != dir && (speedCounter > 0 || !grounded) && morphFrame <= 0 && (aimAngle > -2 || !cJump))
		{
			if((state != State.Somersault && state != State.Morph) || (state == State.Morph && abs(velX) <= maxSpeed[MaxSpeed.MorphBall,liquidState]) || grounded)
			{
				stopBoosting = true;
				
				if(!spiderBoosting)
				{
					speedCounter = 0;
					speedBoost = false;
				}
			}
		}
	}
	
	if(boots[Boots.SpeedBoost])
	{
		if(speedCounter >= speedCounterMax)
		{
			speedBoost = true;
		}
		else if(!speedBoost && (abs(velX) >= minBoostSpeed || abs(spiderSpeed) >= minBoostSpeed) && (state == State.Stand || !restrictSBToRun) && state != State.Dodge && state != State.Grapple && !grapBoost && !spiderJump)
		{
			speedCounter = speedCounterMax;
			speedBoost = true;
		}
	}
	else
	{
		speedCounter = 0;
		speedBoost = false;
	}
	
	if(speedBoost && state != State.Spark && state != State.BallSpark)
	{
		if(state != State.Grapple && stopBoosting && !spiderBoosting)
		{
			if(state == State.Stand && abs(velX) >= minBoostSpeed-fFrict && abs(velX) > 0 && !cDown && !brake)
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
			speedBoost = false;
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
	
	if((state == State.Stand || state == State.Crouch || state == State.Morph) && (speedBoost || speedCatchCounter > 0) && move == 0 && cDown && dir != 0 && grounded && morphFrame <= 0 && !SpiderActive())
	{
		shineCharge = shineChargeMax;
		speedCounter = 0;
		speedBoost = false;
	}
	
	/*if(speedCounter < speedCounterMax)
	{
		speedBoost = false;
	}*/
	
	#endregion
	
#endregion
#region Vertical Movement
	if(grounded)
	{
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
	}
	
	canMorphBounce = true;
	
	if(moonFallState || moonFall)
	{
		bufferJump = 0;
		coyoteJump = 0;
	}
	
	var canGripJump = false;
	if(state == State.Grip)
	{
		bufferJump = 0;
		coyoteJump = 0;
		
		canGripJump = true;
		if(climbTarget > 0 && !startClimb)
		{
			var climbUp = (move2 == dir && cJump && rJump);
			if(global.gripStyle == 0)
			{
				climbUp |= (upClimbCounter >= 25 && cUp && move != -dir);
			}
			if(global.gripStyle == 2)
			{
				climbUp = (move2 != -dir && cJump && rJump) || (upClimbCounter >= 25 && cUp && move != -dir);
			}
			if(cDown)
			{
				climbUp = false;
			}
			if(climbUp && !startClimb)
			{
				audio_play_sound(snd_Climb,0,false);
				gripGunReady = false;
				gripGunCounter = 0;
				startClimb = true;
				climbIndexCounter += 2;
			}
				
			canGripJump = (!climbUp && !cDown && cJump && rJump);
		}
	}
	
	if(state == State.Jump || state == State.Somersault)
	{
		var detectRange = 8 + abs(prevVelX);
		//canWallJump = (move != 0 && (entity_place_collide(velX-detectRange*move,0) || place_meeting(position.X+velX-detectRange*move,position.Y,ColType_Platform)) && wjFrame <= 0 && coyoteJump <= 0);
		canWallJump = false;
		if(move != 0 && wjFrame <= 0 && coyoteJump <= 0)
		{
			var _solids = array_concat(solids,ColType_Platform);
			var num = instance_place_list(position.X+velX-detectRange*move,position.Y,_solids,blockList,true);
			if(num > 0)
			{
				for(var i = 0; i < num; i++)
				{
					if(instance_exists(blockList[| i]) && isValidSolid(blockList[| i]))
					{
						var block = blockList[| i];
						var isSolid = true;
						if (block.object_index == obj_Tile || object_is_ancestor(block.object_index,obj_Tile) ||
							block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
						{
							isSolid = block.canWallJump;
						}
						if(isSolid)
						{
							canWallJump = true;
							break;
						}
					}
				}
				ds_list_clear(blockList);
			}
		}
	}
	else
	{
		if(state == State.Grip)
		{
			canWallJump = ((gripGunReady && move2 != dir && !cDown) || (move2 != 0 && move2 != dir));
		}
		else if(state != State.Grapple)
		{
			canWallJump = false;
		}
		wjAnimDelay = 10;
	}
	
	#region Jump Logic
	
	fJumpHeight = jumpHeight[boots[Boots.HiJump],liquidState];
	
	var isJumping = (cJump && dir != 0 && /*climbIndex <= 0 &&*/ state != State.Spark && state != State.BallSpark && 
	state != State.Hurt && (!SpiderActive() || !sparkCancelSpiderJumpTweak) && (state != State.Grapple || grapWJCounter > 0)) && 
	(state != State.Morph || (!entity_place_collide(0,1) && !entity_place_collide(0,-1)) || (!entity_place_collide(0,1) ^^ !entity_place_collide(0,-1)) || entity_place_collide(0,0));
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
			if(shineCharge > 0 && rJump && (CanChangeState(mask_Player_Jump) || state == State.Morph) && !entity_place_collide(0,-1) && 
			(move == 0 || velX == 0 || state == State.Jump) && state != State.Somersault && state != State.DmgBoost && ((!cAngleDown && !cDown) || boots[Boots.ChainSpark]) && 
			(state != State.Morph || misc[Misc.Spring]) && morphFrame <= 0 && state != State.Grip)
			{
				audio_stop_sound(snd_ShineSpark_Charge);
				shineStart = 30;
				shineRestart = false;
				if(state == State.Morph)
				{
					ChangeState(State.BallSpark,State.Morph,mask_Player_Morph,false);
				}
				else
				{
					ChangeState(State.Spark,State.Spark,mask_Player_Jump,false);
				}
				rSparkJump = true;
			}
			else if((rJump || (state == State.Morph && !SpiderActive() && rMorphJump) || bufferJump > 0) && quickClimbTarget <= 0 && //climbIndex <= 0 && 
			(state != State.Morph || (state == State.Morph && ((misc[Misc.Spring] && morphFrame <= 0) || ((unmorphing > 0 || morphSpinJump) && CanChangeState(mask_Player_Somersault))))) && state != State.DmgBoost)
			{
				if((grounded && !moonFallState) || coyoteJump > 0 || canWallJump || (state == State.Grip && canGripJump) || 
				(boots[Boots.SpaceJump] && velY >= sjThresh && state == State.Somersault && !liquidMovement && rJump))
				{
					if(!grounded && !canWallJump && boots[Boots.SpaceJump] && velY >= sjThresh)
					{
						spaceJump = 8;
					}
					if((!grounded || grapWJCounter > 0) && canWallJump)
					{
						grapWJCounter = 0;
						instance_destroy(grapple);
						grappleDist = 0;
						
						audio_stop_sound(snd_Somersault);
						audio_stop_sound(snd_Somersault_Loop);
						audio_stop_sound(snd_Somersault_SJ);
						somerSoundPlayed = false;
						somerUWSndCounter = 16;
						
						audio_stop_sound(snd_ScrewAttack);
						audio_stop_sound(snd_ScrewAttack_Loop);
						screwSoundPlayed = false;
						
						audio_play_sound(snd_WallJump,0,false);
						
						var baseVel = moveSpeed[MoveSpeed.WallJump,liquidState];
						if(state == State.Grip && gripGunReady)
						{
							baseVel = moveSpeed[MoveSpeed.ClingWallJump,liquidState];
							dir *= -1;
							dirFrame = dir;
							wjGripAnim = true;
						}
						if(state == State.Grapple)
						{
							baseVel = moveSpeed[MoveSpeed.ClingWallJump,liquidState];
						}
						
						if(move != 0)
						{
							dir = move;
						}
						
						var m = move;
						if(move == 0 && dir != 0)
						{
							m = dir;
						}
						
						if(fastWallJump)
						{
							velX = max(baseVel,abs(prevVelX))*m;
							
							var spd = min(abs(velX) / max(abs(fastWJCheckVel), maxSpeed[MaxSpeed.Sprint,liquidState]), 1);
							if(abs(velX) >= max(abs(fastWJCheckVel), maxSpeed[MaxSpeed.Sprint,liquidState]) && fastWJCheckVel != 0)
							{
								spd = min(abs(velX) / minBoostSpeed, 1);
								var snd = audio_play_sound(snd_PerfectFastWJ,0,false);
								audio_sound_gain(snd, 0.5 + spd*0.5, 0);
								fastWJFlash = 1;
							}
							else if(abs(velX) > maxSpeed[MaxSpeed.Somersault,liquidState] && fastWJCheckVel != 0)
							{
								var snd = audio_play_sound(snd_FastWallJump,0,false);
								audio_sound_gain(snd, spd*0.75, 0);
								fastWJFlash = spd*0.6;
							}
							
							if(fastWJFlash > 0)
							{
								var _left = bb_left()-16 - velX, _top = bb_top()-8,
									_right = bb_right()+16 - velX, _bottom = bb_bottom()+8;
								var dist = instance_create_depth(0,0,layer_get_depth(layer_get_id("Projectiles_fg"))-1,obj_Distort);
								dist.left = _left;
								dist.top = _top;
								dist.right = _right;
								dist.bottom = _bottom;
								dist.alpha = 0.5;
								dist.alphaNum = 1;
								dist.alphaRate = 0.5;
								dist.alphaRateMultDecr = 0.2;
								dist.spread = 0.5;
								dist.width = 0.5;
								dist.colorMult = -fastWJFlash;
								
								var num = ceil(24*spd);
								for(var i = 0; i < ceil(18*spd); i++)
								{
									var part = instance_create_depth(Center().X-velX,Center().Y,layer_get_depth(layer_get_id("Projectiles_fg"))-1,obj_FastWJParticle);
									part.ang = 360*(i/num) + (irandom(30)-15);
									part.alphaMult = fastWJFlash;
								}
							}
						}
						else
						{
							velX = baseVel*m;
						}
						
						ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
						wallJumped = true;
						
						wjFrame = 8;
						wjAnimDelay = 10;
						
						if(dodgeRecharge >= dodgeRecharge-dodgeRechargeRate)
						{
							dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate,dodgeRechargeMax);
						}
						
						if(liquid && liquid.liquidType != LiquidType.Lava)
						{
							for(var i = 0; i < 3; i++)
							{
								var bub = liquid.CreateBubble(x-6*dir + random_range(-2,2), y+10 + random_range(-2,2), 0,0);
								bub.kill = true;
								bub.canSpread = false;
								if(fastWJFlash > 0)
								{
									bub.spriteIndex = sprt_WaterBubble;
								}
							}
						}
						else if(!liquid)
						{
							part_particles_create(obj_Particles.partSystemB,x-6*dir,y+10,obj_Particles.bDust[0],3);
						}
					}
					else if(state == State.Grip && gripGunReady)
					{
						dir *= -1;
						dirFrame = dir;
					}
					else
					{
						wallJumped = false;
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
					if((rJump || bufferJump > 0) && state != State.Morph)
					{
						if(state == State.Grip)
						{
							stallCamera = true;
						}
						if((abs(velX) > 0 && sign(velX) == dir) || (move != 0 && move == dir) || cSprint || (!grounded && state != State.Grip) || (state == State.Crouch && !CanChangeState(mask_Player_Jump)))
						{
							var mask = mask_Player_Jump;
							if(!CanChangeState(mask_Player_Jump))
							{
								mask = mask_Player_Somersault;
							}
							ChangeState(State.Somersault,State.Somersault,mask,false, false);
						}
						else
						{
							ChangeState(State.Jump,State.Jump,mask_Player_Jump,false, false);
						}
					}
					if((rJump || bufferJump > 0) && state == State.Morph && !misc[Misc.Spring])//(cSprint || !misc[Misc.Spring]) && boostBallCharge < boostBallChargeMin)
					{
						morphSpinJump = true;
					}
					coyoteJump = 0;
					bufferJump = 0;
				}
				else if(rJump)
				{
					if(state != State.Morph && state != State.Grip && !instance_exists(grapple))
					{
						ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
						if(moonFallState && !moonFall)
						{
							moonFall = true;
						}
					}
					if(state == State.Morph && (cSprint || !misc[Misc.Spring]))
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
		
		fJumpSpeed = jumpSpeed[boots[Boots.HiJump],liquidState];
		if(wallJumped)
		{
			fJumpSpeed = jumpSpeed[2+boots[Boots.HiJump],liquidState];
		}
	
		if(boots[Boots.SpeedBoost] && abs(velX) > maxSpeed[MaxSpeed.Sprint,liquidState] && speedCounter > 0)
		{
			fJumpSpeed += max((abs(velX) - maxSpeed[MaxSpeed.Sprint,liquidState]) / 2, 0);
		}
		
		if(jump > 0)
		{
			if(spiderBall && (spiderEdge != Edge.None || spiderJump))
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
				
				spiderJump = true;
			}
			else
			{
				velY = -fJumpSpeed;
			}
			jump -= 1;
			
			ledgeFall = false;
			ledgeFall2 = false;
			
			grounded = false;
			prevGrounded = false;
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
		if(SpiderActive() || state == State.Spark || state == State.BallSpark || state == State.Grip || state == State.Grapple)
		{
			bufferJump = 0;
		}
		
		jump = 0;
		wallJumped = false;
	}
	if(grounded)
	{
		coyoteJump = coyoteJumpMax;
	}
	else if(coyoteJump > 0)
	{
		coyoteJump--;
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
						//velY -= (velY*0.9);
						velY = 0;
					}
					jumpStop = false;
				}
				jumping = false;
			}
		}
	}
	else
	{
		jumpStop = false;
	}
	
	#endregion
	
	#region Bomb Jump Logic
	
	if(bombJumpX != 0 && !SpiderActive() && bombJump > 0)
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
		if(spiderBall && (spiderEdge != Edge.None || spiderJump))
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
			prevSpiderEdge = Edge.None;
			
			spiderJump = true;
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
		
		grounded = false;
		prevGrounded = false;
		
		bombJump--;
	}
	
	#endregion
	
	// Gravity
	var fallspd = fallSpeedMax;
	if(moonFall)
	{
		fallspd = moonFallMax;
	}
	
	fGrav = grav[liquidState];
	if(jump <= 0 && !grounded && state != State.Elevator && (state != State.Grip || (startClimb && climbIndex > 7)) && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Hurt && state != State.Dodge && state != State.CrystalFlash)
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

#region Grapple Movement

	if(GrappleActive())
	{
		grapAngle = point_direction(position.X, position.Y, grapple.x, grapple.y) - 90;
		var dist = point_distance(position.X,position.Y,grapple.x,grapple.y);
		var ndist = point_distance(position.X+velX,position.Y+velY,grapple.x,grapple.y);
		
		var reel = 0;
		
		if(state == State.Grapple)
		{
			if(grappleDist <= grappleMinDist+2 && entity_place_collide(sign(grapple.x-x),0) && (grapAngle <= 45 || grapAngle >= 315))
			{
				if(sign(x-grapple.x) != 0)
			    {
			        dir = sign(x-grapple.x);
			    }
			    speedCounter = 0;
				speedBoost = false;

			    dirFrame = 4*dir;
			    canWallJump = (move != -dir);
			    if(cShoot)
			    {
			        grapWJCounter = 60;
			    }
			}
			else
			{
				canWallJump = false;
			    grapWJCounter = 0;
				
				var grapAngVel = angle_difference(point_direction(position.X+velX,position.Y+velY,grapple.x,grapple.y),point_direction(position.X,position.Y,grapple.x,grapple.y));
				
				if(!speedBoost)
				{
					var angCurv = dcos(grapAngle+90);
					if(angCurv != 0)
					{
						angCurv = sqrt(abs(angCurv)) * sign(angCurv);
					}
					
					var grapMoveSpeed = moveSpeed[MoveSpeed.Grapple,liquidState],
						angleGrav = grapGrav[liquidState] * angCurv;
					
					velX += lengthdir_x(grapMoveSpeed * move + angleGrav,grapAngle);
					velY += lengthdir_y(grapMoveSpeed * move + angleGrav,grapAngle);
					velX *= (0.99 + 0.007*liquidMovement);
					velY *= (0.99 + 0.007*liquidMovement);
				}
				else
				{
					if(point_distance(position.X,position.Y,position.X+velX,position.Y+velY) >= minBoostSpeed*0.75)
					{
						if(point_distance(position.X,position.Y,position.X+velX,position.Y+velY) < maxSpeed[MaxSpeed.SpeedBoost,liquidState]*1.25)
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
				
				var kickDir = dir;
				if(move2 != 0)
				{
					kickDir = move2;
				}
				if(sign(grapAngVel) != 0)
				{
					kickDir = sign(grapAngVel);
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
						var kickSpeed = moveSpeed[MoveSpeed.GrappleKick,liquidState];
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
			}
			
			var reelSpeed = 6 / (1+liquidMovement);
			var up = (cUp && grappleDist > grappleMinDist),
				down = (cDown && grappleDist < grappleMaxDist);
			if(global.grappleStyle == 1 && move != 0)
			{
				up = false;
				down = false;
			}
			if(up)
			{
				reel = max(-reelSpeed, grappleMinDist-dist);
				grappleDist = min(dist,grappleMaxDist);
			}
			if(down)
			{
				reel = min(reelSpeed, grappleMaxDist-dist);
				grappleDist = min(dist,grappleMaxDist);
			}
			if(grappleDist > grappleMaxDist)
			{
				reel = max(-reelSpeed/2, grappleMaxDist-dist-1);
				grappleDist = dist;
			}
			if(grappleDist < grappleMinDist)
			{
				reel = min(reelSpeed/2, grappleMinDist-dist);
				grappleDist = min(dist,grappleMaxDist);
			}
		}
		if(state == State.Morph)
		{
			var reelSpeed = 8 / (1+liquidMovement);
			reel = -reelSpeed;
			grappleDist = min(dist,grappleMaxDist);
			
			canMorphBounce = false;
			
			if((misc[Misc.MagBall] || misc[Misc.Spider]) && unmorphing == 0)
			{
				spiderGrappleSpeedKeep = true;
			}
			velX = 0;
			velY = 0;
		}
		
		var vX = position.X - grapple.x,
			vY = position.Y - grapple.y;
		
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
		
		if(state == State.Morph)
		{
			if(grappleDist <= 20 || spiderEdge != Edge.None || !cShoot)
			{
				instance_destroy(grapple);
				if(spiderEdge != Edge.None)
				{
					if(spiderEdge == Edge.Bottom)
					{
						spiderSpeed += grappleVelX;
					}
					if(spiderEdge == Edge.Top)
					{
						spiderSpeed -= grappleVelX;
					}
					if(spiderEdge == Edge.Right)
					{
						spiderSpeed -= grappleVelY;
					}
					if(spiderEdge == Edge.Left)
					{
						spiderSpeed += grappleVelY;
					}
					spiderMove = sign(spiderSpeed);
				}
				else
				{
					velX += grappleVelX;
					velY += grappleVelY;
				}
			}
		}
	}
	else
	{
		if(!instance_exists(grapple))
		{
			grappleDist = 0;
			grapAngle = 0;
		}
		grappleVelX = 0;
		grappleVelY = 0;
		grapDisVel = 0;
	}

#endregion

#region Boost Ball Movement
	if((state == State.Morph || state == State.BallSpark || state == State.Grip || state == State.Hurt) && stateFrame == State.Morph && misc[Misc.Boost] && unmorphing == 0)
	{
		if(cSprint)
		{
			boostBallCharge = min(boostBallCharge + 1, boostBallChargeMax);
			boostBallFX = max(boostBallFX - 0.025, boostBallCharge / boostBallChargeMax);
			
			if(boostBallCharge >= 10)
			{
				if(boostBallSnd == noone || !audio_is_playing(boostBallSnd))
				{
					boostBallSnd = audio_play_sound(snd_BoostBall_Charge,0,false);
					audio_sound_loop(boostBallSnd,true);
					audio_sound_loop_start(boostBallSnd,1.938);
					audio_sound_loop_end(boostBallSnd,3.589);
				}
			}
		}
		else
		{
			if(!rSprint && boostBallCharge >= boostBallChargeMin && state == State.Morph)
			{
				var bbMult = boostBallCharge / boostBallChargeMax;
				var _dir = dir;
				if(move2 != 0)
				{
					_dir = move2;
				}
				var _spd = moveSpeed[MoveSpeed.BoostBall,liquidState] * bbMult;
					
				if(SpiderActive())
				{
					if(spiderSpeed != 0)
					{
						_dir = sign(spiderSpeed);
					}
					
					spiderSpeed += _spd * _dir;
				}
				else
				{
					if(!grounded)
					{
						_spd /= 2;
					}
					
					if(grounded && velX == 0 && velY == 0)
					{
						velX += _spd * _dir;
					}
					else if(velX != 0 || velY != 0)
					{
						var _ang = point_direction(0,0,velX,velY);
						velX += lengthdir_x(_spd,_ang);
						velY += lengthdir_y(_spd,_ang);
						jumping = false;
					}
				}
				
				audio_play_sound(snd_BoostBall,0,false);
				boostBallDmgCounter = bbMult;
				boostBallFXFlash = true;
				
				spiderJump = false;
				grapBoost = false;
			}
			
			boostBallCharge = 0;
			audio_stop_sound(boostBallSnd);
			
			boostBallFX = max(boostBallFX - 0.025, 0);
		}
	}
	else
	{
		boostBallCharge = 0;
		boostBallFX = 0;
		boostBallFXFlash = false;
		audio_stop_sound(boostBallSnd);
	}
#endregion
#region Spider Ball Movement
	if(spiderBall)
	{
		switch(spiderEdge)
		{
			case Edge.Bottom:
			{
				if(!entity_place_collide(0,2) && !entity_place_collide(2,2) && !entity_place_collide(-2,2))
				{
					spiderEdge = Edge.None;
				}
				break;
			}
			case Edge.Left:
			{
				if(!entity_place_collide(-2,0) && !entity_place_collide(-2,2) && !entity_place_collide(-2,-2))
				{
					spiderEdge = Edge.None;
				}
				break;
			}
			case Edge.Top:
			{
				if(!entity_place_collide(0,-2) && !entity_place_collide(2,-2) && !entity_place_collide(-2,-2))
				{
					spiderEdge = Edge.None;
				}
				break;
			}
			case Edge.Right:
			{
				if(!entity_place_collide(2,0) && !entity_place_collide(2,2) && !entity_place_collide(2,-2))
				{
					spiderEdge = Edge.None;
				}
				break;
			}
		}
		
		if(state == State.BallSpark && (shineStart > 0 || shineLauncherStart > 0))
		{
			spiderEdge = Edge.None;
		}
		
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = 0;
			if(state != State.BallSpark && !spiderJump)
			{
				if((entity_place_collide(0,1) || grounded) && Crawler_CanStickBottom())
				{
					spiderEdge = Edge.Bottom;
					spiderSpeed = velX;
					spiderMove = sign(spiderSpeed);
				}
				if(entity_place_collide(0,-1) && Crawler_CanStickTop())
				{
					spiderEdge = Edge.Top;
					spiderSpeed = -velX;
					spiderMove = sign(spiderSpeed);
				}
				if(entity_place_collide(1,0) && Crawler_CanStickRight())
				{
					spiderEdge = Edge.Right;
					spiderSpeed = -velY;
					spiderMove = sign(spiderSpeed);
				}
				if(entity_place_collide(-1,0) && Crawler_CanStickLeft())
				{
					spiderEdge = Edge.Left;
					spiderSpeed = velY;
					spiderMove = sign(spiderSpeed);
				}
			}
			
			if(jump <= 0 && bombJump <= 0)
			{
				spiderJump = false;
				spiderJumpDir = 90;
				spiderJump_SpeedAddX = 0;
				spiderJump_SpeedAddY = 0;
			}
		}
		else
		{
			canMorphBounce = false;
			rMorphJump = false;
			spiderJump = false;
			
			var moveX = (cRight-cLeft),
		        moveY = (cDown-cUp);
			if(moveX == 0 && moveY == 0)
		    {
		        spiderMove = 0;
		    }
		    if(spiderMove == 0)
		    {
				if(entity_place_collide(0,1) && spiderEdge != Edge.Top && moveX != 0)
		        {
		            spiderMove = moveX;
		        }
				if(entity_place_collide(0,-1) && spiderEdge != Edge.Bottom && moveX != 0)
		        {
		            spiderMove = -moveX;
		        }
				if(entity_place_collide(-1,0) && spiderEdge != Edge.Right && moveY != 0)
		        {
		            spiderMove = moveY;
		        }
				if(entity_place_collide(1,0) && spiderEdge != Edge.Left && moveY != 0)
		        {
		            spiderMove = -moveY;
		        }
		    }
			
			var fMaxSpeed2 = maxSpeed[MaxSpeed.MorphBall,liquidState];
			if(speedBoost)
			{
				fMaxSpeed2 = maxSpeed[MaxSpeed.SpeedBoost,liquidState];
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
					spiderSpeed = max(spiderSpeed - fFrict*0.25, maxSpeed2);
				}
				if(sign(spiderSpeed) == -1)
				{
					spiderSpeed = min(spiderSpeed + fFrict*0.25, -maxSpeed2);
				}
			}
			
			switch(spiderEdge)
			{
				case Edge.Bottom:
				{
					velX = spiderSpeed;
					velY = 1;
					
					spiderJump_SpeedAddX = velX;
					spiderJump_SpeedAddY = 0;
					break;
				}
				case Edge.Left:
				{
					velX = -1;
					velY = spiderSpeed;
					
					spiderJump_SpeedAddX = 0;
					spiderJump_SpeedAddY = velY;
					break;
				}
				case Edge.Top:
				{
					velX = -spiderSpeed;
					velY = -1;
					
					spiderJump_SpeedAddX = velX;
					spiderJump_SpeedAddY = 0;
					break;
				}
				case Edge.Right:
				{
					velX = 1;
					velY = -spiderSpeed;
					
					spiderJump_SpeedAddX = 0;
					spiderJump_SpeedAddY = velY;
					break;
				}
			}
			
			spiderJumpDir = scr_wrap(GetEdgeAngle(spiderEdge) + 90,0,360);
			
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
		
		if(grounded || abs(velX) < maxSpeed[MaxSpeed.MockBall,liquidState])
		{
			spiderJump = false;
		}
	}
#endregion

	if(debug)
	{
		#region noclip
		if(keyboard_check(vk_numpad6) || keyboard_check(vk_numpad4))
		{
			position.X += (keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4)) * 3;
			velX = 0;
			
			//position.X = scr_round(position.X) + 0.5;
			
			x = scr_round(position.X);
		}
		if(keyboard_check(vk_numpad5) || keyboard_check(vk_numpad8))
		{
			position.Y += (keyboard_check(vk_numpad5) - keyboard_check(vk_numpad8)) * 3;
			if(!grounded)
			{
				velY = -fGrav;
			}
			y = scr_round(position.Y);
		}
		#endregion
	}


#region Grip Collision

	if(misc[Misc.PowerGrip] && (state == State.Jump || state == State.Somersault) && morphFrame <= 0 && !grounded && abs(dirFrame) >= 4 && velY >= 0 && move2 != 0)
	{
		if(!entity_place_collide(0,-4) && ((state == State.Jump && !entity_place_collide(0,3)) || (state == State.Somersault && !entity_place_collide(0,13))))
		{
			var vcheck = x+6,// - 1,
				rcheck = x+6,// - 1,
				lcheck = x;// - 1;
			if(move2 == -1)
			{
				vcheck = x-6;
				rcheck = x;
				lcheck = x-6;
			}
			
			var canGrip = true;
			var num = instance_place_list(x+move2,y,solids,blockList,true);
				num += collision_line_list(lcheck,y-17,rcheck,y-17,solids,true,true,blockList,true);
			for(var i = 0; i < num; i++)
			{
				if (instance_exists(blockList[| i]))
				{
					var block = blockList[| i];
					if (block.object_index == obj_Tile || object_is_ancestor(block.object_index,obj_Tile) ||
						block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
					{
						canGrip = block.canGrip;
					}
					if(canGrip)
					{
						break;
					}
				}
			}
			ds_list_clear(blockList);
			
			if(entity_collision_line(lcheck,y-17,rcheck,y-17) && !entity_collision_line(lcheck,y-22,rcheck,y-26) && entity_place_collide(move2,0) && dir == move2)
			{
				var rslopeX = x+14,// - 1,
					rslopeY = y-25,
					lslopeX = x+6,// - 1,
					lslopeY = y-17;
				if(move2 == -1)
				{
					rslopeX = x-6;
					rslopeY = y-17;
					lslopeX = x-14;
					lslopeY = y-25;
				}
				var slopeOffset = 0;
				while(slopeOffset >= -8 && entity_collision_line(lslopeX,lslopeY+slopeOffset,rslopeX,rslopeY+slopeOffset))
				{
					slopeOffset -= 1;
				}
				if(slopeOffset <= -8)
				{
					canGrip = false;
				}
				
				if(canGrip)
				{
					audio_play_sound(snd_Grip,0,false);
					jump = 0;
					fVelY = 0;
					velY = 0;
					dir = move2;
					
					ChangeState(State.Grip,State.Grip,mask_Player_Jump,false);
					stallCamera = true;
					
					position.Y = scr_ceil(position.Y);
					for(var j = 10; j > 0; j--)
					{
						if(entity_collision_line(lcheck,position.Y-18,rcheck,position.Y-18))
						{
							position.Y -= 1;
						}
					}
					y = scr_round(position.Y);
					
					instance_destroy(grapple);
				}
			}
		}
	}
#endregion

#region Quick Climb
	if(global.quickClimb && state != State.Grip && !startClimb && state != State.Morph && morphFrame <= 0 && grounded && abs(dirFrame) >= 4 && entity_place_collide(2*move2,0) && !entity_place_collide(0,0))
	{
		var qcHeight = 0;
		var bbottom = bb_bottom();
		var heightMax = 50;
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
				var lcheck = x,// - 1,
					rcheck = x+7;// - 1;
				if(dir == -1)
				{
					lcheck = x-7;
					rcheck = x;
				}
				
				if(i == 0 && entity_collision_rectangle(lcheck,bbottom-8,rcheck,bbottom-5))
				{
					while(qcHeight > -heightMax && entity_collision_line(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight))
					{
						qcHeight--;
					}
				}
				else if(i == 1)
				{
					qcHeight = -heightMax;
					while(qcHeight < -5 && entity_collision_line(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight))
					{
						qcHeight++;
					}
					while(qcHeight < -5 && !entity_collision_line(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight))
					{
						qcHeight++;
					}
					qcHeight -= 1;
				}
				
				quickClimbTarget = 0;
				if(qcHeight <= -7)
				{
					var yHeight = bbottom+qcHeight;
					
					lcheck = x+6;// - 1;
					rcheck = x+14;// - 1;
					var rcheckY = yHeight-9,
						lcheckY = yHeight-1;
					if(dir == -1)
					{
						lcheck = x-14;
						rcheck = x-6;
						
						rcheckY = yHeight-1;
						lcheckY = yHeight-9;
					}
					
					if(entity_collision_line(lcheck,yHeight,rcheck,yHeight) && !entity_collision_line(lcheck,lcheckY,rcheck,rcheckY))
					{
						var slopeOffset = 0;
						while(slopeOffset > -16 && entity_collision_line(lcheck,yHeight+slopeOffset,rcheck,yHeight+slopeOffset))
						{
							slopeOffset -= 1;
						}
					
						yHeight += slopeOffset;
					}
					
					lcheck = x-4;// - 1;
					rcheck = x+14;// - 1;
					if(dir == -1)
					{
						lcheck = x-14;
						rcheck = x+4;
					}
					
					var canGrip = true;
					var num = collision_rectangle_list(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight+3,solids,true,true,blockList,true);
					if(num > 0)
					{
						for(var j = 0; j < num; j++)
						{
							if (instance_exists(blockList[| j]))
							{
								var block = blockList[| j];
								if (block.object_index == obj_Tile || object_is_ancestor(block.object_index,obj_Tile) ||
									block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
								{
									canGrip = block.canGrip;
								}
								if(canGrip)
								{
									break;
								}
							}
						}
					}
					ds_list_clear(blockList);
					
					if(canGrip && !entity_collision_rectangle(lcheck,yHeight-15,rcheck,yHeight-2))
					{
						if(!entity_collision_rectangle(lcheck,yHeight-31,rcheck,yHeight-2))
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
			ledgeFall = false;
			justFell = false;
			
			audio_play_sound(snd_Climb,0,false);
			gripGunReady = false;
			gripGunCounter = 0;
			startClimb = true;
			
			var _h = 0;
			if(state == State.Stand)
			{
				_h = -11;
			}
			for(var i = 8; i >= 0; i--)
			{
				_h -= climbY[i];
				if(_h <= qcHeight)
				{
					climbIndex = i;
					break;
				}
			}
			shiftY -= (abs(qcHeight) - abs(_h));
			
			climbTarget = quickClimbTarget;
			climbIndexCounter = 1;
			
			ChangeState(State.Grip,State.Grip,mask_Player_Crouch,false);
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

#region Collision
	
	if(!PlayerGrounded() && !PlayerOnPlatform())
	{
		grounded = false;
	}
	
	colEdge = Edge.Bottom;
	if(spiderBall)
	{
		colEdge = spiderEdge;
	}
	else if(state == State.Grip)
	{
		if(startClimb && climbIndex <= 6)
		{
			colEdge = Edge.None;
		}
	}
	
	if(state != State.Elevator && state != State.Recharge)
	{
		fVelX = velX;
		fVelY = velY;
	
		fVelY += grappleVelY;
		fVelX += grappleVelX;
		
		if(armPumping && prAngle && fVelX != 0 && move == dir && grounded && state == State.Stand)
		{
			fVelX += move;
		}
	
		if(state == State.Hurt)
		{
			fVelX = hurtSpeedX;
			fVelY = hurtSpeedY;
		}
		
		if(dir == 0 || state == State.CrystalFlash)
		{
			velX = 0;
			fVelX = 0;
		}
			
		DestroyBlock(x+fVelX,y);
		DestroyBlock(x,y+fVelY);
		
		if(state == State.Grip)
		{
			fVelX = 0;
			fVelY = 0;
			if(startClimb)
			{
				var cX = climbX[climbIndex] * dir,
					cY = -climbY[climbIndex];
				if(liquidMovement && climbIndex > 1)
				{
					cX /= 2;
					cY /= 2;
				}
				
				if(climbIndex >= 7 && move == dir)
				{
					var msp = 0.5*(stateFrame == State.Morph) / (1+liquidMovement);
					//if(cSprint || global.autoSprint)
					//{
					//	msp = 1 + 0.5*(stateFrame == State.Morph) / (1+liquidMovement);
					//}
					velX = max(msp,abs(velX))*move;
				}
				
				fVelX = cX + velX;
				fVelY = cY + velY;
			}
		}
	}
	else
	{
		fVelX = 0;
		fVelY = 0;
	}
	
	fastWJGrace = false;
	
	if(spiderBall || (state == State.Grip && startClimb && climbIndex <= 6))
	{
		Collision_Crawler(fVelX,fVelY, (state != State.Grip));
	}
	else
	{
		Collision_Normal(fVelX,fVelY, (state != State.Grip));
	}
	
	if(!grounded && velY == 0 && PlayerGrounded())
	{
		grounded = true;
	}
	if(!onPlatform && velY == 0 && PlayerOnPlatform())
	{
		onPlatform = true;
	}
	
	fell = false;
	var shouldForceDown = (state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge && jump <= 0 && bombJump <= 0);
	if((PlayerGrounded() || PlayerOnPlatform()) && fVelY >= 0)
	{
		justFell = shouldForceDown;
	}
	else
	{
		if(justFell && ledgeFall && fVelY >= 0 && fVelY <= fGrav)
		{
			fell = true;
			if(!entity_place_collide(0,1))
			{
				position.Y += 1;
				y = scr_round(position.Y);
			}
			stallCamera = true;
		}
		justFell = false;
	}
	
	if(fastWJGrace)
	{
		if(fastWJGraceCounter < fastWJGraceMax)
		{
			var fwjFrict = turnaroundSpd;//max(fastWJGraceVel*0.34,turnaroundSpd);
			if(velX > 0)
			{
				velX = max(velX - fwjFrict, 0);
			}
			if(velX < 0)
			{
				velX = min(velX + fwjFrict, 0);
			}
		}
		fastWJGraceCounter = min(fastWJGraceCounter+1,fastWJGraceMax);
		
		if(fastWJGraceVel == 0)
		{
			fastWJGraceVel = abs(velX);
		}
	}
	else
	{
		fastWJGraceCounter = 0;
		fastWJGraceVel = 0;
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
	
	if(grounded)
	{
		moonFall = false;
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
	
	var colL = instance_exists(collision_line(bb_left()+1,bb_top(),bb_left()+1,bb_bottom(),ColType_MovingSolid,true,true)),
		colR = instance_exists(collision_line(bb_right()-1,bb_top(),bb_right()-1,bb_bottom(),ColType_MovingSolid,true,true)),
		colT = instance_exists(collision_line(bb_left(),bb_top()+1,bb_right(),bb_top()+1,ColType_MovingSolid,true,true)),
		colB = instance_exists(collision_line(bb_left(),bb_bottom()-1,bb_right(),bb_bottom()-1,ColType_MovingSolid,true,true));
	if (place_meeting(position.X,position.Y,ColType_MovingSolid) && (state != State.Grip || !startClimb) && colL+colR+colT+colB >= 4)
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
		solids = ColType_Solid;
	}
	else
	{
		solids = array_concat(ColType_Solid, ColType_MovingSolid);
	}
	
#endregion

#region Stand, Walk, Run, Sprint, Brake
	if(state == State.Stand)
	{
		stateFrame = State.Stand;
		mask_index = mask_Player_Stand;
		
		if(cAimLock && move != 0 && move != dir && !entity_place_collide(-3*dir,4))
		{
			moonFallCounter++;
		}
		else
		{
			moonFallCounter = 0;
		}
		moonFallState = (moonFallCounter > 0 && moonFallCounter < moonFallCounterMax);
		moonFall = false;
		
		if(crouchFrame >= 5)
		{
			var velMove = (velX != 0 && sign(velX) == dir) || (prevVelX != 0 && sign(prevVelX) == dir),
				moveMove = (move != 0 && (move == dir || walkState));
			if(brake)
			{
				stateFrame = State.Brake;
			}
			else if(moonFallState)
			{
				stateFrame = State.Moon;
			}
			else if((velMove || moveMove) && landFrame <= 0)
			{
				if((walkState && sign(velX) != dir))
				{
					stateFrame = State.Walk;
				}
				else
				{
					stateFrame = State.Run;
				}
			}
		}
		
		if(!PlayerGrounded() && !PlayerOnPlatform())
		{
			grounded = false;
		}
		
		var canCrouch = true;
		
		var ship = instance_position(x,bb_bottom()+1,obj_Gunship);
		if(instance_exists(ship) && ship.state == ShipState.Idle && abs(x - ship.x) <= 10 && y < ship.y)
		{
			canCrouch = false;
			if(cDown && move2 == 0 && velX == 0 && dir != 0 && grounded)
			{
				ship.state = ShipState.SaveDescend;
				
				state = State.Elevator;
				dir = 0;
				aimAngle = 0;
			}
		}
		var ele = instance_position(x,bb_bottom()+1,obj_Elevator);
		if(instance_exists(ele))
		{
			if(ele.downward)
			{
				canCrouch = false;
			}
			if(ele.activeDir == 0 && (ele.elevatorID != -1 || ele.singleRoom) && ((ele.upward && cUp && rUp) || (ele.downward && cDown && rDown)) && move2 == 0 && velX == 0 && dir != 0 && grounded)
			{
				ele.activeDir = (cDown-cUp);
				state = State.Elevator;
				dir = 0;
				aimAngle = 0;
			}
		}
		
		if(canCrouch && move2 == 0 && cDown && dir != 0 && grounded)
		{
			crouchFrame = 5;
			ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
		}
		if(!grounded && dir != 0)
		{
			ChangeState(State.Jump,State.Jump,mask_Player_Jump,ledgeFall);
		}
		
		isPushing = false;
		pushBlock = instance_place(x+3*move2,y,obj_PushBlock);
		if(move2 == dir && grounded && !place_meeting(x,y+2,pushBlock))
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
			if(cSprint || global.autoSprint)
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
		
		moonFallState = false;
		moonFallCounter = 0;
		
		isPushing = false;
		pushBlock = noone;
	}
#endregion
#region Elevator
	if(state == State.Elevator)
	{
		dir = 0;
		stateFrame = State.Stand;
		mask_index = mask_Player_Stand;
		velX = 0;
		velY = 0;
		aimAngle = 0;
		
		var flag = true;
		var ship = instance_place(x,y+2,obj_Gunship);
		if(instance_exists(ship) && ship.state != ShipState.Idle)
		{
			flag = false;
		}
		var elev = instance_place(x,y+2,obj_Elevator);
		if(instance_exists(elev) && elev.activeDir != 0)
		{
			flag = false;
		}
		var savStat = instance_place(x,y,obj_SaveStation);
		if(instance_exists(savStat) && savStat.saving > 0)
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
		mask_index = mask_Player_Stand;
		velX = 0;
		velY = 0;
		aimAngle = 0;
		
		/*var flag = true;
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
		}*/
		if(!instance_exists(activeStation) || activeStation.activeDir == 0)
		{
			state = State.Stand;
		}
	}
#endregion
#region Crouch
	if(state == State.Crouch)
	{
		stateFrame = State.Crouch;
		if(CanChangeState(mask_Player_Crouch))
		{
			ChangeState(state,stateFrame,mask_Player_Crouch,false);
		}
		
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
		if(((cUp && rUp) || uncrouch >= 7) && CanChangeState(mask_Player_Stand) && crouchFrame <= 0)
		{
			aimUpDelay = 6;//10;
			ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
		}
		if(misc[Misc.Morph] && crouchFrame <= 0 && ((cDown && (rDown || !CanChangeState(mask_Player_Stand)) && move2 == 0) || (cMorph && rMorph)) && stateFrame != State.Morph && morphFrame <= 0)
		{
			audio_play_sound(snd_Morph,0,false);
			ChangeState(State.Morph,State.Morph,mask_Player_Morph,true);
			groundedMorph = true;
			morphFrame = 8;
		}
		else if(!grounded && CanChangeState(mask_Player_Jump))
		{
			ChangeState(State.Jump,State.Jump,mask_Player_Jump,false);
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
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
		landFrame = 0;
		
		if(grounded && !prevGrounded)
		{
			if(morphFrame <= 0 && !shineRampFix && !slopeGrounded)
			{
				if(!SpiderActive())
				{
					audio_stop_sound(snd_Land);
					audio_play_sound(snd_Land,0,false);
					
					if((speedKeep == 0 || (speedKeep == 2 && liquidMovement)) && canMorphBounce && !justBounced)
					{
						velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
						speedCounter = 0;
						speedBoost = false;
					}
				}
			}
		}
		
		if(!GrappleActive() && ((cUp && rUp) || (cJump && rJump && (!misc[Misc.Spring] || morphSpinJump)) || (cMorph && rMorph)) && unmorphing == 0 && morphFrame <= 0 && !spiderBall)
		{
			if(CanChangeState(mask_Player_Crouch))
			{
				audio_play_sound(snd_Morph,0,false);
				unmorphing = 1;
				morphFrame = 8;
				aimUpDelay = 10;
				
				if(cUp && rUp && move2 == 0)
				{
					velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
					velY = min(velY, 0);
					speedCounter = 0;
					speedBoost = false;
					unmorphing = 2;
				}
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
		if(unmorphing > 0)
		{
			var oldY = y;
			if(grounded)
			{
				ChangeState(state,stateFrame,mask_Player_Crouch,false);
				groundedMorph = true;
			}
			else
			{
				ChangeState(state,stateFrame,mask_Player_Somersault,false);
				groundedMorph = false;
			}
			
			aimUpDelay = 10;
			if(morphFrame <= 0)
			{
				if(morphSpinJump || (!grounded && unmorphing == 1))
				{
					ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
					frame[Frame.Somersault] = 2;
					morphSpinJump = false;
				}
				else
				{
					ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
					crouchFrame = 0;
					if(velX != 0 && grounded)
					{
						uncrouch = 7;
						if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
						{
							velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
							speedCounter = 0;
							speedBoost = false;
						}
					}
				}
			}
		}
		else
		{
			mask_index = mask_Player_Morph;
			morphSpinJump = false;
		}
		
		var ammo = missileStat+superMissileStat+powerBombStat;
		if((CanChangeState(mask_Player_Crouch) || crystalClip) && energy < lowEnergyThresh && ammo > 0 && cFlashStartCounter > 0 && cShoot && cDown)
		{
			cFlashStartCounter++;
			
			if(cFlashStartCounter > 70+60)
			{
				ChangeState(State.CrystalFlash,State.CrystalFlash,mask_Player_Crouch,true);
			}
		}
		else
		{
			cFlashStartCounter = 0;
		}
	}
	else
	{
		if(state != State.Hurt)
		{
			unmorphing = 0;
		}
		cFlashStartCounter = 0;
	}
	
	if((state == State.Morph || state == State.BallSpark) && (misc[Misc.MagBall] || misc[Misc.Spider]) && unmorphing == 0)
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
		/*if(global.spiderBallStyle == 2)
		{
			if(cDown && rDown && morphFrame <= 0)
			{
				SpiderEnable(true);
			}
			if(cJump && rJump)
			{
				SpiderEnable(false);
			}
		}*/

		if(!spiderBall)
		{
			spiderEdge = Edge.None;
			spiderMove = 0;
			spiderSpeed = 0;
			audio_stop_sound(snd_SpiderLoop);
		}
		else if(state == State.Morph)
		{
			if(spiderEdge != Edge.None && prevSpiderEdge == Edge.None )//&& grounded && !prevGrounded)
			{
				if(morphFrame <= 0 && !shineRampFix)
				{
					audio_play_sound(snd_SpiderStick,0,false);
					
					if(grounded && !prevGrounded)
					{
						audio_stop_sound(snd_SpiderLand);
						audio_play_sound(snd_SpiderLand,0,false);
						
						if(!spiderGrappleSpeedKeep && (speedKeep == 0 || (speedKeep == 2 && liquidMovement)))
						{
							spiderSpeed = min(abs(spiderSpeed),maxSpeed[MaxSpeed.Run,liquidState])*sign(spiderSpeed);
							speedCounter = 0;
							speedBoost = false;
						}
						jump = 0;
					}
				}
			}
			
			if(spiderGrappleSpeedKeep && spiderEdge != Edge.None)
			{
				spiderGrappleSpeedKeep = false;
			}
			
			if(spiderEdge != Edge.None)
			{
				if(!audio_is_playing(snd_SpiderLoop))
				{
					audio_play_sound(snd_SpiderLoop,0,true);
				}
				
				spiderPartCounter += max(abs(spiderSpeed),1);
				if(spiderPartCounter > spiderPartMax)
				{
					var _partType = obj_Particles.sbTrail;
					if(misc[Misc.Spider])
					{
						_partType = obj_Particles.sbTrail2;
					}
					var _num = max(abs(spiderSpeed)/2,1);
					var _partX = clamp(x+lengthdir_x(16,spiderJumpDir+180), bb_left(x), bb_right(x)),
						_partY = clamp(y+lengthdir_y(16,spiderJumpDir+180), bb_top(y), bb_bottom(y));
					var _partX1 = _partX + lengthdir_x(5,spiderJumpDir+90),
						_partY1 = _partY + lengthdir_y(5,spiderJumpDir+90),
						_partX2 = _partX + lengthdir_x(5,spiderJumpDir-90),
						_partY2 = _partY + lengthdir_y(5,spiderJumpDir-90);
					part_emitter_region(obj_Particles.partSystemA,obj_Particles.partEmitA, _partX1,_partX2, _partY1,_partY2, ps_shape_line, ps_distr_linear);
					part_emitter_burst(obj_Particles.partSystemA,obj_Particles.partEmitA,_partType,_num);
					spiderPartCounter = 0;
				}
			}
			else
			{
				audio_stop_sound(snd_SpiderLoop);
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
		
		spiderGrappleSpeedKeep = false;
	}
#endregion
#region Jump
	if(state == State.Jump)
	{
		if(dBoostFrame <= 0 || dBoostFrame >= 19)
		{
			stateFrame = State.Jump;
		}
		
		if(aimAngle == -2 || aimFrame <= -3)
		{
			downGrabDelay = 2;
		}
		if(downGrabDelay > 0)
		{
			ChangeState(state,stateFrame,mask_Player_AimDown,false);
			downGrabDelay--;
		}
		else if(CanChangeState(mask_Player_Jump))
		{
			ChangeState(state,stateFrame,mask_Player_Jump,false);
		}
		
		if(grounded )//|| PlayerGrounded())
		{
			if(!slopeGrounded)
			{
				if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
				{
					velX = min(abs(velX) * (power(abs(velX),0.25) - 1),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
					speedCounter = 0;
					speedBoost = false;
				}
				audio_play_sound(snd_Land,0,false);
			}
			
			if(mask_index == mask_Player_AimDown)
			{
				if(!CanChangeState(mask_Player_Stand))
				{
					ChangeState(State.Crouch,State.Crouch,mask_Player_AimDown,true);
					crouchFrame = 0;
				}
				else
				{
					ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
					landFrame = 7;
					smallLand = false;
				}
			}
			else
			{
				if(!CanChangeState(mask_Player_Stand))
				{
					crouchFrame = 5;
					ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
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
					ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
				}
			}
			
			if(slopeGrounded && state == State.Stand)
			{
				landFrame = 0;
				smallLand = false;
				
				brake = true;
				brakeFrame = 10;
				audio_play_sound(snd_Brake,0,false);
				stateFrame = State.Brake;
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
		mask_index = mask_Player_Somersault;
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
		
		if(grounded)
		{
			if(!slopeGrounded)
			{
				if(speedKeep == 0 || (speedKeep == 2 && liquidMovement))
				{
					velX = min(abs(velX) * (power(abs(velX),0.25) - 1),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
					speedCounter = 0;
					speedBoost = false;
				}
				audio_play_sound(snd_Land,0,false);
			}
			
			if(!CanChangeState(mask_Player_Stand))
			{
				var mask = mask_Player_Crouch;
				if(!CanChangeState(mask_Player_Crouch))
				{
					mask = mask_Player_Somersault;
				}
				ChangeState(State.Crouch,State.Crouch,mask,true);
				crouchFrame = 0;
			}
			else
			{
				ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
				landFrame = 7;
				smallLand = false;
			}
			
			if(slopeGrounded && state == State.Stand)
			{
				landFrame = 0;
				smallLand = false;
				
				brake = true;
				brakeFrame = 10;
				audio_play_sound(snd_Brake,0,false);
				stateFrame = State.Brake;
			}
		}
		else
		{
			landFrame = 0;
			var unchargeable = ((hudSlot == 1 && (hudSlotItem[1] == 0 || hudSlotItem[1] == 1 || hudSlotItem[1] == 3)) || hyperBeam);
			if(prAngle || (cUp && rUp) || (cDown && rDown) || (cShoot && rShoot) || (!cShoot && !rShoot && !unchargeable) || (!cShoot && rShoot && statCharge >= 20))
			{
				if(!CanChangeState(mask_Player_Jump))
				{
					ChangeState(State.Crouch,State.Crouch,mask_Player_Somersault,true);
					crouchFrame = 0;
				}
				else
				{
					var mask = mask_Player_Jump;
					if(aimAngle == -2 || aimFrame <= -3)
					{
						mask = mask_Player_Somersault;
					}
					ChangeState(State.Jump,State.Jump,mask,false);
				}
			}
		}
	}
	else
	{
		audio_stop_sound(snd_Somersault_Loop);
		audio_stop_sound(snd_Somersault);
		audio_stop_sound(snd_Somersault_SJ);
		somerSoundPlayed = false;
		somerUWSndCounter = 16;
	}
#endregion
#region Power Grip
	if(state == State.Grip)
	{
		gunReady = false;
		ledgeFall = false;
		ledgeFall2 = false;
		
		var breakGrip = false;
		if(startClimb)
		{
			stallCamera = true;
			if(climbIndex > 0)
			{
				if(climbIndex <= 7)
				{
					velY = 0;
				}
				
				if(stateFrame != State.Morph)
				{
					stateFrame = State.Grip;
					mask_index = mask_Player_Crouch;
					if(climbIndex >= 3 && climbTarget == 1)
					{
						audio_play_sound(snd_Morph,0,false);
						ChangeState(state,State.Morph,mask_Player_Morph,true);
						morphFrame = 8;
						groundedMorph = true;
					}
					else if(climbIndex > 17)
					{
						if(CanChangeState(mask_Player_Stand))
						{
							ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
							crouchFrame = 2;
						}
						else
						{
							ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
							crouchFrame = 0;
						}
					}
				}
				else if(climbIndex > 11 && !entity_place_collide(0,0))
				{
					ChangeState(State.Morph,State.Morph,mask_Player_Morph,true);
					groundedMorph = true;
				}
			}
		}
		else
		{
			velX = 0;
			velY = 0;
			
			stateFrame = State.Grip;
			mask_index = mask_Player_Jump;
			if(move2 != 0 && (!gripGunReady || gripGunCounter <= 0))
			{
				gripGunReady = (move2 != dir);
			}
			if(aimAngle != 0)
			{
				gripGunReady = true;
			}
			
			climbTarget = 0;
			if(!entity_place_collide(0,-8))
			{
				var ctStart = 0;
				while(ctStart >= -16 && entity_collision_line(x,bb_top()+ctStart,x+9*dir,bb_top()+ctStart))
				{
					ctStart--;
				}
				if(ctStart >= -16)
				{
					var morphH = 12,
						crouchH = 29;
				
					var ctHeight = -(crouchH+1);
					while(ctHeight <= -morphH && entity_collision_line(x,bb_top()+ctStart+ctHeight,x+9*dir,bb_top()+ctStart+ctHeight))
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
				ChangeState(State.Jump,State.Jump,mask_Player_Jump,true);
			}
			
			var rcheck = x+6,// - 1,
				lcheck = x;// - 1;
			if(dir == -1)
			{
				rcheck = x;
				lcheck = x-6;
			}
			if(!entity_collision_line(lcheck,y-17,rcheck,y-17))
			{
				breakGrip = true;
			}
		}
		
		var colFlag = false;
		var sColNum = collision_point_list(x+6*dir,y-18, array_concat(ColType_SolidSlope,ColType_MovingSolidSlope), true,true,blockList,true);
		for(var i = 0; i < sColNum; i++)
		{
			if(instance_exists(blockList[| i]))
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
		
		if((!entity_place_collide(2*dir,0) && !entity_place_collide(2*dir,4) && !entity_place_collide(0,2)) || (entity_position_collide(6*dir,-19) && !startClimb) || (colFlag && !startClimb) || (cDown && cJump && rJump) || (place_meeting(x,y,ColType_MovingSolid) && !startClimb))
		{
			breakGrip = true;
		}
		if(breakGrip)
		{
			if(stateFrame == State.Morph)
			{
				state = State.Morph;
			}
			else
			{
				ChangeState(State.Jump,State.Jump,mask_Player_Jump,true);
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
			mask_index = mask_Player_Morph;
		}
		else
		{
			stateFrame = State.Spark;
			mask_index = mask_Player_Jump;
		}
		speedCounter = speedCounterMax;
		speedBoost = true;
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
		shineRampFix = true;
		shineFXCounter = min(shineFXCounter + 0.05, 1);
		
		var aUp = false,
			aDown = false;
		if((move2 == 0 && !cUp && !cDown) || !spiderBall)
		{
			aUp = (aimAngle == 1);
			aDown = (aimAngle == -1);
		}
		
		if(shineStart > 0)
		{
			if(move2 != 0 || aUp || (aDown && boots[Boots.ChainSpark]))
			{
				if(aUp || cUp)
				{
					if(move2 != 0)
					{
						shineDir = 135*move2;
					}
					else
					{
						shineDir = 135*dir;
					}
				}
				else if((aDown || cDown) && boots[Boots.ChainSpark])
				{
					if(move2 != 0)
					{
						shineDir = 45*move2;
					}
					else
					{
						shineDir = 45*dir;
					}
				}
				else
				{
					shineDir = 90*move2;
				}
			}
			else
			{
				if(cDown && boots[Boots.ChainSpark])
				{
					shineDir = 0;
				}
				else
				{
					shineDir = 180;
				}
			}
			if((entity_place_collide(0,4) || (onPlatform && place_meeting(x,y+4,ColType_Platform))) && (!entity_place_collide(0,-1) || entity_place_collide(0,0)))
			{
				position.Y -= 1;
				y = scr_round(position.Y);
			}
			velX = 0;
			velY = 0;
			shineCharge = 0;
			shineSparkSpeed = shineSparkStartSpeed;
			shineReflecCounter = 0;
			
			if((cSprint || (cJump && !rSparkJump)) && (move2 != 0 || cUp || cDown || aUp || aDown))
			{
				shineStart = min(shineStart, 1);
			}
			
			if(shineStart == 1)
			{
				audio_play_sound(snd_ShineSpark,0,false);
				SparkDistort();
				if(move2 != 0)
				{
					dir = move2;
					dirFrame = 4*dir;
				}
			}
		}
		else if(state == State.BallSpark && shineLauncherStart > 0)
		{
			shineDir = 180;
			velX = 0;
			velY = 0;
			shineCharge = 0;
			shineSparkSpeed = shineSparkStartSpeed;
			shineReflecCounter = 0;
			
			if(shineLauncherStart == 1)
			{
				audio_play_sound(snd_ShineSpark,0,false);
				SparkDistort();
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
			shineReflecCounter = 0;
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
						shineDir = 135*move2;
					}
					else if(aDown || cDown)
					{
						shineDir = 45*move2;
					}
					else
					{
						shineDir = 90*move2;
					}
					audio_play_sound(snd_ShineSpark,0,false);
					SparkDistort();
					dir = move2;
					dirFrame = 4*dir;
					shineRestart = false;
					shineEnd = 0;
				}
				else if(cDown && move2 == -dir && chainSparkReCharge)
				{
					shineCharge = shineChargeMax;
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
						var sdir = shineDir + 180*i;
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
				speedCounter = 0;
				speedBoost = false;
			}
		}
		else
		{
			var oldSDir = shineDir;
			if (canDodge && shineSparkRedirect && (
				(global.dodgeStyle == 0 && cAimLock && rAimLock) || 
				(global.dodgeStyle == 1 && cSprint && rSprint)))
			{
				if(move2 != 0 || aUp || (aDown && boots[Boots.ChainSpark]))
				{
					if(aUp || cUp)
					{
						if(move2 != 0)
						{
							shineDir = 135*move2;
						}
						else
						{
							shineDir = 135*dir;
						}
					}
					else if((aDown || cDown) && boots[Boots.ChainSpark])
					{
						if(move2 != 0)
						{
							shineDir = 45*move2;
						}
						else
						{
							shineDir = 45*dir;
						}
					}
					else
					{
						shineDir = 90*move2;
					}
				}
				else if(cDown && boots[Boots.ChainSpark])
				{
					shineDir = 0;
				}
				else if(cUp)
				{
					shineDir = 180;
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
			if(!SparkDir_VertUp() && !SparkDir_VertDown())
			{
				dir = sign(shineDir);
			}
			shineCharge = 0;
			
			shineSparkSpeed = min(shineSparkSpeed+moveSpeed[MoveSpeed.Spark,liquidState], shineSparkSpeedMax);
			
			shineDirDiff = 0;
			if(shineSparkFlightAdjust)
			{
				var moveY = (cDown-cUp);
				moveY = clamp(moveY+(aDown-aUp),-1,1);
				
				var angleChange = 11.25;
				
				if(SparkDir_VertUp() || SparkDir_VertDown())
				{
					shineDirDiff -= angleChange*move2 * (SparkDir_VertUp() - SparkDir_VertDown());
				}
				if(SparkDir_DiagUp() || SparkDir_DiagDown())
				{
					var sdir = SparkDir_DiagUp() - SparkDir_DiagDown();
					shineDirDiff -= angleChange*clamp(move2*sign(GetSparkDir())*sdir + moveY,-1,1)*dir;
				}
				if(SparkDir_Hori())
				{
					shineDirDiff -= angleChange*moveY*dir;
				}
			}
			
			velX = lengthdir_x(shineSparkSpeed,shineDir-90+shineDirDiff);
			velY = lengthdir_y(shineSparkSpeed,shineDir-90+shineDirDiff);
			
			if(shineReflecCounter < shineSparkReflecMax || shineSparkReflecMax < 0)
			{
				var reflec = noone;
				/*for(var k = 0; k < ceil(shineSparkSpeed); k++)
				{
					var vX = sign(velX)*k, vY = sign(velY)*k;
					instance_place_list(x+vX,y+vY,obj_Reflec,reflecList,true);
				}*/
				collision_rectangle_list(bb_left()+min(velX,0),bb_top()+min(velY,0),bb_right()+max(velX,0),bb_bottom()+max(velY,0),obj_Reflec,true,true,reflecList,true);
				for(var i = 0; i < ds_list_size(reflecList); i++)
				{
					var _ref = reflecList[| i];
					if(instance_exists(_ref))
					{
						var p1 = _ref.GetPoint1(),
							p2 = _ref.GetPoint2();
						for(var k = 0; k < ceil(shineSparkSpeed); k++)
						{
							var vX = sign(velX)*k, vY = sign(velY)*k;
							if(lastReflec != _ref && rectangle_intersect_line(bb_left()+vX,bb_top()+vY,bb_right()+vX,bb_bottom()+vY, p1.X,p1.Y,p2.X,p2.Y))
							{
								reflec = _ref;
								break;
							}
						}
					}
					if(instance_exists(reflec))
					{
						break;
					}
				}
				ds_list_clear(reflecList);
			
				if(instance_exists(reflec) && lastReflec != reflec)
				{
					shineDir = ReflectAngle(shineDir-90, reflec.image_angle+90)+90;
					shineDir = scr_wrap(shineDir,-180,180);
					if(shineSparkReflecMax > 0)
					{
						shineReflecCounter++;
					}
				
					var p1 = reflec.GetPoint1(),
						p2 = reflec.GetPoint2();
					var vX = 0,
						vY = 0,
						_c = 0,
						_spd = ceil(shineSparkSpeed);
					while(!rectangle_intersect_line(bb_left()+vX,bb_top()+vY,bb_right()+vX,bb_bottom()+vY, p1.X,p1.Y,p2.X,p2.Y) && _c < _spd)
					{
						vX += sign(velX) * min(1,abs(velX)-abs(vX));
						vY += sign(velY) * min(1,abs(velY)-abs(vY));
						_c++;
					}
				
					velX = lengthdir_x(shineSparkSpeed,shineDir-90);
					velY = lengthdir_y(shineSparkSpeed,shineDir-90);
				
					while(_c < _spd)
					{
						vX += sign(velX) * min(1,abs(velX)-abs(vX));
						vY += sign(velY) * min(1,abs(velY)-abs(vY));
						_c++;
					}
				
					velX = vX;
					velY = vY;
				
					lastReflec = reflec;
				}
				else if(instance_exists(lastReflec))
				{
					if(!place_meeting(x,y,lastReflec))
					{
						lastReflec = noone;
					}
				}
			}
        
			if(cJump && rJump && shineSparkCancel)
			{
				if(state == State.BallSpark)
				{
					state = State.Morph;
				}
				else
				{
					ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
				}
				if(SparkDir_Hori())
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
				if(!SparkDir_VertUp() && !SparkDir_VertDown())
				{
					speedCounter = speedCounterMax;
					speedFXCounter = 1;
					audio_stop_sound(snd_ShineSpark);
				}
				else
				{
					speedCounter = 0;
					speedBoost = false;
				}
			}
		}
		
		sparkCancelSpiderJumpTweak = true;
		if(!cJump)
		{
			rSparkJump = false;
		}
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
		shineRampFix = false;
		shineRestart = false;
		
		shineSparkSpeed = shineSparkStartSpeed;
		
		if(!cJump)
		{
			sparkCancelSpiderJumpTweak = false;
		}
		
		rSparkJump = false;
	}
#endregion
#region Grapple
	if(state == State.Grapple)
	{
		stateFrame = State.Grapple;
		mask_index = mask_Player_Somersault;
		if(!GrappleActive())
		{
			ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
			var signx = (move2 != 0) ? move2 : sign(x - xprevious);
			if(signx != 0)
			{
				dir = signx;
				dirFrame = 4*dir;
			}
			if(abs(velX) <= minBoostSpeed*0.75)
			{
				speedBoost = false;
				speedCounter = 0;
			}
		}
	}
	else
	{
		if(grounded || abs(velX) < maxSpeed[MaxSpeed.Sprint,liquidState])
		{
			grapBoost = false;
		}
		
		grapWJCounter = 0;
		grapWallBounceCounter = 0;
		prevGrapVelocity = 0;
	}
#endregion
#region Hurt
	if(state == State.Hurt)
	{
		if(stateFrame != State.Morph || (unmorphing > 0 && morphFrame <= 0))
		{
			stateFrame = State.Hurt;
		}
		if(hurtTime <= 0)
		{
			if(lastState == State.Grip || lastState == State.Spark || (lastState == State.Morph && unmorphing > 0))
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
			hurtTime = max(hurtTime - 1, 0);
		}
		
		if(!speedBoost)
		{
			speedCounter = 0;
			speedBuffer = 0;
			speedBufferCounter = 0;
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
	
	if(state == State.Hurt || state == State.Stand || (state == State.Crouch && CanChangeState(mask_Player_Stand)) || state == State.Jump || state == State.Somersault)
	{
		if(dmgBoost > 0 && stateFrame != State.Morph && cJump && move2 == -dir)
		{
			ChangeState(State.DmgBoost,State.DmgBoost,mask_Player_Jump,false);
			dmgBoost = 0;
		}
	}
	else
	{
		dmgBoost = 0;
	}
#endregion
#region Damage Boost
	if(state == State.DmgBoost)
	{
		stateFrame = State.DmgBoost;
		mask_index = mask_Player_Jump;
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
		//if(((cJump && move2 == -dir) || velY < 0) && !grounded)
		if(cJump && move2 == -dir && !grounded)
		{
			if(move2 == -dir)
			{
				velX = moveSpeed[MoveSpeed.DmgBoost,liquidState]*move2;
			}
			if(!dmgBoostJump)
			{
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
				velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
				speedCounter = 0;
				speedBoost = false;
				audio_play_sound(snd_Land,0,false);
				if(!CanChangeState(mask_Player_Stand))
				{
					crouchFrame = 3;
					ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
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
					ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
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
	if(boots[Boots.Dodge] && dir != 0 && (state == State.Stand || state == State.Crouch || state == State.Jump || state == State.Somersault || (state == State.Grip && !startClimb)))
	{
		if ((global.dodgeStyle == 0 && cAimLock) || 
			(global.dodgeStyle == 1 && cSprint && !global.autoSprint))
		{
			dodgePress++;
			if(prevState == State.Morph)
			{
				dodgePress = 16;
			}
		}
		else if(canDodge)
		{
			if ((global.dodgeStyle == 0 && !rAimLock && dodgePress <= 15) || 
				(global.dodgeStyle == 1 && !global.autoSprint && !rSprint && dodgePress <= 15) || 
				(global.dodgeStyle == 1 && global.autoSprint && cSprint && rSprint))
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
				ChangeState(State.Dodge,State.Dodge,mask_Player_Crouch,(groundedDodge == 1));
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
		mask_index = mask_Player_Crouch;
		gunReady = true;
		ledgeFall = true;
		ledgeFall2 = true;
		
		var unchargeable = ((hudSlot == 1 && (hudSlotItem[1] == 0 || hudSlotItem[1] == 1 || hudSlotItem[1] == 3)) || hyperBeam);
		var shoot = cancelDashShoot && ((cShoot && rShoot) || (!cShoot && !rShoot && !unchargeable));
		if(dodgeLength >= dodgeLengthMax || shoot)
		{
			if(grounded)
			{
				if(!CanChangeState(mask_Player_Stand) || groundedDodge == 2)
				{
					ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
					crouchFrame = 0;
				}
				else
				{
					ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
					landFrame = 7;
					smallLand = false;
				}
			}
			else if(shoot)
			{
				if(!CanChangeState(mask_Player_Jump))
				{
					ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,false);
				}
				else
				{
					ChangeState(State.Jump,State.Jump,mask_Player_Jump,false);
				}
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
				velX = max(moveSpeed[MoveSpeed.Dodge,liquidState],abs(velX))*dodgeDir;
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
		mask_index = mask_Player_Crouch;
		immune = true;
		
		velX = 0;
		velY = 0;
		
		if(cFlashStartMove < 16)
		{
			cFlashStartMove++;
			
			if(crystalClip)
			{
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
			if(!CanChangeState(mask_Player_Jump))
			{
				ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
				crouchFrame = 0;
			}
			else
			{
				ChangeState(State.Jump,State.Jump,mask_Player_Jump,false);
			}
		}
		
		if(cFlashPal >= 1)
		{
			if(cFlashPalDiff <= 0)
			{
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

#region Set Shoot Pos
	shotOffsetX = 0;
	shotOffsetY = 0;
	
	if(stateFrame == State.Stand || stateFrame == State.Crouch)
	{
		switch aimAngle
		{
			case 2:
			{
				shotOffsetX = 2*dir2;
				shotOffsetY = -28;
				break;
			}
			case 1:
			{
				shotOffsetX = 21*dir2;
				shotOffsetY = -(21 + (dir == -1));
				break;
			}
			case -1:
			{
				shotOffsetX = 20*dir2;
				shotOffsetY = 10;
				break;
			}
			case -2:
			{
				shotOffsetX = (8+(dir == -1))*dir2;
				shotOffsetY = 19;
				break;
			}
			default:
			{
				shotOffsetX = 15*dir2;
				shotOffsetY = 1;
				break;
			}
		}
	}
	if(stateFrame == State.Walk || stateFrame == State.Moon || stateFrame == State.Run || stateFrame == State.Jump || stateFrame == State.Somersault ||
	stateFrame == State.Spark || stateFrame == State.Hurt || stateFrame == State.DmgBoost)
	{
		switch aimAngle
		{
			case 2:
			{
				shotOffsetX = 2*dir2;
				shotOffsetY = -28;
				break;
			}
			case 1:
			{
				shotOffsetX = 17*dir2;
				shotOffsetY = -20;
				if(stateFrame == State.Run)
				{
					shotOffsetX = 19*dir2;
					shotOffsetY = -21;
				}
				break;
			}
			case -1:
			{
				shotOffsetX = 18*dir2;
				shotOffsetY = 8;
				break;
			}
			case -2:
			{
				shotOffsetX = (7+(dir == -1))*dir2;
				shotOffsetY = 19;
				break;
			}
			default:
			{
				shotOffsetX = 15*dir2;
				shotOffsetY = 1;
				if(stateFrame == State.Walk || stateFrame == State.Run)
				{
					shotOffsetX = (21+(stateFrame == State.Run))*dir2;
					shotOffsetY = -2;
				}
				break;
			}
		}
	}
	if(stateFrame == State.Brake)
	{
		var _armPosR = [[4,2], [5,2], [7,2], [9,1], [12,1]],
			_armPosL = [[-14,2], [-15,2], [-16,2], [-16,1], [-17,1]];
		
		if(aimAngle == 1)
		{
			_armPosR = [[5,-16], [6,-16], [7,-17], [13,-18], [14,-19]];
			_armPosL = [[-12,-16], [-13,-16], [-14,-17], [-16,-19], [-17,-20]];
		}
		else if(aimAngle == -1)
		{
			_armPosR = [[1,12], [2,12], [3,11], [10,10], [12,9]];
			_armPosL = [[-11,11], [-12,11], [-13,10], [-14,9], [-16,8]];
		}
		else if(aimAngle == 2)
		{
			_armPosR = [[-6,-25], [-5,-25], [-4,-26], [0,-27], [1,-28]];
			_armPosL = [[0,-25], [-1,-25], [-2,-26], [-2,-27], [-4,-28]];
		}
		
		var _bFrame = clamp(5 - ceil(brakeFrame/2), 0, 4);
		var armPos = _armPosR[_bFrame];
		if(dir == -1)
		{
			armPos = _armPosL[_bFrame];
		}
		shotOffsetX = armPos[0];
		shotOffsetY = armPos[1];
	}
	if(stateFrame == State.Grip)
	{
		switch aimAngle
		{
			case 2:
			{
				shotOffsetX = 13*dir2;
				shotOffsetY = -31;
				if(dir == -1)
				{
					shotOffsetX = 12*dir2;
				}
				break;
			}
			case 1:
			{
				shotOffsetX = 28*dir2;
				shotOffsetY = -22;
				if(dir == -1)
				{
					shotOffsetX = 27*dir2;
					shotOffsetY = -22;
				}
				break;
			}
			case -1:
			{
				shotOffsetX = 27*dir2;
				shotOffsetY = 9;
				if(dir == -1)
				{
					shotOffsetX = 25*dir2;
					shotOffsetY = 10;
				}
				break;
			}
			case -2:
			{
				shotOffsetX = 11*dir2;
				shotOffsetY = 17;
				if(dir == -1)
				{
					shotOffsetX = 10*dir2;
					shotOffsetY = 18;
				}
				break;
			}
			default:
			{
				shotOffsetX = 30*dir2;
				shotOffsetY = -6;
				if(dir == -1)
				{
					shotOffsetX = 32*dir2;
					shotOffsetY = -8;
				}
				break;
			}
		}
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
	if(abs(fastWJCheckVel) < abs(prevVelX))
	{
		fastWJCheckVel = prevVelX;
	}
	if(grounded || abs(prevVelX) <= maxSpeed[MaxSpeed.Somersault,liquidState] || sign(prevVelX) != sign(fastWJCheckVel))
	{
		fastWJCheckVel = 0;
	}
	
	aimUpDelay = max(aimUpDelay - 1, 0);
	
	shineCharge = max(shineCharge - 1, 0);
	shineStart = max(shineStart - 1, 0);
	shineEnd = max(shineEnd - 1, 0);
	shineLauncherStart = max(shineLauncherStart - 1, 0);
	if(grapWallBounceCounter > 0)
	{
		grapWallBounceCounter = max(grapWallBounceCounter-1,0);
	}
	else
	{
		grapWallBounceCounter = min(grapWallBounceCounter+1,0);
	}
	justBounced = false;
	prevSpiderEdge = spiderEdge;
	
	//morphStall = max(morphStall-1,0);
	
	if(!PlayerGrounded() && !PlayerOnPlatform())
	{
		grounded = false;
	}
	if(!PlayerOnPlatform())
	{
		onPlatform = false;
	}
	
	slopeGrounded = false;
	prevGrounded = grounded;
	
	var xVel = x - xprevious,
		yVel = y - yprevious;
	if(justFell)
	{
		yVel = velY;
	}
	EntityLiquid_Large(xVel,yVel);
	
	if(IsChargeSomersaulting() || boostBallDmgCounter > 0)
	{
		immune = true;
	}
	if(IsSpeedBoosting() || IsScrewAttacking())
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
