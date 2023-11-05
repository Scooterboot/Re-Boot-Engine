/// @description Update Anims, Shoot, & Environmental Dmg

var xRayActive = instance_exists(XRay);

Set_Beams();

var sndFlag = false;

if(!global.gamePaused || (((xRayActive && !global.roomTrans) || (global.roomTrans && stateFrame != State.Grapple)) && !obj_PauseMenu.pause && !pauseSelect))
{
	#region X-Ray
	if((cDash || global.HUD == 1) && itemSelected == 1 && itemHighlighted[1] == 4 && dir != 0 && fVelX == 0 && fVelY == 0 && (state == State.Stand || state == State.Crouch) && grounded && (move2 == 0 || instance_exists(XRay)))
    {
        if(instance_exists(XRay))
        {
            if(cUp)
            {
                XRay.coneDir += 3*dir;
            }
            if(cDown)
            {
                XRay.coneDir -= 3*dir;
            }
            
            if(dir != oldDir)
            {
                XRay.coneDir = (180 - XRay.coneDir);
            }
            
            if(abs(angle_difference(XRay.coneDir,90-(90*dir))) >= 80)
            {
                XRay.coneDir = 90-(90*dir) + 80*sign(angle_difference(XRay.coneDir,90-(90*dir)));
            }
            
            XRay.x = x + dir*3 + lengthdir_x(-1,XRay.coneDir);
            XRay.y = y - 12 + lengthdir_y(-1,XRay.coneDir);
        }
        else
        {
			//var xrayDepth = layer_get_depth(layer_get_id("BTS_Tiles")) - 1;
			var xrayDepth = layer_get_depth(layer_get_id("Tiles_fade0")) - 1;
            XRay = instance_create_depth(x+3*dir,y-12,xrayDepth,obj_XRay);
            XRay.kill = 0;
            XRay.coneDir = 90-(dir*90);
            global.gamePaused = true;
        }
        shineCharge = 0;
    }
    else
    {
        if(instance_exists(XRay))
        {
            XRay.kill = 1;
        }
        if((state != State.Stand && state != State.Crouch) || !grounded)
        {
            with(XRay)
            {
                instance_destroy();
            }
        }
    }
	#endregion

	var unchargeable = ((itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3)) || xRayActive || hyperBeam);
	
	if(!global.roomTrans)
	{
		hSpeed = fVelX;
		vSpeed = fVelY * 0.75;
		dir2 = dir;
		if(stateFrame == State.Grip)
		{
			dir2 = -dir;
		}
		
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
		if(stateFrame == State.Walk || stateFrame == State.Moon || stateFrame == State.Run || stateFrame == State.Brake || stateFrame == State.Jump || stateFrame == State.Somersault ||
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
		
		#region Shoot direction
		if(aimAngle == 0)
		{
			extraSpeed_x = hSpeed;
			extraSpeed_y = 0;
			shootDir = 0;
			if(dir2 == -1)
			{
				shootDir = 180;
			}
		}
		else if(aimAngle == 1)
		{
			extraSpeed_x = hSpeed;
			if(vSpeed < 0)
			{
				extraSpeed_y = vSpeed;
			}
			else
			{
				extraSpeed_y = 0;
			}
			shootDir = 45;
			if(dir2 == -1)
			{
				shootDir = 135;
			}
		}
		else if(aimAngle == -1)
		{
			extraSpeed_x = hSpeed;
			if(vSpeed > 0)
			{
				extraSpeed_y = vSpeed;
			}
			else
			{
				extraSpeed_y = 0;
			}
			shootDir = 315;
			if(dir2 == -1)
			{
				shootDir = 225;
			}
		}
		else if(aimAngle == 2)
		{
			extraSpeed_x = 0;
			if(vSpeed < 0)
			{
				extraSpeed_y = vSpeed;
			}
			else
			{
				extraSpeed_y = 0;
			}
			shootDir = 90;
		}
		else if(aimAngle == -2)// && !grounded)
		{
			extraSpeed_x = 0;
			if(vSpeed > 0)
			{
				extraSpeed_y = vSpeed;
			}
			else
			{
				extraSpeed_y = 0;
			}
			shootDir = 270;
		}
		if((dir == 1 && extraSpeed_x < 0) || (dir == -1 && extraSpeed_x > 0))
		{
			extraSpeed_x = 0;
		}
		#endregion
	}
	
	#region Update Anims
	
	drawMissileArm = false;
	shootFrame = (gunReady || justShot > 0 || instance_exists(grapple) || (cShoot && (rShoot || (beam[Beam.Charge] && !unchargeable)) && (itemSelected == 1 ||
				((itemHighlighted[1] != 0 || missileStat > 0) && (itemHighlighted[1] != 1 || superMissileStat > 0)))));
	sprtOffsetX = 0;
	sprtOffsetY = 0;
	torsoR = sprt_StandCenter;
	torsoL = torsoR;
	legs = -1;
	bodyFrame = 0;
	legFrame = 0;
	runYOffset = 0;
	fDir = dir;
	armDir = fDir;
	//rotation = 0;
	if(rotation != 0 && rotReAlignStep > 0)
	{
		/*if(oldDir != dir)
		{
			var rcos = dcos(scr_wrap(rotation, 0, 360)),
				rsin = dsin(scr_wrap(rotation, 0, 360));
			//rotation = darctan2(rsin,rcos*dir);
		}*/
		
		if(stateFrame == State.Somersault)
		{
			var step = (360 - scr_wrap(rotation, 0, 360)) / rotReAlignStep;
			if(fDir == 1)
			{
				step = -scr_wrap(rotation, 0, 360) / rotReAlignStep;
			}
			rotation = scr_wrap(rotation + step, 0, 360);
		}
		else
		{
			var step = angle_difference(0,rotation) / rotReAlignStep;
			rotation = scr_wrap(rotation + step, 0, 360);
		}
		
		rotReAlignStep = max(rotReAlignStep-1,0);
	}
	else if(rotation != 0)
	{
		rotation = 0;
	}
	
	var liquidMovement = (liquidState > 0);
	
	var aimSpeed = 1 / (1 + liquidMovement);
	
	if(aimSnap > 0)
	{
		aimSpeed *= 3;
	}
	
	var aimFrameTarget = aimAngle*2;
	if(xRayActive)
	{
		aimFrameTarget = 0;
	}
	if(abs(aimFrameTarget-aimFrame) > 4 && stateFrame == State.Grip)
	{
		aimSpeed *= 2;
	}
	if(stateFrame == State.Grapple)
	{
		aimFrameTarget = 4;
		aimSpeed = 1;
		if(abs(aimFrameTarget-aimFrame) <= 2)
		{
			aimSpeed = 0.5;
		}
		
		aimSpeed /= (1 + liquidMovement);
	}
	
	if(aimFrame > aimFrameTarget)
	{
		aimFrame = max(aimFrame - aimSpeed, aimFrameTarget);
	}
	else
	{
		aimFrame = min(aimFrame + aimSpeed, aimFrameTarget);
	}
	
	if(aimFrame == aimFrameTarget)
	{
		aimSnap = 0;
	}
	
	if(stateFrame == State.Stand || stateFrame == State.Crouch)
	{
		aimFrame = max(aimFrame,-2);
	}
	
	finalArmFrame = aimFrame + 4;
	
	/*if(((cShoot && (rShoot || !beam[Beam.Charge])) || (!cShoot && !rShoot && statCharge >= 20) || enqueShot) && shotDelayTime <= 0 && !instance_exists(grapple) &&
	(itemSelected == 0 || (itemSelected == 1 && (itemHighlighted[1] != 0 || missileStat > 0) && (itemHighlighted[1] != 1 || superMissileStat > 0))))*/
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
	else if(lastDir == 0)
	{
		turnSpeed *= 0.75;
	}
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
	
	if((dir == 0 || lastDir == 0) && dirFrameF == 0 && stateFrame == State.Stand)
	{
		fDir = 1;
		torsoR = sprt_StandCenter;
		torsoL = torsoR;
		bodyFrame = suit[Suit.Varia];
		
		// --- Uncomment this code to DAB while in elevator pose ---
			/*torsoR = sprt_Dab;
			torsoL = torsoR;
			bodyFrame = 0;
			fDir = 1;*/
		// ---
	}
	else if(abs(dirFrameF) < 4 && stateFrame != State.Somersault && stateFrame != State.Morph && (stateFrame != State.Spark || shineRestart) && stateFrame != State.Dodge)
	{
		fDir = 1;
		var shootflag = (shootFrame || cAimLock || aimFrame != 0 || recoilCounter > 0);
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
		
		if(stateFrame == State.Spark)
		{
			aimFrame = 0;
		}
		
		if((lastDir == 0 || dir == 0) && aimFrame == 0 && (state == State.Stand || state == State.Elevator))
		{
			torsoR = sprt_TurnCenter;
			bodyFrame = 3 + dirFrameF;
		}
		else
		{
			if(aimFrame > 0 && aimFrame < 3)
			{
				torsoR = sprt_TurnAimUp;
				ArmPos(turnArmPosX[3,dirFrameF+3], turnArmPosY[3]);
			}
			else if(aimFrame < 0 && aimFrame > -3)
			{
				torsoR = sprt_TurnAimDown;
				ArmPos(turnArmPosX[1,dirFrameF+3], turnArmPosY[1]);
			}
			else if(aimFrame >= 3)
			{
				torsoR = sprt_TurnAimUpV;
				ArmPos(turnArmPosX[4,dirFrameF+3], turnArmPosY[4]);
				
				armDir = 1;
				if(dirFrameF < 2)
				{
					armDir = -1;
				}
				drawMissileArm = true;
			}
			else if(aimFrame <= -3)
			{
				torsoR = sprt_TurnAimDownV;
				ArmPos(turnArmPosX[0,dirFrameF+3], turnArmPosY[0]);
				
				armDir = 1;
				if(dirFrameF < 2)
				{
					armDir = -1;
				}
				drawMissileArm = true;
				
				if(stateFrame == State.Jump)
				{
					sprtOffsetX = -dirFrameF;
				}
			}
			else
			{
				torsoR = sprt_Turn;
				ArmPos(turnArmPosX[2,dirFrameF+3], turnArmPosY[2,dirFrameF+3]);
			}
			legs = sprt_TurnLeg;
			if(stateFrame == State.Crouch || stateFrame == State.Jump || !grounded)
			{
				legs = sprt_TurnCrouchLeg;
			}
			if(stateFrame == State.Stand && crouchFrame < 5)
			{
				sprtOffsetY = 11;
				legs = sprt_TurnCrouchLeg;
			}
			bodyFrame = 3 + dirFrameF;
			legFrame = 3 + dirFrameF;
		}
	}
	else
	{
		SetArmPosStand();
		
		switch stateFrame
		{
			#region Stand
			case State.Stand:
			{
				drawMissileArm = true;
				torsoR = sprt_StandRight;
				torsoL = sprt_StandLeft;
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
				if(instance_exists(obj_XRay) || aimFrame != 0 || landFrame > 0 || recoilCounter > 0 || runToStandFrame[0] > 0 || runToStandFrame[1] > 0 || walkToStandFrame > 0)
				{
					frame[Frame.Idle] = 0;
					frameCounter[Frame.Idle] = 0;
					torsoR = sprt_StandAimRight;
					torsoL = sprt_StandAimLeft;
					if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame <= 0)
					{
						torsoR = sprt_StandFireRight;
						torsoL = sprt_StandFireLeft;
						bodyFrame = 2 + scr_round(aimFrame/2);
					}
					else
					{
						if(transFrame > 0)
						{
							torsoR = sprt_TransAimRight;
							torsoL = sprt_TransAimLeft;
							SetArmPosTrans();
						}
						if((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
						{
							torsoR = sprt_JumpAimRight;
							torsoL = sprt_JumpAimLeft;
							SetArmPosJump();
						}
						bodyFrame = 4 + aimFrame;
					}
					if(aimFrame == 0)
					{
						if(runToStandFrame[1] > 0)
						{
							torsoR = sprt_RunAimRight;
							torsoL = sprt_RunAimLeft;
							bodyFrame = scr_round(runToStandFrame[1])-1;
							ArmPos((19+(2*bodyFrame))*dir,-(1+bodyFrame));
						}
						else if(runToStandFrame[0] > 0)
						{
							torsoR = sprt_RunRight;
							torsoL = sprt_RunLeft;
							bodyFrame = scr_round(runToStandFrame[0])-1;
							drawMissileArm = false;
							runYOffset = -(scr_round(runToStandFrame[0]) == 1);
						}
						else if(walkToStandFrame > 0)
						{
							torsoR = sprt_MoonWalkRight;
							torsoL = sprt_MoonWalkLeft;
							bodyFrame = scr_round(walkToStandFrame)-1;
							ArmPos((18+(3*bodyFrame))*dir,-(1+bodyFrame));
						}
						else if(instance_exists(obj_XRay))
						{
							torsoR = sprt_XRayRight;
							torsoL = sprt_XRayLeft;
							bodyFrame = scr_round(XRay.coneDir/45)+2;
							if(dir == -1)
							{
								bodyFrame = 4-scr_round((XRay.coneDir-90)/45);
							}
						}
					}
					if(landFrame > 0)
					{
						legs = sprt_LandLeg;
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
						legs = sprt_StandLeg;
						legFrame = min(abs(aimFrame),2);
					}
				}
				else
				{
					bodyFrame = iSeq[frame[Frame.Idle]];
					if(crouchFrame < 5)
					{
						torsoR = sprt_CrouchRight;
						torsoL = sprt_CrouchLeft;
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
					legs = sprt_CrouchLeg;
				}
				transFrame = max(transFrame - 1, 0);
				frame[Frame.JAim] = 6;
				break;
			}
			#endregion
			#region Walk
			case State.Walk:
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
				if(global.roomTrans)
				{
					numCounter = 5;
				}
				if(frameCounter[Frame.Walk] >= numCounter)
				{
					if(frame[Frame.Walk] == 6 || frame[Frame.Walk] == 12)
					{
						if(!audio_is_playing(snd_SpeedBooster) && !audio_is_playing(snd_SpeedBooster_Loop) && !global.roomTrans)
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
						//frame[Frame.Walk] = scr_wrap(frame[Frame.Walk]+1,1,12);
						//frame[Frame.Walk] = scr_wrap(frame[Frame.Walk]-move2*dir,1,13);
						frame[Frame.Walk] = scr_wrap(frame[Frame.Walk]+1,1,13);
					}
					frameCounter[Frame.Walk] -= numCounter;
				}
				
				SetArmPosJump();
				
				runYOffset = -mOffset[frame[Frame.Walk]];
				
				if(aimFrame != 0)
				{
					torsoR = sprt_JumpAimRight;
					torsoL = sprt_JumpAimLeft;
					if(transFrame < 2)
					{
						torsoR = sprt_TransAimRight;
						torsoL = sprt_TransAimLeft;
						SetArmPosTrans();
					}
					bodyFrame = 4 + aimFrame;
				}
				else
				{
					torsoR = sprt_MoonWalkRight;
					torsoL = sprt_MoonWalkLeft;
					bodyFrame = min(floor(walkToStandFrame),1);
					if(bodyFrame == 0)
					{
						ArmPos(18*dir,-1);
					}
					else if(bodyFrame == 1)
					{
						ArmPos(21*dir,-2);
					}
				}
				legs = sprt_MoonWalkLeg;
				legFrame = frame[Frame.Walk];
				drawMissileArm = true;
				
				walkToStandFrame = min(walkToStandFrame + 0.5, 2);
				transFrame = min(transFrame + 1, 2);
				frame[Frame.JAim] = 6;
				break;
			}
			#endregion
			#region Moon
			case State.Moon:
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
				
				torsoR = sprt_BrakeRight;
				torsoL = sprt_BrakeLeft;
				
				bodyFrame = 4 - floor(frame[Frame.Moon]);
				switch bodyFrame
				{
					case 4:
					{
						ArmPos(11,-5);
						if(dir == -1)
						{
							ArmPos(-9,-4);
						}
						break;
					}
					case 3:
					{
						ArmPos(4,-7);
						if(dir == -1)
						{
							ArmPos(-1,-6);
						}
						break;
					}
					case 2:
					{
						ArmPos(0,-8);
						if(dir == -1)
						{
							ArmPos(1,-7);
						}
						break;
					}
					case 1:
					{
						ArmPos(-2,-8);
						if(dir == -1)
						{
							ArmPos(4,-6);
						}
						break;
					}
					default:
					{
						ArmPos(-3,-8);
						if(dir == -1)
						{
							ArmPos(5,-6);
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
			case State.Run:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Run)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				if(!global.roomTrans)
				{
					var num = clamp(4 * ((abs(velX)-maxSpeed[0,liquidState]) / (maxSpeed[2,liquidState]-maxSpeed[0,liquidState])), speedCounter, 4);
					var num2 = runAnimCounterMax[0];
					if(num > 0)
					{
						num2 = LerpArray(runAnimCounterMax,num,false);
					}
					if(!smoothRunAnim)
					{
						num = speedCounter;
						if(((cDash || global.autoDash) && speedBuffer > 0) || speedCounter > 0)
						{
							num += 1;
						}
						num2 = speedBufferCounterMax[num];
					}
					
					if(!boots[Boots.SpeedBoost])
					{
						num2 = 3;
						if(!smoothRunAnim)
						{
							num2 = 2.5;
						}
						if(abs(velX) > maxSpeed[0,liquidState])
						{
							num2 = lerp(num2, 2, (abs(velX)-maxSpeed[0,liquidState]) / (maxSpeed[1,liquidState]-maxSpeed[0,liquidState]));
						}
					}
					
					var numCounter = num2/2;
					if(!smoothRunAnim)
					{
						var runSpdMult = 1 - abs(velX)/maxSpeed[2,liquidState];
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
				
				#region old old code - why did i make it so retarded
				/*var runNum = floor(max(abs(velX)*1.1, maxSpeed[0,0]));
				if(boots[Boots.SpeedBoost] && (10*(speedCounter/speedCounterMax)) >= abs(velX))
				{
					runNum = floor(max(10*(speedCounter/speedCounterMax)*1.1, maxSpeed[0,0]));
				}
				var runCounterMax = 8;
				if(speedCounter >= speedCounterMax || abs(velX) > maxSpeed[1,0])
				{
					runCounterMax = 7;
				}
				if(liquidMovement)
				{
					runNum = floor(clamp(abs(velX)*1.1,maxSpeed[0,liquidState], maxSpeed[0,0]));
					runCounterMax = 12;
				}
				
				frameCounter[Frame.Run]++;
				var speednum = (maxSpeed[0,0]+abs(maxSpeed[1,0]-maxSpeed[0,0])/2);
				
				var flag = ((frameCounter[Frame.Run] > !(frame[Frame.Run] & 1) && abs(velX) < speednum) || abs(velX) >= speednum || (10*(speedCounter/speedCounterMax)) >= speednum);
				if(liquidMovement)
				{
					flag = (frameCounter[Frame.Run] > (4/runNum)*1.125 || speedBoost);
				}
				if(global.roomTrans)
				{
					flag = (frameCounter[Frame.Run] > 4);
				}
				if(flag)
				{
					if(!global.roomTrans)
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
						var runNum2 = max(runNum/runCounterMax,1);
						if(global.roomTrans)
						{
							runNum2 = 1;
						}
						if(frame[Frame.Run] < 2)
						{
							frame[Frame.Run] += runNum2;
						}
						else
						{
							frame[Frame.Run] = scr_wrap(frame[Frame.Run]+runNum2, 2, 22);
						}
					}
					else
					{
						if(frame[Frame.Run] < 2)
						{
							frame[Frame.Run] += 1;
						}
						else
						{
							frame[Frame.Run] = scr_wrap(frame[Frame.Run]+1, 2, 22);
						}
					}
					frameCounter[Frame.Run] = 0;
				}*/
				#endregion
				
				var shootFrame2 = shootFrame;//(shootFrame || cAimLock);
				
				runYOffset = -rOffset[frame[Frame.Run]];
				if(aimFrame != 0 || shootFrame2)
				{
					runYOffset = -rOffset2[frame[Frame.Run]];
				}
				SetArmPosJump();
				if((aimFrame != 0 && aimFrame != 2 && aimFrame != -2) || (frame[Frame.Run] < 2 && aimFrame != 0))
				{
					if(frame[Frame.Run] < 2)
					{
						torsoR = sprt_TransAimRight;
						torsoL = sprt_TransAimLeft;
						SetArmPosTrans();
					}
					else
					{
						torsoR = sprt_JumpAimRight;
						torsoL = sprt_JumpAimLeft;
					}
					bodyFrame = 4 + aimFrame;
					drawMissileArm = true;
				}
				else
				{
					if(aimFrame == 0)
					{
						if(shootFrame2)
						{
							torsoR = sprt_RunAimRight;
							torsoL = sprt_RunAimLeft;
							drawMissileArm = true;
						}
						else
						{
							torsoR = sprt_RunRight;
							torsoL = sprt_RunLeft;
						}
						if(frame[Frame.Run] == 0)
						{
							ArmPos(19*dir,-1);
						}
						else if(frame[Frame.Run] == 1)
						{
							ArmPos(21*dir,-2);
						}
						else
						{
							ArmPos(22*dir,-2);
						}
						runToStandFrame[shootFrame2] = 2;
						runToStandFrame[!shootFrame2] = 0;
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
						torsoR = sprt_RunAimUpRight;
						torsoL = sprt_RunAimUpLeft;
						ArmPos(19*dir,-21);
					}
					if(aimFrame == -2)
					{
						torsoR = sprt_RunAimDownRight;
						torsoL = sprt_RunAimDownLeft;
					}
				}
				legs = sprt_RunLeg;
				legFrame = frame[Frame.Run];
				
				transFrame = 2;
				frame[Frame.JAim] = 6;
				break;
			}
			#endregion
			#region Brake
			case State.Brake:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				aimFrame = 0;
				walkToStandFrame = 0;
				runToStandFrame[0] = 0;
				runToStandFrame[1] = 0;
				
				torsoR = sprt_BrakeRight;
				torsoL = sprt_BrakeLeft;
				if(move != 0 && move != dir)
				{
					brakeFrame = max(brakeFrame - 2, 0);
				}
				else if(abs(velX) <= (maxSpeed[1,0]*0.75))
				{
					if(abs(velX) < (maxSpeed[0,0]*0.75) || move != 0)
					{
						brakeFrame = max(brakeFrame - ((abs(velX) < (maxSpeed[0,0]*0.75)) + (move != 0)), 0);
					}
				}
				if(brakeFrame >= 10 && !liquid)
				{
					//repeat(3)
					//{
						part_particles_create(obj_Particles.partSystemB,x-(8+random(4))*dir,bbox_bottom+random(4),obj_Particles.bDust[1],1);
					//}
				}
				bodyFrame = clamp(5 - ceil(brakeFrame/2), 0, 4);
				switch bodyFrame
				{
					case 4:
					{
						ArmPos(11,-5);
						if(dir == -1)
						{
							ArmPos(-9,-4);
						}
						break;
					}
					case 3:
					{
						ArmPos(4,-7);
						if(dir == -1)
						{
							ArmPos(-1,-6);
						}
						break;
					}
					case 2:
					{
						ArmPos(0,-8);
						if(dir == -1)
						{
							ArmPos(1,-7);
						}
						break;
					}
					case 1:
					{
						ArmPos(-2,-8);
						if(dir == -1)
						{
							ArmPos(4,-6);
						}
						break;
					}
					default:
					{
						ArmPos(-3,-8);
						if(dir == -1)
						{
							ArmPos(5,-6);
						}
						break;
					}
				}
				if(brakeFrame <= 0)
				{
					brake = false;
				}
				break;
			}
			#endregion
			#region Crouch
			case State.Crouch:
			{
				torsoR = sprt_CrouchRight;
				torsoL = sprt_CrouchLeft;
				legs = sprt_CrouchLeg;
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
				if(aimFrame != 0 || crouchFrame > 0 || recoilCounter > 0 || instance_exists(obj_XRay))
				{
					frame[Frame.Idle] = 0;
					frameCounter[Frame.Idle] = 0;
					if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame <= 0)
					{
						torsoR = sprt_StandFireRight;
						torsoL = sprt_StandFireLeft;
						bodyFrame = 2 + scr_round(aimFrame/2);
					}
					else
					{
						if(aimFrame == 0)
						{
							if(instance_exists(obj_XRay))
							{
								torsoR = sprt_XRayRight;
								torsoL = sprt_XRayLeft;
								bodyFrame = scr_round(XRay.coneDir/45)+2;
								if(dir == -1)
								{
									bodyFrame = 4-scr_round((XRay.coneDir-90)/45);
								}
							}
							else
							{
								torsoR = sprt_CrouchRight;
								torsoL = sprt_CrouchLeft;
								bodyFrame = iSeq[frame[Frame.Idle]];
							}
						}
						else
						{
							torsoR = sprt_StandAimRight;
							torsoL = sprt_StandAimLeft;
							if(transFrame > 0)
							{
								torsoR = sprt_TransAimRight;
								torsoL = sprt_TransAimLeft;
								SetArmPosTrans();
							}
							if ((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
								(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) || 
								(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
							{
								torsoR = sprt_JumpAimRight;
								torsoL = sprt_JumpAimLeft;
								SetArmPosJump();
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
			case State.Morph:
			{
				aimFrame = 0;
				ArmPos(0,0);
				torsoR = sprt_MorphFade;
				
				ballAnimDir = dir;
				if(sign(velX) != 0)
				{
					ballAnimDir = sign(velX);
				}
				
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.Morph && i != Frame.Ball)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[Frame.JAim] = 6 * (velY <= 0);
				
				var xNum = point_distance(x,y,x+velX,y+velY);
				if(liquidMovement)
				{
					xNum *= 0.75;
				}
				
				if(spiderBall && spiderEdge != Edge.None)
				{
					/*if(spiderEdge == Edge.Top)
					{
						ballAnimDir *= -1;
					}
					xNum = 2*(spiderMove != 0);*/
					if(sign(spiderSpeed) != 0)
					{
						ballAnimDir = sign(spiderSpeed);
					}
				}
				
				if(xNum < 1 && xNum > 0)
				{
					xNum = 1;
				}
				if(global.roomTrans)
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
				frameCounter[Frame.Ball] += morphNum;
				if(frameCounter[Frame.Ball] > 2)
				{
					frame[Frame.Ball] = scr_wrap(frame[Frame.Ball]+max(morphNum/3,1)*ballAnimDir, 0, 24);
					frameCounter[Frame.Ball] = 0;
				}
				
				ballFrame = frame[Frame.Ball];
				
				if(unmorphing && scr_round(morphFrame) <= 5)
				{
					torsoR = sprt_MorphOut;
					morphFinal = scr_round(morphFrame)-1;
					bodyFrame = morphFinal;
				}
				else if(scr_round(morphFrame) >= 4 && !unmorphing)
				{
					torsoR = sprt_MorphOut;
					morphFinal = 8-scr_round(morphFrame);
					bodyFrame = morphFinal;
					frame[Frame.Morph] = 0;
				}
				else
				{
					if(unmorphing)
					{
						frame[Frame.Morph] = 0;
					}
					else
					{
						frame[Frame.Morph] += 1/(1+liquidMovement);
						if(frame[Frame.Morph] > 22)
						{
							frame[Frame.Morph] = 0;
						}
					}
					bodyFrame = scr_round(frame[Frame.Morph]);
				}
				torsoL = torsoR;
				
				var yOff = 0;
				if(unmorphing)
				{
					yOff = morphYOff * (morphFrame/8);
				}
				
				sprtOffsetY = 8+yOff;
				break;
			}
			#endregion
			#region Jump
			case State.Jump:
			{
				SetArmPosJump();
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.JAim && i != Frame.Jump)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				if(shootFrame || cAimLock || aimFrame != 0 || recoilCounter > 0)
				{
					aimAnimTweak = 2;
				}
				if(aimAnimTweak > 0)
				{
					if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame >= 0)
					{
						torsoR = sprt_JumpFireRight;
						torsoL = sprt_JumpFireLeft;
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
							torsoR = sprt_TransAimRight;
							torsoL = sprt_TransAimLeft;
							SetArmPosTrans();
						}
						else
						{
							torsoR = sprt_JumpAimRight;
							torsoL = sprt_JumpAimLeft;
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
					
					legs = sprt_JumpAimLeg;
					if(!global.roomTrans)
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
						/*
						if(velY < 0)
						{
							ledgeFall2 = false;
							frame[Frame.JAim] = 6;
						}
						else if(!global.roomTrans)
						{
							frame[Frame.Jump] = min(frame[Frame.Jump] + max(0.5/max(frame[Frame.Jump],1),0.125), 4);
							frame[Frame.JAim] = 6;
						}
						torsoR = sprt_FallRight;
						torsoL = sprt_FallLeft;
						legs = sprt_JumpAimLeg;
						bodyFrame = frame[Frame.Jump];
						legFrame = floor((frame[Frame.Jump]+0.5)*2);
						*/
						
						if(velY < 0)
						{
							ledgeFall2 = false;
						}
						frame[Frame.JAim] = 6;
						
						torsoR = sprt_FallRight;
						torsoL = sprt_FallLeft;
						legs = sprt_JumpAimLeg;
						
						if(frameCounter[Frame.Jump] < 30)
						{
							if(!global.roomTrans)
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
							if(!global.roomTrans)
							{
								frame[Frame.Jump] = clamp(frame[Frame.Jump] + 0.25,4,8);
							}
							bodyFrame = scr_floor(frame[Frame.Jump]);
							legFrame = scr_ceil(12 - frame[Frame.Jump]);
						}
					}
					else
					{
						if(!global.roomTrans)
						{
							if(velY <= 0 || frame[Frame.Jump] < 4)
							{
								frame[Frame.Jump] = min(frame[Frame.Jump] + (0.5/(1+liquidMovement)), 4);
								frame[Frame.JAim] = 6;
							}
							else
							{
								//frame[Frame.Jump] = min(frame[Frame.Jump] + max(0.5/max((frame[Frame.Jump]-3),1),0.125), 8);
								frame[Frame.Jump] = clamp(frame[Frame.Jump] + (0.25/(1+liquidMovement)), 4, 9);
								frame[Frame.JAim] = 6;
							}
						}
						//if(frame[Frame.Jump] <= 4)
						//{
							torsoR = sprt_JumpRight;
							torsoL = sprt_JumpLeft;
							bodyFrame = frame[Frame.Jump];
						/*}
						else
						{
							torsoR = sprt_FallRight;
							torsoL = sprt_FallLeft;
							legs = sprt_JumpFallLeg;
							bodyFrame = frame[Frame.Jump]-4;
							legFrame = frame[Frame.Jump]-4;
						}*/
					}
				}
				transFrame = min(transFrame + 1, 2);
				break;
			}
			#endregion
			#region Somersault
			case State.Somersault:
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
				if(wjFrame > 0 || (canWallJump && entity_place_collide(-8*move,0) && !entity_place_collide(0,16) && wjAnimDelay <= 0))
				{
					torsoR = sprt_WallJumpRight;
					torsoL = sprt_WallJumpLeft;
					if(wjFrame > 0)
					{
						bodyFrame = wjSequence[scr_round(wjFrame)];
						frame[Frame.Somersault] = 3;
						if(boots[Boots.SpaceJump] && !liquidMovement)
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
					torsoR = sprt_SomersaultRight;
					torsoL = sprt_SomersaultLeft;
					var sFrameMax = 18;
					if(boots[Boots.SpaceJump] && !liquidMovement)
					{
						if(spaceJump <= 0)
						{
							torsoR = sprt_SpaceJumpRight;
							torsoL = sprt_SpaceJumpLeft;
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
						if(global.roomTrans)
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
					if(boots[Boots.SpaceJump] && !liquidMovement)
					{
						degNum = 90;
					}
					SetArmPosSomersault(sFrameMax, degNum, frame[Frame.Somersault]);
				}
				break;
			}
			#endregion
			#region Grip
			case State.Grip:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				var gripAimTarget = aimFrameTarget+4;
				if(climbIndex <= 0)
				{
					torsoR = sprt_GripRight;
					torsoL = sprt_GripLeft;
					/*if(gripGunReady)
					{
						if(gripAimFrame > gripAimTarget)
						{
							gripAimFrame = max(gripAimFrame - aimSpeed, gripAimTarget);
						}
						else
						{
							gripAimFrame = min(gripAimFrame + aimSpeed, gripAimTarget);
						}
						//if(abs(gripAimTarget - gripAimFrame) < 3)
						//{
							gripFrame = min(gripFrame + aimSpeed, 3);
						//}
					}
					else
					{
						gripAimFrame = max(gripAimFrame - aimSpeed, 0);
						gripFrame = max(gripFrame - aimSpeed, 0);
					}
					if(recoilCounter > 0)
					{
						gripAimFrame = clamp(gripAimFrame, gripAimTarget-3,gripAimTarget+3);
						gripGunReady = true;
						gripGunCounter = 30;
					}
					if(pMove == dir || aimAngle > 0)
					{
						gripGunCounter = 0;
					}
					finalArmFrame = gripAimFrame;
					SetArmPosGrip();
					armDir = -fDir;
					drawMissileArm = true;
					bodyFrame = scr_round(gripFrame) + (4 * scr_round(gripAimFrame));
					if(recoilCounter > 0 && gripAimFrame == (scr_round(gripAimFrame/2)*2) && gripFrame >= 3)
					{
						torsoR = sprt_GripFireRight;
						torsoL = sprt_GripFireLeft;
						bodyFrame = scr_round(gripAimFrame/2);
					}*/
					var gSpeed = 1/(1+liquidMovement);
					if(recoilCounter > 0)
					{
						gripAimFrame = clamp(gripAimFrame, gripAimTarget-3,gripAimTarget+3);
						gripGunReady = true;
						gripGunCounter = 30;
						gSpeed *= 2;
					}
					if(gripGunReady)
					{
						gripFrame = min(gripFrame + gSpeed, 3);
						
						if(gripFrame >= 3)
						{
							if(gripAimFrame > gripAimTarget)
							{
								gripAimFrame = max(gripAimFrame - aimSpeed, gripAimTarget);
							}
							else
							{
								gripAimFrame = min(gripAimFrame + aimSpeed, gripAimTarget);
							}
						}
						else
						{
							gripAimFrame = clamp(gripAimFrame, gripAimTarget-3,gripAimTarget+3);
						}
					}
					else
					{
						gripAimFrame = 0;
						gripFrame = max(gripFrame - gSpeed, 0);
					}
					SetArmPosGrip();
					if(gripFrame <= 2)
					{
						finalArmFrame = 2-(gripFrame > 0);
					}
					else
					{
						armDir = -fDir;
						finalArmFrame = gripAimFrame;
					}
					drawMissileArm = true;
					bodyFrame = scr_round(gripFrame);
					if(gripFrame >= 3)
					{
						bodyFrame += scr_round(gripAimFrame);
					}
					if(recoilCounter > 0 && gripAimFrame == (scr_round(gripAimFrame/2)*2) && gripFrame >= 3)
					{
						torsoR = sprt_GripFireRight;
						torsoL = sprt_GripFireLeft;
						bodyFrame = scr_round(gripAimFrame/2);
					}
				}
				else
				{
					aimFrame = 0;
					torsoR = sprt_ClimbRight;
					torsoL = sprt_ClimbLeft;
					if(climbIndexCounter > liquidMovement)
					{
						climbFrame = climbSequence[climbIndex];
					}
					bodyFrame = climbFrame;
					SetArmPosClimb();
				}
				
				break;
			}
			#endregion
			#region Spark
			case State.Spark:
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
					torsoR = sprt_SparkStartRight;
					torsoL = sprt_SparkStartLeft;
					bodyFrame = floor(frame[Frame.SparkStart]);
					frame[Frame.SparkV] = 0;
					frameCounter[Frame.SparkV] = 0;
					frame[Frame.SparkH] = 0;
					frameCounter[Frame.SparkH] = 0;
					
					switch(bodyFrame)
					{
						case 3:
						{
							ArmPos(2*dir,9);
							break;
						}
						case 2:
						{
							ArmPos(2*dir,7);
							break;
						}
						case 1:
						{
							ArmPos(2*dir,5);
							break;
						}
						default:
						{
							ArmPos(2*dir,4);
							break;
						}
					}
				}
				else
				{
					if(shineDir == 0)
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
							if(!global.roomTrans || frameCounter[Frame.SparkV] > 4)
							{
								frame[Frame.SparkV] = scr_wrap(frame[Frame.SparkV]+1,1,17);
								frameCounter[Frame.SparkV] = 0;
							}
						}
						torsoR = sprt_SparkVRight;
						torsoL = sprt_SparkVLeft;
						bodyFrame = frame[Frame.SparkV];
						
						SetArmPosSpark(0);
					}
					else if(shineDir == 4)
					{
						if(abs(shineDownRot) < 180)
						{
							shineDownRot = clamp(shineDownRot - 45*dir, -180, 180);

							torsoR = sprt_SomersaultRight;
							torsoL = sprt_SomersaultLeft;
							bodyFrame = scr_round(abs(shineDownRot)/45)*2;
							sprtOffsetY = 8*(abs(shineDownRot)/180);
							
							SetArmPosSomersault(17, 40, bodyFrame);
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
								if(!global.roomTrans || frameCounter[Frame.SparkV] > 4)
								{
									frame[Frame.SparkV] = scr_wrap(frame[Frame.SparkV]+1,1,17);
									frameCounter[Frame.SparkV] = 0;
								}
							}
							torsoR = sprt_SparkVRight;
							torsoL = sprt_SparkVLeft;
							bodyFrame = frame[Frame.SparkV];
							rotation = shineDownRot;
							rotReAlignStep = 4;
							sprtOffsetY = 8;
							
							SetArmPosSpark(shineDownRot);
						}

						//frame[Frame.Somersault] = 10/(1+boots[Boots.SpaceJump]);
					}
					else
					{
						frame[Frame.SparkH] = min(frame[Frame.SparkH] + 0.3334, 2);
						if(shineRestart)
						{
							frame[Frame.SparkH] = 0;
						}
						torsoR = sprt_SparkHRight;
						torsoL = sprt_SparkHLeft;
						bodyFrame = floor(frame[Frame.SparkH]);
						
						switch(bodyFrame)
						{
							case 2:
							{
								ArmPos(-17,-1);
								if(dir == -1)
								{
									ArmPos(-4,-3);
								}
								break;
							}
							case 1:
							{
								ArmPos(-10,8);
								if(dir == -1)
								{
									ArmPos(-5,-3);
								}
								break;
							}
							default:
							{
								ArmPos(-5,9);
								if(dir == -1)
								{
									ArmPos(-9,-2);
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
			case State.Grapple:
			{
				//aimFrame = 0;
	            for(var i = 0; i < array_length(frame); i += 1)
	            {
	                if(i != Frame.GrappleLeg && i != Frame.GrappleBody && i != Frame.JAim)
	                {
	                    frame[i] = 0;
	                    frameCounter[i] = 0;
	                }
	            }
	            if(grapWJCounter > 0)
	            {
	                torsoR = sprt_GrappleWJRight;
	                torsoL = sprt_GrappleWJLeft;
	                bodyFrame = 0;
	                ArmPos(-15*dir,-22);
					rotation = 0;
	            }
				else if(aimFrame != aimFrameTarget)
				{
					torsoR = sprt_JumpAimRight;
					torsoL = sprt_JumpAimLeft;
					bodyFrame = 4 + scr_round(aimFrame);
					
					legs = sprt_JumpAimLeg;
					legFrame = frame[Frame.JAim];
					
					var aimF = scr_round(aimFrame)-aimFrameTarget;
					var gRot = grapAngle + abs(aimF)*22.5*fDir;
					rotation = scr_round(gRot/2.8125)*2.8125;
					
					SetArmPosJump();
					var armR = point_direction(0,0,armOffsetX,armOffsetY),
						armL = point_distance(0,0,armOffsetX,armOffsetY);
					
					ArmPos(lengthdir_x(armL,armR+rotation),lengthdir_y(armL,armR+rotation));
				}
	            else if(instance_exists(grapple))
	            {
	                torsoR = sprt_GrappleRight;
	                torsoL = sprt_GrappleLeft;
					
					//bodyFrame = scr_wrap(10-scr_round(grapAngle/18)*dir,0,20);
					if(speedBoost)
					{
						frame[Frame.GrappleBody] = clamp(frame[Frame.GrappleBody]+1,9,14);
					}
					else
					{
						frame[Frame.GrappleBody] = scr_wrap(10-scr_round(grapAngle/18)*dir,0,20);
					}
					bodyFrame = frame[Frame.GrappleBody];
					
					legs = sprt_GrappleLeg;
	                rotation = scr_round(grapAngle/2.8125)*2.8125;
					rotReAlignStep = 4;

	                ArmPos(lengthdir_x(31, rotation + 90),lengthdir_y(31, rotation + 90));
	                //if((grappleDist-grappleOldDist) < 0 && grapWallBounceFrame <= 0)
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
							/*if(move != 0)
		                    {
		                        gFrameDest = move;//-move*2;
								
								if(abs(scr_round(grapMoveAnim)) <= scr_round(abs(grapAngVel)) || move != sign(grapAngVel))// && sign(grapMoveAnim) == sign(grapAngVel))
								{
									if(grapMoveAnim < grapAngVel)
									{
										//grapMoveAnim = min(grapMoveAnim+max((grapMoveAnim-grapAngVel)*0.5,1),grapAngVel);
										grapMoveAnim = min(grapMoveAnim+1,grapAngVel);
									}
									else
									{
										//grapMoveAnim = max(grapMoveAnim-max((grapMoveAnim-grapAngVel)*0.5,1),grapAngVel);
										grapMoveAnim = max(grapMoveAnim-1,grapAngVel);
									}
								}
								else
								{
									if(move == sign(grapAngVel))
									{
										gFrameDest = 0;//move;
									}
									else
									{
										gFrameDest = 0;
									}
									
									if(scr_round(abs(grapAngVel)) < abs(scr_round(grapMoveAnim*0.75)))
									{
										grapMoveAnim *= 0.9;
									}
								}
		                    }
							else
							{
								grapMoveAnim = 0;
							}*/
						}
	                    if(grapWallBounceFrame > 0)
	                    {
	                        //gFrameDest = -2*dir;
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
	                    legFrame = 5+(scr_round(frame[Frame.GrappleLeg])*dir);
	                }
	            }
				break;
			}
			#endregion
			#region Hurt
			case State.Hurt:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				
				torsoR = sprt_HurtRight;
				torsoL = sprt_HurtLeft;
				bodyFrame = floor(hurtFrame);
				hurtFrame = min(hurtFrame + 0.34, 1);
				ArmPos(11,-11);
				if(dir == -1)
				{
					ArmPos(-2,-14);
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
			case State.DmgBoost:
			{
				SetArmPosJump();
				for(var i = 0; i < array_length(frame); i++)
				{
					if(i != Frame.JAim && i != Frame.Jump || dBoostFrame < 19)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				torsoR = sprt_DamageBoostRight;
				torsoL = sprt_DamageBoostLeft;
				if(dBoostFrame < 19)
				{
					frame[Frame.JAim] = 6;
					bodyFrame = dBoostFrame;
					dBoostFrameCounter++;
					if(dBoostFrameCounter > 5)
					{
						dBoostFrame++;
						dBoostFrameCounter = 6;
					}
					if(velY < 0 && dBoostFrame >= 17)
					{
						dBoostFrame = 2;
					}
					if(bodyFrame == 0 || bodyFrame == 18)
					{
						ArmPos(2*dir,7);
					}
					if(bodyFrame == 1 || bodyFrame == 17)
					{
						ArmPos(6*dir,10);
					}
					
					if(bodyFrame >= 2 && bodyFrame <= 16)
					{
						var rotPos = ((360/16) * max(bodyFrame-1,0) - 40);
						ArmPos(lengthdir_x(10*dir,rotPos),lengthdir_y(10,rotPos));
					}
				}
				else
				{
					if(shootFrame || /*gunReady2 ||*/ aimFrame != 0 || recoilCounter > 0)
					{
						if(recoilCounter > 0 && aimFrame == (scr_round(aimFrame/2)*2) && transFrame >= 2)
						{
							torsoR = sprt_JumpFireRight;
							torsoL = sprt_JumpFireLeft;
							bodyFrame = 2 + scr_round(aimFrame/2);
						}
						else
						{
							if(transFrame < 2)
							{
								torsoR = sprt_TransAimRight;
								torsoL = sprt_TransAimLeft;
								SetArmPosTrans();
							}
							else
							{
								torsoR = sprt_JumpAimRight;
								torsoL = sprt_JumpAimLeft;
							}
							bodyFrame = 4 + aimFrame;
						}
						legs = sprt_JumpAimLeg;
						if(velY <= 0)
						{
							frame[Frame.JAim] = max(frame[Frame.JAim] - 0.3, 0);
							frame[Frame.Jump] = 0;
						}
						else
						{
							frame[Frame.JAim] = min(frame[Frame.JAim] + max(1/max(frame[Frame.JAim],1),0.25), 9);
							if(ledgeFall2)
							{
								frame[Frame.Jump] = 0;
							}
							else
							{
								frame[Frame.Jump] = 5;
							}
						}
						legFrame = frame[Frame.JAim];
						drawMissileArm = true;
					}
					else
					{
						frame[Frame.JAim] = 6;
						frame[Frame.Jump] = max(min(frame[Frame.Jump] + max(0.5/max(frame[Frame.Jump],1),0.125), 4),1);
						torsoR = sprt_FallRight;
						torsoL = sprt_FallLeft;
						legs = sprt_JumpAimLeg;
						bodyFrame = frame[Frame.Jump];
						legFrame = floor((frame[Frame.Jump]+0.5)*2);
					}
				}
				break;
			}
			#endregion
			#region Dodge
			case State.Dodge:
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
				
				torsoR = sprt_SparkHRight;
				torsoL = sprt_SparkHLeft;
				if(dodgeDir != dir)
				{
					torsoR = sprt_DodgeBack_Right;
					torsoL = sprt_DodgeBack_Left;
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
					//if(dodgeDir != dir)
					//{
						//frame[Frame.Dodge] = max(frame[Frame.Dodge],1);
					//}
				}
				bodyFrame = scr_floor(frame[Frame.Dodge]);
				
				if(dodgeDir == dir)
				{
					switch(bodyFrame)
					{
						case 2:
						{
							ArmPos(-17,-1);
							if(dir == -1)
							{
								ArmPos(-4,-3);
							}
							break;
						}
						case 1:
						{
							ArmPos(-10,8);
							if(dir == -1)
							{
								ArmPos(-5,-3);
							}
							break;
						}
						default:
						{
							ArmPos(-5,9);
							if(dir == -1)
							{
								ArmPos(-9,-2);
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
							ArmPos(14,-12);
							if(dir == -1)
							{
								ArmPos(-1,0);
							}
							break;
						}
						case 1:
						{
							ArmPos(8,-7);
							if(dir == -1)
							{
								ArmPos(-6,-3);
							}
							break;
						}
						default:
						{
							ArmPos(1*dir,7);
							break;
						}
					}
				}
				
				break;
			}
			#endregion
			#region CrystalFlash
			case State.CrystalFlash:
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
					torsoR = sprt_MorphOut;
					bodyFrame = 4-frame[Frame.CFlash];
					sprtOffsetY = 8;
					
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
					
					torsoR = sprt_CrystalFlash;
					bodyFrame = cFlashFrameSequence[frame[Frame.CFlash]-5];
					
					sprtOffsetY = -bodyFrame;
				}
				
				torsoL = torsoR;
				break;
			}
			#endregion
			#region Push
			case State.Push:
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

	            torsoR = sprt_PushRight;
	            torsoL = sprt_PushLeft;

	            if(grounded && move2 != 0 && instance_exists(pushBlock) && pushBlock.grounded)
	            {
					var animSpStart = 0.375 / (1+liquidMovement),
						animSp = 0.275 / (1+liquidMovement);
					if(cDash || global.autoDash)
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
	                frame[Frame.Push] = clamp(frame[Frame.Push]-0.5,0,3);
	            }
	            bodyFrame = pushFrameSequence[scr_floor(frame[Frame.Push])];
				break;
			}
			#endregion
		}
	}
	
	if(stateFrame != State.Push)
	{
		audio_sound_loop(pushSnd,false);
		pushSndPlayed = false;
	}
	
	if(rotation == 0)
	{
		rotReAlignStep = 4;
	}
	
	if(!global.roomTrans)
	{
		var animDiv = (1+liquidMovement);
		var animSpeed = 1/animDiv;
	
		aimAnimTweak = max(aimAnimTweak - 1, 0);
		aimSnap = max(aimSnap - 1, 0);
		if(sign(velX) == dir)
		{
			landFrame = max(landFrame - (1 + max(1.5*(move != 0),abs(velX)*0.5))/animDiv, 0);
		}
		else
		{
			landFrame = max(landFrame - animSpeed, 0);
		}
		//if(uncrouching)
		//if(uncrouched)
		if(stateFrame != State.Crouch)
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
		wjAnimDelay = max(wjAnimDelay - 1, 0);
		spaceJump = max(spaceJump - 1, 0);
		morphFrame = max(morphFrame - animSpeed, 0);
	
		//if((velX == 0 && move == 0) || lhc_place_collide(move,0) || landFrame > 0 || !grounded)
		if(stateFrame == State.Stand)
		{
			runToStandFrame[0] = max(runToStandFrame[0] - animSpeed, 0);
			runToStandFrame[1] = max(runToStandFrame[1] - animSpeed, 0);
		
			if(!walkState)
			{
				walkToStandFrame = max(walkToStandFrame - (1/(1+(walkToStandFrame < 2)))/animDiv, 0);
			}
		}
		else if(stateFrame != State.Run && stateFrame != State.Walk)
		{
			runToStandFrame[0] = 2;
			if(stateFrame == State.Crouch)
			{
				runToStandFrame[0] = 0;
			}
			runToStandFrame[1] = 0;
			walkToStandFrame = 0;
		}
	
		if(stateFrame != State.Brake)
		{
			brakeFrame = 0;
		}
		if(stateFrame != State.Spark)
		{
			shineDownRot = 0;
		}
		if(stateFrame != State.Grapple)
		{
		    grapFrame = 3;
		    grapWallBounceFrame = 0;
		}
		else
		{
		    grapWallBounceFrame = max(grapWallBounceFrame-1,0);
		}
		if(stateFrame != State.DmgBoost)
		{
			dBoostFrame = 0;
			dBoostFrameCounter = 0;
		}
	
		recoilCounter = max(recoilCounter - 1, 0);
		gripGunCounter = max(gripGunCounter - 1, 0);
	
		if(climbIndexCounter > liquidMovement || climbIndex <= 1)
		{
			if(state == State.Grip && startClimb)
			{
				climbIndex = min(climbIndex + 1, 18);
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
	else
	{
		afterImgAlphaMult = 0.25;//0.375;
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
	
	#endregion
	
	#region MB Trail
	
	if(drawBallTrail)
	{
		if(stateFrame == State.Morph)
		{
			drawAfterImage = false;
		
			mbTrailColor_Start = c_lime;
			mbTrailColor_End = c_green;
			if(spiderBall)
			{
				mbTrailColor_Start = merge_color(c_lime,c_yellow,0.6);
				mbTrailColor_End = c_green;
			}
			/*else if(suit[Suit.Gravity])
			{
				mbTrailColor_Start = c_aqua;
				mbTrailColor_End = c_teal;
			}*/
			if(state == State.BallSpark)
			{
				mbTrailColor_Start = c_yellow;
				mbTrailColor_End = c_olive;
			}
			else if(speedBoost)
			{
				mbTrailColor_Start = c_aqua;
				mbTrailColor_End = make_color_rgb(0,148,255);
			}
		
			if(immuneTime > 0 && !(immuneTime&1) && !global.roomTrans)
			{
				mbTrailColor_Start = c_black;
				mbTrailColor_End = c_black;
			}
		
			for(var i = 0; i < mbTrailLength-1; i++)
			{
				mbTrailPosX[i] = mbTrailPosX[i+1];
				mbTrailPosY[i] = mbTrailPosY[i+1];
				mbTrailDir[i] = mbTrailDir[i+1];
			}
			mbTrailPosX[mbTrailLength-1] = x + sprtOffsetX;
			mbTrailPosY[mbTrailLength-1] = y + sprtOffsetY;
			var trailDir = point_direction(scr_round(x),scr_round(y),scr_round(xprevious),scr_round(yprevious));
			if(point_distance(scr_round(x),scr_round(y),scr_round(xprevious),scr_round(yprevious)) > 0)
			{
				mbTrailDir[mbTrailLength-1] = trailDir;
			}
			else
			{
				mbTrailDir[mbTrailLength-1] = noone;
			}
			
			mbTrailAlpha = min(mbTrailAlpha+0.1, 1);
		}
		else
		{
			mbTrailAlpha = max(mbTrailAlpha-0.1, 0);
		}
	}
	
	#endregion
	
	
	if(!global.roomTrans)
	{
		var noBeamsActive = (beam[Beam.Ice]+beam[Beam.Wave]+beam[Beam.Spazer]+beam[Beam.Plasma] <= 0);
		
		var canShoot = (!startClimb && !brake && !moonFallState && !isPushing && state != State.Somersault && state != State.Spark && state != State.BallSpark && 
						state != State.Hurt && (stateFrame != State.DmgBoost || dBoostFrame >= 19) && state != State.Dodge && state != State.Death);
		
		if(!canShoot)
		{
			enqueShot = false;
		}
	
		shootPosX = x+sprtOffsetX+shotOffsetX;
		shootPosY = y+sprtOffsetY+runYOffset+shotOffsetY;
	
		var shotIndex = beamShot,
			damage = beamDmg,
			sSpeed = shootSpeed,
			delay = beamDelay,
			amount = beamAmt,
			sound = beamSound,
			autoFire = 1;
		if(itemSelected == 1 && itemHighlighted[1] <= 1)
		{
			if(itemHighlighted[1] == 0 && missileStat > 0 && item[Item.Missile])
			{
				shotIndex = obj_MissileShot;
				damage = 100;
				sSpeed = shootSpeed/2;
				delay = 9;
				amount = 1;
				sound = snd_Missile_Shot;
				autoFire = 0;
			}
			if(itemHighlighted[1] == 1 && superMissileStat > 0 && item[Item.SMissile])
			{
				shotIndex = obj_SuperMissileShot;
				damage = 300;
				sSpeed = shootSpeed/3;
				delay = 19;
				amount = 1;
				sound = snd_SuperMissile_Shot;
				autoFire = 0;
			}
		}
		else if(hyperBeam)
		{
			shotIndex = obj_HyperBeamShot;
			damage = 450;
			delay = 20;
			amount = 1;
			sound = snd_PlasmaBeam_ChargeShot;
			autoFire = 2;
		}
	
		// ----- Shoot -----
		#region Shoot
		if((cShoot || enqueShot || (state == State.Grapple && grapWJCounter > 0)) && dir != 0 && !xRayActive && state != State.Death)
		{
			if(state != State.Morph && stateFrame != State.Morph)
			{
				if(itemSelected == 1 && itemHighlighted[1] == 3 && item[Item.Grapple] && canShoot)
				{
					delay = 14;
					
					if(!instance_exists(grapple))
					{
						if(shotDelayTime <= 0)
						{
							if(rShoot || enqueShot)
							{
								grapple = Shoot(obj_GrappleBeamShot,20,0,0,1,snd_GrappleBeam_Shoot);
								recoil = true;
							}
							enqueShot = false;
						}
						else if(rShoot && shotDelayTime < delay/2)
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
				
					//if(shotDelayTime <= 0)
					if(canShoot && (itemSelected == 0 || ((itemHighlighted[1] != 0 || missileStat > 0) && (itemHighlighted[1] != 1 || superMissileStat > 0))))
					{
						if(autoFire > 0)
						{
							gunReady = true;
							justShot = 90;
						}
						
						if(shotDelayTime <= 0)
						{
							if(rShoot || enqueShot || (!beam[Beam.Charge] && autoFire > 0) || autoFire == 2)
							{
								if(itemSelected == 1 && itemHighlighted[1] <= 1)
								{
									if(itemHighlighted[1] == 0 && missileStat > 0 && item[Item.Missile])
									{
										missileStat--;
									}
									if(itemHighlighted[1] == 1 && superMissileStat > 0 && item[Item.SMissile])
									{
										superMissileStat--;
									}
								}
								if(!rShoot && !enqueShot && autoFire == 1)
								{
									delay *= 2;
								}
								Shoot(shotIndex,damage,sSpeed,delay,amount,sound,beamIsWave,beamWaveStyleOffset);
								if(hyperBeam && shotIndex == obj_HyperBeamShot)
								{
									if(beam[Beam.Spazer])
									{
										Shoot(obj_HyperBeamLesserShot,damage,sSpeed,delay,2+2*beamIsWave,noone,beamIsWave,1);
									}
									
									var flareDir = shootDir;
									if(dir == -1)
									{
										flareDir = angle_difference(shootDir,180);
									}
									var flare = instance_create_layer(shootPosX+lengthdir_x(5,shootDir),shootPosY+lengthdir_y(5,shootDir),layer_get_id("Projectiles_fg"),obj_ChargeFlare);
									flare.damage = damage;
									flare.sprite_index = sprt_HyperBeamChargeFlare;
									flare.damageType = DmgType.Misc;
									flare.damageSubType[1] = false;
									flare.damageSubType[2] = false;
									flare.damageSubType[3] = false;
									flare.damageSubType[4] = true;
									flare.damageSubType[5] = false;
									flare.direction = flareDir;
									flare.image_angle = flareDir;
									flare.image_xscale = dir;
									flare.creator = object_index;
									
									hyperFired = delay+2;
								}
								
								gunReady = true;
								justShot = 90;
								recoil = true;
							}
							enqueShot = false;
						}
						else if(rShoot && shotDelayTime < delay/2)
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
			else if(bombDelayTime <= 0 && canShoot && rShoot)
			{
				if(itemSelected == 1 && (itemHighlighted[1] == 2 || global.HUD > 0) && powerBombStat > 0 && item[Item.PBomb])
				{
					var pBomb = instance_create_layer(x,y+11,"Projectiles_fg",obj_PowerBomb);
					pBomb.damage = 20;
					bombDelayTime = 30;
					powerBombStat--;
					cFlashStartCounter++;
					//audio_play_sound(snd_PowerBombSet,0,false);
				}
				else if(misc[Misc.Bomb] && (instance_number(obj_MBBomb) < 3 || cDown))
				{
					var bombposx = x,
						bombposy = y+11,
						instaBomb = cDown;
					if(spiderBall)
					{
						bombposx = x + lengthdir_x(-2,spiderJumpDir);
						bombposy = y+9 + lengthdir_y(-2,spiderJumpDir);
						if(spiderEdge == Edge.Top)
						{
							instaBomb = cUp;
						}
						if(spiderEdge == Edge.Left)
						{
							instaBomb = cLeft;
						}
						if(spiderEdge == Edge.Right)
						{
							instaBomb = cRight;
						}
					}
					
					if(instaBomb)
					{
						var explo = instance_create_layer(bombposx,bombposy,"Projectiles_fg",obj_MBBombExplosion);
						explo.damage = 50;
						scr_PlayExplodeSnd(0,false);
					}
					else
					{
						var mbBomb = instance_create_layer(bombposx,bombposy,"Projectiles_fg",obj_MBBomb);
						mbBomb.damage = 50;
						//audio_play_sound(snd_BombSet,0,false);
					}
					bombDelayTime = 8;
				}
			}
		
			if(beam[Beam.Charge] && !unchargeable && !enqueShot && !isPushing && //(canShoot || statCharge >= 10) &&
			((state != State.Morph && stateFrame != State.Morph) || (statCharge >= 10 && (itemSelected == 0 || (global.HUD <= 0 && itemHighlighted[1] == 4)) && misc[Misc.Bomb])))
			{
				statCharge = min(statCharge + 1, maxCharge);
				if(statCharge >= 10)
				{
					if(!chargeSoundPlayed)
					{
						audio_play_sound(snd_Charge,0,false);
						chargeSoundPlayed = true;
					}
					else if(!audio_is_playing(snd_Charge) && !audio_is_playing(snd_Charge_Loop))
					{
						audio_play_sound(snd_Charge_Loop,0,true);
					}
				}
				else
				{
					audio_stop_sound(snd_Charge);
					audio_stop_sound(snd_Charge_Loop);
					chargeSoundPlayed = false;
				}
				if(state == State.Morph)
				{
					if(bombCharge < statCharge)
					{
						bombCharge = statCharge;
					}
					bombCharge = min(bombCharge+1,bombChargeMax+maxCharge);
				}
				else
				{
					bombCharge = 0;
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
				//if(grapple.grappled)
				if(grapple.grappleState != GrappleState.None)
				{
					instance_destroy(grapple);
				}
				else
				{
					grapple.impacted = max(grapple.impacted,1);
				}
			}
			else
			{
				grappleDist = 0;
			}
		
			if(statCharge <= 0)
			{
				audio_stop_sound(snd_Charge);
				audio_stop_sound(snd_Charge_Loop);
				chargeSoundPlayed = false;
			}
		
			if(canShoot && dir != 0 && !xRayActive)
			{
				if(state != State.Morph && stateFrame != State.Morph)
				{
					if(beam[Beam.Charge] && !unchargeable)
					{
						if(statCharge >= maxCharge)
						{
							var flareDir = shootDir;
							if(dir == -1)
							{
								flareDir = angle_difference(shootDir,180);
							}
							var flare = instance_create_layer(shootPosX+lengthdir_x(5,shootDir),shootPosY+lengthdir_y(5,shootDir),layer_get_id("Projectiles_fg"),obj_ChargeFlare);
							flare.damage = (damage*chargeMult*beamChargeAmt);// / 2;
							flare.sprite_index = beamFlare;
							flare.damageSubType[2] = (beam[Beam.Ice] || (noBeamsActive && itemHighlighted[0] == 1));
							flare.damageSubType[3] = (beam[Beam.Wave] || (noBeamsActive && itemHighlighted[0] == 2));
							flare.damageSubType[4] = (beam[Beam.Spazer] || (noBeamsActive && itemHighlighted[0] == 3));
							flare.damageSubType[5] = (beam[Beam.Plasma] || (noBeamsActive && itemHighlighted[0] == 4));
							flare.direction = flareDir;
							flare.image_angle = flareDir;
							flare.image_xscale = dir;
							flare.creator = object_index;
							if(beam[Beam.Ice] || (noBeamsActive && itemHighlighted[0] == 1))
							{
								flare.freezeType = 2;
								flare.freezeKill = true;
							}
							
							chargeReleaseFlash = 4;
							Shoot(beamCharge,damage*chargeMult,sSpeed,beamChargeDelay,beamChargeAmt,beamChargeSound,beamIsWave,beamWaveStyleOffset);
							recoil = true;
						}
						else if(statCharge >= 20)
						{
							Shoot(shotIndex,damage,sSpeed,delay,amount,sound,beamIsWave,beamWaveStyleOffset);
							recoil = true;
						}
					}
				}
				statCharge = 0;
			}
			if(state == State.Spark || state == State.BallSpark || dir == 0)
			{
				statCharge = 0;
			}
			enqueShot = false;
		}
	
		if(canShoot && state == State.Morph && stateFrame == State.Morph)
		{
			var bChMax = bombChargeMax+maxCharge;
		
			if(bombCharge >= bChMax || (!cShoot && bombCharge > 0))
			{
				if(!grounded && cDown)
				{
					var bombDir = array(0,90,210,330),
						bombTime = array(0,30,30,30),
						bombSpd = 2+((4/bChMax)*bombCharge);
					for(var i = 0; i < 4; i++)
					{
						var bomb = instance_create_layer(x,y+11,"Projectiles_fg",obj_MBBomb);
						bomb.damage = 15;
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
				else
				{
					var bombDirection = array(45, 135, 67.5, 112.5, 90),
						bombDirectionR = array(45, 56.25, 67.5, 78.75, 90),
						bombDirectionL = array(135, 123.75, 112.5, 101.25, 90),
						bombSpeed = 2+((4/bChMax)*bombCharge),
						spreadFrict = 2,
						spreadType = 0;
					for(var i = 0; i < 5; i++)
					{
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
						else if(cDown)
						{
							bDir = 90;
							spreadFrict = 2 / max(3*i,1);
							spreadType = 1;
						}
						var bomb = instance_create_layer(x,y+11,"Projectiles_fg",obj_MBBomb);
						bomb.damage = 15;
						bomb.velX = lengthdir_x(bombSpeed,bDir);
						bomb.velY = lengthdir_y(bombSpeed,bDir);
						bomb.spreadType = spreadType;
						bomb.spreadFrict = spreadFrict;
						bomb.bombTimer = 55 + (10 + (5*spreadType))*i;
					}
					bombDelayTime = 120 + (30*spreadType);
					audio_play_sound(snd_BombSet,0,false);
				}
				bombCharge = 0;
				statCharge = 0;
				audio_stop_sound(snd_Charge);
				audio_stop_sound(snd_Charge_Loop);
				chargeSoundPlayed = false;
			}
		}
		else
		{
			bombCharge = 0;
		}
		#endregion
	
		if(isSpeedBoosting || isScrewAttacking)
		{
			var dmgST;
			dmgST[0] = true;
			dmgST[1] = false;
			dmgST[2] = isSpeedBoosting;
			dmgST[3] = isScrewAttacking;
			dmgST[4] = false;
			dmgST[5] = false;
		    scr_DamageNPC(x,y,2000,DmgType.Misc,dmgST,0,3,0);
		}
		else if(isChargeSomersaulting)
		{
		    var psDmg = beamDmg*chargeMult;
		    if(beam[Beam.Spazer] || (noBeamsActive && itemHighlighted[0] == 3))
		    {
		        psDmg *= 2;
		    }
			var dmgST;
			dmgST[0] = true;
			dmgST[1] = true;
			dmgST[2] = (beam[Beam.Ice] || (noBeamsActive && itemHighlighted[0] == 1));
			dmgST[3] = (beam[Beam.Wave] || (noBeamsActive && itemHighlighted[0] == 2));
			dmgST[4] = (beam[Beam.Spazer] || (noBeamsActive && itemHighlighted[0] == 3));
			dmgST[5] = (beam[Beam.Plasma] || (noBeamsActive && itemHighlighted[0] == 4));
		    scr_DamageNPC(x,y,psDmg,DmgType.Charge,dmgST,0,3,0);
		}
		
		// ----- Environmental Damage -----
		#region Environmental Damage
		
		var palFlag = false;
		
		if(global.rmHeated && !suit[Suit.Varia])
		{
			//scr_ConstantDamageSamus(1, 4 + (2 * suit[Suit.Gravity]));
			ConstantDamage(1, 4 + (2 * suit[Suit.Gravity]));
			
			if(!audio_is_playing(snd_HeatDamageLoop))
	        {
	            var snd = audio_play_sound(snd_HeatDamageLoop,0,true);
	            audio_sound_gain(snd,0.7,0);
	        }
			
			palFlag = true;
		}
		else
		{
			audio_stop_sound(snd_HeatDamageLoop);
		}
		
		if(liquid && liquid.liquidType == LiquidType.Lava && !suit[Suit.Gravity])
	    {
	        ConstantDamage(1, 2 + (1 * (suit[Suit.Varia])));
        
	        if(!audio_is_playing(snd_LavaDamageLoop))
	        {
	            var snd = audio_play_sound(snd_LavaDamageLoop,0,true);
	            audio_sound_gain(snd,0.8,0);
	        }
        
	        palFlag = true;
	    }
	    else
	    {
	        audio_stop_sound(snd_LavaDamageLoop);
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
	
		if(aimAngle != 0 || velX == 0 || notGrounded || abs(dirFrame) < 4 || state == State.Morph)
		{
			justShot = 0;
		}
		shotDelayTime = max(shotDelayTime - 1, 0);
		justShot = max(justShot - 1, 0);
	
		if(!instance_exists(obj_PowerBomb) && !instance_exists(obj_PowerBombExplosion))
		{
			bombDelayTime = max(bombDelayTime - 1, 0);
		}
	
		rRight = !cRight;
		rLeft = !cLeft;
		rUp = !cUp;
		rDown = !cDown;
		rJump = !cJump;
		rShoot = !cShoot;
		rDash = !cDash;
		rAngleUp = !cAngleUp;
		rAngleDown = !cAngleDown;
		rAimLock = !cAimLock;
		rMorph = !cMorph;
	
		oldDir = dir;
	
		prevAimAngle = aimAngle;
	
		outOfLiquid = (liquidState <= 0);
		shineRestarted = false;
	
		immuneTime = max(immuneTime - 1, 0);
	
		grappleOldDist = grappleDist;
		grapWJCounter = max(grapWJCounter-1,0);
		
		hyperFired = max(hyperFired-1,0);
		
		stallCamera = false;
		
		shiftedVelX = 0;
		shiftedVelY = 0;
		
		if(state != prevState)
		{
			lastState = prevState;
		}
		prevState = state;
		
		if(stateFrame != prevStateFrame)
		{
			lastStateFrame = prevStateFrame;
		}
		prevStateFrame = stateFrame;
	}
	else
	{
		sndFlag = true;
	}
}
else
{
	sndFlag = true;
}

if(sndFlag)
{
	audio_stop_sound(snd_HeatDamageLoop);
    audio_stop_sound(snd_LavaDamageLoop);
	
	audio_sound_loop(pushSnd,false);
	pushSndPlayed = false;
}