/// @description Everything

// --- PHYSICS & STATES ---
if(!global.GamePaused())
{
	#region debug keys
	if(instance_exists(obj_Debug))
	{
		debug = (obj_Debug.debug > 0);
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
	if(state == State.Stand && animState == AnimState.Stand)
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
	
	lowEnergyThresh = self.GetLowEnergyThreshold();
	
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
	
	if(global.grappleAimAssist && state != State.Morph && self.EquipmentSelected(Equipment.GrappleBeam))
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
	
	stallCamera = false;

#region Liquid Movement
	var liquidMovement = false;
	var findLiquid = self.liquid_place();
	if(instance_exists(findLiquid))
	{
		liquidLevel = max(self.bb_bottom() - findLiquid.y,0);

	    var dph = 10;
	    if(animState == AnimState.Morph)
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
	(!cMoonwalk || state == State.Somersault || state == State.Morph || state == State.Grip || (global.aimStyle == 2 && cAimUp)) && 
	!instance_exists(grapple) && state != State.Spark && state != State.BallSpark && state != State.Hurt && animState != AnimState.DmgBoost && dmgBoost <= 0 && state != State.Dodge)
	{
		dir = move;
		if(state == State.Grip && sign(dirFrame) != dir)
		{
			dirFrame = dir;
		}
	}
	if(self.SpiderActive())
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
	
	if(dir != 0 && cMorph && rMorph && morphFrame <= 0 && state != State.Crouch && state != State.Morph && animState != AnimState.Morph && item[Item.MorphBall] && state != State.Spark && state != State.BallSpark && state != State.Grip)
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
		self.ChangeState(State.Morph, AnimState.Morph, MoveState.Normal, mask_Player_Morph, grounded);
		morphFrame = 8;
		morphYDiff = y-oldY;
		
		if(self.GrappleActive() && (item[Item.MagniBall] || item[Item.SpiderBall]) && unmorphing == 0 && global.spiderBallStyle == 0)
		{
			self.SpiderEnable(true);
		}
	}
	
	dir2 = dir;
	//if(animState == AnimState.Grip)
	//{
	//	dir2 = -dir;
	//}

#region Aim Control, part 1
	prAngle = ((cAimUp && rAimUp) || (cAimDown && rAimDown) || (cAimLock && rAimLock));
	rlAngle = ((!cAimUp && !rAimUp) || (!cAimDown && !rAimDown) || (!cAimLock && !rAimLock));
	
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
					self.ChangeState(State.Morph, AnimState.Morph, MoveState.Normal, mask_Player_Morph, false);
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
				if(_up && (move == 0 || _aimUp) && cAimLock)
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
				if(_down && (move == 0 || _aimDown) && cAimLock)
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
	
	if(aimAngle != prevAimAngle)
	{
		lastAimAngle = prevAimAngle;
	}
#endregion

#region Horizontal Movement
	
	var sprint = (cSprint || global.autoSprint);
	
	// basically free super short charge if you uncomment this
	/*if(debug && speedBuffer >= speedBufferMax-1 && speedCounter < speedCounterMax)
	{
		sprint = true;
	}*/
	
	#region Determine speed vars
	
	var maxSpdInd = MaxSpeed.Run;
	if(state == State.Morph)
	{
		if(grounded)
		{
			if(abs(velX) > maxSpeed[MaxSpeed.MorphBall,liquidState] && liquidState <= 0)
			{
				maxSpdInd = MaxSpeed.MockBall;
			}
			else
			{
				maxSpdInd = MaxSpeed.MorphBall;
			}
		}
		else
		{
			if(item[Item.SpringBall])
			{
				maxSpdInd = MaxSpeed.AirSpring;
			}
			else
			{
				maxSpdInd = MaxSpeed.AirMorph;
			}
		}
	}
	else if(state == State.Somersault)
	{
		maxSpdInd = MaxSpeed.Somersault;
	}
	else if(state == State.Jump && moonFall && !grounded)
	{
		maxSpdInd = MaxSpeed.MoonFall;
	}
	else if(state == State.Jump)
	{
		maxSpdInd = MaxSpeed.Jump;
		if(animState == AnimState.DmgBoost)
		{
			maxSpdInd = MaxSpeed.Somersault;
		}
	}
	else if(state == State.Stand && walkState && sign(velX) != dir)
	{
		maxSpdInd = MaxSpeed.MoonWalk;
		if(sprint)
		{
			maxSpdInd = MaxSpeed.MoonSprint;
		}
	}
	else
	{
		if(sprint && !liquidMovement)
		{
			if(item[Item.SpeedBooster])
			{
				maxSpdInd = MaxSpeed.SpeedBoost;
			}
			else
			{
				maxSpdInd = MaxSpeed.Sprint;
			}
		}
	}
	
	fMaxSpeed = maxSpeed[maxSpdInd,liquidState];
	fMoveSpeed = moveSpeed[MoveSpeed.Normal,liquidState];
	if(state == State.Morph)
	{
		fMoveSpeed = moveSpeed[MoveSpeed.MorphBall,liquidState];
	}
	fFrict = frict[!grounded,liquidState];
	
	if(maxSpdInd == MaxSpeed.Sprint || maxSpdInd == MaxSpeed.SpeedBoost)
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
			fMoveSpeed = lerp(runMoveSpd,sprintMoveSpd, (spd-runMaxSpd) / (sprintMaxSpd-runMaxSpd));
		}
		else
		{
			fMoveSpeed = sprintMoveSpd;
		}
	}
	
	var turnaroundSpd = fMoveSpeed + fFrict;
	
	#endregion
	
	#region Momentum Logic
	
	if(moveState == MoveState.Normal)
	{
		var _move = 2*move;
		if(sign(dirFrame) != dir && sign(dirFrame) != 0)
		{
			_move = move;
		}
		
		var _frict = fFrict;
		if(cAimLock)
		{
			_frict = turnaroundSpd + sprintTurnSpeed[liquidState];
		}
		else if(move == 0 && ((state != State.Morph && aimAngle <= -2 && !grounded) || (state == State.Morph && abs(velX) > maxSpeed[MaxSpeed.MorphBall,liquidState] && (morphFrame > 0 || (cJump && !grounded)))))
		{
			_frict = 0;
		}
		
		if(fastWJGrace && move != -sign(velX))
		{
			_move = 0;
			_frict = max(_frict, turnaroundSpd);
		}
		
		if(sprint && state == State.Stand)
		{
			turnaroundSpd += sprintTurnSpeed[liquidState];
		}
		
		self.PerformMovement(_move, fMoveSpeed, turnaroundSpd, _frict, fMaxSpeed);
	}
	if(moveState == MoveState.Somersault)
	{
		var _move = 2*move;
		var spinJumpMoveFlag = (move == 0 && state == State.Somersault && (frame[Frame.Somersault] >= 2 || abs(velX) > 2*moveSpeed[MoveSpeed.Normal,liquidState]));
		if(spinJumpMoveFlag && dir == 1 && velX > 0)
		{
			_move = 2;
		}
		if(spinJumpMoveFlag && dir == -1 && velX < 0)
		{
			_move = -2;
		}
		
		var _frict = fFrict;
		if(fastWJGrace)
		{
			_move = 0;
			_frict = turnaroundSpd;
		}
		
		self.PerformMovement(_move, fMoveSpeed, turnaroundSpd, _frict, fMaxSpeed);
	}
	if(moveState == MoveState.Halted)
	{
		var _frict = fFrict*2;
		
		self.PerformMovement(0, 0, 0, _frict, 0);
	}
	
	if(moveState != MoveState.Custom)
	{
		var maxSpeed2 = maxSpeed[MaxSpeed.SpeedBoost,liquidState];
		if(abs(velX) > maxSpeed2 && (speedCounter > 0 || grounded))
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
	}
	
	/*
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
		if(animState == AnimState.DmgBoost)
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
	state != State.Hurt && !self.SpiderActive() && !self.GrappleActive() && state != State.Dodge)
	{
		var spinJumpMoveFlag = (state == State.Somersault && (frame[Frame.Somersault] >= 2 || abs(velX) > 2*moveSpeed[MoveSpeed.Normal,liquidState]));
		
		var moveflag = false;
		if((move == 1 && !brake && !cAimLock) || (spinJumpMoveFlag && dir == 1 && velX > 0))
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
		if((move == -1 && !brake && !cAimLock) || (spinJumpMoveFlag && dir == -1 && velX < 0))
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
		if(spinJumpMoveFlag && sign(velX) == dir)
		{
			moveflag = true;
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
			if((aimAngle > -2 /*|| !cJump//) && 
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
	*/
	#endregion
	
	#region Speed Booster Logic
	
	var minBoostSpeed = self.MinimumBoostSpeed();
	
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
	
	var spiderBoosting = (self.SpiderActive() && sign(spiderSpeed) == spiderMove && abs(spiderSpeed) > maxSpeed[MaxSpeed.MorphBall,liquidState]);
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
	
	if((state == State.Stand || state == State.Crouch || state == State.Morph) && (speedBoost || speedCatchCounter > 0) && move == 0 && cPlayerDown && dir != 0 && grounded && morphFrame <= 0 && !self.SpiderActive())
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
	
	#region Wall Jump detection
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
	#endregion
	#region Gravity
	
	if(liquidState > 0)
	{
		fGrav = grav[liquidState];
		liqGrav = fGrav;
		liqGravShift = 1;
	}
	else
	{
		if(jump > 0)
		{
			liqGravShift = 0;
		}
		fGrav = lerp(grav[0], liqGrav, liqGravShift);
		liqGravShift = max(liqGravShift - (1/30), 0);
	}
	
	var fallspd = fallSpeedMax;
	if(moonFall)
	{
		fallspd = moonFallMax;
	}
	
	if(jump <= 0 && bombJump <= 0 && !grounded && state != State.Elevator && (state != State.Grip || (startClimb && climbIndex > 7)) && state != State.Spark && state != State.BallSpark && state != State.Grapple && state != State.Hurt && state != State.Dodge && state != State.CrystalFlash)
	{
		velY += min(fGrav,max(fallspd-velY,0));
	}
	
	#endregion
	#region Jump Logic
	
	var isJumping = (cJump && dir != 0 && state != State.Spark && state != State.BallSpark && 
	state != State.Hurt && (!self.SpiderActive() || !sparkCancelSpiderJumpTweak) && (state != State.Grapple || grapWJCounter > 0)) && 
	(state != State.Morph || (!self.entity_place_collide(0,1) && !self.entity_place_collide(0,-1)) || (!self.entity_place_collide(0,1) ^^ !self.entity_place_collide(0,-1)) || self.entity_place_collide(0,0));
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
			if(shineCharge > 0 && rJump && (self.CanChangeState(mask_Player_Jump) || state == State.Morph) && !self.entity_place_collide(0,-1) && !moonFallState && 
			(move == 0 || velX == 0 || state == State.Jump) && state != State.Somersault && state != State.DmgBoost && ((!cAimDown && !cPlayerDown) || _SPARK_DOWN == 1 || (_SPARK_DOWN == 2 && item[Item.ChainSpark])) && 
			(state != State.Morph || item[Item.SpringBall]) && morphFrame <= 0 && state != State.Grip)
			{
				audio_stop_sound(snd_ShineSpark_Charge);
				shineStart = 30;
				shineRestart = false;
				if(state == State.Morph)
				{
					self.ChangeState(State.BallSpark, AnimState.Morph, MoveState.Custom, mask_Player_Morph, false);
				}
				else
				{
					self.ChangeState(State.Spark, AnimState.Spark, MoveState.Custom, mask_Player_Jump, false);
				}
				rSparkJump = true;
			}
			else if((rJump || (state == State.Morph && !self.SpiderActive() && rMorphJump) || bufferJump > 0) && quickClimbTarget <= 0 && 
			(state != State.Morph || (state == State.Morph && ((item[Item.SpringBall] && morphFrame <= 0) || ((unmorphing > 0 || morphSpinJump) && self.CanChangeState(mask_Player_Somersault))))) && state != State.DmgBoost)
			{
				if((grounded && !moonFallState) || coyoteJump > 0 || canWallJump || (state == State.Grip && canGripJump) || 
				(item[Item.SpaceJump] && velY >= sjThresh && state == State.Somersault && !liquidMovement && (!detectWJ || bufferJump <= 1) && rRespinJump))//&& ((!detectWJ && rRespinJump) || bufferJump <= 1)))
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
								var _left = self.bb_left()-16 - velX, _top = self.bb_top()-8,
									_right = self.bb_right()+16 - velX, _bottom = self.bb_bottom()+8;
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
									var part = instance_create_depth(self.Center().X-velX,self.Center().Y,layer_get_depth(layer_get_id("Projectiles_fg"))-1,obj_FastWJParticle);
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
						self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false);
						
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
					
					ledgeFall = false;
					ledgeFall2 = false;
					justFell = false;
					
					var _jInd = 0+item[Item.HiJump];
					if(state == State.Crouch)
					{
						_jInd = 4+item[Item.HiJump];
					}
					else if(wallJumped)
					{
						_jInd = 2+item[Item.HiJump];
					}
					jump += jumpHeight[_jInd, liquidState];
					
					jumping = true;
					
					if((rJump || bufferJump > 0) && state != State.Morph)
					{
						if(state == State.Grip)
						{
							stallCamera = true;
						}
						if((abs(velX) > 0 && sign(velX) == dir) || (move != 0 && move == dir) || cSprint || (!grounded && state != State.Grip) || (state == State.Crouch && !self.CanChangeState(mask_Player_Jump)))
						{
							var mask = mask_Player_Jump;
							if(!self.CanChangeState(mask_Player_Jump))
							{
								mask = mask_Player_Somersault;
							}
							self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask, false, false);
						}
						else
						{
							self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, false, false);
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
						self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false);
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
		
		if(jump <= 0 && velY < 0 && !liquidMovement && !outOfLiquid)
		{
			velY = max(velY*1.75,-fJumpSpeed);
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
			if(self.SpiderActive() || state == State.Spark || state == State.BallSpark || state == State.Grip)
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
	
	if(bombJumpX != 0 && !self.SpiderActive() && bombJump > 0)
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

	if(self.GrappleActive())
	{
		grapAngle = point_direction(position.X, position.Y, grapple.x, grapple.y) - 90;
		var dist = point_distance(position.X,position.Y,grapple.x,grapple.y);
		var ndist = point_distance(position.X+velX,position.Y+velY,grapple.x,grapple.y);
		
		var reel = 0;
		var _lmult = 1 / (1+liquidMovement);
		
		if(state == State.Grapple)
		{
			if(grappleDist <= grappleMinDist+2 && self.entity_place_collide(sign(grapple.x-x),0) && (grapAngle <= 45 || grapAngle >= 315))
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
				
				var grapVel = point_distance(0,0, velX,velY),
					detectKick = 8 + grapVel;
				var checkL = self.entity_place_collide(lengthdir_x(-detectKick, grapAngle), lengthdir_y(-detectKick, grapAngle)),
					checkR = self.entity_place_collide(lengthdir_x(detectKick, grapAngle), lengthdir_y(detectKick, grapAngle));
				
				var kickDir = checkL - checkR;
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
								if(!self.entity_position_collide(lengthdir_x(partLen,gAngle), lengthdir_y(partLen,gAngle)))
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
	if((state == State.Morph || state == State.BallSpark || state == State.Grip || state == State.Hurt) && animState == AnimState.Morph && item[Item.BoostBall] && unmorphing == 0)
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
					
				if(self.SpiderActive())
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
				if(self.entity_place_collide(0,1) && self.Crawler_CanStickBottom())
				{
					spiderEdge = Edge.Bottom;
					spiderSpeed = velX;
					spiderMove = sign(spiderSpeed);
				}
				if(self.entity_place_collide(0,-1) && self.Crawler_CanStickTop())
				{
					spiderEdge = Edge.Top;
					spiderSpeed = -velX;
					spiderMove = sign(spiderSpeed);
				}
				if(self.entity_place_collide(1,0) && self.Crawler_CanStickRight())
				{
					spiderEdge = Edge.Right;
					spiderSpeed = -velY;
					spiderMove = sign(spiderSpeed);
				}
				if(self.entity_place_collide(-1,0) && self.Crawler_CanStickLeft())
				{
					spiderEdge = Edge.Left;
					spiderSpeed = velY;
					spiderMove = sign(spiderSpeed);
				}
			}
		}
		else
		{
			if ((spiderEdge == Edge.Bottom && !self.entity_place_collide(0,2) && !self.entity_place_collide(2,2) && !self.entity_place_collide(-2,2)) ||
				(spiderEdge == Edge.Left && !self.entity_place_collide(-2,0) && !self.entity_place_collide(-2,2) && !self.entity_place_collide(-2,-2)) ||
				(spiderEdge == Edge.Top && !self.entity_place_collide(0,-2) && !self.entity_place_collide(2,-2) && !self.entity_place_collide(-2,-2)) || 
				(spiderEdge == Edge.Right && !self.entity_place_collide(2,0) && !self.entity_place_collide(2,2) && !self.entity_place_collide(2,-2)))
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
				if(self.entity_place_collide(0,1) && spiderEdge != Edge.Top && moveX != 0)
		        {
		            spiderMove = moveX;
		        }
				if(self.entity_place_collide(0,-1) && spiderEdge != Edge.Bottom && moveX != 0)
		        {
		            spiderMove = -moveX;
		        }
				if(self.entity_place_collide(-1,0) && spiderEdge != Edge.Right && moveY != 0)
		        {
		            spiderMove = moveY;
		        }
				if(self.entity_place_collide(1,0) && spiderEdge != Edge.Left && moveY != 0)
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
			if(spiderMove < 0)
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
			if(spiderMove == 0)
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
			
			var maxSpeed2 = maxSpeed[MaxSpeed.SpeedBoost,liquidState];
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
			if(self.PlayerGrounded() || self.PlayerOnPlatform())
			{
				velX = spiderSpeed*sign(lengthdir_x(1, GetEdgeAngle(spiderEdge)));
				if(self.PlayerGrounded())
				{
					grounded = true;
				}
				if(self.PlayerOnPlatform())
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
		if(!self.entity_place_collide(0,-4) && ((state == State.Jump && !self.entity_place_collide(0,3)) || (state == State.Somersault && !self.entity_place_collide(0,12))))
		{
			var _px = position.X,
				_py = position.Y,
				_bt = self.bb_top();
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
				num += collision_line_list(lcheck,_bt-3,rcheck,_bt-3,solids,true,true,blockList,true);
			if(num > 0)
			{
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
			}
			
			if(self.entity_collision_line(lcheck,_bt-3,rcheck,_bt-3) && !self.entity_collision_line(lcheck,_bt-8,rcheck,_bt-12) && self.entity_place_collide(move2,0) && dir == move2)
			{
				var rslopeX = _px+14,// - 1,
					rslopeY = _bt-11,
					lslopeX = _px+6,// - 1,
					lslopeY = _bt-3;
				if(move2 == -1)
				{
					rslopeX = _px-6;
					rslopeY = _bt-3;
					lslopeX = _px-14;
					lslopeY = _bt-11;
				}
				var slopeOffset = 0;
				while(slopeOffset >= -8 && self.entity_collision_line(lslopeX,lslopeY+slopeOffset,rslopeX,rslopeY+slopeOffset))
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
					
					self.ChangeState(State.Grip, AnimState.Grip, MoveState.Custom, mask_Player_Jump, false);
					stallCamera = true;
					
					position.Y = scr_ceil(position.Y);
					for(var j = 10; j > 0; j--)
					{
						if(self.entity_collision_line(lcheck,position.Y-18,rcheck,position.Y-18))
						{
							position.Y -= 1;
						}
						if(!self.entity_collision_line(lcheck,position.Y-17,rcheck,position.Y-17))
						{
							position.Y += 1;
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
	if(global.quickClimb && state != State.Grip && !startClimb && state != State.Morph && morphFrame <= 0 && grounded && abs(dirFrame) >= 4 && self.entity_place_collide(2*move2,0) && !self.entity_place_collide(0,0))
	{
		var qcHeight = 0;
		var bbottom = self.bb_bottom();
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
				
				if(i == 0 && self.entity_collision_rectangle(lcheck,bbottom-8,rcheck,bbottom-5))
				{
					while(qcHeight > -heightMax && self.entity_collision_line(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight))
					{
						qcHeight--;
					}
				}
				else if(i == 1)
				{
					qcHeight = -heightMax;
					while(qcHeight < -5 && self.entity_collision_line(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight))
					{
						qcHeight++;
					}
					while(qcHeight < -5 && !self.entity_collision_line(lcheck,bbottom+qcHeight,rcheck,bbottom+qcHeight))
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
					
					if(self.entity_collision_line(lcheck,yHeight,rcheck,yHeight) && !self.entity_collision_line(lcheck,lcheckY,rcheck,rcheckY))
					{
						var slopeOffset = 0;
						while(slopeOffset > -16 && self.entity_collision_line(lcheck,yHeight+slopeOffset,rcheck,yHeight+slopeOffset))
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
					
					if(canGrip && !self.entity_collision_rectangle(lcheck,yHeight-15,rcheck,yHeight-2))
					{
						if(!self.entity_collision_rectangle(lcheck,yHeight-31,rcheck,yHeight-2))
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
			
			self.ChangeState(State.Grip, AnimState.Grip, MoveState.Custom, mask_Player_Crouch, false);
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
	
	if(!self.PlayerGrounded() && !self.PlayerOnPlatform())
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
			
		self.DestroyBlock(x+fVelX,y);
		self.DestroyBlock(x,y+fVelY);
		
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
					var msp = 0.5*(animState == AnimState.Morph) / (1+liquidMovement);
					//if(cSprint || global.autoSprint)
					//{
					//	msp = 1 + 0.5*(animState == AnimState.Morph) / (1+liquidMovement);
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
		self.Collision_Crawler(fVelX,fVelY, (state != State.Grip), (state == State.Elevator));
	}
	else
	{
		self.Collision_Normal(fVelX,fVelY, (state != State.Grip), (state == State.Elevator));
	}
	
	if(!grounded && velY == 0 && self.PlayerGrounded())
	{
		grounded = true;
	}
	if(!onPlatform && velY == 0 && self.PlayerOnPlatform())
	{
		onPlatform = true;
	}
	
	fell = false;
	var shouldForceDown = (state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge && jump <= 0 && bombJump <= 0 && !self.SpiderActive());
	if((self.PlayerGrounded() || self.PlayerOnPlatform()) && fVelY >= 0)
	{
		justFell = shouldForceDown;
	}
	else
	{
		if(justFell && ledgeFall && fVelY >= 0 && fVelY <= fGrav)
		{
			fell = true;
			if(!self.entity_place_collide(0,1))
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
	
	var colL = instance_exists(collision_line(self.bb_left()+1,self.bb_top(),self.bb_left()+1,self.bb_bottom(),ColType_MovingSolid,true,true)),
		colR = instance_exists(collision_line(self.bb_right()-1,self.bb_top(),self.bb_right()-1,self.bb_bottom(),ColType_MovingSolid,true,true)),
		colT = instance_exists(collision_line(self.bb_left(),self.bb_top()+1,self.bb_right(),self.bb_top()+1,ColType_MovingSolid,true,true)),
		colB = instance_exists(collision_line(self.bb_left(),self.bb_bottom()-1,self.bb_right(),self.bb_bottom()-1,ColType_MovingSolid,true,true));
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
		moveState = MoveState.Normal;
		
		animState = AnimState.Stand;
		mask_index = mask_Player_Stand;
		
		if(cMoonwalk && move != 0 && move != dir && !self.entity_place_collide(-3*dir,4))
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
				animState = AnimState.Brake;
			}
			else if(moonFallState)
			{
				animState = AnimState.Moon;
			}
			else if((velMove || moveMove) && landFrame <= 0)
			{
				if((walkState && sign(velX) != dir))
				{
					animState = AnimState.Walk;
				}
				else
				{
					animState = AnimState.Run;
				}
			}
		}
		
		if(!self.PlayerGrounded() && !self.PlayerOnPlatform())
		{
			grounded = false;
		}
		
		var canCrouch = true;
		
		var ship = instance_position(x,self.bb_bottom()+1,obj_Gunship);
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
		var ele = instance_position(x,self.bb_bottom()+1,obj_Elevator);
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
			aimAnimDelay = aimAnimDelayMax;
			self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
		}
		if(!grounded && dir != 0)
		{
			self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, ledgeFall);
		}
		
		isPushing = false;
		pushBlock = instance_place(x+2*move2, y, obj_PushBlock);
		if(move2 == dir && grounded && !place_meeting(x, y+2, pushBlock))
		{
		    isPushing = (instance_exists(pushBlock) && pushBlock.grounded);
		}
		
		if(instance_exists(pushBlock) && isPushing)
		{
			animState = AnimState.Push;
			
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
			animState = AnimState.Push;
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
		moveState = MoveState.Custom;
		velX = 0;
		velY = 0;
		
		animState = AnimState.Stand;
		mask_index = mask_Player_Stand;
		aimAngle = 0;
		dir = 0;
		
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
		moveState = MoveState.Custom;
		velX = 0;
		velY = 0;
		
		animState = AnimState.Stand;
		mask_index = mask_Player_Stand;
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
		moveState = MoveState.Halted;
		
		animState = AnimState.Crouch;
		if(self.CanChangeState(mask_Player_Crouch))
		{
			self.ChangeState(state, animState, moveState, mask_Player_Crouch, false);
		}
		
		landFrame = 0;
		if(uncrouch < 7)
		{
			speedCounter = 0;
		}
		if(move2 != 0 && !self.entity_place_collide(0,-11))
		{
			uncrouch += 1;
		}
		else
		{
			uncrouch = 0;
		}
		if(((cPlayerUp && rPlayerUp) || uncrouch >= 7) && self.CanChangeState(mask_Player_Stand) && crouchFrame <= 0)
		{
			//aimUpDelay = 6;//10;
			aimAnimDelay = aimAnimDelayMax;
			self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
		}
		//if(item[Item.MorphBall] && crouchFrame <= 0 && ((cPlayerDown && (rPlayerDown || !self.CanChangeState(mask_Player_Stand)) && move2 == 0) || (cMorph && rMorph)) && animState != AnimState.Morph && morphFrame <= 0)
		if(item[Item.MorphBall] && crouchFrame <= 0 && ((cPlayerDown && rPlayerDown && move2 == 0) || (cMorph && rMorph)) && animState != AnimState.Morph && morphFrame <= 0)
		{
			audio_play_sound(snd_Morph,0,false);
			var oldY = y;
			self.ChangeState(State.Morph, AnimState.Morph, MoveState.Normal, mask_Player_Morph, true);
			morphYDiff = y-oldY;
			morphFrame = 8;
		}
		else if(!grounded && self.CanChangeState(mask_Player_Jump))
		{
			self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, false);
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
		moveState = MoveState.Normal;
		
		animState = AnimState.Morph;
		gunReady = false;
		ledgeFall = true;
		ledgeFall2 = true;
		landFrame = 0;
		
		if(grounded && !prevGrounded)
		{
			if(morphFrame <= 0 && !shineRampFix && !slopeGrounded)
			{
				if(!self.SpiderActive())
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
		
		if(!self.GrappleActive() && ((cPlayerUp && rPlayerUp) || (cJump && rJump && (!item[Item.SpringBall] || morphSpinJump)) || (cMorph && rMorph)) && unmorphing == 0 && morphFrame <= 0 && !self.SpiderActive()) //!spiderBall)
		{
			if(self.CanChangeState(mask_Player_Crouch))
			{
				audio_play_sound(snd_Morph,0,false);
				unmorphing = 1;
				morphFrame = 8;
				aimAnimDelay = aimAnimDelayMax;
				
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
				self.ChangeState(state, animState, moveState, mask_Player_Crouch, false);
			}
			else
			{
				self.ChangeState(state, animState, moveState, mask_Player_Somersault, false);
			}
			if(morphFrame >= 8)
			{
				morphYDiff = y-oldY;
			}
			
			aimAnimDelay = aimAnimDelayMax;
			if(morphFrame <= 0)
			{
				if(morphSpinJump || (!grounded && unmorphing == 1))
				{
					self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false);
					frame[Frame.Somersault] = 2;
					morphSpinJump = false;
				}
				else
				{
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
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
		if((self.CanChangeState(mask_Player_Crouch) || _CRYSTAL_CLIP) && energy < lowEnergyThresh && ammo > 0 && cFlashStartCounter > 0 && cFire && cPlayerDown)
		{
			cFlashStartCounter++;
			
			if(cFlashStartCounter > 70+60)
			{
				self.ChangeState(State.CrystalFlash, AnimState.CrystalFlash, MoveState.Custom, mask_Player_Crouch, true);
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
		audio_stop_sound(snd_SpiderLoop1);
		audio_stop_sound(snd_SpiderLoop2);
	}
	
	if((state == State.Morph || state == State.BallSpark) && (item[Item.MagniBall] || item[Item.SpiderBall]) && unmorphing == 0)
	{
		if(global.controlInput[INPUT_VERB.SpiderBall].pressType == PressType.Press)
		{
			if(cSpiderBall && rSpiderBall)
			{
				self.SpiderEnable(!spiderBall);
			}
		}
		if(global.controlInput[INPUT_VERB.SpiderBall].pressType == PressType.Hold)
		{
			self.SpiderEnable(cSpiderBall);
		}
	}
	else
	{
		self.SpiderEnable(false);
		spiderGrappleSpeedKeep = false;
	}
	
	if(self.SpiderActive())
	{
		moveState = MoveState.Custom;
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
		
		if(!audio_is_playing(snd_SpiderLoop1))
		{
			var snd = audio_play_sound(snd_SpiderLoop1, 0, true, 1.0);
			audio_sound_loop_start(snd, 1.161);
			audio_sound_loop_end(snd, 2.479);
			audio_sound_gain(snd, 0.5, 2000);
		}
		if(!audio_is_playing(snd_SpiderLoop2))
		{
			audio_play_sound(snd_SpiderLoop2, 0, true);
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
			var _partX = clamp(x+lengthdir_x(16,spiderJumpDir+180), self.bb_left(x), self.bb_right(x)),
				_partY = clamp(y+lengthdir_y(16,spiderJumpDir+180), self.bb_top(y), self.bb_bottom(y));
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
		audio_stop_sound(snd_SpiderLoop1);
		audio_stop_sound(snd_SpiderLoop2);
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
		moveState = MoveState.Normal;
		
		if(dBoostFrame <= 0 || dBoostFrame >= 19)
		{
			animState = AnimState.Jump;
		}
		
		if(aimAngle == -2 || aimFrame <= -3)
		{
			downGrabDelay = 2;
		}
		if(downGrabDelay > 0)
		{
			self.ChangeState(state, animState, moveState, mask_Player_AimDown, false);
			downGrabDelay--;
		}
		else if(self.CanChangeState(mask_Player_Jump))
		{
			self.ChangeState(state, animState, moveState, mask_Player_Jump, false);
		}
		
		if(grounded )//|| self.PlayerGrounded())
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
				if(!self.CanChangeState(mask_Player_Stand))
				{
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_AimDown, true);
					crouchFrame = 0;
				}
				else
				{
					self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
					landFrame = 7;
					smallLand = false;
				}
			}
			else
			{
				if(!self.CanChangeState(mask_Player_Stand))
				{
					crouchFrame = 5;
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
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
					self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
				}
			}
			
			if(slopeGrounded && state == State.Stand)
			{
				landFrame = 0;
				smallLand = false;
				
				brake = true;
				brakeFrame = 10;
				audio_play_sound(snd_Brake,0,false);
				animState = AnimState.Brake;
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
		moveState = MoveState.Somersault;
		
		animState = AnimState.Somersault;
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
			
			if(!self.CanChangeState(mask_Player_Stand))
			{
				var mask = mask_Player_Crouch;
				if(!self.CanChangeState(mask_Player_Crouch))
				{
					mask = mask_Player_Somersault;
				}
				self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask, true);
				crouchFrame = 0;
			}
			else
			{
				self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
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
				animState = AnimState.Brake;
			}
		}
		else
		{
			landFrame = 0;
			if(prAngle || (cPlayerUp && rPlayerUp) || (cPlayerDown && rPlayerDown) || (cFire && rFire) || (!cFire && !rFire && CanCharge()) || (!cFire && rFire && statCharge >= 20))
			{
				if(!self.CanChangeState(mask_Player_Jump))
				{
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Somersault, true);
					crouchFrame = 0;
				}
				else
				{
					var mask = mask_Player_Jump;
					if(aimAngle == -2 || aimFrame <= -3)
					{
						mask = mask_Player_Somersault;
					}
					self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask, false);
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
		moveState = MoveState.Custom;
		
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
				if(climbIndex < 7)
				{
					velY = 0;
				}
				else
				{
					moveState = MoveState.Normal;
				}
				
				if(animState != AnimState.Morph)
				{
					animState = AnimState.Grip;
					mask_index = mask_Player_Crouch;
					if(climbIndex >= 3 && climbTarget == 1)
					{
						audio_play_sound(snd_Morph,0,false);
						var oldY = y;
						self.ChangeState(state, AnimState.Morph, MoveState.Normal, mask_Player_Morph, true);
						morphFrame = 8;
						morphYDiff = y-oldY;
					}
					else if(climbIndex > 17)
					{
						if(self.CanChangeState(mask_Player_Stand))
						{
							self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
							crouchFrame = 2;
						}
						else
						{
							self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
							crouchFrame = 0;
						}
					}
				}
				else if(climbIndex > 11 && !self.entity_place_collide(0,0))
				{
					self.ChangeState(State.Morph, AnimState.Morph, MoveState.Normal, mask_Player_Morph, true);
				}
			}
		}
		else
		{
			moveState = MoveState.Custom;
			velX = 0;
			velY = 0;
			
			animState = AnimState.Grip;
			mask_index = mask_Player_Jump;
			
			climbTarget = 0;
			if(!self.entity_place_collide(0,-8))
			{
				var ctStart = 0;
				while(ctStart >= -16 && self.entity_collision_line(_px,self.bb_top()+ctStart,_px+9*_dir,self.bb_top()+ctStart))
				{
					ctStart--;
				}
				if(ctStart >= -16)
				{
					var morphH = 12,
						crouchH = 29;
				
					var ctHeight = -(crouchH+1);
					while(ctHeight <= -morphH && self.entity_collision_line(_px,self.bb_top()+ctStart+ctHeight,_px+9*_dir,self.bb_top()+ctStart+ctHeight))
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
				self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, true);
			}
			
			var rcheck = _px+6,// - 1,
				lcheck = _px;// - 1;
			if(_dir == -1)
			{
				rcheck = _px;
				lcheck = _px-6;
			}
			if(!self.entity_collision_line(lcheck,_py-17,rcheck,_py-17))
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
		
		if((!self.entity_place_collide(2*_dir,0) && !self.entity_place_collide(2*_dir,4) && !self.entity_place_collide(0,2)) || (self.entity_position_collide(6*_dir,-19) && !startClimb) || (colFlag && !startClimb) || (cPlayerDown && cJump && rJump) || (place_meeting(_px,_py,ColType_MovingSolid) && !startClimb))
		{
			breakGrip = true;
		}
		if(breakGrip)
		{
			if(animState == AnimState.Morph)
			{
				state = State.Morph;
			}
			else
			{
				self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, true);
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
		moveState = MoveState.Custom;
		
		if(state == State.BallSpark)
		{
			animState = AnimState.Morph;
			mask_index = mask_Player_Morph;
		}
		else
		{
			animState = AnimState.Spark;
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
		var allowDown = (_SPARK_DOWN == 1 || (_SPARK_DOWN == 2 && item[Item.ChainSpark]));
		
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
			if((self.entity_place_collide(0,4) || (onPlatform && place_meeting(x,y+4,ColType_Platform))) && (!self.entity_place_collide(0,-1) || self.entity_place_collide(0,0)))
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
					animState = AnimState.Morph;
				}
				else
				{
					animState = AnimState.Somersault;
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
				collision_rectangle_list(self.bb_left()+min(velX,0),self.bb_top()+min(velY,0),self.bb_right()+max(velX,0),self.bb_bottom()+max(velY,0),obj_Reflec,true,true,reflecList,true);
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
							if(lastReflec != _ref && rectangle_intersect_line(self.bb_left()+vX,self.bb_top()+vY,self.bb_right()+vX,self.bb_bottom()+vY, p1.X,p1.Y,p2.X,p2.Y))
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
					while(!rectangle_intersect_line(self.bb_left()+vX,self.bb_top()+vY,self.bb_right()+vX,self.bb_bottom()+vY, p1.X,p1.Y,p2.X,p2.Y) && _c < _spd)
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
					self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false);
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
	if(self.GrappleActive())
	{
		moveState = MoveState.Custom;
	}
	if(state == State.Grapple)
	{
		animState = AnimState.Grapple;
		mask_index = mask_Player_Somersault;
		if(!self.GrappleActive())
		{
			self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false);
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
		moveState = MoveState.Custom;
		
		aimAngle = 0;
		if(animState != AnimState.Morph || (unmorphing > 0 && morphFrame <= 0))
		{
			animState = AnimState.Hurt;
			if(self.CanChangeState(mask_Player_Jump))
			{
				self.ChangeState(state, animState, moveState, mask_Player_Jump, false, true);
			}
		}
		
		if(hurtTime <= 0)
		{
			//if(lastState == State.Grip || lastState == State.Spark || (lastState == State.Morph && unmorphing > 0))
			//if(lastState == State.Somersault || lastState == State.Grip || lastState == State.Spark || (lastState == State.Morph && unmorphing > 0) || lastState == State.Dodge || lastState == State.Grapple)
			if (lastState == State.Stand || lastState == State.Crouch || (lastState == State.Morph && unmorphing > 0) || lastState == State.Somersault || 
				lastState == State.Grip || lastState == State.Spark || lastState == State.Grapple || lastState == State.Dodge)
			{
				//state = State.Jump;
				if(self.CanChangeState(mask_Player_Jump))
				{
					self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, false, true);
				}
				else if(self.CanChangeState(mask_Player_Somersault))
				{
					self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false, true);
				}
			}
			/*else if(lastState == State.Dodge || lastState == State.Grapple)
			{
				state = State.Somersault;
			}*/
			else if(lastState == State.BallSpark)
			{
				state = State.Morph;
			}
			else
			{
				state = lastState;
				if(animState != AnimState.Morph)
				{
					animState = lastAnimState;
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
	
	if(state == State.Hurt || state == State.Stand || (state == State.Crouch && self.CanChangeState(mask_Player_Stand)) || state == State.Jump || state == State.Somersault)
	{
		if(dmgBoost > 0 && animState != AnimState.Morph && cJump && move2 == -dir)
		{
			self.ChangeState(State.DmgBoost, AnimState.DmgBoost, MoveState.Normal, mask_Player_Jump, false);
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
		moveState = MoveState.Normal;
		
		animState = AnimState.DmgBoost;
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
				if(!self.CanChangeState(mask_Player_Stand))
				{
					crouchFrame = 3;
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
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
					self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
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
			self.ChangeState(State.Dodge, AnimState.Dodge, MoveState.Custom, mask_Player_Crouch, (groundedDodge == 1));
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
		moveState = MoveState.Custom;
		
		animState = AnimState.Dodge;
		mask_index = mask_Player_Crouch;
		gunReady = true;
		ledgeFall = true;
		ledgeFall2 = true;
		
		var shoot = _DASH_SHOOT_CANCEL && ((cFire && rFire) || (!cFire && !rFire && CanCharge()));
		if(dodgeLength >= dodgeLengthMax || shoot)
		{
			if(grounded)
			{
				if(!self.CanChangeState(mask_Player_Stand) || groundedDodge == 2)
				{
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
					crouchFrame = 0;
				}
				else
				{
					self.ChangeState(State.Stand, AnimState.Stand, MoveState.Normal, mask_Player_Stand, true);
					landFrame = 7;
					smallLand = false;
				}
			}
			else if(shoot)
			{
				if(!self.CanChangeState(mask_Player_Jump))
				{
					self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, false);
				}
				else
				{
					self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, false);
				}
			}
			else
			{
				self.ChangeState(State.Somersault, AnimState.Somersault, MoveState.Somersault, mask_Player_Somersault, false);
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
			else
			{
				var flag = (!liquidMovement && (move != dir || dodgeDir == -dir || abs(velX) > maxSpeed[MaxSpeed.Dodge,0]));
				if(velX > 0)
				{
					velX = max(velX - fFrict*(1+flag), 0);
				}
				if(velX < 0)
				{
					velX = min(velX + fFrict*(1+flag), 0);
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
		moveState = MoveState.Custom;
		velX = 0;
		velY = 0;
		
		animState = AnimState.CrystalFlash;
		mask_index = mask_Player_Crouch;
		immune = true;
		
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
			if(!self.CanChangeState(mask_Player_Jump))
			{
				self.ChangeState(State.Crouch, AnimState.Crouch, MoveState.Halted, mask_Player_Crouch, true);
				crouchFrame = 0;
			}
			else
			{
				self.ChangeState(State.Jump, AnimState.Jump, MoveState.Normal, mask_Player_Jump, false);
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

#region Aim Control, part 2

	if(!instance_exists(grapple) && state != State.Morph)
	{
		var _up = cPlayerUp,
			_down = cPlayerDown,
			_aimUp = cAimUp,
			_aimDown = cAimDown;
		if(cAimLock)
		{
			_aimUp = false;
			_aimDown = false;
		}
		
		if(!_aimDown)
		{
			if(_up && (move == 0 || _aimUp) && aimAnimDelay < aimAnimDelayMax-2)
			{
				aimAngle = 2;
			}
		}
		if(!_aimUp)
		{
			if(_down && (move == 0 || _aimDown) && aimAnimDelay < aimAnimDelayMax-2)
			{
				aimAngle = -2;
			}
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
	
	if(!self.PlayerGrounded() && !self.PlayerOnPlatform())
	{
		grounded = false;
	}
	if(!self.PlayerOnPlatform())
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
	self.EntityLiquid_Large(xVel,yVel);
	
	if(self.IsChargeSomersaulting() || boostBallDmgCounter > 0)
	{
		immune = true;
	}
	if(self.IsSpeedBoosting() || self.IsScrewAttacking())
	{
		immune = true;
		var xv = fVelX;
		if(fVelX == 0)
		{
			xv = move2;
		}
		self.DestroyBlock(x+xv,y+fVelY);
	}
	
	if(!instance_exists(lifeBoxes[0]))
	{
		lifeBoxes[0] = self.CreateLifeBox(0,0,mask_index,false);
	}
	if(instance_exists(lifeBoxes[0]))
	{
		lifeBoxes[0].mask_index = mask_index;
		lifeBoxes[0].UpdatePos(x,y);
	}
}

// --- ANIMATIONS & MISC FX ---
if(global.pauseState == PauseState.None || (self.VisorSelected(Visor.XRay) && global.pauseState == PauseState.XRay) || global.pauseState == PauseState.RoomTrans)
{
	if(self.VisorSelected(Visor.XRay) && global.pauseState == PauseState.XRay)
	{
		aimAngle = 0;
	}
	
	#region Update Anims
	
	var roomTrans = (global.pauseState == PauseState.RoomTrans);
	
	drawMissileArm = false;
	shootFrame = (gunReady || justShot > 0 || instance_exists(grapple) || (cFire && (rFire || self.CanCharge())));
	sprtOffsetX = 0;
	sprtOffsetY = 0;
	torsoR = sprt_Player_StandCenter;
	torsoL = torsoR;
	legs = -1;
	bodyFrame = 0;
	legFrame = 0;
	runYOffset = 0;
	fDir = dir;
	armDir = fDir;
	
	gripOverlay = -1;
	gripOverlayFrame = 0;
	
	rotation = 0;
	
	var liquidMovement = (liquidState > 0);
	
	var aimSpeed = 1 / (1 + liquidMovement);
	
	if(aimSnap > 0)
	{
		aimSpeed *= 3;
	}
	
	var aimFrameTarget = aimAngle*2;
	if(self.VisorSelected(Visor.XRay))
	{
		aimFrameTarget = 0;
	}
	if(abs(aimFrameTarget-aimFrame) > 4 && animState == AnimState.Grip)
	{
		aimSpeed *= 2;
	}
	if(animState == AnimState.Grapple)
	{
		aimFrameTarget = 4;
		aimSpeed = 1;
		if(abs(aimFrameTarget-aimFrame) <= 2)
		{
			aimSpeed = 0.5;
		}
		
		aimSpeed /= (1 + liquidMovement);
	}
	
	if(aimAnimDelay <= 0)
	{
		if(aimFrame > aimFrameTarget)
		{
			aimFrame = max(aimFrame - aimSpeed, aimFrameTarget);
		}
		else
		{
			aimFrame = min(aimFrame + aimSpeed, aimFrameTarget);
		}
	}
	else if(aimSnap > 0 || prAngle || rlAngle)
	{
		aimAnimDelay = 0;
	}
	
	if(aimFrame == aimFrameTarget)
	{
		aimSnap = 0;
	}
	
	finalArmFrame = aimFrame + 4;
	
	if(recoil)
	{
		recoilCounter = 4 + (statCharge >= maxCharge) + liquidMovement;
		var aimClamp = 2-liquidMovement;
		aimFrame = clamp(aimFrame, aimFrameTarget-aimClamp,aimFrameTarget+aimClamp);
		aimSnap = 8;
		recoil = false;
	}
	
	var turnSpeed = (1/(1+liquidMovement));
	if(dir == 0)
	{
		turnSpeed /= 2;
	}
	/*else if(lastDir == 0)
	{
		turnSpeed *= 0.75;
	}*/
	if(state == State.Grip)
	{
		turnSpeed *= 2;
	}
	if(dir == 0)
	{
		if(dirFrame < 0)
		{
			dirFrame = min(dirFrame + turnSpeed, 0);
		}
		else
		{
			dirFrame = max(dirFrame - turnSpeed, 0);
		}
	}
	else
	{
		if(dir == 1)
		{
			dirFrame = min(dirFrame + turnSpeed, 4);
		}
		else if(dir == -1)
		{
			dirFrame = max(dirFrame - turnSpeed, -4);
		}
	}
	
	var dirFrameF = scr_floor(dirFrame);
	
	if((dir == 0 || lastDir == 0) && dirFrameF == 0 && animState == AnimState.Stand)
	{
		fDir = 1;
		torsoR = sprt_Player_StandCenter;
		torsoL = torsoR;
		bodyFrame = item[Item.VariaSuit];
		
		// --- Uncomment this code to DAB while in elevator pose ---
			/*torsoR = sprt_Dab;
			torsoL = torsoR;
			bodyFrame = 0;
			fDir = 1;*/
		// ---
	}
	else if(abs(dirFrameF) < 4 && animState != AnimState.Somersault && animState != AnimState.Morph && animState != AnimState.Grip && (animState != AnimState.Spark || shineRestart) && animState != AnimState.Grapple && animState != AnimState.Dodge)
	{
		fDir = 1;
		var shootflag = (shootFrame || cMoonwalk || aimFrame != 0 || recoilCounter > 0);
		for(var i = 0; i < array_length(frame); i++)
		{
			frame[i] = 0;
			if(i != Frame.Jump || shootflag)
			{
				frameCounter[i] = 0;
			}
		}
		ledgeFall = true;
		ledgeFall2 = true;
		if(!shootflag && frameCounter[Frame.Jump] >= 30)
		{
			frame[Frame.Jump] = 7;
		}
		
		if(animState == AnimState.Spark)
		{
			aimFrame = 0;
		}
		
		if((lastDir == 0 || dir == 0) && aimFrame == 0 && (state == State.Stand || state == State.Elevator))
		{
			torsoR = sprt_Player_TurnCenter;
			bodyFrame = 3 + dirFrameF;
		}
		else
		{
			if(aimFrame > 0 && aimFrame < 3)
			{
				torsoR = sprt_Player_TurnAimUp;
				self.ArmPos(turnArmPosX[3,dirFrameF+3], turnArmPosY[3]);
			}
			else if(aimFrame < 0 && aimFrame > -3)
			{
				torsoR = sprt_Player_TurnAimDown;
				self.ArmPos(turnArmPosX[1,dirFrameF+3], turnArmPosY[1]);
			}
			else if(aimFrame >= 3)
			{
				torsoR = sprt_Player_TurnAimUpV;
				self.ArmPos(turnArmPosX[4,dirFrameF+3], turnArmPosY[4]);
				
				armDir = 1;
				if(dirFrameF < 2)
				{
					armDir = -1;
				}
				drawMissileArm = true;
			}
			else if(aimFrame <= -3)
			{
				torsoR = sprt_Player_TurnAimDownV;
				self.ArmPos(turnArmPosX[0,dirFrameF+3], turnArmPosY[0]);
				
				armDir = 1;
				if(dirFrameF < 2)
				{
					armDir = -1;
				}
				drawMissileArm = true;
				
				if(animState == AnimState.Jump)
				{
					sprtOffsetX = -dirFrameF;
				}
			}
			else
			{
				torsoR = sprt_Player_Turn;
				self.ArmPos(turnArmPosX[2,dirFrameF+3], turnArmPosY[2,dirFrameF+3]);
			}
			legs = sprt_Player_TurnLeg;
			if(animState == AnimState.Crouch || animState == AnimState.Jump || !grounded)
			{
				legs = sprt_Player_TurnCrouchLeg;
			}
			if(animState == AnimState.Stand && crouchFrame < 5)
			{
				sprtOffsetY = 11;
				legs = sprt_Player_TurnCrouchLeg;
			}
			bodyFrame = 3 + dirFrameF;
			legFrame = 3 + dirFrameF;
		}
	}
	else
	{
		self.SetArmPosStand();
		
		switch animState
		{
			#region Stand
			case AnimState.Stand:
			{
				drawMissileArm = true;
				torsoR = sprt_Player_StandRight;
				torsoL = sprt_Player_StandLeft;
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Idle)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				var iNum = idleNum,
					iSeq = idleSequence;
				if(energy < lowEnergyThresh)
				{
					iNum = idleNum_Low;
					iSeq = idleSequence_Low;
				}
				frame[Frame.Idle] = scr_wrap(frame[Frame.Idle],0,array_length(iNum));
				
				frameCounter[Frame.Idle]++;
				if(frameCounter[Frame.Idle] > iNum[frame[Frame.Idle]])
				{
					frame[Frame.Idle] = scr_wrap(frame[Frame.Idle] + 1,0,array_length(iNum));
					frameCounter[Frame.Idle] = 0;
				}
				if(self.VisorSelected(Visor.Scan) || self.VisorSelected(Visor.XRay) || aimFrame != 0 || landFrame > 0 || recoilCounter > 0 || runToStandFrame[0] > 0 || runToStandFrame[1] > 0 || walkToStandFrame > 0)
				{
					frame[Frame.Idle] = 0;
					frameCounter[Frame.Idle] = 0;
					torsoR = sprt_Player_StandAimRight;
					torsoL = sprt_Player_StandAimLeft;
					if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame <= 0)
					{
						torsoR = sprt_Player_StandFireRight;
						torsoL = sprt_Player_StandFireLeft;
						bodyFrame = 2 + scr_round(aimFrame/2);
					}
					else
					{
						if(transFrame > 0)
						{
							torsoR = sprt_Player_TransAimRight;
							torsoL = sprt_Player_TransAimLeft;
							self.SetArmPosTrans();
						}
						if((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
						{
							torsoR = sprt_Player_JumpAimRight;
							torsoL = sprt_Player_JumpAimLeft;
							self.SetArmPosJump();
						}
						bodyFrame = 4 + aimFrame;
					}
					if(aimFrame == 0)
					{
						if(runToStandFrame[1] > 0)
						{
							torsoR = sprt_Player_RunAimRight;
							torsoL = sprt_Player_RunAimLeft;
							bodyFrame = scr_round(runToStandFrame[1])-1;
							self.ArmPos((19+(2*bodyFrame))*dir,-(1+bodyFrame));
						}
						else if(runToStandFrame[0] > 0)
						{
							torsoR = sprt_Player_RunRight;
							torsoL = sprt_Player_RunLeft;
							bodyFrame = scr_round(runToStandFrame[0])-1;
							drawMissileArm = false;
							runYOffset = -(scr_round(runToStandFrame[0]) == 1);
						}
						else if(walkToStandFrame > 0)
						{
							torsoR = sprt_Player_MoonWalkRight;
							torsoL = sprt_Player_MoonWalkLeft;
							bodyFrame = scr_round(walkToStandFrame)-1;
							self.ArmPos((18+(3*bodyFrame))*dir,-(1+bodyFrame));
						}
						else if(self.VisorSelected(Visor.Scan))
						{
							torsoR = sprt_Player_XRayRight;
							torsoL = sprt_Player_XRayLeft;
							var sdir = point_direction(x,y, scanVisor.GetRoomX(),scanVisor.GetRoomY());
							var xcone = abs(scr_wrap(sdir-90, -180, 180));
							bodyFrame = 4-scr_round(xcone/45);
						}
						else if(self.VisorSelected(Visor.XRay))
						{
							torsoR = sprt_Player_XRayRight;
							torsoL = sprt_Player_XRayLeft;
							var xcone = abs(scr_wrap(xrayVisor.coneDir-90, -180, 180));
							bodyFrame = 4-scr_round(xcone/45);
						}
					}
					if(landFrame > 0)
					{
						legs = sprt_Player_LandLeg;
						if(smallLand)
						{
							landFinal = smallLandSequence[scr_round(landFrame)];
						}
						else
						{
							landFinal = landSequence[scr_round(landFrame)];
						}
						legFrame = landFinal;
						sprtOffsetY = landYOffset[landFinal];
					}
					else
					{
						legs = sprt_Player_StandLeg;
						legFrame = min(abs(aimFrame),2);
					}
				}
				else
				{
					bodyFrame = iSeq[frame[Frame.Idle]];
					if(crouchFrame < 5)
					{
						torsoR = sprt_Player_CrouchRight;
						torsoL = sprt_Player_CrouchLeft;
					}
				}
				if(crouchFrame < 5)
				{
					crouchFinal = crouchSequence[scr_round(crouchFrame)];
					if(crouchFrame > 0)
					{
						legFrame = crouchFinal;
					}
					else
					{
						legFrame = 0;
					}
					sprtOffsetY = 11-crouchYOffset[legFrame];
					legs = sprt_Player_CrouchLeg;
				}
				transFrame = max(transFrame - 1, 0);
				frame[Frame.JAim] = 6;
				
				if(memeDance)
				{
					if(memeDanceFrame < 94)
					{
						var seqNum = memeDanceSeq[memeDanceFrame];
						memeDanceFrameCounter++;
						if(memeDanceFrameCounter > seqNum)
						{
							memeDanceFrame++;
							memeDanceFrameCounter -= seqNum
						}
					}
					torsoR = sprt_Player_Dance;
					torsoL = torsoR;
					legs = -1;
					bodyFrame = memeDanceFrame;
				}
				
				break;
			}
			#endregion
			#region Walk
			case AnimState.Walk:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Walk)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				runToStandFrame[0] = 0;
				runToStandFrame[1] = 0;
				
				frameCounter[Frame.Walk]++;
				var numCounter = 2.5 * (1+liquidMovement);
				if(abs(velX) > maxSpeed[MaxSpeed.MoonWalk,liquidState])
				{
					numCounter = 1.875 * (1+liquidMovement);
				}
				if(roomTrans)
				{
					numCounter = 5;
				}
				if(frameCounter[Frame.Walk] >= numCounter)
				{
					if(frame[Frame.Walk] == 6 || frame[Frame.Walk] == 12)
					{
						if(!audio_is_playing(snd_SpeedBooster) && !audio_is_playing(snd_SpeedBooster_Loop) && !roomTrans)
						{
							audio_play_sound(snd_Step,0,false);
						}
					}
					
					if(frame[Frame.Walk] < 1)
					{
						frame[Frame.Walk] += 1;
					}
					else
					{
						frame[Frame.Walk] = scr_wrap(frame[Frame.Walk]+1,1,13);
					}
					frameCounter[Frame.Walk] -= numCounter;
				}
				
				self.SetArmPosJump();
				
				runYOffset = -mOffset[frame[Frame.Walk]];
				
				if(aimFrame != 0)
				{
					torsoR = sprt_Player_JumpAimRight;
					torsoL = sprt_Player_JumpAimLeft;
					if(transFrame < 2)
					{
						torsoR = sprt_Player_TransAimRight;
						torsoL = sprt_Player_TransAimLeft;
						self.SetArmPosTrans();
					}
					bodyFrame = 4 + aimFrame;
				}
				else
				{
					torsoR = sprt_Player_MoonWalkRight;
					torsoL = sprt_Player_MoonWalkLeft;
					bodyFrame = min(floor(walkToStandFrame),1);
					if(bodyFrame == 0)
					{
						self.ArmPos(18*dir,-1);
					}
					else if(bodyFrame == 1)
					{
						self.ArmPos(21*dir,-2);
					}
				}
				legs = sprt_Player_MoonWalkLeg;
				legFrame = frame[Frame.Walk];
				drawMissileArm = true;
				
				walkToStandFrame = min(walkToStandFrame + 0.5, 2);
				transFrame = min(transFrame + 1, 2);
				frame[Frame.JAim] = 6;
				break;
			}
			#endregion
			#region Moon
			case AnimState.Moon:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Moon)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[Frame.JAim] = 6;
				aimFrame = 0;
				walkToStandFrame = 0;
				runToStandFrame[0] = 0;
				runToStandFrame[1] = 0;
				
				torsoR = sprt_Player_BrakeRight;
				torsoL = sprt_Player_BrakeLeft;
				legs = sprt_Player_BrakeLeg;
				
				bodyFrame = 4 - floor(frame[Frame.Moon]);
				legFrame = bodyFrame;
				switch bodyFrame
				{
					case 4:
					{
						self.ArmPos(11,-5);
						if(dir == -1)
						{
							self.ArmPos(-9,-4);
						}
						break;
					}
					case 3:
					{
						self.ArmPos(4,-7);
						if(dir == -1)
						{
							self.ArmPos(-1,-6);
						}
						break;
					}
					case 2:
					{
						self.ArmPos(0,-8);
						if(dir == -1)
						{
							self.ArmPos(1,-7);
						}
						break;
					}
					case 1:
					{
						self.ArmPos(-2,-8);
						if(dir == -1)
						{
							self.ArmPos(4,-6);
						}
						break;
					}
					default:
					{
						self.ArmPos(-3,-8);
						if(dir == -1)
						{
							self.ArmPos(5,-6);
						}
						break;
					}
				}
				
				if(moonFallCounter < moonFallCounterMax-6)
				{
					frame[Frame.Moon] = min(frame[Frame.Moon] + 0.75, 2);
				}
				else
				{
					frame[Frame.Moon] = max(frame[Frame.Moon] - 1/3, 0);
				}
				
				break;
			}
			#endregion
			#region Run
			case AnimState.Run:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Run)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				if(!roomTrans)
				{
					var num = clamp(4 * ((abs(velX)-maxSpeed[MaxSpeed.Run,liquidState]) / (maxSpeed[MaxSpeed.SpeedBoost,liquidState]-maxSpeed[MaxSpeed.Run,liquidState])), speedCounter, 4);
					var num2 = runAnimCounterMax[0];
					if(num > 0)
					{
						num2 = LerpArray(runAnimCounterMax,num,false);
					}
					if(!_SMOOTH_RUN_ANIM)
					{
						num = speedCounter;
						if(((cSprint || global.autoSprint) && speedBuffer > 0) || speedCounter > 0)
						{
							num += 1;
						}
						num2 = speedBufferCounterMax[num];
					}
					
					if(!item[Item.SpeedBooster])
					{
						num2 = 3;
						if(!_SMOOTH_RUN_ANIM)
						{
							num2 = 2.5;
						}
						if(abs(velX) > maxSpeed[MaxSpeed.Run,liquidState])
						{
							num2 = lerp(num2, 2, (abs(velX)-maxSpeed[MaxSpeed.Run,liquidState]) / (maxSpeed[MaxSpeed.Sprint,liquidState]-maxSpeed[MaxSpeed.Run,liquidState]));
						}
					}
					
					var numCounter = num2/2;
					if(!_SMOOTH_RUN_ANIM)
					{
						var runSpdMult = 1 - abs(velX)/maxSpeed[MaxSpeed.SpeedBoost,liquidState];
						numCounter = min(num2/2, 5*runSpdMult);
					}
					
					var numRun = clamp(1/numCounter, 1, 1.6);
					
					if(liquidMovement)
					{
						if(!speedBoost)
						{
							numCounter = 3.5;
						}
						numRun = 1;
					}
					else if(frame[Frame.Run] < 2)
					{
						numCounter = 1 + (frame[Frame.Run] <= 0);
						numRun = 1;
					}
					
					frameCounter[Frame.Run]++;
					if(frameCounter[Frame.Run] >= numCounter)
					{
						var sndFrameCheck = floor(frame[Frame.Run]/2);
						if(sndFrameCheck == 4 || sndFrameCheck == 9)
						{
							if(sndFrameCheck != stepSndPlayedAt)
							{
								if(!audio_is_playing(snd_SpeedBooster) && !audio_is_playing(snd_SpeedBooster_Loop))
								{
									audio_play_sound(snd_Step,0,false);
								}
								stepSndPlayedAt = sndFrameCheck;
							}
						}
						else
						{
							stepSndPlayedAt = 0;
						}
						
						if(frame[Frame.Run] < 2)
						{
							frame[Frame.Run] += numRun;
						}
						else
						{
							frame[Frame.Run] = scr_wrap(frame[Frame.Run]+numRun, 2, 22);
						}
						
						frameCounter[Frame.Run] -= numCounter;
					}
				}
				else
				{
					frameCounter[Frame.Run]++;
					if(frameCounter[Frame.Run] > 4)
					{
						if(frame[Frame.Run] < 2)
						{
							frame[Frame.Run] += 1;
						}
						else
						{
							frame[Frame.Run] = scr_wrap(frame[Frame.Run]+1, 2, 22);
						}
						frameCounter[Frame.Run] = 0;
					}
				}
				
				runYOffset = -rOffset[frame[Frame.Run]];
				if(aimFrame != 0 || shootFrame)
				{
					runYOffset = -rOffset2[frame[Frame.Run]];
				}
				self.SetArmPosJump();
				if((aimFrame != 0 && aimFrame != 2 && aimFrame != -2) || (frame[Frame.Run] < 2 && aimFrame != 0))
				{
					if(frame[Frame.Run] < 2)
					{
						torsoR = sprt_Player_TransAimRight;
						torsoL = sprt_Player_TransAimLeft;
						self.SetArmPosTrans();
					}
					else
					{
						torsoR = sprt_Player_JumpAimRight;
						torsoL = sprt_Player_JumpAimLeft;
					}
					bodyFrame = 4 + aimFrame;
					drawMissileArm = true;
				}
				else
				{
					if(aimFrame == 0)
					{
						if(shootFrame)
						{
							torsoR = sprt_Player_RunAimRight;
							torsoL = sprt_Player_RunAimLeft;
							drawMissileArm = true;
						}
						else
						{
							torsoR = sprt_Player_RunRight;
							torsoL = sprt_Player_RunLeft;
						}
						if(frame[Frame.Run] == 0)
						{
							self.ArmPos(19*dir,-1);
						}
						else if(frame[Frame.Run] == 1)
						{
							self.ArmPos(21*dir,-2);
						}
						else
						{
							self.ArmPos(22*dir,-2);
						}
						runToStandFrame[shootFrame] = 2;
						runToStandFrame[!shootFrame] = 0;
						bodyFrame = frame[Frame.Run];
					}
					else
					{
						runToStandFrame[0] = 0;
						runToStandFrame[1] = 0;
						drawMissileArm = true;
						bodyFrame = runAimSequence[frame[Frame.Run]];
					}
					if(aimFrame == 2)
					{
						torsoR = sprt_Player_RunAimUpRight;
						torsoL = sprt_Player_RunAimUpLeft;
						self.ArmPos(19*dir,-21);
					}
					if(aimFrame == -2)
					{
						torsoR = sprt_Player_RunAimDownRight;
						torsoL = sprt_Player_RunAimDownLeft;
					}
				}
				legs = sprt_Player_RunLeg;
				legFrame = frame[Frame.Run];
				
				transFrame = 2;
				frame[Frame.JAim] = 6;
				break;
			}
			#endregion
			#region Brake
			case AnimState.Brake:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				walkToStandFrame = 0;
				runToStandFrame[0] = 0;
				runToStandFrame[1] = 0;
				transFrame = 2;
				
				bodyFrame = clamp(5 - ceil(brakeFrame/2), 0, 4);
				legFrame = bodyFrame;
				
				torsoR = sprt_Player_BrakeRight;
				torsoL = sprt_Player_BrakeLeft;
				legs = sprt_Player_BrakeLeg;
				var _armPosR = [[-3,-8], [-2,-8], [0,-8], [4,-7], [11,-5]],
					_armPosL = [[5,-6], [4,-6], [1,-7], [-1,-6], [-9,-4]];
				
				drawMissileArm = true;
				if(aimFrame > 0 && aimFrame < 3)
				{
					torsoR = sprt_Player_BrakeAimUpRight;
					torsoL = sprt_Player_BrakeAimUpLeft;
					_armPosR = [[5,-16], [6,-16], [7,-17], [13,-18], [14,-19]];
					_armPosL = [[-12,-16], [-13,-16], [-14,-17], [-16,-19], [-17,-20]];
				}
				else if(aimFrame < 0 && aimFrame > -3)
				{
					torsoR = sprt_Player_BrakeAimDownRight;
					torsoL = sprt_Player_BrakeAimDownLeft;
					_armPosR = [[1,12], [2,12], [3,11], [10,10], [12,9]];
					_armPosL = [[-11,11], [-12,11], [-13,10], [-14,9], [-16,8]];
				}
				else if(aimFrame >= 3)
				{
					torsoR = sprt_Player_BrakeAimUpVRight;
					torsoL = sprt_Player_BrakeAimUpVLeft;
					_armPosR = [[-6,-25], [-5,-25], [-4,-26], [0,-27], [1,-28]];
					_armPosL = [[0,-25], [-1,-25], [-2,-26], [-2,-27], [-4,-28]];
				}
				else if(shootFrame)
				{
					torsoR = sprt_Player_BrakeAimRight;
					torsoL = sprt_Player_BrakeAimLeft;
					_armPosR = [[4,2], [5,2], [7,2], [9,1], [12,1]];
					_armPosL = [[-14,2], [-15,2], [-16,2], [-16,1], [-17,1]];
				}
				else
				{
					drawMissileArm = false;
				}
				var armPos = _armPosR[bodyFrame];
				if(dir == -1)
				{
					armPos = _armPosL[bodyFrame];
				}
				self.ArmPos(armPos[0], armPos[1]);
				
				if(move != 0 && move != dir)
				{
					brakeFrame = max(brakeFrame - 2, 0);
				}
				else if(abs(velX) <= (maxSpeed[MaxSpeed.Sprint,liquidState]*0.75))
				{
					if(abs(velX) < (maxSpeed[MaxSpeed.Run,liquidState]*0.75) || move != 0)
					{
						brakeFrame = max(brakeFrame - ((abs(velX) < (maxSpeed[MaxSpeed.Run,liquidState]*0.75)) + (move != 0)), 0);
					}
				}
				if(brakeFrame >= 10 && !liquid)
				{
					part_particles_create(obj_Particles.partSystemB, x-(8+random(4))*dir, self.bb_bottom(y)+random(4), obj_Particles.bDust[1], 1);
				}
				if(brakeFrame <= 0)
				{
					brake = false;
				}
				break;
			}
			#endregion
			#region Crouch
			case AnimState.Crouch:
			{
				torsoR = sprt_Player_CrouchRight;
				torsoL = sprt_Player_CrouchLeft;
				legs = sprt_Player_CrouchLeg;
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Idle)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[Frame.JAim] = 6;
				
				var iNum = idleNum,
					iSeq = idleSequence;
				if(energy < lowEnergyThresh)
				{
					iNum = idleNum_Low;
					iSeq = idleSequence_Low;
				}
				frame[Frame.Idle] = scr_wrap(frame[Frame.Idle],0,array_length(iNum));
				
				frameCounter[Frame.Idle]++;
				if(frameCounter[Frame.Idle] > iNum[frame[Frame.Idle]])
				{
					frame[Frame.Idle] = scr_wrap(frame[Frame.Idle] + 1,0,array_length(iNum));
					frameCounter[Frame.Idle] = 0;
				}
				if(aimFrame != 0 || crouchFrame > 0 || recoilCounter > 0 || self.VisorSelected(Visor.Scan) || self.VisorSelected(Visor.XRay))
				{
					frame[Frame.Idle] = 0;
					frameCounter[Frame.Idle] = 0;
					if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame <= 0)
					{
						torsoR = sprt_Player_StandFireRight;
						torsoL = sprt_Player_StandFireLeft;
						bodyFrame = 2 + scr_round(aimFrame/2);
					}
					else
					{
						if(aimFrame == 0)
						{
							if(self.VisorSelected(Visor.Scan))
							{
								torsoR = sprt_Player_XRayRight;
								torsoL = sprt_Player_XRayLeft;
								var sdir = point_direction(x,y, scanVisor.GetRoomX(),scanVisor.GetRoomY());
								var xcone = abs(scr_wrap(sdir-90, -180, 180));
								bodyFrame = 4-scr_round(xcone/45);
							}
							else if(self.VisorSelected(Visor.XRay))
							{
								torsoR = sprt_Player_XRayRight;
								torsoL = sprt_Player_XRayLeft;
								var xcone = abs(scr_wrap(xrayVisor.coneDir-90, -180, 180));
								bodyFrame = 4-scr_round(xcone/45);
							}
							else
							{
								torsoR = sprt_Player_CrouchRight;
								torsoL = sprt_Player_CrouchLeft;
								bodyFrame = iSeq[frame[Frame.Idle]];
							}
						}
						else
						{
							torsoR = sprt_Player_StandAimRight;
							torsoL = sprt_Player_StandAimLeft;
							if(transFrame > 0)
							{
								torsoR = sprt_Player_TransAimRight;
								torsoL = sprt_Player_TransAimLeft;
								self.SetArmPosTrans();
							}
							if ((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
								(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) || 
								(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
							{
								torsoR = sprt_Player_JumpAimRight;
								torsoL = sprt_Player_JumpAimLeft;
								self.SetArmPosJump();
							}
							bodyFrame = 4 + aimFrame;
						}
					}
					crouchFinal = crouchSequence[scr_round(crouchFrame)];
					if(crouchFrame > 0)
					{
						legFrame = crouchFinal;
					}
					else
					{
						legFrame = 0;
					}
					sprtOffsetY = -crouchYOffset[legFrame];
				}
				else
				{
					bodyFrame = iSeq[frame[Frame.Idle]];
				}
				transFrame = max(transFrame - 1, 0);
				drawMissileArm = true;
				break;
			}
			#endregion
			#region Morph
			case AnimState.Morph:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Morph)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[Frame.JAim] = 6 * (velY <= 0);
				
				aimFrame = 0;
				self.ArmPos(0,0);
				
				var ballAnimDir = dir;
				if(sign(velX) != 0)
				{
					ballAnimDir = sign(velX);
				}
				if(self.SpiderActive())
				{
					if(sign(spiderSpeed) != 0)
					{
						ballAnimDir = sign(spiderSpeed);
					}
				}
				
				var xNum = point_distance(x,y,x+velX,y+velY);
				if(liquidMovement)
				{
					xNum *= 0.75;
				}
				xNum = xNum > 0 ? max(xNum,1) : 0;
				
				if(roomTrans)
				{
					morphNum = 1.5;
				}
				else if(state == State.BallSpark)
				{
					morphNum = min(morphNum + 0.25, shineSparkSpeed) * (shineEnd <= 0);
				}
				else
				{
					morphNum = xNum;
				}
				
				frame[Frame.Morph] = scr_wrap(frame[Frame.Morph] + morphNum/3*ballAnimDir, 0, 24);
				
				var yOffFrame = 4;
				if(unmorphing > 0 && scr_round(morphFrame) <= 5)
				{
					torsoR = sprt_Player_Morph;
					bodyFrame = scr_round(morphFrame)-1;
					yOffFrame = bodyFrame;
				}
				else if(scr_round(morphFrame) >= 4 && unmorphing == 0)
				{
					torsoR = sprt_Player_Morph;
					bodyFrame = 8-scr_round(morphFrame);
					yOffFrame = bodyFrame;
				}
				else
				{
					fDir = 1;
					torsoR = sprt_Player_MorphBall;
					if((item[Item.MagniBall] || item[Item.SpiderBall]))
					{
						torsoR = sprt_Player_MorphBallAlt;
					}
					bodyFrame = frame[Frame.Morph];
				}
				torsoL = torsoR;
				
				if(unmorphing > 0)
				{
					var _yo = 8-morphYOffset[yOffFrame];
					sprtOffsetY = clamp(-morphYDiff, -_yo, _yo);
				}
				else if(scr_round(morphFrame) >= 4)
				{
					var _yo = morphYOffset[yOffFrame];
					sprtOffsetY = clamp(-morphYDiff, -_yo, _yo);
				}
				
				break;
			}
			#endregion
			#region Jump
			case AnimState.Jump:
			{
				self.SetArmPosJump();
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.JAim && i != Frame.Jump)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				if(shootFrame || cMoonwalk || aimFrame != 0 || recoilCounter > 0)
				{
					aimAnimTweak = 2;
				}
				if(aimAnimTweak > 0)
				{
					if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame >= 0)
					{
						torsoR = sprt_Player_JumpFireRight;
						torsoL = sprt_Player_JumpFireLeft;
						bodyFrame = 2 + scr_round(aimFrame/2);
						
						if(bodyFrame <= 0)
						{
							sprtOffsetX = -4 * fDir;
						}
					}
					else
					{
						if(transFrame < 2)
						{
							torsoR = sprt_Player_TransAimRight;
							torsoL = sprt_Player_TransAimLeft;
							self.SetArmPosTrans();
						}
						else
						{
							torsoR = sprt_Player_JumpAimRight;
							torsoL = sprt_Player_JumpAimLeft;
						}
						bodyFrame = 4 + aimFrame;
						
						if(bodyFrame <= 1)
						{
							sprtOffsetX = -4 / (1+bodyFrame) * fDir;
							if(transFrame < 2)
							{
								sprtOffsetX /= 2;
							}
						}
					}
					
					legs = sprt_Player_JumpAimLeg;
					if(!roomTrans)
					{
						if(velY <= 0)
						{
							frame[Frame.JAim] = max(frame[Frame.JAim] - 0.3, 0);
							frame[Frame.Jump] = 0;
						}
						else
						{
							var jAimFMax = 9;
							if(bodyFrame <= 0)
							{
								jAimFMax = 6;
							}
							if(frame[Frame.JAim] < jAimFMax)
							{
								frame[Frame.JAim] = min(frame[Frame.JAim] + max(1/max(frame[Frame.JAim],1),0.25), jAimFMax);
							}
							else if(bodyFrame <= 0)
							{
								frame[Frame.JAim] = max(frame[Frame.JAim] - 1, jAimFMax);
							}
							
							if(ledgeFall2)
							{
								frame[Frame.Jump] = 0;
							}
							else
							{
								frame[Frame.Jump] = 5;
							}
						}
					}
					legFrame = frame[Frame.JAim];
					drawMissileArm = true;
				}
				else
				{
					if(ledgeFall2)
					{
						if(velY < 0)
						{
							ledgeFall2 = false;
						}
						frame[Frame.JAim] = 6;
						
						torsoR = sprt_Player_FallRight;
						torsoL = sprt_Player_FallLeft;
						legs = sprt_Player_JumpAimLeg;
						
						if(frameCounter[Frame.Jump] < 30)
						{
							if(!roomTrans)
							{
								frame[Frame.Jump] = min(frame[Frame.Jump] + max(0.5/max(frame[Frame.Jump],1),0.125), 4);
								if(frame[Frame.Jump] >= 4)
								{
									frameCounter[Frame.Jump]++;
								}
							}
							bodyFrame = scr_round(frame[Frame.Jump]);
							legFrame = floor((frame[Frame.Jump]+0.5)*2);
						}
						else
						{
							if(!roomTrans)
							{
								frame[Frame.Jump] = clamp(frame[Frame.Jump] + 0.25,4,8);
							}
							bodyFrame = scr_floor(frame[Frame.Jump]);
							legFrame = scr_ceil(12 - frame[Frame.Jump]);
						}
					}
					else
					{
						if(!roomTrans)
						{
							if(velY <= 0 || frame[Frame.Jump] < 4)
							{
								frame[Frame.Jump] = min(frame[Frame.Jump] + (0.5/(1+liquidMovement)), 4);
								frame[Frame.JAim] = 6;
							}
							else
							{
								frame[Frame.Jump] = clamp(frame[Frame.Jump] + (0.25/(1+liquidMovement)), 4, 9);
								frame[Frame.JAim] = 6;
							}
						}
						torsoR = sprt_Player_JumpRight;
						torsoL = sprt_Player_JumpLeft;
						bodyFrame = frame[Frame.Jump];
					}
				}
				transFrame = min(transFrame + 1, 2);
				break;
			}
			#endregion
			#region Somersault
			case AnimState.Somersault:
			{
				aimFrame = 0;
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Somersault)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[Frame.JAim] = 6 * (velY <= 0);
				if(wjFrame > 0 || (canWallJump && self.entity_place_collide(-8*move,0) && !self.entity_place_collide(0,16) && wjAnimDelay <= 0))
				{
					torsoR = sprt_Player_WallJumpRight;
					torsoL = sprt_Player_WallJumpLeft;
					if(wjGripAnim)
					{
						torsoR = sprt_Player_GripWallJumpRight;
						torsoL = sprt_Player_GripWallJumpLeft;
					}
					if(wjFrame > 0)
					{
						bodyFrame = wjSequence[scr_round(wjFrame)];
						frame[Frame.Somersault] = 3;
						if(item[Item.SpaceJump] && !liquidMovement)
						{
							frame[Frame.Somersault] = 2;
						}
					}
					else
					{
						bodyFrame = 0;
					}
					switch bodyFrame
					{
						case 1:
						{
							ArmPos(7*dir,-3);
							break;
						}
						case 2:
						{
							ArmPos(13*dir,-4);
							break;
						}
						case 3:
						{
							ArmPos(8*dir,7);
							break;
						}
						default:
						{
							ArmPos(-5*dir,-5);
							break;
						}
					}
				}
				else
				{
					torsoR = sprt_Player_SomersaultRight;
					torsoL = sprt_Player_SomersaultLeft;
					var sFrameMax = 18;
					if(item[Item.SpaceJump] && !liquidMovement)
					{
						if(spaceJump <= 0)
						{
							torsoR = sprt_Player_SpaceJumpRight;
							torsoL = sprt_Player_SpaceJumpLeft;
						}
						sFrameMax = 10;
					}
					if(oldDir == dir)
					{
						var num = 0;
						if(frame[Frame.Somersault] == 0 || frame[Frame.Somersault] == 1)
						{
							num = 1+(frame[Frame.Somersault] == 0);
						}
						num += liquidMovement;
						if(roomTrans)
						{
							num = 4;
						}
						frameCounter[Frame.Somersault]++;
						if(frameCounter[Frame.Somersault] > num)
						{
							frame[Frame.Somersault]++;
							frameCounter = 0;
						}
						if(frame[Frame.Somersault] >= sFrameMax)
						{
							frame[Frame.Somersault] = 2;
						}
					}
					else if(frame[Frame.Somersault] >= 2)
					{
						frame[Frame.Somersault] = scr_wrap(frame[Frame.Somersault] - (frame[Frame.Somersault]-2)*2, 2, sFrameMax);
					}
					bodyFrame = frame[Frame.Somersault];
					if(spaceJump > 0 && frame[Frame.Somersault] >= 2)
					{
						bodyFrame = scr_wrap(frame[Frame.Somersault]*2, 2, 18);
					}
					var degNum = 40;
					if(item[Item.SpaceJump] && !liquidMovement)
					{
						degNum = 90;
					}
					self.SetArmPosSomersault(sFrameMax, degNum, frame[Frame.Somersault]);
				}
				break;
			}
			#endregion
			#region Grip
			case AnimState.Grip:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				var gripAimTarget = aimFrameTarget+4;
				fDir = grippedDir;
				if(climbIndex <= 0)
				{
					var usingVisor = (self.VisorSelected(Visor.Scan) || self.VisorSelected(Visor.XRay));
					var visorFrame = 2;
					if(self.VisorSelected(Visor.Scan))
					{
						var sdir = point_direction(x,y, scanVisor.GetRoomX(),scanVisor.GetRoomY());
						var xcone = abs(scr_wrap(sdir-90, -180, 180));
						visorFrame = 4-scr_round(xcone/45);
					}
					if(self.VisorSelected(Visor.XRay))
					{
						var xcone = abs(scr_wrap(xrayVisor.coneDir-90, -180, 180));
						visorFrame = 4-scr_round(xcone/45);
					}
					
					var faceAway = (dir != grippedDir);
					if(faceAway)
					{
						gripTurnFrame = min(gripTurnFrame+1,3);
					}
					else
					{
						gripTurnFrame = max(gripTurnFrame-1,0);
					}
					
					if(grippedDir == -1)
					{
						gripOverlay = sprt_Player_GripLeft_ArmOverlay;
					}
					
					if(gripTurnFrame > 0 && gripTurnFrame < 3)
					{
						bodyFrame = gripTurnFrame-1;
						gripOverlayFrame = gripTurnFrame+5;
						torsoR = sprt_Player_GripTurnRight_Idle;
						torsoL = sprt_Player_GripTurnLeft_Idle;
						self.ArmPos(-4*fDir, 11);
						if(bodyFrame > 0)
						{
							self.ArmPos(-5*fDir, 11);
						}
						
						if(!usingVisor)
						{
							if(aimFrame > 0 && aimFrame < 3)
							{
								torsoR = sprt_Player_GripTurnRight_AimUp;
								torsoL = sprt_Player_GripTurnLeft_AimUp;
								self.ArmPos(-4*fDir,-21);
								if(bodyFrame > 0)
								{
									self.ArmPos(-19*fDir,-21);
								}
							}
							else if(aimFrame < 0 && aimFrame > -3)
							{
								torsoR = sprt_Player_GripTurnRight_AimDown;
								torsoL = sprt_Player_GripTurnLeft_AimDown;
								self.ArmPos(-4*fDir,8);
								if(bodyFrame > 0)
								{
									self.ArmPos(-15*fDir,9);
								}
							}
							else if(aimFrame >= 3)
							{
								torsoR = sprt_Player_GripTurnRight_AimUpV;
								torsoL = sprt_Player_GripTurnLeft_AimUpV;
								self.ArmPos(-4*fDir,-30);
								if(bodyFrame > 0)
								{
									self.ArmPos(-7*fDir,-30);
								}
							}
							else if(aimFrame <= -3)
							{
								torsoR = sprt_Player_GripTurnRight_AimDownV;
								torsoL = sprt_Player_GripTurnLeft_AimDownV;
								self.ArmPos(-8*fDir,16);
								if(bodyFrame > 0)
								{
									self.ArmPos(-10*fDir,17);
								}
							}
							else
							{
								torsoR = sprt_Player_GripTurnRight;
								torsoL = sprt_Player_GripTurnLeft;
								self.ArmPos(0,-1);
								if(bodyFrame > 0)
								{
									self.ArmPos(-24*fDir,-3);
								}
							}
						}
					}
					else if(usingVisor)
					{
						torsoR = sprt_Player_GripXRayRight;
						torsoL = sprt_Player_GripXRayLeft;
						bodyFrame = visorFrame;
						gripOverlayFrame = bodyFrame;
						if(faceAway)
						{
							torsoR = sprt_Player_GripXRayAwayRight;
							torsoL = sprt_Player_GripXRayAwayLeft;
							gripOverlayFrame = 7;
						}
					}
					else
					{
						drawMissileArm = true;
						
						torsoR = sprt_Player_GripIdleRight;
						torsoL = sprt_Player_GripIdleLeft;
						bodyFrame = min(gripAimAnim,1);
						gripOverlayFrame = 2;
						self.ArmPos(-1*fDir, 9);
						finalArmFrame = 2;
						if(bodyFrame > 0)
						{
							self.ArmPos(2*fDir, 3);
							finalArmFrame = 3;
						}
						
						if(shootFrame || aimFrame != 0 || recoilCounter > 0 || faceAway)
						{
							aimAnimTweak = 2;
						}
						if(aimAnimTweak > 0 && !faceAway)
						{
							gripAimAnim = min(gripAimAnim+1,2);
						}
						else
						{
							gripAimAnim = max(gripAimAnim-1,0);
						}
						
						if(aimAnimTweak > 0 || gripAimAnim >= 2)
						{
							if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame >= 0)
							{
								torsoR = sprt_Player_GripAimRight_Recoil;
								torsoL = sprt_Player_GripAimLeft_Recoil;
								bodyFrame = 2 + scr_round(aimFrame/2);
								gripOverlayFrame = bodyFrame;
								if(faceAway)
								{
									torsoR = sprt_Player_GripAimAwayRight_Recoil;
									torsoL = sprt_Player_GripAimAwayLeft_Recoil;
									gripOverlayFrame = 7;
								}
							}
							else
							{
								torsoR = sprt_Player_GripAimRight;
								torsoL = sprt_Player_GripAimLeft;
								bodyFrame = 4 + aimFrame;
								gripOverlayFrame = 2 + scr_round(aimFrame/2);
								if(faceAway)
								{
									torsoR = sprt_Player_GripAimAwayRight;
									torsoL = sprt_Player_GripAimAwayLeft;
									gripOverlayFrame = 7;
								}
							}
							
							self.SetArmPosGrip();
							finalArmFrame = aimFrame + 4;
						}
					}
				}
				else
				{
					aimFrame = 0;
					gripTurnFrame = 0;
					torsoR = sprt_Player_ClimbRight;
					torsoL = sprt_Player_ClimbLeft;
					if(climbIndexCounter > liquidMovement)
					{
						climbFrame = climbSequence[climbIndex];
					}
					bodyFrame = climbFrame;
					self.SetArmPosClimb();
				}
				
				break;
			}
			#endregion
			#region Spark
			case AnimState.Spark:
			{
				aimFrame = 0;
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.SparkStart && i != Frame.SparkV && i != Frame.SparkH)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				if(shineStart > 0)
				{
					if(shineStart <= 20)
					{
						frame[Frame.SparkStart] = min(frame[Frame.SparkStart] + 0.25, 3);
					}
					torsoR = sprt_Player_SparkStartRight;
					torsoL = sprt_Player_SparkStartLeft;
					bodyFrame = floor(frame[Frame.SparkStart]);
					frame[Frame.SparkV] = 0;
					frameCounter[Frame.SparkV] = 0;
					frame[Frame.SparkH] = 0;
					frameCounter[Frame.SparkH] = 0;
					
					switch(bodyFrame)
					{
						case 3:
						{
							self.ArmPos(2*dir,9);
							break;
						}
						case 2:
						{
							self.ArmPos(2*dir,7);
							break;
						}
						case 1:
						{
							self.ArmPos(2*dir,5);
							break;
						}
						default:
						{
							self.ArmPos(2*dir,4);
							break;
						}
					}
				}
				else
				{
					if(self.SparkDir_VertUp())
					{
						if(frame[Frame.SparkV] < 1)
						{
							frameCounter[Frame.SparkV] += 1;
							if(frameCounter[Frame.SparkV] > 2)
							{
								frame[Frame.SparkV] += 1;
								frameCounter[Frame.SparkV] = 0;
							}
						}
						else if(shineEnd <= 0)
						{
							frameCounter[Frame.SparkV] += 1;
							if(!roomTrans || frameCounter[Frame.SparkV] > 4)
							{
								frame[Frame.SparkV] = scr_wrap(frame[Frame.SparkV]+1,1,17);
								frameCounter[Frame.SparkV] = 0;
							}
						}
						torsoR = sprt_Player_SparkVRight;
						torsoL = sprt_Player_SparkVLeft;
						bodyFrame = frame[Frame.SparkV];
						
						self.SetArmPosSpark(0);
					}
					else if(self.SparkDir_VertDown())
					{
						if(abs(shineDownRot) < 180)
						{
							shineDownRot = clamp(shineDownRot - 45*dir, -180, 180);

							torsoR = sprt_Player_SomersaultRight;
							torsoL = sprt_Player_SomersaultLeft;
							bodyFrame = scr_round(abs(shineDownRot)/45)*2;
							sprtOffsetY = 8*(abs(shineDownRot)/180);
							
							self.SetArmPosSomersault(17, 40, bodyFrame);
						}
						else
						{
							if(frame[Frame.SparkV] < 1)
							{
								frameCounter[Frame.SparkV] += 1;
								if(frameCounter[Frame.SparkV] > 1)
								{
									frame[Frame.SparkV] += 1;
									frameCounter[Frame.SparkV] = 0;
								}
							}
							else if(shineEnd <= 0)
							{
								frameCounter[Frame.SparkV] += 1;
								if(!roomTrans || frameCounter[Frame.SparkV] > 4)
								{
									frame[Frame.SparkV] = scr_wrap(frame[Frame.SparkV]+1,1,17);
									frameCounter[Frame.SparkV] = 0;
								}
							}
							torsoR = sprt_Player_SparkVRight;
							torsoL = sprt_Player_SparkVLeft;
							bodyFrame = frame[Frame.SparkV];
							rotation = shineDownRot;
							sprtOffsetY = 8;
							
							self.SetArmPosSpark(shineDownRot);
						}
					}
					else
					{
						frame[Frame.SparkH] = min(frame[Frame.SparkH] + 0.3334, 2);
						if(shineRestart)
						{
							frame[Frame.SparkH] = 0;
						}
						torsoR = sprt_Player_SparkHRight;
						torsoL = sprt_Player_SparkHLeft;
						bodyFrame = floor(frame[Frame.SparkH]);
						
						switch(bodyFrame)
						{
							case 2:
							{
								self.ArmPos(-17,-1);
								if(dir == -1)
								{
									self.ArmPos(-4,-3);
								}
								break;
							}
							case 1:
							{
								self.ArmPos(-10,8);
								if(dir == -1)
								{
									self.ArmPos(-5,-3);
								}
								break;
							}
							default:
							{
								self.ArmPos(-5,9);
								if(dir == -1)
								{
									self.ArmPos(-9,-2);
								}
								break;
							}
						}
					}
					
					// --- Uncomment this code to ASSERT DOMINANCE while Shine Sparking ---
					
						/*torsoR = sprt_Dominance;
						torsoL = torsoR;
						bodyFrame = 0;
						fDir = 1;*/
						
					// ---
				}
				break;
			}
			#endregion
			#region Grapple
			case AnimState.Grapple:
			{
	            for(var i = 0; i < array_length(frame); i += 1)
	            {
	                if(i != Frame.GrappleLeg && i != Frame.GrappleBody && i != Frame.JAim)
	                {
	                    frame[i] = 0;
	                    frameCounter[i] = 0;
	                }
	            }
				var _grapAngle = grapAngle;
				if(instance_exists(grapple))
				{
					_grapAngle = point_direction(position.X, position.Y, grapple.x, grapple.y) - 90;
				}
				
				var _gAngle = scr_wrap(-_grapAngle*dir,0,360);
				var _somerFrame = _gAngle / (360 / 16);
				if(item[Item.SpaceJump] && !liquidMovement)
				{
					_somerFrame = _gAngle / (360 / 8);
				}
				frame[Frame.Somersault] = 2 + _somerFrame;
				
	            if(grapWJCounter > 0)
	            {
	                torsoR = sprt_Player_GrappleWJRight;
	                torsoL = sprt_Player_GrappleWJLeft;
	                bodyFrame = 0;
	                self.ArmPos(-15*dir,-22);
					rotation = 0;
	            }
				else if(aimFrame != aimFrameTarget)
				{
					torsoR = sprt_Player_JumpAimRight;
					torsoL = sprt_Player_JumpAimLeft;
					bodyFrame = 4 + scr_round(aimFrame);
					
					legs = sprt_Player_JumpAimLeg;
					legFrame = frame[Frame.JAim];
					
					var aimF = scr_round(aimFrame)-aimFrameTarget;
					var gRot = _grapAngle + abs(aimF)*22.5*fDir;
					rotation = scr_round(gRot/2.8125)*2.8125;
					
					self.SetArmPosJump();
					var armR = point_direction(0,0,armOffsetX,armOffsetY),
						armL = point_distance(0,0,armOffsetX,armOffsetY);
					
					self.ArmPos(lengthdir_x(armL,armR+rotation),lengthdir_y(armL,armR+rotation));
				}
	            else
	            {
	                torsoR = sprt_Player_GrappleRight;
	                torsoL = sprt_Player_GrappleLeft;
					
					if(speedBoost)
					{
						frame[Frame.GrappleBody] = clamp(frame[Frame.GrappleBody]+1,9,14);
					}
					else
					{
						frame[Frame.GrappleBody] = scr_wrap(10-scr_round(_grapAngle/18)*dir,0,20);
					}
					bodyFrame = frame[Frame.GrappleBody];
					
					legs = sprt_Player_GrappleLeg;
	                rotation = scr_round(_grapAngle/2.8125)*2.8125;

	                self.ArmPos(lengthdir_x(31, rotation + 90),lengthdir_y(31, rotation + 90));
	                if(grapDisVel <= -1 && grapWallBounceFrame <= 0)
	                {
	                    grapFrame = max(grapFrame-(0.34-(0.09*liquidMovement)),0);
	                }
	                else
	                {
	                    grapFrame = min(grapFrame+(0.34-(0.09*liquidMovement)),3);
	                }
	                if(grapFrame <= 2)
	                {
	                    frame[Frame.GrappleLeg] = 0;
	                    legFrame = scr_ceil(grapFrame);
	                }
	                else
					{
						if(instance_exists(grapple))
		                {
							var grapAngVel = angle_difference(point_direction(x+velX,y+velY,grapple.x,grapple.y),point_direction(x,y,grapple.x,grapple.y));
						
							var gFrameDest = 0;
		                    if(grapDisVel >= 1)
		                    {
		                        gFrameDest = 2*dir;
		                    }
		                    else
							{
								if(move != 0 && move == sign(grapAngVel))
								{
									gFrameDest = move;
								}
							}
		                    if(grapWallBounceFrame > 0)
		                    {
		                        gFrameDest = 2*sign(grapAngVel);
		                        frame[Frame.GrappleLeg] = gFrameDest;
		                    }
							if(frame[Frame.GrappleLeg] != gFrameDest)
							{
								var fnum = 3 * (1 + liquidMovement);
								frameCounter[Frame.GrappleLeg]++;
								if(frameCounter[Frame.GrappleLeg] > fnum)
								{
									if(frame[Frame.GrappleLeg] < gFrameDest)
									{
										frame[Frame.GrappleLeg] = min(frame[Frame.GrappleLeg]+1,gFrameDest);
									}
									else
									{
										frame[Frame.GrappleLeg] = max(frame[Frame.GrappleLeg]-1,gFrameDest);
									}
									frameCounter[Frame.GrappleLeg] = 0;
								}
							}
							else
							{
								frameCounter[Frame.GrappleLeg] = 0;
							}
						}
	                    legFrame = 5+(scr_round(frame[Frame.GrappleLeg])*dir);
	                }
	            }
				break;
			}
			#endregion
			#region Hurt
			case AnimState.Hurt:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				gunReady = false;
				ledgeFall2 = true;
				
				torsoR = sprt_Player_HurtRight;
				torsoL = sprt_Player_HurtLeft;
				bodyFrame = floor(hurtFrame);
				hurtFrame = min(hurtFrame + 0.34, 1);
				self.ArmPos(11,-11);
				if(dir == -1)
				{
					self.ArmPos(-2,-14);
				}
				
				/*torsoR = sprt_DamageRight;
				torsoL = sprt_DamageLeft;
				if(hurtTime <= 2)
				{
					bodyFrame = 2;
				}
				else
				{
					bodyFrame = floor(hurtFrame);
					hurtFrame = min(hurtFrame + 0.34, 1);
				}*/
				
				break;
			}
			#endregion
			#region Damage Boost
			case AnimState.DmgBoost:
			{
				self.SetArmPosJump();
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.JAim && i != Frame.Jump || dBoostFrame < 19)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				torsoR = sprt_Player_DamageBoostRight;
				torsoL = sprt_Player_DamageBoostLeft;
				if(dBoostFrame < 19)
				{
					frame[Frame.JAim] = 6;
					bodyFrame = dBoostFrameSeq[dBoostFrame];
					if(dBoostFrame != 0)
					{
						torsoR = sprt_Player_SomersaultRight;
						torsoL = sprt_Player_SomersaultLeft;
					}
					
					self.SetArmPosSomersault(18, 40, bodyFrame);
					
					var loopPoint = 17;
					if(velY >= 0)
					{
						loopPoint = 20;
					}
					dBoostFrameCounter++;
					if(dBoostFrameCounter > 5)
					{
						dBoostFrame = scr_wrap(dBoostFrame+1,min(dBoostFrame,2),loopPoint);
						dBoostFrameCounter = 6;
					}
				}
				else
				{
					if(shootFrame || cMoonwalk || aimFrame != 0 || recoilCounter > 0)
					{
						aimAnimTweak = 2;
					}
					if(aimAnimTweak > 0)
					{
						if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame >= 0)
						{
							torsoR = sprt_Player_JumpFireRight;
							torsoL = sprt_Player_JumpFireLeft;
							bodyFrame = 2 + scr_round(aimFrame/2);
						
							if(bodyFrame <= 0)
							{
								sprtOffsetX = -4 * fDir;
							}
						}
						else
						{
							if(transFrame < 2)
							{
								torsoR = sprt_Player_TransAimRight;
								torsoL = sprt_Player_TransAimLeft;
								self.SetArmPosTrans();
							}
							else
							{
								torsoR = sprt_Player_JumpAimRight;
								torsoL = sprt_Player_JumpAimLeft;
							}
							bodyFrame = 4 + aimFrame;
						
							if(bodyFrame <= 1)
							{
								sprtOffsetX = -4 / (1+bodyFrame) * fDir;
								if(transFrame < 2)
								{
									sprtOffsetX /= 2;
								}
							}
						}
					
						legs = sprt_Player_JumpAimLeg;
						if(!roomTrans)
						{
							if(velY <= 0)
							{
								frame[Frame.JAim] = max(frame[Frame.JAim] - 0.3, 0);
								frame[Frame.Jump] = 0;
							}
							else
							{
								var jAimFMax = 9;
								if(bodyFrame <= 0)
								{
									jAimFMax = 6;
								}
								if(frame[Frame.JAim] < jAimFMax)
								{
									frame[Frame.JAim] = min(frame[Frame.JAim] + max(1/max(frame[Frame.JAim],1),0.25), jAimFMax);
								}
								else if(bodyFrame <= 0)
								{
									frame[Frame.JAim] = max(frame[Frame.JAim] - 1, jAimFMax);
								}
							
								if(ledgeFall2)
								{
									frame[Frame.Jump] = 0;
								}
								else
								{
									frame[Frame.Jump] = 5;
								}
							}
						}
						legFrame = frame[Frame.JAim];
						drawMissileArm = true;
					}
					else
					{
						frame[Frame.JAim] = 6;
						
						torsoR = sprt_Player_FallRight;
						torsoL = sprt_Player_FallLeft;
						legs = sprt_Player_JumpAimLeg;
						
						if(frameCounter[Frame.Jump] < 30)
						{
							if(!roomTrans)
							{
								frame[Frame.Jump] = min(frame[Frame.Jump] + max(0.5/max(frame[Frame.Jump],1),0.125), 4);
								if(frame[Frame.Jump] >= 4)
								{
									frameCounter[Frame.Jump]++;
								}
							}
							bodyFrame = scr_round(frame[Frame.Jump]);
							legFrame = floor((frame[Frame.Jump]+0.5)*2);
						}
						else
						{
							if(!roomTrans)
							{
								frame[Frame.Jump] = clamp(frame[Frame.Jump] + 0.25,4,8);
							}
							bodyFrame = scr_floor(frame[Frame.Jump]);
							legFrame = scr_ceil(12 - frame[Frame.Jump]);
						}
					}
				}
				break;
			}
			#endregion
			#region Dodge
			case AnimState.Dodge:
			{
				aimFrame = 0;
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Dodge)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				torsoR = sprt_Player_SparkHRight;
				torsoL = sprt_Player_SparkHLeft;
				if(dodgeDir != dir)
				{
					torsoR = sprt_Player_DodgeBack_Right;
					torsoL = sprt_Player_DodgeBack_Left;
				}
				if(dodgeLength <= dodgeLengthMax-2)
				{
					frame[Frame.Dodge] = min(frame[Frame.Dodge]+(0.5/(1+liquidMovement)),2);
					if(groundedDodge == 1)
					{
						sprtOffsetY = -5*(2-frame[Frame.Dodge]);
					}
				}
				else
				{
					frame[Frame.Dodge] = max(frame[Frame.Dodge]-(1/(1+liquidMovement)),0);
				}
				bodyFrame = scr_floor(frame[Frame.Dodge]);
				
				if(dodgeDir == dir)
				{
					switch(bodyFrame)
					{
						case 2:
						{
							self.ArmPos(-17,-1);
							if(dir == -1)
							{
								self.ArmPos(-4,-3);
							}
							break;
						}
						case 1:
						{
							self.ArmPos(-10,8);
							if(dir == -1)
							{
								self.ArmPos(-5,-3);
							}
							break;
						}
						default:
						{
							self.ArmPos(-5,9);
							if(dir == -1)
							{
								self.ArmPos(-9,-2);
							}
							break;
						}
					}
				}
				else
				{
					switch(bodyFrame)
					{
						case 2:
						{
							self.ArmPos(14,-12);
							if(dir == -1)
							{
								self.ArmPos(-1,0);
							}
							break;
						}
						case 1:
						{
							self.ArmPos(8,-7);
							if(dir == -1)
							{
								self.ArmPos(-6,-3);
							}
							break;
						}
						default:
						{
							self.ArmPos(1*dir,7);
							break;
						}
					}
				}
				
				break;
			}
			#endregion
			#region CrystalFlash
			case AnimState.CrystalFlash:
			{
				aimFrame = 0;
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.CFlash)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				if(frame[Frame.CFlash] < 5)
				{
					torsoR = sprt_Player_Morph;
					bodyFrame = 4-frame[Frame.CFlash];
					sprtOffsetY = 8-morphYOffset[bodyFrame];
					
					frame[Frame.CFlash]++;
				}
				else
				{
					frameCounter[Frame.CFlash]++;
					if(frameCounter[Frame.CFlash] > 8)
					{
						frame[Frame.CFlash] = scr_wrap(frame[Frame.CFlash]+1,5,9);
						frameCounter[Frame.CFlash] = 0;
					}
					
					torsoR = sprt_Player_CrystalFlash;
					bodyFrame = cFlashFrameSequence[frame[Frame.CFlash]-5];
					
					sprtOffsetY = -bodyFrame;
				}
				
				torsoL = torsoR;
				break;
			}
			#endregion
			#region Push
			case AnimState.Push:
			{
				for(var i = 0; i < array_length(frame); i += 1)
	            {
	                if(i != Frame.Push)
	                {
	                    frame[i] = 0;
	                    frameCounter[i] = 0;
	                }
	            }
	            aimFrame = 0;
	            transFrame = 0;
	            walkToStandFrame = 0;
	            runToStandFrame[0] = 0;
	            runToStandFrame[1] = 0;

	            torsoR = sprt_Player_PushRight;
	            torsoL = sprt_Player_PushLeft;

	            if(grounded && move2 != 0 && instance_exists(pushBlock) && pushBlock.grounded)
	            {
					var animSpStart = 0.375 / (1+liquidMovement),
						animSp = 0.275 / (1+liquidMovement);
					if(cSprint || global.autoSprint)
					{
						animSpStart = 0.5 / (1+liquidMovement);
						animSp = 0.375 / (1+liquidMovement);
					}
	                if(frame[Frame.Push] < 5)
					{
						frame[Frame.Push] += animSpStart
					}
					else
					{
						frame[Frame.Push] = scr_wrap(frame[Frame.Push] + animSp, 5, 18);
					}
					if(scr_floor(frame[Frame.Push]) == 16)
					{
						if(stepSndPlayedAt != scr_floor(frame[Frame.Push]))
						{
							audio_play_sound(snd_Step,0,false);
							stepSndPlayedAt = scr_floor(frame[Frame.Push]);
						}
					}
					else
					{
						stepSndPlayedAt = 0;
					}
	            }
	            else
	            {
	                frame[Frame.Push] = clamp(frame[Frame.Push] - (0.5 / (1+liquidMovement)), 0, 3);
	            }
	            bodyFrame = pushFrameSequence[scr_floor(frame[Frame.Push])];
				break;
			}
			#endregion
		}
	}
	
	if(!roomTrans)
	{
		var animDiv = (1+liquidMovement);
		var animSpeed = 1/animDiv;
		
		aimAnimTweak = max(aimAnimTweak - 1, 0);
		aimSnap = max(aimSnap - 1, 0);
		if(morphFrame <= 0 && (state != State.Stand || crouchFrame >= 5) && (state != State.Crouch || crouchFrame <= 0))
		{
			aimAnimDelay = max(aimAnimDelay - 1, 0);
		}
		if(sign(velX) == dir)
		{
			landFrame = max(landFrame - (1 + max(1.5*(move != 0),abs(velX)*0.5))/animDiv, 0);
		}
		else
		{
			landFrame = max(landFrame - animSpeed, 0);
		}
		if(animState != AnimState.Crouch)
		{
			crouchFrame = min(crouchFrame + (1 + abs(velX)*0.5)/animDiv, 5);
		}
		else
		{
			crouchFrame = max(crouchFrame - animSpeed, 0);
		}
		if(liquidMovement)
		{
			wjFrame = max(wjFrame - 0.83, 0);
		}
		else
		{
			wjFrame = max(wjFrame - 1, 0);
		}
		if(wjFrame <= 0 || animState != AnimState.Somersault)
		{
			wjGripAnim = false;
		}
		wjAnimDelay = max(wjAnimDelay - 1, 0);
		spaceJump = max(spaceJump - 1, 0);
		morphFrame = max(morphFrame - animSpeed, 0);
		
		if(animState == AnimState.Brake)
		{
			runToStandFrame[0] = 0;
			runToStandFrame[1] = 0;
			walkToStandFrame = 0;
		}
		else if(animState == AnimState.Stand)
		{
			runToStandFrame[0] = max(runToStandFrame[0] - animSpeed, 0);
			runToStandFrame[1] = max(runToStandFrame[1] - animSpeed, 0);
		
			if(!walkState)
			{
				walkToStandFrame = max(walkToStandFrame - (1/(1+(walkToStandFrame < 2)))/animDiv, 0);
			}
		}
		else if(animState != AnimState.Run && animState != AnimState.Walk)
		{
			runToStandFrame[0] = 2;
			if(animState == AnimState.Crouch || animState == AnimState.Grip)
			{
				runToStandFrame[0] = 0;
			}
			runToStandFrame[1] = 0;
			walkToStandFrame = 0;
		}
	
		if(animState != AnimState.Brake)
		{
			brakeFrame = 0;
		}
		if(animState != AnimState.Spark)
		{
			shineDownRot = 0;
		}
		if(animState != AnimState.Grapple)
		{
		    grapFrame = 3;
		    grapWallBounceFrame = 0;
		}
		else
		{
		    grapWallBounceFrame = max(grapWallBounceFrame-1,0);
		}
		if(animState != AnimState.DmgBoost)
		{
			dBoostFrame = 0;
			dBoostFrameCounter = 0;
		}
	
		recoilCounter = max(recoilCounter - 1, 0);
	
		if(climbIndexCounter > liquidMovement || climbIndex <= 1)
		{
			if(state == State.Grip && startClimb)
			{
				var ciNum = 1;
				if(!liquidMovement && climbIndex >= 10 && (cSprint || global.autoSprint) && move != 0)
				{
					ciNum = 2;
				}
				climbIndex = min(climbIndex + ciNum, 18);
			}
			climbIndexCounter = 0;
		}
	
		if(startClimb)
		{
			climbIndexCounter += 1;
		}
	}
	#endregion
	
	#region After Image Logic
	
	drawAfterImage = false;
	afterImageNum = 0;
	afterImgAlphaMult = 0.625;
	
	if(state == State.Spark || state == State.BallSpark)
	{
		drawAfterImage = true;
		afterImageNum = 10*shineFXCounter;
	}
	else if(speedBoost)
	{
		drawAfterImage = true;
		afterImageNum = (10 * speedFXCounter);
	}
	else if(state != State.Grip)
	{
		afterImgAlphaMult = 0.25;
		if(state == State.Dodge)
		{
			drawAfterImage = true;
			afterImageNum = min(abs(fVelX), 10);
		}
		else if(state == State.Grapple || (grapBoost && !item[Item.SpaceJump]))
		{
			if(point_distance(xprevious,yprevious,x,y) >= 3)
			{
				drawAfterImage = true;
				afterImageNum = min((point_distance(xprevious,yprevious,x,y)-3),10);
			}
		}
		else if(!grounded && item[Item.SpaceJump] && state == State.Somersault && !liquidMovement)
		{
			drawAfterImage = true;
			afterImageNum = 10;
		}
		else if(!grounded && fVelY < 0)
		{
			drawAfterImage = true;
			afterImageNum = min(abs(fVelY)*1.5, 10);
		}
		else if(!grounded && fVelY >= 3)
		{
			drawAfterImage = true;
			afterImageNum = min((abs(fVelY)-3),10);
		}
	}
	
	#endregion
	
	#region MB Trail
	
	if(_MORPH_TRAIL)
	{
		if(animState == AnimState.Morph)
		{
			drawAfterImage = false;
		
			mbTrailColor_Start = c_lime;
			mbTrailColor_End = c_green;
			if(spiderBall)
			{
				if(item[Item.SpiderBall])
				{
					mbTrailColor_Start = merge_color(c_lime,c_yellow,0.6);
					mbTrailColor_End = c_green;
				}
				else
				{
					mbTrailColor_Start = c_aqua;
					mbTrailColor_End = c_teal;
				}
			}
			
			if(speedFXCounter > 0)
			{
				mbTrailColor_Start = merge_color(mbTrailColor_Start, c_aqua, speedFXCounter);
				mbTrailColor_End = merge_color(mbTrailColor_End, make_color_rgb(0,148,255), speedFXCounter);
			}
			if(shineFXCounter > 0)
			{
				mbTrailColor_Start = merge_color(mbTrailColor_Start, c_yellow, shineFXCounter);
				mbTrailColor_End = merge_color(mbTrailColor_End, c_olive, shineFXCounter);
			}
			if(boostBallFX > 0)
			{
				mbTrailColor_Start = merge_color(mbTrailColor_Start, c_yellow, boostBallFX);
				mbTrailColor_End = merge_color(mbTrailColor_End, c_olive, boostBallFX);
			}
			
			for(var i = 0; i < mbTrailLength-1; i++)
			{
				mbTrailPosX[i] = mbTrailPosX[i+1];
				mbTrailPosY[i] = mbTrailPosY[i+1];
				mbTrailDir[i] = mbTrailDir[i+1];
				mbTrailCol1[i] = mbTrailCol1[i+1];
				mbTrailCol2[i] = mbTrailCol2[i+1];
			}
			mbTrailPosX[mbTrailLength-1] = position.X + sprtOffsetX;
			mbTrailPosY[mbTrailLength-1] = position.Y + sprtOffsetY;
			mbTrailCol1[mbTrailLength-1] = mbTrailColor_Start;
			mbTrailCol2[mbTrailLength-1] = mbTrailColor_End;
			
			var posX = mbTrailPosX[mbTrailLength-1],
				posY = mbTrailPosY[mbTrailLength-1];
			var oldPosX = mbTrailPosX[mbTrailLength-2],
				oldPosY = mbTrailPosY[mbTrailLength-2];
			var trailDir = point_direction(posX,posY,oldPosX,oldPosY);
			
			if(point_distance(posX,posY,oldPosX,oldPosY) > 0)
			{
				mbTrailDir[mbTrailLength-1] = trailDir;
			}
			else
			{
				mbTrailDir[mbTrailLength-1] = noone;
			}
			
			mbTrailNum = scr_wrap(mbTrailNum + mbTrailNumRate, 0, mbTrailLength);
			mbTrailAlpha = min(mbTrailAlpha+0.1, 1);
		}
		else
		{
			mbTrailAlpha = max(mbTrailAlpha-0.1, 0);
		}
	}
	
	#endregion
}

// --- SHOOT, ENVIRO DMG, & FINALIZE VARS ---
if(global.pauseState == PauseState.None)
{
	#region Shoot direction
	
	shootDir = self.GetShootDirection(aimAngle,dir2);
	
	if(instance_exists(grapReticle) && grapReticle.adjustedShootDir != 0)
	{
		shootDir += grapReticle.adjustedShootDir;
	}
	
	#endregion
	#region Set Shoot Pos
	
	shotOffsetX = 0;
	shotOffsetY = 0;
	
	if(animState == AnimState.Stand || animState == AnimState.Crouch)
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
	if(animState == AnimState.Walk || animState == AnimState.Moon || animState == AnimState.Run || animState == AnimState.Jump || animState == AnimState.Somersault ||
	animState == AnimState.Spark || animState == AnimState.Hurt || animState == AnimState.DmgBoost)
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
				if(animState == AnimState.Run)
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
				if(animState == AnimState.Walk || animState == AnimState.Run)
				{
					shotOffsetX = (21+(animState == AnimState.Run))*dir2;
					shotOffsetY = -2;
				}
				break;
			}
		}
	}
	if(animState == AnimState.Brake)
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
	if(animState == AnimState.Grip)
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
	
	self.UpdateBeam();
	currentWeapon = weap[Weapon.Beam];
	if(hyperBeam) { currentWeapon = weap[Weapon.HyperBeam]; }
	if(self.EquipmentSelected(Equipment.Missile)) { currentWeapon = weap[Weapon.Missile]; }
	if(self.EquipmentSelected(Equipment.SuperMissile)) { currentWeapon = weap[Weapon.SuperMissile]; }
	if(self.EquipmentSelected(Equipment.GrappleBeam)) { currentWeapon = weap[Weapon.GrappleBeam]; }
	if(self.EquipmentSelected(Equipment.GravGrapple)) { currentWeapon = weap[Weapon.GravGrapple]; }
	
	var canShoot = (currentWeapon.CanShoot() && dir != 0 && !startClimb && !moonFallState && !isPushing && /*state != State.Somersault &&*/ state != State.Spark && state != State.BallSpark && 
					state != State.Hurt && (animState != AnimState.DmgBoost || dBoostFrame >= 19) && state != State.Dodge && state != State.Death);
	if(!canShoot)
	{
		enqueShot = false;
	}
	
	shootPosX = x+sprtOffsetX+shotOffsetX;
	shootPosY = y+sprtOffsetY+runYOffset+shotOffsetY;
	
	#region Charge logic
	
	var killSnd = true;
	if(self.CanCharge() && cFire && dir != 0 && state != State.Death)
	{
		var cflag = (state != State.Morph && state != State.BallSpark);
		if((state == State.Morph || state == State.BallSpark) && statCharge > 0)
		{
			cflag = true;
		}
				
		if(!isPushing && cflag)
		{
			var chargeRate = 1;
			if(state == State.DmgBoost && dBoostFrame < 19)
			{
				chargeRate *= 3;
			}
			statCharge = min(statCharge + chargeRate, maxCharge * 2);
			
			gunReady = true;
			justShot = 90;
			
			if(statCharge >= 10)
			{
				if(!chargeSoundPlayed)
				{
					audio_play_sound(snd_Charge,0,false);
					chargeSoundPlayed = true;
				}
				else
				{
					if(audio_is_playing(snd_Charge) && state == State.DmgBoost && dBoostFrame < 19 && statCharge >= maxCharge)
					{
						audio_stop_sound(snd_Charge);
					}
						
					if(!audio_is_playing(snd_Charge) && !audio_is_playing(snd_Charge_Loop))
					{
						audio_play_sound(snd_Charge_Loop,0,true);
					}
				}
				
				killSnd = false;
			}
		}
	}
	else if(!canShoot || !self.CanCharge())
	{
		statCharge = 0;
	}
	
	if(killSnd)
	{
		audio_stop_sound(snd_Charge);
		audio_stop_sound(snd_Charge_Loop);
		chargeSoundPlayed = false;
	}
	
	#endregion
	
	if(state != State.Morph && animState != AnimState.Morph)
	{
		#region Firing logic
		
		var shotInd = currentWeapon.shotIndex,
			sndInd = currentWeapon.soundIndex,
			damage = currentWeapon.damage,
			delay = currentWeapon.shotDelay,
			sSpeed = currentWeapon.shotSpeed,
			autoFire = currentWeapon.autoFireStyle,
			shotAmt = currentWeapon.shotAmount,
			
			chShotInd = currentWeapon.chargeShotIndex,
			chSndInd = currentWeapon.chargeSoundIndex,
			chDamage = currentWeapon.chargeDamage,
			chDelay = currentWeapon.chargeShotDelay,
			chSpeed = currentWeapon.chargeShotSpeed,
			chShotAmt = currentWeapon.chargeShotAmount;
		
		if(canShoot)
		{
			if((cFire || enqueShot))
			{
				if(currentWeapon.autoFireStyle == AutoFireStyle.Tether)
				{
					if(!instance_exists(tetherProj))
					{
						if(shotDelayTime <= 0)
						{
							if(rFire || enqueShot)
							{
								var shot = self.PlayerShoot(shotInd, damage, sSpeed, 0, shotAmt, sndInd);
								tetherProj = shot[0];
								currentWeapon.OnShoot();
							}
							enqueShot = false;
						}
						else if(rFire && shotDelayTime < delay/2)
						{
							enqueShot = true;
						}
					}
					else
					{
						enqueShot = false;
					}
					
					if(instance_exists(tetherProj))
					{
						gunReady = true;
						justShot = 90;
						shotDelayTime = delay;
					}
				}
				else
				{
					instance_destroy(tetherProj);
					
					if(shotDelayTime <= 0)
					{
						if(rFire || enqueShot || (!currentWeapon.canCharge && autoFire != AutoFireStyle.None))
						{
							if(!rFire && !enqueShot && autoFire == AutoFireStyle.SoftAuto)
							{
								delay *= 2;
							}
							self.PlayerShoot(shotInd,damage,sSpeed,delay,shotAmt,sndInd,beamIsWave,beamWaveStyleOffset);
							currentWeapon.OnShoot();
							
							gunReady = true;
							justShot = 90;
						}
						enqueShot = false;
					}
					else
					{
						if(rFire && shotDelayTime < delay/2)
						{
							enqueShot = true;
						}
						
						if(autoFire != AutoFireStyle.None)
						{
							gunReady = true;
							justShot = 90;
						}
					}
				}
			}
			else
			{
				if(currentWeapon.autoFireStyle != AutoFireStyle.Tether && instance_exists(tetherProj))
				{
					instance_destroy(tetherProj);
				}
				
				if(self.CanCharge())
				{
					if(statCharge >= maxCharge)
					{
						self.PlayerShoot(chShotInd,chDamage,chSpeed,chDelay,chShotAmt,chSndInd,beamIsWave,beamWaveStyleOffset);
						currentWeapon.OnChargeShoot();
						
						chargeReleaseFlash = 4;
					}
					else if(statCharge >= 20)
					{
						self.PlayerShoot(shotInd,damage,sSpeed,delay,shotAmt,sndInd,beamIsWave,beamWaveStyleOffset);
						currentWeapon.OnShoot();
					}
				}
				
				statCharge = 0;
			}
		}
		else
		{
			instance_destroy(tetherProj);
		}
		
		#endregion
	}
	else
	{
		#region Bomb logic
		
		var bombDmg = 5, // Scales to 2.5x -> 7.5x -> 10x as the bomb's timer tics down. Logic stored in obj_Bomb.
			instaBombDmg = 5, // Damage of bombs if you hold down to insta explode them. Very spammable.
			chargeBombDmg = 30, // Bomb spread damage.
			bombDelay = 8,
			pBombDmg = 40, // Power bomb explosions deal damage per frame (but do NOT ignore i-frames).
			pBombDelay = 30;
		
		var bombPosX = x,
			bombPosY = y+3,
			instaBomb = cPlayerDown;
		if(self.SpiderActive())
		{
			bombPosX = x + lengthdir_x(-2,spiderJumpDir);
			bombPosY = y+1 + lengthdir_y(-2,spiderJumpDir);
			if(spiderEdge == Edge.Top)
			{
				instaBomb = cPlayerUp;
			}
			if(spiderEdge == Edge.Left)
			{
				instaBomb = cPlayerLeft;
			}
			if(spiderEdge == Edge.Right)
			{
				instaBomb = cPlayerRight;
			}
		}
		
		if(canShoot)
		{
			if((cFire || enqueShot))
			{
				if(bombDelayTime <= 0)
				{
					if(rFire || enqueShot)
					{
						if(self.EquipmentSelected(Equipment.PowerBomb) || (item[Item.PowerBomb] && equipIndex >= 0 && equipSelected && powerBombStat > 0))
						{
							var pBomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_PowerBomb);
							pBomb.damage = pBombDmg;
							bombDelayTime = pBombDelay;
							powerBombStat--;
							cFlashStartCounter++;
							//audio_play_sound(snd_PowerBombSet,0,false);
						}
						else if(item[Item.MBBomb] && (instance_number(obj_MBBomb) < 3 || cPlayerDown))
						{
							if(instaBomb)
							{
								var explo = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBombExplosion);
								explo.damage = instaBombDmg;
								explo.MovePushBlock();
								scr_PlayExplodeSnd(0,false);
							}
							else
							{
								var mbBomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBomb);
								mbBomb.damage = bombDmg;
								//audio_play_sound(snd_BombSet,0,false);
							}
							bombDelayTime = bombDelay;
						}
					}
					enqueShot = false;
				}
				else if(rFire && bombDelayTime < bombDelay/2)
				{
					enqueShot = true;
				}
			}
			else
			{
				if(item[Item.MBBomb] && !self.EquipmentSelected(Equipment.PowerBomb))
				{
					if(statCharge >= 20)
					{
						var bChargeScale = min(statCharge / (maxCharge*1.5), 1);
						
						if(!grounded && !self.SpiderActive() && cPlayerDown)
						{
							var bombDir = [0,90,210,330],
								bombTime = [0,30,30,30],
								bombSpd = 2 + 4*bChargeScale;
							for(var i = 0; i < 4; i++)
							{
								var bomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBomb);
								bomb.damage = chargeBombDmg * bChargeScale;
								bomb.spreadType = 2;
								if(i > 0)
								{
									bomb.spreadSpeed = bombSpd;
								}
								bomb.spreadDir = bombDir[i];
								bomb.spreadFrict = 0.5;
								bomb.bombTimer = bombTime[i];
							}
							bombDelayTime = 60;
							audio_play_sound(snd_BombSet,0,false);
						}
						else if(self.SpiderActive())
						{
							var bombDir = [0, 45, 90, 135, 180],
								bombTime = [30, 30, 30, 30, 30],
								bombSpd = 2 + 4*bChargeScale;
							for(var i = 0; i < 5; i++)
							{
								bombDir[i] += spiderJumpDir-90;
									
								var bomb = instance_create_layer(x,y,"Projectiles_fg",obj_MBBomb);
								bomb.damage = chargeBombDmg * bChargeScale;
								bomb.spreadType = 2;
								bomb.spreadSpeed = bombSpd;
								bomb.spreadDir = bombDir[i];
								bomb.spreadFrict = 0.5;
								bomb.bombTimer = bombTime[i];
							}
							bombDelayTime = 60;
							audio_play_sound(snd_BombSet,0,false);
						}
						else
						{
							var bombDirection = [60, 120, 75, 105, 90],
								bombDirectionR = [45, 56.25, 67.5, 78.75, 90],
								bombDirectionL = [135, 123.75, 112.5, 101.25, 90],
								bombSpeed = 6*bChargeScale,
								spreadFrict = 2,
								spreadType = 0;
							
							for(var i = 0; i < 5; i++)
							{
								var bombTime = 100 - 5*i;
								var bDir = bombDirection[i];
								if(move2 != 0)
								{
									if(move2 == 1)
									{
										bDir = bombDirectionR[i];
									}
									else
									{
										bDir = bombDirectionL[i];
									}
								}
								else if(cPlayerDown)
								{
									bDir = 90;
									bombSpeed = 3 + 4*bChargeScale;
									spreadFrict = 2 / max(3*i,1);
									spreadType = 1;
									bombTime = 55 + 20*i;
								}
								
								var bomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBomb);
								bomb.damage = chargeBombDmg * bChargeScale;
								bomb.velX = lengthdir_x(bombSpeed,bDir);
								bomb.velY = lengthdir_y(bombSpeed,bDir);
								bomb.spreadType = spreadType;
								bomb.spreadFrict = spreadFrict;
								bomb.bombTimer = bombTime;
							}
							bombDelayTime = 120 + (30*spreadType);
							audio_play_sound(snd_BombSet,0,false);
						}
					}
				}
				
				statCharge = 0;
			}
		}
		
		#endregion
	}
	
	#region old code
	/*
	var shotIndex = beamShot,
		damage = beamDmg / beamAmt,
		sSpeed = shootSpeed,
		delay = beamDelay,
		amount = beamAmt,
		sound = beamSound,
		autoFire = 1;
	if(self.EquipmentSelected(Equipment.Missile))
	{
		shotIndex = obj_MissileShot;
		damage = 100;
		sSpeed = shootSpeed/2;
		delay = 9;
		amount = 1;
		sound = snd_Missile_Shot;
		autoFire = 0;
	}
	else if(self.EquipmentSelected(Equipment.SuperMissile))
	{
		shotIndex = obj_SuperMissileShot;
		damage = 300;
		sSpeed = shootSpeed/3;
		delay = 19;
		amount = 1;
		sound = snd_SuperMissile_Shot;
		autoFire = 0;
	}
	else if(hyperBeam)
	{
		shotIndex = obj_HyperBeamShot;
		damage = 1000;
		delay = 20;
		amount = 1;
		sound = snd_PlasmaBeam_ChargeShot;
		autoFire = 2;
	}
		
	var bombDmg = 5, // Scales to 2.5x -> 7.5x -> 10x as the bomb's timer tics down. Logic stored in obj_Bomb.
		instaBombDmg = 5, // Damage of bombs if you hold down to insta explode them. Very spammable.
		chargeBombDmg = 30, // Bomb spread damage.
		pBombDmg = 40; // Power bomb explosions deal damage per frame (well, not really, because enemies have i-frames).
		
	// ----- Shoot -----
	#region Shoot
	if((cFire || enqueShot) && dir != 0 && state != State.Death)
	{
		if(state != State.Morph && animState != AnimState.Morph)
		{
			if(self.EquipmentSelected(Equipment.GrappleBeam) && canShoot)
			{
				delay = 14;
					
				if(!instance_exists(grapple))
				{
					if(shotDelayTime <= 0)
					{
						if(rFire || enqueShot)
						{
							grapple = self.PlayerShoot(obj_GrappleBeamShot,20,0,0,1,snd_GrappleBeam_Shoot);
							grapple.shootDir = shootDir;
							recoil = true;
						}
						enqueShot = false;
					}
					else if(rFire && shotDelayTime < delay/2)
					{
						enqueShot = true;
					}
				}
				else
				{
					enqueShot = false;
				}
					
					
				if(instance_exists(grapple))
				{
					if(state != State.Grapple)
					{
						gunReady = true;
						justShot = 90;
					}
					else
					{
						shotDelayTime = delay;
					}
				}
				else
				{
					grappleDist = 0;
				}
			}
			else
			{
				instance_destroy(grapple);
				grappleDist = 0;
					
				if(canShoot && (equipIndex <= -1 || self.EquipmentHasAmmo(equipIndex)))
				{
					if(autoFire > 0)
					{
						gunReady = true;
						justShot = 90;
					}
						
					if(shotDelayTime <= 0)
					{
						if(rFire || enqueShot || (!item[Item.ChargeBeam] && autoFire > 0) || autoFire == 2)
						{
							if(self.EquipmentSelected(Equipment.Missile))
							{
								missileStat--;
							}
							if(self.EquipmentSelected(Equipment.SuperMissile))
							{
								superMissileStat--;
							}
									
							if(!rFire && !enqueShot && autoFire == 1)
							{
								delay *= 2;
							}
							self.PlayerShoot(shotIndex,damage,sSpeed,delay,amount,sound,beamIsWave,beamWaveStyleOffset);
							if(hyperBeam && shotIndex == obj_HyperBeamShot)
							{
								if(item[Item.Spazer])
								{
									self.PlayerShoot(obj_HyperBeamLesserShot,damage,sSpeed,delay,2+2*beamIsWave,noone,beamIsWave,1);
								}
									
								var flareDir = shootDir;
								if(dir2 == -1)
								{
									flareDir = angle_difference(shootDir,180);
								}
								var flare = instance_create_layer(shootPosX+lengthdir_x(5,shootDir),shootPosY+lengthdir_y(5,shootDir),layer_get_id("Projectiles_fg"),obj_ChargeFlare);
								flare.damage = damage;
								flare.sprite_index = sprt_HyperBeamChargeFlare;
								flare.damageSubType[DmgSubType_Beam.Hyper] = true;
								flare.direction = flareDir;
								flare.image_angle = flareDir;
								flare.image_xscale = dir2;
								flare.creator = id;
									
								hyperFired = delay+2;
							}
								
							gunReady = true;
							justShot = 90;
							recoil = true;
						}
						enqueShot = false;
					}
					else if(rFire && shotDelayTime < delay/2)
					{
						enqueShot = true;
					}
				}
				else
				{
					enqueShot = false;
				}
			}
		}
		else if(canShoot)
		{
			if(bombDelayTime <= 0)
			{
				if(rFire || enqueShot)
				{
					var bombPosX = x,
						bombPosY = y+3,
						instaBomb = cPlayerDown;
					if(self.SpiderActive())
					{
						bombPosX = x + lengthdir_x(-2,spiderJumpDir);
						bombPosY = y+1 + lengthdir_y(-2,spiderJumpDir);
						if(spiderEdge == Edge.Top)
						{
							instaBomb = cPlayerUp;
						}
						if(spiderEdge == Edge.Left)
						{
							instaBomb = cPlayerLeft;
						}
						if(spiderEdge == Edge.Right)
						{
							instaBomb = cPlayerRight;
						}
					}
							
					if(self.EquipmentSelected(Equipment.PowerBomb) || (item[Item.PowerBomb] && equipIndex >= 0 && equipSelected && powerBombStat > 0))
					{
						var pBomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_PowerBomb);
						pBomb.damage = pBombDmg;
						bombDelayTime = 30;
						powerBombStat--;
						cFlashStartCounter++;
						//audio_play_sound(snd_PowerBombSet,0,false);
					}
					else if(item[Item.MBBomb] && (instance_number(obj_MBBomb) < 3 || cPlayerDown))
					{
						if(instaBomb)
						{
							var explo = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBombExplosion);
							explo.damage = instaBombDmg;
							explo.MovePushBlock();
							scr_PlayExplodeSnd(0,false);
						}
						else
						{
							var mbBomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBomb);
							mbBomb.damage = bombDmg;
							//audio_play_sound(snd_BombSet,0,false);
						}
						bombDelayTime = 8;
					}
				}
				enqueShot = false;
			}
			else if(rFire && bombDelayTime < 4)
			{
				enqueShot = true;
			}
		}
		else
		{
			enqueShot = false;
		}
				
		var cflag = (state != State.Morph && state != State.BallSpark);
		if((state == State.Morph || state == State.BallSpark) && statCharge > 0)
		{
			cflag = true;
		}
				
		if(item[Item.ChargeBeam] && self.CanCharge() && !enqueShot && !isPushing && cflag)
		{
			var chargeRate = 1;
			if(state == State.DmgBoost && dBoostFrame < 19)
			{
				chargeRate *= 3;
			}
			statCharge = min(statCharge + chargeRate, maxCharge * 2);
			if(statCharge >= 10)
			{
				if(!chargeSoundPlayed)
				{
					audio_play_sound(snd_Charge,0,false);
					chargeSoundPlayed = true;
				}
				else
				{
					if(audio_is_playing(snd_Charge) && state == State.DmgBoost && dBoostFrame < 19 && statCharge >= maxCharge)
					{
						audio_stop_sound(snd_Charge);
					}
						
					if(!audio_is_playing(snd_Charge) && !audio_is_playing(snd_Charge_Loop))
					{
						audio_play_sound(snd_Charge_Loop,0,true);
					}
				}
			}
			else
			{
				audio_stop_sound(snd_Charge);
				audio_stop_sound(snd_Charge_Loop);
				chargeSoundPlayed = false;
			}
		}
		else
		{
			statCharge = 0;
			audio_stop_sound(snd_Charge);
			audio_stop_sound(snd_Charge_Loop);
			chargeSoundPlayed = false;
		}
	}
	else
	{
		if(instance_exists(grapple))
		{
			if((state != State.Grapple || grapWJCounter <= 0))
			{
				if(grapple.grappleState != GrappleState.None)
				{
					instance_destroy(grapple);
				}
				else
				{
					grapple.impacted = max(grapple.impacted,1);
				}
			}
		}
		
		if(statCharge <= 0)
		{
			audio_stop_sound(snd_Charge);
			audio_stop_sound(snd_Charge_Loop);
			chargeSoundPlayed = false;
		}
		
		if(canShoot && self.CanCharge() && dir != 0)
		{
			if(state != State.Morph && animState != AnimState.Morph)
			{
				if(statCharge >= maxCharge)
				{
					var flareDir = shootDir;
					if(dir2 == -1)
					{
						flareDir = angle_difference(shootDir,180);
					}
					var flare = instance_create_layer(shootPosX+lengthdir_x(5,shootDir),shootPosY+lengthdir_y(5,shootDir),layer_get_id("Projectiles_fg"),obj_ChargeFlare);
					flare.damage = (beamDmg*chargeMult);
					flare.sprite_index = beamFlare;
					flare.damageSubType[DmgSubType_Beam.Ice] = item[Item.IceBeam];
					flare.damageSubType[DmgSubType_Beam.Wave] = item[Item.WaveBeam];
					flare.damageSubType[DmgSubType_Beam.Spazer] = item[Item.Spazer];
					flare.damageSubType[DmgSubType_Beam.Plasma] = item[Item.PlasmaBeam];
					flare.direction = flareDir;
					flare.image_angle = flareDir;
					flare.image_xscale = dir2;
					flare.creator = id;
					if(item[Item.IceBeam])
					{
						flare.freezeType = 2;
						flare.freezeKill = true;
					}
							
					damage = (beamDmg*chargeMult) / beamChargeAmt;
					self.PlayerShoot(beamCharge,damage,sSpeed,beamChargeDelay,beamChargeAmt,beamChargeSound,beamIsWave,beamWaveStyleOffset);
							
					chargeReleaseFlash = 4;
					recoil = true;
				}
				else if(statCharge >= 20)
				{
					self.PlayerShoot(shotIndex,damage,sSpeed,delay,amount,sound,beamIsWave,beamWaveStyleOffset);
					recoil = true;
				}
			}
			else if(item[Item.MBBomb] && !self.EquipmentSelected(Equipment.PowerBomb))
			{
				var bombPosX = x,
					bombPosY = y+3;
				if(self.SpiderActive())
				{
					bombPosX = x + lengthdir_x(-2,spiderJumpDir);
					bombPosY = y+1 + lengthdir_y(-2,spiderJumpDir);
				}
						
				if(statCharge >= 20)
				{
					var bChargeScale = min(statCharge / (maxCharge*1.5), 1);
							
					if(!grounded && !self.SpiderActive() && cPlayerDown)
					{
						var bombDir = [0,90,210,330],
							bombTime = [0,30,30,30],
							bombSpd = 2 + 4*bChargeScale;
						for(var i = 0; i < 4; i++)
						{
							var bomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBomb);
							bomb.damage = chargeBombDmg * bChargeScale;
							bomb.spreadType = 2;
							if(i > 0)
							{
								bomb.spreadSpeed = bombSpd;
							}
							bomb.spreadDir = bombDir[i];
							bomb.spreadFrict = 0.5;
							bomb.bombTimer = bombTime[i];
						}
						bombDelayTime = 60;
						audio_play_sound(snd_BombSet,0,false);
					}
					else if(self.SpiderActive())
					{
						var bombDir = [0, 45, 90, 135, 180],
							bombTime = [30, 30, 30, 30, 30],
							bombSpd = 2 + 4*bChargeScale;
						for(var i = 0; i < 5; i++)
						{
							bombDir[i] += spiderJumpDir-90;
									
							var bomb = instance_create_layer(x,y,"Projectiles_fg",obj_MBBomb);
							bomb.damage = chargeBombDmg * bChargeScale;
							bomb.spreadType = 2;
							bomb.spreadSpeed = bombSpd;
							bomb.spreadDir = bombDir[i];
							bomb.spreadFrict = 0.5;
							bomb.bombTimer = bombTime[i];
						}
						bombDelayTime = 60;
						audio_play_sound(snd_BombSet,0,false);
					}
					else
					{
						var bombDirection = [60, 120, 75, 105, 90],
							bombDirectionR = [45, 56.25, 67.5, 78.75, 90],
							bombDirectionL = [135, 123.75, 112.5, 101.25, 90],
							bombSpeed = 6*bChargeScale,
							spreadFrict = 2,
							spreadType = 0;
								
						for(var i = 0; i < 5; i++)
						{
							var bombTime = 100 - 5*i;
							var bDir = bombDirection[i];
							if(move2 != 0)
							{
								if(move2 == 1)
								{
									bDir = bombDirectionR[i];
								}
								else
								{
									bDir = bombDirectionL[i];
								}
							}
							else if(cPlayerDown)
							{
								bDir = 90;
								bombSpeed = 3 + 4*bChargeScale;
								spreadFrict = 2 / max(3*i,1);
								spreadType = 1;
								bombTime = 55 + 20*i;
							}
									
							var bomb = instance_create_layer(bombPosX,bombPosY,"Projectiles_fg",obj_MBBomb);
							bomb.damage = chargeBombDmg * bChargeScale;
							bomb.velX = lengthdir_x(bombSpeed,bDir);
							bomb.velY = lengthdir_y(bombSpeed,bDir);
							bomb.spreadType = spreadType;
							bomb.spreadFrict = spreadFrict;
							bomb.bombTimer = bombTime;
						}
						bombDelayTime = 120 + (30*spreadType);
						audio_play_sound(snd_BombSet,0,false);
					}
				}
			}
		}
		statCharge = 0;
		enqueShot = false;
	}
	#endregion
	*/
	#endregion
	
	#region Charge Somersault / Pseudo Screw Attack Dmg box
	
	if(self.IsChargeSomersaulting() && !self.IsSpeedBoosting() && !self.IsScrewAttacking())
	{
		var psDmg = currentWeapon.chargeDamage * currentWeapon.chargeShotAmount * 2;
		var dmgST = array_create(DmgSubType_Beam._Length,false);
		dmgST[DmgSubType_Beam.All] = true;
		dmgST[DmgSubType_Beam.Power] = true;
		dmgST[DmgSubType_Beam.Ice] = item[Item.IceBeam];
		dmgST[DmgSubType_Beam.Wave] = item[Item.WaveBeam];
		dmgST[DmgSubType_Beam.Spazer] = item[Item.Spazer];
		dmgST[DmgSubType_Beam.Plasma] = item[Item.PlasmaBeam];
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.PseudoScrew]))
		{
			dmgBoxes[PlayerDmgBox.PseudoScrew] = self.CreateDamageBox(0,0,screwAttackMask,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.PseudoScrew]))
		{
			dmgBoxes[PlayerDmgBox.PseudoScrew].Damage(x, y, psDmg, DmgType.Charge, dmgST, , , 3);
		}
	}
	else if(instance_exists(dmgBoxes[PlayerDmgBox.PseudoScrew]))
	{
		instance_destroy(dmgBoxes[PlayerDmgBox.PseudoScrew]);
	}
	
	#endregion
	#region Boost Ball Dmg box
	
	if(boostBallDmgCounter > 0)
	{
		var dmgST = array_create(DmgSubType_Misc._Length,false);
		dmgST[DmgSubType_Misc.All] = true;
		dmgST[DmgSubType_Misc.BoostBall] = true;
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.BoostBall]))
		{
			dmgBoxes[PlayerDmgBox.BoostBall] = self.CreateDamageBox(0,0,mask_index,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.BoostBall]))
		{
			dmgBoxes[PlayerDmgBox.BoostBall].mask_index = mask_index;
			dmgBoxes[PlayerDmgBox.BoostBall].Damage(x, y, 300*boostBallDmgCounter, DmgType.Misc, dmgST, , , 3);
		}
		
		boostBallDmgCounter = max(boostBallDmgCounter - 0.0375, 0);
	}
	else if(instance_exists(dmgBoxes[PlayerDmgBox.BoostBall]))
	{
		instance_destroy(dmgBoxes[PlayerDmgBox.BoostBall]);
	}
	
	#endregion
	#region Speed Boost / Shine Spark Dmg box(es)
	
	if(self.IsSpeedBoosting())
	{
		var dmgST = array_create(DmgSubType_Misc._Length,false);
		dmgST[DmgSubType_Misc.All] = true;
		dmgST[DmgSubType_Misc.SpeedBoost] = true;
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.SpeedBoost]))
		{
			dmgBoxes[PlayerDmgBox.SpeedBoost] = self.CreateDamageBox(0,0,mask_index,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.SpeedBoost]))
		{
			dmgBoxes[PlayerDmgBox.SpeedBoost].mask_index = mask_index;
			dmgBoxes[PlayerDmgBox.SpeedBoost].Damage(x, y, 2000, DmgType.Misc, dmgST, , , 3);
		}
		
		if(state == State.Spark )//|| state == State.BallSpark)
		{
			if(!instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
			{
				dmgBoxes[PlayerDmgBox.ShineSpark] = self.CreateDamageBox(0,0,shineSparkMask,false);
			}
			if(instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
			{
				var shineRot = shineDir - 90;
				var len = 6;
				var shineX = scr_round(x + lengthdir_x(len,shineRot)),
					shineY = scr_round(y + lengthdir_y(len,shineRot));
				
				var ssbox = dmgBoxes[PlayerDmgBox.ShineSpark];
				ssbox.direction = shineRot;
				ssbox.image_angle = shineRot;
				ssbox.Damage(shineX, shineY, 2000, DmgType.Misc, dmgST, , , 3);
			}
		}
		else if(instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
		{
			instance_destroy(dmgBoxes[PlayerDmgBox.ShineSpark]);
		}
	}
	else
	{
		if(instance_exists(dmgBoxes[PlayerDmgBox.SpeedBoost]))
		{
			instance_destroy(dmgBoxes[PlayerDmgBox.SpeedBoost]);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
		{
			instance_destroy(dmgBoxes[PlayerDmgBox.ShineSpark]);
		}
	}
	
	#endregion
	#region Screw Attack Dmg box
	
	if(self.IsScrewAttacking())
	{
		var dmgST = array_create(DmgSubType_Misc._Length,false);
		dmgST[DmgSubType_Misc.All] = true;
		dmgST[DmgSubType_Misc.ScrewAttack] = true;
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.ScrewAttack]))
		{
			dmgBoxes[PlayerDmgBox.ScrewAttack] = self.CreateDamageBox(0,0,screwAttackMask,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.ScrewAttack]))
		{
			dmgBoxes[PlayerDmgBox.ScrewAttack].Damage(x, y, 2000, DmgType.Misc, dmgST, , , 3);
		}
	}
	else if(instance_exists(dmgBoxes[PlayerDmgBox.ScrewAttack]))
	{
		instance_destroy(dmgBoxes[PlayerDmgBox.ScrewAttack]);
	}
	
	#endregion
	
	self.IncrInvFrames();
	
	// ----- Environmental Damage -----
	#region Environmental Damage
	
	var palFlag = false;
	
	if(global.rmHeated && !item[Item.VariaSuit])
	{
		self.ConstantDamage(1, 4 + (2 * item[Item.GravitySuit]));
		
		if(!audio_is_playing(snd_HealthDrainLoop) && !audio_is_playing(heatDmgSnd))
		{
		    heatDmgSnd = audio_play_sound(snd_HealthDrainLoop,0,true);
			audio_sound_gain(heatDmgSnd,0.7,0);
		}
		
		palFlag = true;
	}
	else
	{
		audio_stop_sound(heatDmgSnd);
	}
	
	var sndFlag2 = false;
	var sndFlag3 = false;
	if(liquid && liquid.liquidType == LiquidType.Lava && !item[Item.GravitySuit])
	{
		self.ConstantDamage(1, 2 + (2 * (item[Item.VariaSuit])));
		
		palFlag = true;
		sndFlag2 = true;
		if(!liquidTop)
		{
			sndFlag3 = true;
		}
	}
	if(liquid && liquid.liquidType == LiquidType.Acid)
	{
		self.ConstantDamage(3, 2 + (2 * (item[Item.VariaSuit] + item[Item.GravitySuit])));
		
		palFlag = true;
		sndFlag2 = true;
		if(!liquidTop)
		{
			sndFlag3 = true;
		}
	}
	
	if(sndFlag2)
	{
		if(!audio_is_playing(snd_LavaDamageLoop))
		{
		    var snd = audio_play_sound(snd_LavaDamageLoop,0,true);
		    audio_sound_gain(snd,0.6,2000);
		}
	}
	else
	{
		audio_stop_sound(snd_LavaDamageLoop);
	}
	if(sndFlag3)
	{
		if(!audio_is_playing(snd_LiquidTopDmgLoop))
		{
		    audio_play_sound(snd_LiquidTopDmgLoop,0,true);
		}
	}
	else
	{
		audio_stop_sound(snd_LiquidTopDmgLoop);
	}
	
	if(palFlag)
	{
		heatDmgPalCounter += 1;
	}
	else
	{
		heatDmgPalCounter = 0;
	}
	
	#endregion
	
	if(animState == AnimState.Grip)
	{
		if(aimAngle != 0 || dir != grippedDir)
		{
			justShot = 0;
		}
	}
	else
	{
		if(aimAngle != 0 || (velX == 0 && animState != AnimState.Brake) || !grounded || abs(dirFrame) < 4 || state == State.Morph)
		{
			justShot = 0;
		}
	}
	if(animState != AnimState.Brake)
	{
		justShot = max(justShot - 1, 0);
	}
	
	shotDelayTime = max(shotDelayTime - 1, 0);
	if(!instance_exists(obj_PowerBomb) && !instance_exists(obj_PowerBombExplosion))
	{
		bombDelayTime = max(bombDelayTime - 1, 0);
	}
	
	SetReleaseVars("player");
	
	oldDir = dir;
	prevAimAngle = aimAngle;
	outOfLiquid = (liquidState <= 0);
	invFrames = max(invFrames - 1, 0);
	
	grappleOldDist = grappleDist;
	grapWJCounter = max(grapWJCounter-1,0);
	
	hyperFired = max(hyperFired-1,0);
	
	movedVelX = 0;
	movedVelY = 0;
	
	if(state != prevState)
	{
		lastState = prevState;
	}
	prevState = state;
	
	if(animState != prevAnimState)
	{
		lastAnimState = prevAnimState;
	}
	prevAnimState = animState;
}
else
{
	audio_stop_sound(heatDmgSnd);
    audio_stop_sound(snd_LavaDamageLoop);
	audio_stop_sound(snd_LiquidTopDmgLoop);
}