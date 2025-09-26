/// @description Physics, States, etc.

if(HUDVisorSelected(HUDVisor.XRay) && global.pauseState == PauseState.XRay)
{
	aimAngle = 0;
}

if(!global.GamePaused())
{
	#region debug keys
	if(instance_exists(obj_Display))
	{
		debug = (obj_Display.debug > 0);
	}
	
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
		
			for(var i = 0; i < Item._Length; i++)
			{
				item[i] = true;
				hasItem[i] = true;
			}
		}
		#endregion
		#region 6
		if(keyboard_check_pressed(ord("6")))
		{
			var ilen = Item._Length;
			var rnum = irandom(ilen),
				rnum2 = ilen;
			while(rnum2 > 0)
			{
				if(rnum >= Item._Length)
				{
					if(energyMax < 1499)
					{
						energyMax += 100;
						energy = energyMax;
						break;
					}
					else
					{
						rnum = irandom(ilen-1);
					}
				}
				else if(rnum == Item.Missile && missileMax < 250)
				{
					missileMax += 5;
					missileStat = missileMax;
					item[Item.Missile] = true;
					break;
				}
				else if(rnum == Item.SuperMissile && superMissileMax < 50)
				{
					superMissileMax += 5;
					superMissileStat = superMissileMax;
					item[Item.SuperMissile] = true;
					break;
				}
				else if(rnum == Item.PowerBomb && powerBombMax < 50)
				{
					powerBombMax += 5;
					powerBombStat = powerBombMax;
					item[Item.PowerBomb] = true;
					break;
				}
				else if(!hasItem[rnum])
				{
					item[rnum] = true;
					break;
				}
				else
				{
					rnum = scr_wrap(rnum+1,0,ilen+1);
				}
				rnum2--;
			}
		
			for(var i = 0; i < Item._Length; i++)
			{
				if(!hasItem[i] && item[i])
				{
					hasItem[i] = true;
				}
			}
		}
		#endregion
		#region 5, 4, 3, 2
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
		if(keyboard_check_pressed(ord("2")))
		{
			energyMax += 100;
			//energy = energyMax;
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
	
	SetControlVars("player");
	if(state == State.Elevator || state == State.Recharge || state == State.CrystalFlash || introAnimState != -1)
	{
		InitControlVars("player");
	}
	
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
		
		if(global.control[INPUT_VERB.Start])
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
	if(item[Item.VariaSuit])
	{
		damageReduct *= 0.5;
	}
	if(item[Item.GravitySuit])
	{
		damageReduct *= 0.5;
	}
	
	if(global.grappleAimAssist && state != State.Morph && HUDWeaponSelected(HUDWeapon.GrappleBeam))
	{
		if(!instance_exists(grapReticle))
		{
			grapReticle = instance_create_depth(x,y,-4,obj_GrappleTargetAssist);
		}
	}
	else if(instance_exists(grapReticle))
	{
		instance_destroy(grapReticle);
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
	    liquidMovement = (liquidLevel > dph && !item[Item.GravitySuit]);
		
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

	move = cPlayerRight - cPlayerLeft;
	move2 = cPlayerRight - cPlayerLeft;
	pMove = ((cPlayerRight && rPlayerRight) - (cPlayerLeft && rPlayerLeft));
	
	if(move != 0 && !brake && morphFrame <= 0 && wjFrame <= 0 && (state != State.Grip || !startClimb) && 
	(!cMoonwalk || state == State.Somersault || state == State.Morph || (global.aimStyle == 2 && cAimUp)) && 
	!instance_exists(grapple) && state != State.Spark && state != State.BallSpark && state != State.Hurt && stateFrame != State.DmgBoost && dmgBoost <= 0 && state != State.Dodge)
	{
		dir = move;
		if(state == State.Grip && sign(dirFrame) != dir)
		{
			dirFrame = dir;
		}
	}
	if(SpiderActive())
	{
		if(spiderMove != 0)
		{
			dir = spiderMove;
		}
	}
	
	if(dir != oldDir)
	{
		lastDir = oldDir;
		
		brake = false;
		brakeFrame = 0;
	}
	
	walkState = ((cMoonwalk || instance_exists(grapple)) && velX != 0 && sign(velX) != dir && state == State.Stand);
	
	if(dir != 0 && cMorph && rMorph && morphFrame <= 0 && state != State.Crouch && state != State.Morph && stateFrame != State.Morph && item[Item.MorphBall] && state != State.Spark && state != State.BallSpark && state != State.Grip)
	{
		audio_play_sound(snd_Morph,0,false);
		if(state == State.Stand)
		{
			if(_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement))
			{
				velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
				speedCounter = 0;
				speedBoost = false;
			}
		}
		var oldY = y;
		ChangeState(State.Morph,State.Morph,mask_Player_Morph,grounded);
		morphFrame = 8;
		morphYDiff = y-oldY;
		
		if(GrappleActive() && (item[Item.MagniBall] || item[Item.SpiderBall]) && unmorphing == 0 && global.spiderBallStyle == 0)
		{
			SpiderEnable(true);
		}
	}
	
	dir2 = dir;
	//if(stateFrame == State.Grip)
	//{
	//	dir2 = -dir;
	//}

#region Aim Control
	prAngle = ((cAimUp && rAimUp) || (cAimDown && rAimDown));
	rlAngle = ((!cAimUp && !rAimUp) || (!cAimDown && !rAimDown));
	
	if(!instance_exists(grapple))
	{
		if((aimAngle > -2 && (aimAngle < 2 || state != State.Grip || rlAngle)) || prAngle || grounded || move != 0 || 
			state == State.Morph || state == State.Somersault || state == State.Spark || state == State.BallSpark)
		{
			aimAngle = 0;
		}
		if(state != State.Morph)
		{
			var _up = cPlayerUp,
				_down = cPlayerDown,
				_aimUp = cAimUp,
				_aimDown = cAimDown;
			if(cAimLock)
			{
				aimAngle = 2;
				_aimUp = false;
				_aimDown = false;
			}
			else
			{
				if(item[Item.MorphBall] && morphFrame <= 0 && state == State.Jump && !grounded && aimAngle == -2 && move == 0 && cPlayerDown && rPlayerDown && !cPlayerUp && !cAimUp && !cAimDown)
				{
					audio_play_sound(snd_Morph,0,false);
					var oldY = y;
					ChangeState(State.Morph,State.Morph,mask_Player_Morph,false);
					morphFrame = 8;
					morphYDiff = y-oldY;
				}
			}
			
			if(move != 0)
			{
				aimAngle = 0;
			}
			
			if(!_aimDown)
			{
				if((_up && move != 0) || _aimUp)
				{
					aimAngle = 1;
				}
				if(_up && (move == 0 || _aimUp))
				{
					aimAngle = 2;
				}
			}
			if(!_aimUp)
			{
				if((_down && move != 0) || _aimDown)
				{
					aimAngle = -1;
				}
				if(_down && (move == 0 || _aimDown))
				{
					aimAngle = -2;
				}
			}
			if(_aimUp && _aimDown && !cAimLock)
			{
				aimAngle = 2;
			}
			
			if(cAimLock)
			{
				cPlayerUp = false;
				cPlayerDown = false;
				cPlayerLeft = false;
				cPlayerRight = false;
				move = 0;
				move2 = 0;
			}
		}
	}
	
	/*if(!instance_exists(grapple))
	{
		if((aimAngle > -2 && (aimAngle < 2 || state != State.Grip || (rlAngle && global.aimStyle != 2))) ||
			(prAngle && global.aimStyle != 2) || grounded || move != 0 || instance_exists(XRay) || 
			state == State.Morph || state == State.Somersault || state == State.Spark || state == State.BallSpark)
		{
			aimAngle = 0;
		}
		if(!instance_exists(XRay))
		{
			if(!grounded && cPlayerDown && !cPlayerUp && state != State.Morph)
			{
				if(aimAngle == -2 && move == 0 && rPlayerDown && morphFrame <= 0 && state != State.Morph && item[Item.MorphBall] && state != State.Somersault && state != State.Spark && state != State.BallSpark && state != State.Grip && !cAimUp && !cAimDown)
				{
					audio_play_sound(snd_Morph,0,false);
					ChangeState(State.Morph,State.Morph,mask_Player_Morph,false);
					groundedMorph = false;
					morphFrame = 8;
				}
				
				aimAngle = -2;
			}
			
			if(((state != State.Morph && (state != State.Crouch || entity_place_collide(0,-11))) || (global.aimStyle == 2 && cAimUp)) && morphFrame <= 0)
			{
				if(move != 0 && (state != State.Grip || move != dir) && sign(dirFrame) == dir)
				{
					if(cPlayerUp && !cPlayerDown && aimUpDelay <= 0)
					{
						aimAngle = 1;
					}
					else if(cPlayerDown)
					{
						aimAngle = -1;
					}
				}
				else
				{
					if(cPlayerUp && !cPlayerDown && aimUpDelay <= 0)
					{
						aimAngle = 2;
					}
					if(cPlayerDown && !cPlayerUp && global.aimStyle == 2 && cAimUp && grounded)
					{
						aimAngle = -1;//-2;
					}
				}
			}
			
			if(!spiderBall)
			{
				if(global.aimStyle == 0)
				{
					if(cAimUp)
					{
						aimAngle = cAimUp + cAimDown;
					}
					else if(cAimDown)
					{
						aimAngle = -1;
					}
					
					if(!allowMovingVertAim && cAimUp && cAimDown && move != 0 && grounded && !walkState && sign(velX) == dir && abs(dirFrame) >= 4)
					{
						aimAngle = 1;
					}
					
					/*if(cAimUp)
					{
						if(extAimAngle == 0 || !cAimDown)
						{
							extAimAngle = 1;
						}
						else if(cAimDown && extAimAngle > 0)
						{
							extAimAngle = 2;
						}
					}
					if(cAimDown)
					{
						if(extAimAngle == 0 || !cAimUp)
						{
							extAimAngle = -1;
						}
						else if(cAimDown && extAimAngle < 0)
						{
							extAimAngle = -2;
						}
					}
					
					if(!cAimUp && !cAimDown)
					{
						extAimAngle = 0;
						extAimPreAngle = 0;
					}
					else
					{
						if((extAimAngle >= 2 && cPlayerDown && rPlayerDown) || (extAimAngle <= -2 && cPlayerUp && rPlayerUp))
						{
							extAimAngle *= -1;
						}
						
						aimAngle = extAimAngle;
						
						if(!cPlayerUp && !cPlayerDown)
						{
							extAimPreAngle = extAimAngle;
						}
						
						if(extAimAngle != extAimPreAngle && abs(extAimAngle) >= 2)
						{
							cPlayerUp = false;
							cPlayerDown = false;
						}
					}//
				}
				
				if(global.aimStyle == 1)
				{
					if(cAimUp)
					{
						if(extAimAngle == 0)
						{
							extAimAngle = 1;
						}
						
						if(extAimAngle == extAimPreAngle)
						{
							if(cPlayerUp && rPlayerUp)
							{
								extAimAngle = min(extAimAngle+1,2);
								if(extAimAngle == 0)
								{
									extAimAngle++;
								}
							}
							if(cPlayerDown && rPlayerDown)
							{
								extAimAngle = max(extAimAngle-1,-1);
								if(extAimAngle == 0)
								{
									extAimAngle--;
								}
							}
						}
						
						aimAngle = extAimAngle;
						
						if(!cPlayerUp && !cPlayerDown)
						{
							extAimPreAngle = extAimAngle;
						}
						
						if(extAimAngle != extAimPreAngle && abs(extAimAngle) >= 1)
						{
							cPlayerUp = false;
							cPlayerDown = false;
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
					if(cAimUp && !spiderBall)
					{
						cPlayerUp = false;
						cPlayerDown = false;
						cPlayerLeft = false;
						cPlayerRight = false;
						move = 0;
						move2 = 0;
					}
				}
			}
		}
	}*/
	
	if(aimAngle != prevAimAngle)
	{
		lastAimAngle = prevAimAngle;
	}
#endregion

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
			if(abs(velX) > lerp(maxSpeed[MaxSpeed.MorphBall,liquidState],maxSpeed[MaxSpeed.MockBall,liquidState],0.5) && liquidState <= 0)
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
			if(item[Item.SpringBall])
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
			if(item[Item.SpeedBooster])
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
		if((move == 1 && !brake && !cAimLock) || (state == State.Somersault && dir == 1 && velX > 1.1*moveSpeed[MoveSpeed.Normal,liquidState]))
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
		if((move == -1 && !brake && !cAimLock) || (state == State.Somersault && dir == -1 && velX < -1.1*moveSpeed[MoveSpeed.Normal,liquidState]))
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
			var _frict = fFrict;
			if(cAimLock)
			{
				_frict = turnaroundSpd;
			}
			if((aimAngle > -2 /*|| !cJump*/) && 
			(state != State.Morph || (state == State.Morph && abs(velX) <= maxSpeed[MaxSpeed.MorphBall,liquidState]) || grounded) && morphFrame <= 0)
			{
				if(velX > 0)
				{
					velX = max(velX - _frict, 0);
				}
				if(velX < 0)
				{
					velX = min(velX + _frict, 0);
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
		else if(state == State.Dodge && dodgeLength >= dodgeLengthEnd && !speedBoost)
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
	
	if(_FAST_WALLJUMP && _SPEEDBOOST_WALLJUMP)
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
			//if(!speedBoost && (_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement)))
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
	
	if(item[Item.SpeedBooster])
	{
		if(speedCounter >= speedCounterMax)
		{
			speedBoost = true;
		}
		else if(!speedBoost && (abs(velX) >= minBoostSpeed || abs(spiderSpeed) >= minBoostSpeed) && (state == State.Stand || !_RUN_RESTRICT_SB) && state != State.Dodge && state != State.Grapple && !grapBoost && !spiderJumpBoost)
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
			if(state == State.Stand && abs(velX) >= minBoostSpeed-fFrict && abs(velX) > 0 && !cPlayerDown && !brake)
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
	
	if((state == State.Stand || state == State.Crouch || state == State.Morph) && (speedBoost || speedCatchCounter > 0) && move == 0 && cPlayerDown && dir != 0 && grounded && morphFrame <= 0 && !SpiderActive())
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
			var climbUp = (move2 == grippedDir && cJump && rJump);
			if(global.gripStyle == 0)
			{
				climbUp |= (upClimbCounter >= 25 && cPlayerUp && move != -grippedDir);
			}
			if(global.gripStyle == 2)
			{
				climbUp = (move2 != -grippedDir && cJump && rJump) || (upClimbCounter >= 25 && cPlayerUp && move != -grippedDir);
			}
			if(cPlayerDown)
			{
				climbUp = false;
			}
			if(climbUp && !startClimb)
			{
				audio_play_sound(snd_Climb,0,false);
				startClimb = true;
				climbIndexCounter += 2;
			}
				
			canGripJump = (!climbUp && !cPlayerDown && cJump && rJump);
		}
	}
	
	var detectWJ = false;
	if(state == State.Jump || state == State.Somersault)
	{
		var detectRange = 8;
		if(_FAST_WALLJUMP)
		{
			detectRange += abs(prevVelX);
		}
		canWallJump = false;
		if((move != 0 || (_FAST_WALLJUMP && sign(velX) != 0 && move != sign(velX))) && wjFrame <= 0 && coyoteJump <= 0)
		{
			var _solids = array_concat(solids,ColType_Platform);
			var num = 0;
			if(move != 0)
			{
				num = instance_place_list(position.X+velX - detectRange*move, position.Y, _solids, blockList, true);
			}
			if(_FAST_WALLJUMP && sign(velX) != 0 && move != sign(velX))
			{
				num = instance_place_list(position.X+velX + detectRange*sign(velX), position.Y, _solids, blockList, true);
			}
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
							if(move != 0 && place_meeting(position.X+velX - detectRange*move, position.Y, block))
							{
								canWallJump = true;
							}
							detectWJ = _FAST_WALLJUMP;
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
			canWallJump = ((dir != grippedDir && move2 != grippedDir && !cPlayerDown) || (move2 != 0 && move2 != grippedDir));
		}
		else if(state != State.Grapple)
		{
			canWallJump = false;
		}
		wjAnimDelay = 10;
	}
	
	#region Jump Logic
	
	fJumpHeight = jumpHeight[item[Item.HiJump],liquidState];
	
	var isJumping = (cJump && dir != 0 && state != State.Spark && state != State.BallSpark && 
	state != State.Hurt && (!SpiderActive() || !sparkCancelSpiderJumpTweak) && (state != State.Grapple || grapWJCounter > 0)) && 
	(state != State.Morph || (!entity_place_collide(0,1) && !entity_place_collide(0,-1)) || (!entity_place_collide(0,1) ^^ !entity_place_collide(0,-1)) || entity_place_collide(0,0));
	if(isJumping)
	{
		if(velY > 0 && !grounded)
		{
			jumping = false;
		}
		
		var sjThresh = spaceJumpFallThresh[0];
		if(liquidTop)
		{
			sjThresh = spaceJumpFallThresh[1];
		}
		
		if(jump <= 0)
		{
			if(shineCharge > 0 && rJump && (CanChangeState(mask_Player_Jump) || state == State.Morph) && !entity_place_collide(0,-1) && 
			(move == 0 || velX == 0 || state == State.Jump) && state != State.Somersault && state != State.DmgBoost && ((!cAimDown && !cPlayerDown) || item[Item.ChainSpark]) && 
			(state != State.Morph || item[Item.SpringBall]) && morphFrame <= 0 && state != State.Grip)
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
			else if((rJump || (state == State.Morph && !SpiderActive() && rMorphJump) || bufferJump > 0) && quickClimbTarget <= 0 && 
			(state != State.Morph || (state == State.Morph && ((item[Item.SpringBall] && morphFrame <= 0) || ((unmorphing > 0 || morphSpinJump) && CanChangeState(mask_Player_Somersault))))) && state != State.DmgBoost)
			{
				if((grounded && !moonFallState) || coyoteJump > 0 || canWallJump || (state == State.Grip && canGripJump) || 
				(item[Item.SpaceJump] && velY >= sjThresh && state == State.Somersault && !liquidMovement && ((!detectWJ && rRespinJump) || bufferJump <= 1)))
				{
					if(!grounded && !canWallJump && item[Item.SpaceJump] && velY >= sjThresh)
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
						if(state == State.Grip && grippedDir != dir)
						{
							baseVel = moveSpeed[MoveSpeed.ClingWallJump,liquidState];
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
						
						if(_FAST_WALLJUMP)
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
								dist.alphaRateMultDecr = 0.3;//0.2;
								dist.spread = 0.5;
								dist.width = 0.5;
								dist.colorMult = -fastWJFlash;
								dist.alphaMult = 0.75;
								
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
						
						wallJumped = true;
						if(state == State.Grip || state == State.Grapple)
						{
							wallJumped = false;
						}
						ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
						//wallJumped = true;
						
						wjFrame = 8;
						wjAnimDelay = 10;
						
						var dRechargeMax = dodgeChargeCellSize * dodgeChargeCells;
						if(dodgeRecharge >= dRechargeMax-dodgeRechargeRate)
						{
							dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate, dRechargeMax);
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
					else if(state == State.Grip && dir != grippedDir)
					{
						dirFrame = dir;
					}
					/*else
					{
						wallJumped = false;
					}*/
					
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
					if((rJump || bufferJump > 0) && state == State.Morph && !item[Item.SpringBall])//(cSprint || !item[Item.SpringBall]) && boostBallCharge < boostBallChargeMin)
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
						if(state == State.Jump)
						{
							rRespinJump = false;
						}
						ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
						if(moonFallState && !moonFall)
						{
							moonFall = true;
						}
					}
					if(state == State.Morph && (cSprint || !item[Item.SpringBall]))
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
		
		fJumpSpeed = jumpSpeed[item[Item.HiJump],liquidState];
		if(wallJumped)
		{
			fJumpSpeed = jumpSpeed[2+item[Item.HiJump],liquidState];
		}
	
		if(item[Item.SpeedBooster] && abs(velX) > maxSpeed[MaxSpeed.Sprint,liquidState] && speedCounter > 0)
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
				spiderJumpBoost = true;
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
		
		if(state != State.Grapple)
		{
			bufferJump = max(bufferJump-1,0);
		}
	}
	else
	{
		if(state != State.Grapple)
		{
			bufferJump = bufferJumpMax;
			if(SpiderActive() || state == State.Spark || state == State.BallSpark || state == State.Grip)
			{
				bufferJump = 0;
			}
		}
		
		jump = 0;
		wallJumped = false;
		rRespinJump = true;
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
			spiderJumpBoost = true;
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
	
	if(state != State.Morph || !item[Item.SpringBall])
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
		var _lmult = 1 / (1+liquidMovement);
		
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
			    if(cFire)
			    {
			        grapWJCounter = 60;
			    }
				bufferJump = 0;
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
					if(point_distance(0,0,velX,velY) >= minBoostSpeed*0.75)
					{
						if(point_distance(0,0,velX,velY) < maxSpeed[MaxSpeed.SpeedBoost,liquidState]*1.25)
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
				
				var kickDir = 0;
				var grapVel = point_distance(0,0, velX,velY),
					detectKick = 8 + grapVel;
				var checkL = entity_place_collide(lengthdir_x(-detectKick, grapAngle), lengthdir_y(-detectKick, grapAngle)),
					checkR = entity_place_collide(lengthdir_x(detectKick, grapAngle), lengthdir_y(detectKick, grapAngle));
				if(checkL ^^ checkR)
				{
					if(checkL) { kickDir = 1; }
					if(checkR) { kickDir = -1; }
				}
				if(kickDir == 0 && (checkL || checkR))
				{
					kickDir = move;
				}
				
				if(cJump)
				{
					if(kickDir != 0 && (rJump || bufferJump > 0))
					{
						var kickSpeed = max(moveSpeed[MoveSpeed.GrappleKick,liquidState], grapVel);
			            velX = lengthdir_x(kickSpeed * kickDir,grapAngle);
						velY = lengthdir_y(kickSpeed * kickDir,grapAngle);
			            audio_play_sound(snd_WallJump,0,false);
			            grapWallBounceFrame = 15;
						
						if(!liquid)
						{
							var partLen = 25;
							var gAngle = grapAngle-90;
							for(var i = 0; i < 45; i++)
							{
								if(!entity_position_collide(lengthdir_x(partLen,gAngle), lengthdir_y(partLen,gAngle)))
								{
									gAngle -= kickDir;
								}
								else
								{
									gAngle += kickDir;
								}
							}
							
							var partX = x+lengthdir_x(partLen,gAngle),
								partY = y+lengthdir_y(partLen,gAngle);
							part_particles_create(obj_Particles.partSystemB,partX,partY,obj_Particles.bDust[0],3);
						}
						bufferJump = 0;
					}
					bufferJump = max(bufferJump-1,0);
				}
				else
				{
					bufferJump = bufferJumpMax;
				}
			}
			
			var _rlSpd = grappleReelSpd*_lmult,
				_rlMax = grappleReelMax*_lmult,
				_rlFrict = grappleReelFrict*_lmult;
			var up = (cPlayerUp && dist >= grappleMinDist),
				down = (cPlayerDown && dist <= grappleMaxDist);
			if(global.grappleStyle == 1 && move != 0)
			{
				up = false;
				down = false;
			}
			if(up)
			{
				if(grappleReelVel > 0)
				{
					_rlSpd += _rlFrict;
				}
				grappleReelVel = max(grappleReelVel - _rlSpd, -_rlMax, grappleMinDist-dist);
				grappleDist = min(dist,grappleMaxDist);
			}
			else if(down)
			{
				if(grappleReelVel < 0)
				{
					_rlSpd += _rlFrict;
				}
				grappleReelVel = min(grappleReelVel + _rlSpd, _rlMax, grappleMaxDist-dist);
				grappleDist = min(dist,grappleMaxDist);
			}
			else
			{
				if(grappleReelVel > 0)
				{
					grappleReelVel = max(grappleReelVel-_rlFrict, 0);
				}
				if(grappleReelVel < 0)
				{
					grappleReelVel = min(grappleReelVel+_rlFrict, 0);
				}
			}
			
			reel = grappleReelVel;
			if(dist >= grappleMaxDist+1)
			{
				var reelSpd = max(-3*_lmult, grappleMaxDist-dist);
				if(reelSpd < 0)
				{
					reel = reelSpd;
				}
				grappleDist = dist;
				grappleReelVel = min(grappleReelVel,0);
			}
			if(dist <= grappleMinDist-1)
			{
				var reelSpd = min(3*_lmult, grappleMinDist-dist);
				if(reelSpd > 0)
				{
					reel = reelSpd;
				}
				grappleDist = min(dist,grappleMaxDist);
				grappleReelVel = max(grappleReelVel,0);
			}
		}
		if(state == State.Morph)
		{
			grappleReelVel = max(grappleReelVel - spiderGrappleReelSpd*_lmult, -spiderGrappleReelMax*_lmult);
			reel = grappleReelVel;
			grappleDist = min(dist,grappleMaxDist);
			
			velX = (velX > 0) ? max(velX-fFrict/2,0) : min(velX+fFrict/2,0);
			velY = (velY > 0) ? max(velY-fFrict/2,0) : min(velY+fFrict/2,0);
			
			canMorphBounce = false;
			
			if((item[Item.MagniBall] || item[Item.SpiderBall]) && unmorphing == 0)
			{
				spiderGrappleSpeedKeep = true;
			}
			if(abs(fVelX) <= 1 && abs(fVelY) <= 1)
			{
				spiderGrappleUnstuck++;
			}
			else
			{
				spiderGrappleUnstuck = max(spiderGrappleUnstuck-1,0);
			}
		}
		
		var vX = position.X - grapple.x,
			vY = position.Y - grapple.y;
		
		grappleDist += reel;
		
		var ddist = ndist - dist;
		vX /= dist;
		vY /= dist;
		velX -= vX * ddist;
		velY -= vY * ddist;
		vX *= grappleDist;
		vY *= grappleDist;
		grappleVelX = (grapple.x + vX) - position.X;
		grappleVelY = (grapple.y + vY) - position.Y;
		
		grapDisVel = reel;
		
		grapBoost = true;
		
		if(state == State.Morph)
		{
			if(point_distance(position.X+velX+grappleVelX,position.Y+velY+grappleVelY,grapple.x,grapple.y) <= 24 || !cFire || spiderGrappleUnstuck > 10)
			{
				instance_destroy(grapple);
				velX += grappleVelX;
				velY += grappleVelY;
				grappleVelX = 0;
				grappleVelY = 0;
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
		grappleReelVel = 0;
		spiderGrappleUnstuck = 0;
	}

#endregion

#region Boost Ball Movement
	if((state == State.Morph || state == State.BallSpark || state == State.Grip || state == State.Hurt) && stateFrame == State.Morph && item[Item.BoostBall] && unmorphing == 0)
	{
		if(cBoostBall)
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
			if(!rBoostBall && boostBallCharge >= boostBallChargeMin && state == State.Morph)
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
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = 0;
			if(state != State.BallSpark && !spiderJump && jump <= 0)
			{
				if(entity_place_collide(0,1) && Crawler_CanStickBottom())
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
		}
		else
		{
			if ((spiderEdge == Edge.Bottom && !entity_place_collide(0,2) && !entity_place_collide(2,2) && !entity_place_collide(-2,2)) ||
				(spiderEdge == Edge.Left && !entity_place_collide(-2,0) && !entity_place_collide(-2,2) && !entity_place_collide(-2,-2)) ||
				(spiderEdge == Edge.Top && !entity_place_collide(0,-2) && !entity_place_collide(2,-2) && !entity_place_collide(-2,-2)) || 
				(spiderEdge == Edge.Right && !entity_place_collide(2,0) && !entity_place_collide(2,2) && !entity_place_collide(2,-2)))
			{
				spiderEdge = Edge.None;
			}
			
			if(state == State.BallSpark && (shineStart > 0 || shineLauncherStart > 0))
			{
				spiderEdge = Edge.None;
			}
			
			canMorphBounce = false;
			rMorphJump = false;
			
			var moveX = (cPlayerRight-cPlayerLeft),
		        moveY = (cPlayerDown-cPlayerUp);
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
					velX = spiderSpeed;
					velY = 1;
				break;
				case Edge.Left:
					velX = -1;
					velY = spiderSpeed;
				break;
				case Edge.Top:
					velX = -spiderSpeed;
					velY = -1;
				break;
				case Edge.Right:
					velX = 1;
					velY = -spiderSpeed;
				break;
			}
			
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
		if(spiderEdge != Edge.None && spiderSpeed != 0 && !spiderJump)
		{
			velY = 0;
			if(PlayerGrounded() || PlayerOnPlatform())
			{
				velX = spiderSpeed*sign(lengthdir_x(1, GetEdgeAngle(spiderEdge)));
				if(PlayerGrounded())
				{
					grounded = true;
				}
				if(PlayerOnPlatform())
				{
					onPlatform = true;
				}
				prevGrounded = grounded;
				colEdge = Edge.Bottom;
			}
			else
			{
				switch(spiderEdge)
				{
					case Edge.Bottom:
						velX = spiderSpeed;
						velY = lengthdir_y(spiderSpeed, GetEdgeAngle(Edge.Bottom));
					break;
					case Edge.Top:
						velX = -spiderSpeed;
						velY = lengthdir_y(spiderSpeed, GetEdgeAngle(Edge.Top));
					break;
					case Edge.Right:
						velX = lengthdir_x(spiderSpeed, GetEdgeAngle(Edge.Right));
						velY = -spiderSpeed;
					break;
					case Edge.Left:
						velX = lengthdir_x(spiderSpeed, GetEdgeAngle(Edge.Left));
						velY = spiderSpeed;
					break;
				}
			}
		}
		spiderEdge = Edge.None;
		spiderMove = 0;
		spiderSpeed = 0;
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

	if(item[Item.PowerGrip] && (state == State.Jump || state == State.Somersault) && morphFrame <= 0 && !grounded && abs(dirFrame) >= 4 && velY >= 0 && move2 != 0)
	{
		if(!entity_place_collide(0,-4) && ((state == State.Jump && !entity_place_collide(0,3)) || (state == State.Somersault && !entity_place_collide(0,13))))
		{
			var _px = position.X,
				_py = position.Y;
			var vcheck = _px+6,// - 1,
				rcheck = _px+6,// - 1,
				lcheck = _px;// - 1;
			if(move2 == -1)
			{
				vcheck = _px-6;
				rcheck = _px;
				lcheck = _px-6;
			}
			
			var canGrip = true;
			var num = instance_place_list(_px+move2,_py,solids,blockList,true);
				num += collision_line_list(lcheck,_py-17,rcheck,_py-17,solids,true,true,blockList,true);
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
			
			if(entity_collision_line(lcheck,_py-17,rcheck,_py-17) && !entity_collision_line(lcheck,_py-22,rcheck,_py-26) && entity_place_collide(move2,0) && dir == move2)
			{
				var rslopeX = _px+14,// - 1,
					rslopeY = _py-25,
					lslopeX = _px+6,// - 1,
					lslopeY = _py-17;
				if(move2 == -1)
				{
					rslopeX = _px-6;
					rslopeY = _py-17;
					lslopeX = _px-14;
					lslopeY = _py-25;
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
					grippedDir = dir;
					
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
			var _px = position.X,
				_py = position.Y;
			
			// using a for loop to cut down on duplicate code like this is probably pretty stupid.
			// then again, 'if it looks stupid, but works, it isn't stupid.'
			for(var i = 0; i < 2; i++)
			{
				var lcheck = _px,// - 1,
					rcheck = _px+7;// - 1;
				if(dir == -1)
				{
					lcheck = _px-7;
					rcheck = _px;
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
					
					lcheck = _px+6;// - 1;
					rcheck = _px+14;// - 1;
					var rcheckY = yHeight-9,
						lcheckY = yHeight-1;
					if(dir == -1)
					{
						lcheck = _px-14;
						rcheck = _px-6;
						
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
					
					lcheck = _px-4;// - 1;
					rcheck = _px+14;// - 1;
					if(dir == -1)
					{
						lcheck = _px-14;
						rcheck = _px+4;
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
						else if(item[Item.MorphBall])
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
			grippedDir = dir;
			
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
	pushBlock = noone;
	
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
		
		if(_ARM_PUMP && prAngle && fVelX != 0 && move == dir && grounded && state == State.Stand)
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
		Collision_Crawler(fVelX,fVelY, (state != State.Grip), (state == State.Elevator));
	}
	else
	{
		Collision_Normal(fVelX,fVelY, (state != State.Grip), (state == State.Elevator));
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
	var shouldForceDown = (state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge && jump <= 0 && bombJump <= 0 && !SpiderActive());
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
		
		if(cMoonwalk && move != 0 && move != dir && !entity_place_collide(-3*dir,4))
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
			if(cPlayerDown && move2 == 0 && velX == 0 && dir != 0 && grounded)
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
			if(ele.activeDir == 0 && (ele.elevatorID != -1 || ele.singleRoom) && ((ele.upward && cPlayerUp && rPlayerUp) || (ele.downward && cPlayerDown && rPlayerDown)) && move2 == 0 && velX == 0 && dir != 0 && grounded)
			{
				ele.activeDir = (cPlayerDown-cPlayerUp);
				state = State.Elevator;
				dir = 0;
				aimAngle = 0;
			}
		}
		
		if(canCrouch && move2 == 0 && cPlayerDown && dir != 0 && grounded)
		{
			crouchFrame = 5;
			aimAnimDelay = 6;
			ChangeState(State.Crouch,State.Crouch,mask_Player_Crouch,true);
		}
		if(!grounded && dir != 0)
		{
			ChangeState(State.Jump,State.Jump,mask_Player_Jump,ledgeFall);
		}
		
		isPushing = false;
		pushBlock = instance_place(x+2*move2, y, obj_PushBlock);
		if(move2 == dir && grounded && !place_meeting(x, y+2, pushBlock))
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
                vX *= 0.875;
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
		if(((cPlayerUp && rPlayerUp) || uncrouch >= 7) && CanChangeState(mask_Player_Stand) && crouchFrame <= 0)
		{
			//aimUpDelay = 6;//10;
			aimAnimDelay = 6;
			ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
		}
		if(item[Item.MorphBall] && crouchFrame <= 0 && ((cPlayerDown && (rPlayerDown || !CanChangeState(mask_Player_Stand)) && move2 == 0) || (cMorph && rMorph)) && stateFrame != State.Morph && morphFrame <= 0)
		{
			audio_play_sound(snd_Morph,0,false);
			var oldY = y;
			ChangeState(State.Morph,State.Morph,mask_Player_Morph,true);
			morphYDiff = y-oldY;
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
					
					if((_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement)) && canMorphBounce && !justBounced)
					{
						velX = min(abs(velX),maxSpeed[MaxSpeed.Run,liquidState])*sign(velX);
						speedCounter = 0;
						speedBoost = false;
					}
				}
			}
		}
		
		if(!GrappleActive() && ((cPlayerUp && rPlayerUp) || (cJump && rJump && (!item[Item.SpringBall] || morphSpinJump)) || (cMorph && rMorph)) && unmorphing == 0 && morphFrame <= 0 && !SpiderActive()) //!spiderBall)
		{
			if(CanChangeState(mask_Player_Crouch))
			{
				audio_play_sound(snd_Morph,0,false);
				unmorphing = 1;
				morphFrame = 8;
				//aimUpDelay = 10;
				aimAnimDelay = 6;
				
				if(cPlayerUp && rPlayerUp && move2 == 0)
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
			}
			else
			{
				ChangeState(state,stateFrame,mask_Player_Somersault,false);
			}
			if(morphFrame >= 8)
			{
				morphYDiff = y-oldY;
			}
			
			//aimUpDelay = 10;
			aimAnimDelay = 6;
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
						if(_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement))
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
		
		// Crystal Flash activation
		var ammo = missileStat+superMissileStat+powerBombStat;
		if((CanChangeState(mask_Player_Crouch) || _CRYSTAL_CLIP) && energy < lowEnergyThresh && ammo > 0 && cFlashStartCounter > 0 && cFire && cPlayerDown)
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
		audio_stop_sound(snd_SpiderLoop);
	}
	
	if((state == State.Morph || state == State.BallSpark) && (item[Item.MagniBall] || item[Item.SpiderBall]) && unmorphing == 0)
	{
		if(global.controlInput[INPUT_VERB.SpiderBall].pressType == PressType.Press)
		{
			if(cSpiderBall && rSpiderBall)
			{
				SpiderEnable(!spiderBall);
			}
		}
		if(global.controlInput[INPUT_VERB.SpiderBall].pressType == PressType.Hold)
		{
			SpiderEnable(cSpiderBall);
		}
	}
	else
	{
		SpiderEnable(false);
		spiderGrappleSpeedKeep = false;
	}
	
	if(spiderBall)
	{
		if(spiderEdge == Edge.None)
		{
			if(jump <= 0 && bombJump <= 0)
			{
				spiderJumpDir = 90;
				spiderJump_SpeedAddX = 0;
				spiderJump_SpeedAddY = 0;
			}
			audio_stop_sound(snd_SpiderLoop);
		}
		else
		{
			spiderJump = false;
			spiderJumpDir = scr_wrap(GetEdgeAngle(spiderEdge) + 90,0,360);
			switch(spiderEdge)
			{
				case Edge.Bottom:
					spiderJump_SpeedAddX = velX;
					spiderJump_SpeedAddY = 0;
				break;
				case Edge.Left:
					spiderJump_SpeedAddX = 0;
					spiderJump_SpeedAddY = velY;
				break;
				case Edge.Top:
					spiderJump_SpeedAddX = velX;
					spiderJump_SpeedAddY = 0;
				break;
				case Edge.Right:
					spiderJump_SpeedAddX = 0;
					spiderJump_SpeedAddY = velY;
				break;
			}
			
			if(prevSpiderEdge == Edge.None)
			{
				if(morphFrame <= 0 && !shineRampFix)
				{
					audio_play_sound(snd_SpiderStick,0,false);
					
					if(grounded && !prevGrounded)
					{
						audio_stop_sound(snd_SpiderLand);
						audio_play_sound(snd_SpiderLand,0,false);
						
						if(!spiderGrappleSpeedKeep && (_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement)))
						{
							spiderSpeed = min(abs(spiderSpeed),maxSpeed[MaxSpeed.Run,liquidState])*sign(spiderSpeed);
							speedCounter = 0;
							speedBoost = false;
						}
						jump = 0;
					}
				}
			}
			spiderGrappleSpeedKeep = false;
			
			if(!audio_is_playing(snd_SpiderLoop))
			{
				audio_play_sound(snd_SpiderLoop,0,true);
			}
			
			spiderPartCounter += max(abs(spiderSpeed),1);
			if(spiderPartCounter > spiderPartMax)
			{
				var _partType = obj_Particles.sbTrail;
				if(item[Item.SpiderBall])
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
	}
	else
	{
		audio_stop_sound(snd_SpiderLoop);
		if((jump <= 0 && bombJump <= 0) || grounded)
		{
			spiderJump = false;
			spiderJumpDir = 90;
			spiderJump_SpeedAddX = 0;
			spiderJump_SpeedAddY = 0;
		}
		if(grounded || abs(velX) < maxSpeed[MaxSpeed.MockBall,liquidState])
		{
			spiderJumpBoost = false;
		}
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
				if(_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement))
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
					if(item[Item.SpaceJump])
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
			if(item[Item.ScrewAttack])
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
			if(oldDir != dir && item[Item.SpaceJump] && !item[Item.ScrewAttack] && wjAnimDelay <= 0)
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
				if(_SPEED_KEEP == 0 || (_SPEED_KEEP == 2 && liquidMovement))
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
			//var unchargeable = ((hudSlot == 1 && (hudSlotItem[1] == 0 || hudSlotItem[1] == 1 || hudSlotItem[1] == 3)) || hyperBeam);
			//if(prAngle || (cPlayerUp && rPlayerUp) || (cPlayerDown && rPlayerDown) || (cFire && rFire) || (!cFire && !rFire && !unchargeable) || (!cFire && rFire && statCharge >= 20))
			if(prAngle || (cPlayerUp && rPlayerUp) || (cPlayerDown && rPlayerDown) || (cFire && rFire) || (!cFire && !rFire && CanCharge()) || (!cFire && rFire && statCharge >= 20))
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
		
		var _px = position.X,
			_py = position.Y;
		
		var breakGrip = false;
		var _dir = grippedDir;
		
		if(startClimb)
		{
			dir = _dir;
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
						var oldY = y;
						ChangeState(state,State.Morph,mask_Player_Morph,true);
						morphFrame = 8;
						morphYDiff = y-oldY;
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
				}
			}
		}
		else
		{
			velX = 0;
			velY = 0;
			
			stateFrame = State.Grip;
			mask_index = mask_Player_Jump;
			
			climbTarget = 0;
			if(!entity_place_collide(0,-8))
			{
				var ctStart = 0;
				while(ctStart >= -16 && entity_collision_line(_px,bb_top()+ctStart,_px+9*_dir,bb_top()+ctStart))
				{
					ctStart--;
				}
				if(ctStart >= -16)
				{
					var morphH = 12,
						crouchH = 29;
				
					var ctHeight = -(crouchH+1);
					while(ctHeight <= -morphH && entity_collision_line(_px,bb_top()+ctStart+ctHeight,_px+9*_dir,bb_top()+ctStart+ctHeight))
					{
						ctHeight++;
					}
					if(ctHeight <= -crouchH)
					{
						climbTarget = 2;
					}
					else if(ctHeight <= -morphH && item[Item.MorphBall])
					{
						climbTarget = 1;
					}
				}
			}
			
			if(cPlayerUp && move != -_dir && (global.gripStyle == 0 || global.gripStyle == 2))
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
			
			var rcheck = _px+6,// - 1,
				lcheck = _px;// - 1;
			if(_dir == -1)
			{
				rcheck = _px;
				lcheck = _px-6;
			}
			if(!entity_collision_line(lcheck,_py-17,rcheck,_py-17))
			{
				breakGrip = true;
			}
		}
		
		var colFlag = false;
		var sColNum = collision_point_list(_px+6*_dir,_py-18, array_concat(ColType_SolidSlope,ColType_MovingSolidSlope), true,true,blockList,true);
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
		
		if((!entity_place_collide(2*_dir,0) && !entity_place_collide(2*_dir,4) && !entity_place_collide(0,2)) || (entity_position_collide(6*_dir,-19) && !startClimb) || (colFlag && !startClimb) || (cPlayerDown && cJump && rJump) || (place_meeting(_px,_py,ColType_MovingSolid) && !startClimb))
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
				if((!cJump || cPlayerDown) && dir != grippedDir)
				{
					dirFrame = dir;
				}
				gunReady = false;
				ledgeFall = true;
				ledgeFall2 = true;
			}
			if(cPlayerDown && cJump && rJump)
			{
				velY += 1;
			}
		}
	}
	else
	{
		gripTurnFrame = 0;
		gripAimAnim = 0;
		
		upClimbCounter = 0;
		startClimb = false;
		climbTarget = 0;
		climbIndex = 0;
		climbFrame = 0;
		grippedDir = 0;
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
		if((move2 == 0 && !cPlayerUp && !cPlayerDown) || !spiderBall)
		{
			aUp = (aimAngle == 1);
			aDown = (aimAngle == -1);
		}
		var allowDown = true; //item[Item.ChainSpark];
		
		if(shineStart > 0)
		{
			if(move2 != 0 || aUp || (aDown && allowDown))
			{
				if(aUp || cPlayerUp)
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
				else if((aDown || cPlayerDown) && allowDown)
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
				if(cPlayerDown && allowDown)
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
			
			if((cSprint || (cJump && !rSparkJump)) && (move2 != 0 || cPlayerUp || cPlayerDown || aUp || aDown))
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
				
				if(instance_exists(obj_ScreenShaker))
				{
					obj_ScreenShaker.Shake(12);
				}
				SparkDistort(1, 0.5);
			}
			velX = 0;
			velY = 0;
			shineSparkSpeed = shineSparkStartSpeed;
			shineReflecCounter = 0;
			if(shineRestart && item[Item.ChainSpark])
			{
				if(dir == sign(shineDir))
				{
					dir *= -1;
					dirFrame = dir;
				}
				else if(move2 == dir)
				{
					if(aUp || cPlayerUp)
					{
						shineDir = 135*move2;
					}
					else if(aDown || cPlayerDown)
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
				else if(cPlayerDown && move2 == -dir && _SPARK_CHAIN_RECHARGE)
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
			if (canDodge && _SPARK_CONTROL && (
				(global.dodgeStyle == 0 && cMoonwalk && rMoonwalk) || 
				(global.dodgeStyle == 1 && cSprint && rSprint)))
			{
				if(move2 != 0 || aUp || (aDown && allowDown))
				{
					if(aUp || cPlayerUp)
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
					else if((aDown || cPlayerDown) && allowDown)
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
				else if(cPlayerDown && allowDown)
				{
					shineDir = 0;
				}
				else if(cPlayerUp)
				{
					shineDir = 180;
				}
				if(shineDir != oldSDir)
				{
					dodgeCharge = max(dodgeCharge - dodgeChargeCellSize, 0);
					dodgeRecharge = dodgeCharge;
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
			if(_SPARK_STEERING)
			{
				var moveY = (cPlayerDown-cPlayerUp);
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
			
			if(shineDiagSpeedFlag)
			{
				shineDirDiff = 0;
				if(SparkDir_DiagUp())
				{
					shineDiagAngleTweak = min(shineDiagAngleTweak+1, 45);
				}
				if(SparkDir_DiagDown())
				{
					shineDiagAngleTweak = max(shineDiagAngleTweak-1, -45);
				}
			}
			else
			{
				shineDiagAngleTweak = 0;
			}
			shineDiagSpeedFlag = false;
			
			var shineDirDiff2 = shineDirDiff + shineDiagAngleTweak*dir;
			
			velX = lengthdir_x(shineSparkSpeed,shineDir-90+shineDirDiff);
			velY = lengthdir_y(shineSparkSpeed,shineDir-90+shineDirDiff2);
			
			if(shineReflecCounter < _SPARK_REFLEC_MAX || _SPARK_REFLEC_MAX < 0)
			{
				var reflec = noone;
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
					if(_SPARK_REFLEC_MAX > 0)
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
        
			if(cJump && rJump && _SPARK_CANCEL)
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
					if(item[Item.SpaceJump] && state != State.Morph)
					{
						velY = -jumpSpeed[item[Item.HiJump],liquidState];
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
		
		shineDiagSpeedFlag = false;
		shineDiagAngleTweak = 0;
		
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
		if(!instance_exists(obj_DeathAnim))
		{
			var d = instance_create_depth(x,y,-6,obj_DeathAnim);
			d.posX = x-camera_get_view_x(view_camera[0]);
			d.posY = y-camera_get_view_y(view_camera[0]);
			d.dir = dir;
			global.pauseState = PauseState.DeathAnim;
		}
	}
#endregion
#region Dodge
	
	var dRechargeMax = dodgeChargeCellSize * dodgeChargeCells;
	if(dodgeRecharge >= dRechargeMax)
	{
		dodgeCharge = dRechargeMax;
	}
	canDodge = (item[Item.AccelDash] && dodgeCharge >= dodgeChargeCellSize);
	
	if(item[Item.AccelDash] && dir != 0 && (state == State.Stand || state == State.Crouch || state == State.Jump || state == State.Somersault || (state == State.Grip && !startClimb) || state == State.Dodge))
	{
		if(canDodge && cDodge && rDodge)
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
			ChangeState(State.Dodge,State.Dodge,mask_Player_Crouch,(groundedDodge == 1));
			dodgeLength = 0;
			dodged = false;
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
	}
	if(state == State.Dodge)
	{
		stateFrame = State.Dodge;
		mask_index = mask_Player_Crouch;
		gunReady = true;
		ledgeFall = true;
		ledgeFall2 = true;
		
		//var unchargeable = ((hudSlot == 1 && (hudSlotItem[1] == 0 || hudSlotItem[1] == 1 || hudSlotItem[1] == 3)) || hyperBeam);
		//var shoot = _DASH_SHOOT_CANCEL && ((cFire && rFire) || (!cFire && !rFire && !unchargeable));
		var shoot = _DASH_SHOOT_CANCEL && ((cFire && rFire) || (!cFire && !rFire && CanCharge()));
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
				ChangeState(State.Somersault,State.Somersault,mask_Player_Somersault,false);
			}
		}
		else
		{
			if(dodgeLength < dodgeLengthEnd)
			{
				var ms_spd = moveSpeed[MoveSpeed.Dodge,liquidState],
					max_spd_d = maxSpeed[MaxSpeed.Dodge,liquidState],
					max_spd_s = maxSpeed[MaxSpeed.SpeedBoost,liquidState];
				if(abs(velX) < max_spd_d)
				{
					if(dodgeDir == 1)
					{
						velX = min(velX + ms_spd, max_spd_d);
					}
					if(dodgeDir == -1)
					{
						velX = max(velX - ms_spd, -max_spd_d);
					}
				}
				else if(!liquidMovement && (dodgeLength <= 0 || abs(velX) > max_spd_d) && abs(velX) < max_spd_s)
				{
					if(dodgeDir == 1)
					{
						velX = min(velX + ms_spd, max_spd_s);
					}
					if(dodgeDir == -1)
					{
						velX = max(velX - ms_spd, -max_spd_s);
					}
				}
			}
			dodgeLength += (1 / (1+liquidMovement));
			
			if(!dodged)
			{
				dodgeCharge = max(dodgeCharge - dodgeChargeCellSize, 0);
				dodgeRecharge = dodgeCharge;
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
		
		if(dodgeRecharge < dRechargeMax-dodgeRechargeRate)
		{
			dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate, dRechargeMax-dodgeRechargeRate);
		}
		else if(grounded || state == State.Grip || state == State.Grapple || ((state == State.Spark || state == State.BallSpark) && shineEnd > 0))
		{
			dodgeRecharge = min(dodgeRecharge+dodgeRechargeRate, dRechargeMax);
			if(shineEnd > 0)
			{
				dodgeRecharge = dRechargeMax;
			}
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
			
			if(_CRYSTAL_CLIP)
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
		var faceAway = (dir != grippedDir);
		var _armPosR = [[-6,16], [10,8], [9,0], [10,-23], [-3,-29]],
			_armPosL = [[-6,16], [10,8], [9,0], [10,-23], [-3,-29]];
		if(faceAway)
		{
			_armPosR = [[-11,17], [-27, 9], [-30,-6], [-27,-21], [-12,-31]];
			_armPosL = [[-10,18], [-25,10], [-32,-8], [-26,-21], [-12,-31]];
		}
		
		shotOffsetX = _armPosR[aimAngle+2][0];
		shotOffsetY = _armPosR[aimAngle+2][1];
		if(grippedDir == -1)
		{
			shotOffsetX = -_armPosL[aimAngle+2][0];
			shotOffsetY = _armPosL[aimAngle+2][1];
		}
	}
#endregion

	x = scr_round(position.X);
	y = scr_round(position.Y);
	
	if(!item[Item.ScrewAttack] || state != State.Somersault || liquidMovement)
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
	
	//aimUpDelay = max(aimUpDelay - 1, 0);
	
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