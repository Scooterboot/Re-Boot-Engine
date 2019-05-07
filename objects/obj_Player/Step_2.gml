/// @description Update Anims, Shoot, & Environmental Dmg

var xRayActive = instance_exists(XRay);

if(!global.gamePaused || (xRayActive && !global.roomTrans && !obj_PauseMenu.pause && !pauseSelect))
{
// ----- X-Ray -----
#region X-Ray
	//scr_PlayerXRay();
#endregion

	var unchargeable = ((itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3)) || xRayActive);
	
	hSpeed = fVelX;
	vSpeed = fVelY * 0.75;
	dir2 = sign(dirFrame);
	if(dir2 == 0 || (itemSelected == 1 && itemHighlighted[1] == 3 && item[3]))
	{
		dir2 = dir;
	}
	if(stateFrame == State.Grip)
	{
		dir2 = -dir;
	}
	
// ----- Set Shoot Pos -----
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
	if(stateFrame == State.Walk || stateFrame == State.Run || stateFrame == State.Brake || stateFrame == State.Jump || stateFrame == State.Somersault ||
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

// ----- Shoot direction -----
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
	else if(aimAngle == -2 && !grounded)
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

// ----- Update Anims -----
#region Update Anims
	drawMissileArm = false;
	shootFrame = (gunReady || justShot > 0 || (cShoot && (rShoot || (beam[0] && !unchargeable)) && (itemSelected == 1 ||
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
	rotation = 0;
	
	var liquidMovement = (liquidState > 0);
	
	var aimSpeed = 1 / (1 + liquidMovement);
	
	if(aimSnap > 0)
	{
		aimSpeed *= 3;
	}
	
	var aimFrameTarget = aimAngle*2;
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
	
	finalArmFrame = aimFrame + 4;
	
	if(((cShoot && rShoot) || (!cShoot && !rShoot && statCharge >= 20)) && shotDelayTime <= 0 && 
	(itemSelected == 0 || (itemSelected == 1 && (itemHighlighted[1] != 0 || missileStat > 0) && (itemHighlighted[1] != 1 || superMissileStat > 0))))
	{
		recoilCounter = 4 + (statCharge >= maxCharge) + liquidMovement;
		var aimClamp = 2-liquidMovement;
		aimFrame = clamp(aimFrame, aimFrameTarget-aimClamp,aimFrameTarget+aimClamp);
		aimSnap = 8;
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
	
	if((dir == 0 || lastDir == 0) && dirFrameF == 0)
	{
		fDir = 1;
		torsoR = sprt_StandCenter;
		torsoL = torsoR;
		bodyFrame = suit[0];
	}
	else if(abs(dirFrameF) < 4 && stateFrame != State.Somersault && stateFrame != State.Morph && stateFrame != State.Spark)
	{
		fDir = 1;
		for(var i = 0; i < array_length_1d(frame); i++)
		{
			frame[i] = 0;
			frameCounter[i] = 0;
		}
		ledgeFall = true;
		
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
				scr_ArmPos(turnArmPosX[3,dirFrameF+3], turnArmPosY[3]);
			}
			else if(aimFrame < 0 && aimFrame > -3)
			{
				torsoR = sprt_TurnAimDown;
				scr_ArmPos(turnArmPosX[1,dirFrameF+3], turnArmPosY[1]);
			}
			else if(aimFrame >= 3)
			{
				torsoR = sprt_TurnAimUpV;
				scr_ArmPos(turnArmPosX[4,dirFrameF+3], turnArmPosY[4]);
				
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
				scr_ArmPos(turnArmPosX[0,dirFrameF+3], turnArmPosY[0]);
				
				armDir = 1;
				if(dirFrameF < 2)
				{
					armDir = -1;
				}
				drawMissileArm = true;
			}
			else
			{
				torsoR = sprt_Turn;
				scr_ArmPos(turnArmPosX[2,dirFrameF+3], turnArmPosY[2,dirFrameF+3]);
			}
			legs = sprt_TurnLeg;
			if(stateFrame == State.Crouch || stateFrame == State.Jump || !grounded)
			{
				legs = sprt_TurnCrouchLeg;
			}
			bodyFrame = 3 + dirFrameF;
			legFrame = 3 + dirFrameF;
		}
	}
	else
	{
		scr_SetArmPosStand();
		
		switch stateFrame
		{
			case State.Stand:
			{
				drawMissileArm = true;
				torsoR = sprt_StandRight;
				torsoL = sprt_StandLeft;
				for(var i = 1; i < array_length_1d(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frameCounter[0]++;
				
				if(frameCounter[0] > idleNum[frame[0]])
				{
					frame[0] = scr_wrap(frame[0] + 1,0,7);
					frameCounter[0] = 0;
				}
				if(instance_exists(obj_XRay) || aimFrame != 0 || landFrame > 0 || recoilCounter > 0 || runToStandFrame[0] > 0 || runToStandFrame[1] > 0 || walkToStandFrame > 0)
				{
					frame[0] = 0;
					frameCounter[0] = 0;
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
							scr_SetArmPosTrans();
						}
						if((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
						{
							torsoR = sprt_JumpAimRight;
							torsoL = sprt_JumpAimLeft;
							scr_SetArmPosJump();
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
							scr_ArmPos((19+(2*bodyFrame))*dir,-(1+bodyFrame));
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
							scr_ArmPos((18+(3*bodyFrame))*dir,-(1+bodyFrame));
						}
						else if(instance_exists(obj_XRay))
						{
							torsoR = sprt_XRayRight;
							torsoL = sprt_XRayLeft;
							bodyFrame = scr_round(XRay.ConeDir/45)+2;
							if(dir == -1)
							{
								bodyFrame = 4-scr_round((XRay.ConeDir-90)/45);
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
					bodyFrame = idleSequence[frame[0]];
				}
				transFrame = max(transFrame - 1, 0);
				frame[4] = 6;
				break;
			}
			case State.Walk:
			{
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 7)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				runToStandFrame[0] = 0;
				runToStandFrame[1] = 0;
				
				frameCounter[7]++;
				if(frameCounter[7] >= ((2 + (frame[7] & 1)) * (1+liquidMovement)))
				{
					if(frame[7] == 6 || frame[7] == 12)
					{
						if(!audio_is_playing(snd_SpeedBooster) && !audio_is_playing(snd_SpeedBooster_Loop))
						{
							audio_play_sound(snd_Step,0,false);
						}
					}
					
					if(frame[7] < 1)
					{
						frame[7] += 1;
					}
					else
					{
						frame[7] = scr_wrap(frame[7]+1,1,12);
					}
					frameCounter[7] = 0;
				}
				
				scr_SetArmPosJump();
				
				runYOffset = -mOffset[frame[7]];
				
				if(aimFrame != 0)
				{
					torsoR = sprt_JumpAimRight;
					torsoL = sprt_JumpAimLeft;
					if(transFrame < 2)
					{
						torsoR = sprt_TransAimRight;
						torsoL = sprt_TransAimLeft;
						scr_SetArmPosTrans();
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
						scr_ArmPos(18*dir,-1);
					}
					else if(bodyFrame == 1)
					{
						scr_ArmPos(21*dir,-2);
					}
				}
				legs = sprt_MoonWalkLeg;
				legFrame = frame[7];
				drawMissileArm = true;
				
				walkToStandFrame = min(walkToStandFrame + 0.5, 2);
				transFrame = min(transFrame + 1, 2);
				frame[4] = 6;
				break;
			}
			case State.Run:
			{
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 1)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				
				var runNum = floor(max(abs(velX)*1.1, maxSpeed[0,0]));
				if(boots[2] && (10*(speedCounter/speedCounterMax)) >= abs(velX))
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
				frameCounter[1]++;
				var speednum = (maxSpeed[0,0]+abs(maxSpeed[1,0]-maxSpeed[0,0])/2);
				if((((abs(velX) < speednum && frameCounter[1] > !(frame[1] & 1)) || abs(velX) >= speednum || (10*(speedCounter/speedCounterMax)) >= speednum) && !liquidMovement) ||
					((frameCounter[1] > (4/runNum)*1.125 || speedBoost) && liquidMovement))
				{
					var sndFrameCheck = floor(frame[1]/2);
					if((sndFrameCheck == 4 || sndFrameCheck == 9))// && !speedBoost)
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
					if(frame[1] < 2)
					{
						frame[1] += runNum2;
					}
					else
					{
						frame[1] = scr_wrap(frame[1]+runNum2, 2, 21);
					}
					
					frameCounter[1] = 0;
				}
				
				runYOffset = -rOffset[frame[1]];
				if(aimFrame != 0 || shootFrame)
				{
					runYOffset = -rOffset2[frame[1]];
				}
				scr_SetArmPosJump();
				if((aimFrame != 0 && aimFrame != 2 && aimFrame != -2) || (frame[1] < 2 && aimFrame != 0))
				{
					if(frame[1] < 2)
					{
						torsoR = sprt_TransAimRight;
						torsoL = sprt_TransAimLeft;
						scr_SetArmPosTrans();
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
						if(shootFrame)
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
						if(frame[1] == 0)
						{
							scr_ArmPos(19*dir,-1);
						}
						else if(frame[1] == 1)
						{
							scr_ArmPos(21*dir,-2);
						}
						else
						{
							scr_ArmPos(22*dir,-2);
						}
						runToStandFrame[shootFrame] = 2;
						runToStandFrame[!shootFrame] = 0;
						bodyFrame = frame[1];
					}
					else
					{
						runToStandFrame[0] = 0;
						runToStandFrame[1] = 0;
						drawMissileArm = true;
						bodyFrame = runAimSequence[frame[1]];
					}
					if(aimFrame == 2)
					{
						torsoR = sprt_RunAimUpRight;
						torsoL = sprt_RunAimUpLeft;
						scr_ArmPos(19*dir,-21);
					}
					if(aimFrame == -2)
					{
						torsoR = sprt_RunAimDownRight;
						torsoL = sprt_RunAimDownLeft;
					}
				}
				legs = sprt_RunLeg;
				legFrame = frame[1];
				
				transFrame = 2;
				frame[4] = 6;
				break;
			}
			case State.Brake:
			{
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[4] = 6;
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
				bodyFrame = clamp(5 - ceil(brakeFrame/2), 0, 4);
				switch bodyFrame
				{
					case 4:
					{
						scr_ArmPos(11,-5);
						if(dir == -1)
						{
							scr_ArmPos(-9,-4);
						}
						break;
					}
					case 3:
					{
						scr_ArmPos(4,-7);
						if(dir == -1)
						{
							scr_ArmPos(-1,-6);
						}
						break;
					}
					case 2:
					{
						scr_ArmPos(0,-8);
						if(dir == -1)
						{
							scr_ArmPos(1,-7);
						}
						break;
					}
					case 1:
					{
						scr_ArmPos(-2,-8);
						if(dir == -1)
						{
							scr_ArmPos(4,-6);
						}
						break;
					}
					default:
					{
						scr_ArmPos(-3,-8);
						if(dir == -1)
						{
							scr_ArmPos(5,-6);
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
			case State.Crouch:
			{
				torsoR = sprt_CrouchRight;
				torsoL = sprt_CrouchLeft;
				legs = sprt_CrouchLeg;
				for(var i = 1; i < array_length_1d(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[4] = 6;
				frameCounter[0]++;
				
				if(frameCounter[0] > idleNum[frame[0]])
				{
					frame[0] = scr_wrap(frame[0] + 1,0,7);
					frameCounter[0] = 0;
				}
				if(aimFrame != 0 || crouchFrame > 0 || recoilCounter > 0 || instance_exists(obj_XRay))
				{
					frame[0] = 0;
					frameCounter[0] = 0;
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
								bodyFrame = scr_round(XRay.ConeDir/45)+2;
								if(dir == -1)
								{
									bodyFrame = 4-scr_round((XRay.ConeDir-90)/45);
								}
							}
							else
							{
								torsoR = sprt_CrouchRight;
								torsoL = sprt_CrouchLeft;
								bodyFrame = idleSequence[frame[0]];
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
								scr_SetArmPosTrans();
							}
							if ((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
								(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) || 
								(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
							{
								torsoR = sprt_JumpAimRight;
								torsoL = sprt_JumpAimLeft;
								scr_SetArmPosJump();
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
					bodyFrame = idleSequence[frame[0]];
				}
				transFrame = max(transFrame - 1, 0);
				drawMissileArm = true;
				break;
			}
			case State.Morph:
			{
				aimFrame = 0;
				scr_ArmPos(0,0);
				torsoR = sprt_MorphFade;
				
				ballAnimDir = dir;
				if(sign(velX) != 0)
				{
					ballAnimDir = sign(velX);
				}
				
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 2 && i != 3)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[4] = 6 * (velY <= 0);
				
				var xNum = point_distance(x,y,x+velX,y+velY);
				if(liquidMovement)
				{
					xNum *= 0.75;
				}
				
				if(spiderBall && spiderEdge != Edge.None)
				{
					if(spiderEdge == Edge.Top)
					{
						ballAnimDir *= -1;
					}
					xNum = 2*(spiderMove != 0);
				}
				
				if(xNum < 1 && xNum > 0)
				{
					xNum = 1;
				}
				if(state == State.BallSpark)
				{
					morphNum = min(morphNum + 0.25, shineSparkSpeed) * (shineEnd <= 0);
				}
				else
				{
					morphNum = xNum;
				}
				frameCounter[3] += morphNum;
				if(frameCounter[3] > 2)
				{
					frame[3] = scr_wrap(frame[3]+max(morphNum/3,1)*ballAnimDir, 0, 23);
					frameCounter[3] = 0;
				}
				
				ballFrame = frame[3];
				
				sprtOffsetY = 8;
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
					frame[2] = 0;
				}
				else
				{
					if(unmorphing)
					{
						frame[2] = 0;
					}
					else
					{
						frame[2] += 1/(1+liquidMovement);
						if(frame[2] > 22)
						{
							frame[2] = 0;
						}
					}
					bodyFrame = scr_round(frame[2]);
				}
				torsoL = torsoR;
				break;
			}
			case State.Jump:
			{
				scr_SetArmPosJump();
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 4 && i != 5)
					{
						frame[i] = 0;
					}
					frameCounter[i] = 0;
				}
				if(shootFrame || gunReady2 || aimFrame != 0 || recoilCounter > 0)
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
					}
					else
					{
						if(transFrame < 2)
						{
							torsoR = sprt_TransAimRight;
							torsoL = sprt_TransAimLeft;
							scr_SetArmPosTrans();
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
						frame[4] = max(frame[4] - 0.3, 0);
						frame[5] = 0;
					}
					else
					{
						frame[4] = min(frame[4] + max(1/max(frame[4],1),0.25), 9);
						if(ledgeFall2)
						{
							frame[5] = 0;
						}
						else
						{
							frame[5] = 5;
						}
					}
					legFrame = frame[4];
					drawMissileArm = true;
				}
				else
				{
					if(ledgeFall2)
					{
						if(velY < 0)
						{
							ledgeFall2 = false;
							frame[4] = 6;
						}
						else
						{
							frame[5] = min(frame[5] + max(0.5/max(frame[5],1),0.125), 4);
							frame[4] = 6;
						}
						torsoR = sprt_FallRight;
						torsoL = sprt_FallLeft;
						legs = sprt_JumpAimLeg;
						bodyFrame = frame[5];
						legFrame = floor((frame[5]+0.5)*2);
					}
					else
					{
						if(velY <= 0 || frame[5] < 4)
						{
							frame[5] = min(frame[5] + (0.5/(1+liquidMovement)), 4);
							frame[4] = 6;
						}
						else
						{
							frame[5] = min(frame[5] + max(0.5/max((frame[5]-3),1),0.125), 8);
							frame[4] = 6;
						}
						if(frame[5] <= 4)
						{
							torsoR = sprt_JumpRight;
							torsoL = sprt_JumpLeft;
							bodyFrame = frame[5];
						}
						else
						{
							torsoR = sprt_FallRight;
							torsoL = sprt_FallLeft;
							legs = sprt_JumpFallLeg;
							bodyFrame = frame[5]-4;
							legFrame = frame[5]-4;
						}
					}
				}
				transFrame = min(transFrame + 1, 2);
				break;
			}
			case State.Somersault:
			{
				aimFrame = 0;
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 6)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				frame[4] = 6 * (velY <= 0);
				if(wjFrame > 0 || (canWallJump && place_collide(-8*move,0) && !place_collide(0,16) && wjAnimDelay <= 0))
				{
					torsoR = sprt_WallJumpRight;
					torsoL = sprt_WallJumpLeft;
					if(wjFrame > 0)
					{
						bodyFrame = wjSequence[scr_round(wjFrame)];
						frame[6] = 3;
						if(boots[1] && !liquidMovement)
						{
							frame[6] = 2;
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
							scr_ArmPos(7*dir,-3);
							break;
						}
						case 2:
						{
							scr_ArmPos(13*dir,-4);
							break;
						}
						case 3:
						{
							scr_ArmPos(8*dir,7);
							break;
						}
						default:
						{
							scr_ArmPos(-5*dir,-5);
							break;
						}
					}
				}
				else
				{
					torsoR = sprt_SomersaultRight;
					torsoL = sprt_SomersaultLeft;
					var sFrameMax = 17;
					if(boots[1] && !liquidMovement)
					{
						torsoR = sprt_SpaceJumpRight;
						torsoL = sprt_SpaceJumpLeft;
						sFrameMax = 9;
					}
					if(oldDir == dir)
					{
						var num = 0;
						if(frame[6] == 0 || frame[6] == 1)
						{
							num = 1+(frame[6] == 0);
						}
						num += liquidMovement;
						frameCounter[6]++;
						if(frameCounter[6] > num)
						{
							frame[6]++;
							frameCounter = 0;
						}
						if(frame[6] > sFrameMax)
						{
							frame[6] = 2;
						}
					}
					else if(frame[6] >= 2)
					{
						frame[6] = scr_wrap(frame[6] - (frame[6]-2)*2, 2, sFrameMax);
					}
					bodyFrame = frame[6];
					var degNum = 40;
					if(boots[1] && !liquidMovement)
					{
						degNum = 90;
					}
					var rotPos = -((360/(sFrameMax-1)) * max(frame[6]-2,0) + degNum);
					switch bodyFrame
					{
						case 0:
						{
							scr_ArmPos(2*dir,7);
							break;
						}
						case 1:
						{
							scr_ArmPos(6*dir,10);
							break;
						}
						default:
						{
							scr_ArmPos(lengthdir_x(10*dir,rotPos),lengthdir_y(10,rotPos));
							break;
						}
					}
				}
				break;
			}
			case State.Grip:
			{
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[4] = 6;
				var gripAimTarget = aimFrameTarget+4;
				if(climbIndex <= 0)
				{
					torsoR = sprt_GripRight;
					torsoL = sprt_GripLeft;
					if(gripGunReady)
					{
						if(gripAimFrame > gripAimTarget)
						{
							gripAimFrame = max(gripAimFrame - aimSpeed, gripAimTarget);
						}
						else
						{
							gripAimFrame = min(gripAimFrame + aimSpeed, gripAimTarget);
						}
						if(abs(gripAimTarget - gripAimFrame) < 3)
						{
							gripFrame = min(gripFrame + aimSpeed, 3);
						}
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
					scr_SetArmPosGrip();
					armDir = -fDir;
					drawMissileArm = true;
					bodyFrame = scr_round(gripFrame) + (4 * scr_round(gripAimFrame));
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
					scr_SetArmPosClimb();
				}
				
				break;
			}
			case State.Spark:
			{
				aimFrame = 0;
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 8 && i != 9 && i != 10)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				if(shineStart > 0)
				{
					if(shineStart <= 20)
					{
						frame[10] = min(frame[10] + 0.25, 3);
					}
					torsoR = sprt_SparkStartRight;
					torsoL = sprt_SparkStartLeft;
					bodyFrame = floor(frame[10]);
					frame[8] = 0;
					frameCounter[8] = 0;
					frame[9] = 0;
					frameCounter[9] = 0;
				}
				else
				{
					if(shineDir == 0)
					{
						if(frame[8] < 1)
						{
							frameCounter[8] += 1;
							if(frameCounter[8] > 2)
							{
								frame[8] += 1;
								frameCounter[8] = 0;
							}
						}
						else if(shineEnd <= 0)
						{
							frame[8] = scr_wrap(frame[8]+1,1,16);
						}
						torsoR = sprt_SparkVRight;
						torsoL = sprt_SparkVLeft;
						bodyFrame = frame[8];
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
						}
						else
						{
							if(frame[8] < 1)
							{
								frameCounter[8] += 1;
								if(frameCounter[8] > 1)
								{
									frame[8] += 1;
									frameCounter[8] = 0;
								}
							}
							else if(shineEnd <= 0)
							{
								frame[8] = scr_wrap(frame[8]+1,1,16);
							}
							torsoR = sprt_SparkVRight;
							torsoL = sprt_SparkVLeft;
							bodyFrame = frame[8];
							rotation = shineDownRot;
							sprtOffsetY = -8;
						}

						frame[6] = 10/(1+boots[1]);
					}
					else
					{
						frame[9] = min(frame[9] + 0.3334, 2);
						if(shineRestarted)
						{
							frame[9] = 0;
						}
						torsoR = sprt_SparkHRight;
						torsoL = sprt_SparkHLeft;
						bodyFrame = floor(frame[9]);
					}
				}
				break;
			}
			case State.Hurt:
			{
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[4] = 6;
				torsoR = sprt_HurtRight;
				torsoL = sprt_HurtLeft;
				bodyFrame = floor(hurtFrame);
				hurtFrame = min(hurtFrame + 0.34, 1);
				scr_ArmPos(11,-11);
				if(dir == -1)
				{
					scr_ArmPos(-2,-14);
				}
				break;
			}
			case State.DmgBoost:
			{
				scr_SetArmPosJump();
				for(var i = 0; i < array_length_1d(frame); i++)
				{
					if(i != 4 && i != 5 || dBoostFrame < 19)
					{
						frame[i] = 0;
						frameCounter[i] = 0;
					}
				}
				torsoR = sprt_DamageBoostRight;
				torsoL = sprt_DamageBoostLeft;
				if(dBoostFrame < 19)
				{
					frame[4] = 6;
					bodyFrame = dBoostFrame;
					dBoostFrameCounter++;
					if(dBoostFrameCounter > 3)
					{
						dBoostFrame++;
						dBoostFrameCounter = 0;
					}
					if(bodyFrame == 0 || bodyFrame == 18)
					{
						scr_ArmPos(2*dir,7);
					}
					if(bodyFrame == 1 || bodyFrame == 17)
					{
						scr_ArmPos(6*dir,10);
					}
					
					if(bodyFrame >= 2 && bodyFrame <= 16)
					{
						var rotPos = ((360/16) * max(bodyFrame-1,0) - 40);
						scr_ArmPos(lengthdir_x(10*dir,rotPos),lengthdir_y(10,rotPos));
					}
				}
				else
				{
					if(shootFrame || gunReady2 || aimFrame != 0 || recoilCounter > 0)
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
								scr_SetArmPosTrans();
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
							frame[4] = max(frame[4] - 0.3, 0);
							frame[5] = 0;
						}
						else
						{
							frame[4] = min(frame[4] + max(1/max(frame[4],1),0.25), 9);
							if(ledgeFall2)
							{
								frame[5] = 0;
							}
							else
							{
								frame[5] = 5;
							}
						}
						legFrame = frame[4];
						drawMissileArm = true;
					}
					else
					{
						frame[4] = 6;
						frame[5] = max(min(frame[5] + max(0.5/max(frame[5],1),0.125), 4),1);
						torsoR = sprt_FallRight;
						torsoL = sprt_FallLeft;
						legs = sprt_JumpAimLeg;
						bodyFrame = frame[5];
						legFrame = floor((frame[5]+0.5)*2);
					}
				}
				break;
			}
		}
	}
	
	var animDiv = (1+liquidMovement);
	var animSpeed = 1/animDiv;
	
	aimAnimTweak = max(aimAnimTweak - 1, 0);
	aimSnap = max(aimSnap - 1, 0);
	landFrame = max(landFrame - (1 + (1.5*(move != 0)))/animDiv, 0);
	if(uncrouching)
	{
		crouchFrame = min(crouchFrame + animSpeed, 5);
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
	morphFrame = max(morphFrame - animSpeed, 0);
	
	if((velX == 0 && move == 0) || landFrame > 0 || !grounded)
	{
		runToStandFrame[0] = max(runToStandFrame[0] - animSpeed, 0);
		runToStandFrame[1] = max(runToStandFrame[1] - animSpeed, 0);
		
		if(!walkState)
		{
			walkToStandFrame = max(walkToStandFrame - (1/(1+(walkToStandFrame < 2)))/animDiv, 0);
		}
	}
	
	if(stateFrame != State.Brake)
	{
		brakeFrame = 0;
	}
	if(stateFrame != State.Spark)
	{
		shineDownRot = 0;
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
#endregion

	var canShoot = (!startClimb && !brake && state != State.Spark && state != State.BallSpark && state != State.Hurt && (stateFrame != State.DmgBoost || dBoostFrame >= 19) && state != State.Death);
	
	shootPosX = x+sprtOffsetX+shotOffsetX;
	shootPosY = y+sprtOffsetY+runYOffset+shotOffsetY;
	
// ----- Set Beams -----
#region Set Beams
	beamShot = obj_PowerBeamShot;
	beamCharge = obj_PowerBeamChargeShot;
	beamChargeAnim = sprt_PowerBeamChargeAnim;
	beamSound = snd_PowerBeam_Shot;
	beamChargeSound = snd_PowerBeam_ChargeShot;
	beamAmt = 1;
	beamChargeAmt = 1;
	beamIconIndex = 0;
	
	beamDelay = 6;
	beamChargeDelay = 18;
	
	var noBeamsActive = ((beam[1]+beam[2]+beam[3]+beam[4]) <= 0);
	
	if(beam[3] || (noBeamsActive && itemHighlighted[0] == 3))
	{
		// Spazer
		beamShot = obj_SpazerBeamShot;
	    beamCharge = obj_SpazerBeamChargeShot;
	    beamChargeAnim = sprt_SpazerChargeAnim;
	    beamSound = snd_Spazer_Shot;
	    beamChargeSound = snd_Spazer_ChargeShot;
	    beamAmt = 3;
	    beamChargeAmt = 3;
	    beamIconIndex = 4;
		if(beam[1])
		{
			// Ice Spazer
			beamShot = obj_IceSpazerBeamShot;
		    beamCharge = obj_IceSpazerBeamChargeShot;
		    beamChargeAnim = sprt_IceBeamChargeAnim;
		    beamSound = snd_IceComboShot;
		    beamChargeSound = snd_IceBeam_ChargeShot;
			beamIconIndex = 5;
			if(beam[2])
			{
				// Ice Wave Spazer
				beamShot = obj_IceWaveSpazerBeamShot;
				beamCharge = obj_IceWaveSpazerBeamChargeShot;
				beamIconIndex = 7;
				if(beam[4])
				{
					// Ice Wave Spazer Plasma
					beamShot = obj_IceWaveSpazerPlasmaBeamShot;
					beamCharge = obj_IceWaveSpazerPlasmaBeamChargeShot;
					beamIconIndex = 15;
				}
			}
			else if(beam[4])
			{
				// Ice Spazer Plasma
				beamShot = obj_IceSpazerPlasmaBeamShot;
				beamCharge = obj_IceSpazerPlasmaBeamChargeShot;
				beamIconIndex = 13;
			}
		}
		else if(beam[2])
		{
			// Wave Spazer
			beamShot = obj_WaveSpazerBeamShot;
			beamCharge = obj_WaveSpazerBeamChargeShot;
			beamChargeAnim = sprt_WaveBeamChargeAnim;
			beamIconIndex = 6;
			if(beam[4])
			{
				// Wave Spazer Plasma
				beamShot = obj_WaveSpazerPlasmaBeamShot;
				beamCharge = obj_WaveSpazerPlasmaBeamChargeShot;
				beamChargeAnim = sprt_PlasmaBeamChargeAnim;
				beamSound = snd_PlasmaBeam_Shot;
				beamChargeSound = snd_PlasmaBeam_ChargeShot;
				beamIconIndex = 14;
			}
		}
		else if(beam[4])
		{
			// Spazer Plasma
			beamShot = obj_SpazerPlasmaBeamShot;
			beamCharge = obj_SpazerPlasmaBeamChargeShot;
			beamChargeAnim = sprt_PlasmaBeamChargeAnim;
			beamSound = snd_PlasmaBeam_Shot;
			beamChargeSound = snd_PlasmaBeam_ChargeShot;
			beamIconIndex = 12;
		}
	}
	else if(beam[1] || (noBeamsActive && itemHighlighted[0] == 1))
	{
		// Ice
		beamShot = obj_IceBeamShot;
		beamCharge = obj_IceBeamChargeShot;
		beamChargeAnim = sprt_IceBeamChargeAnim;
		beamSound = snd_IceBeam_Shot;
		beamChargeSound = snd_IceBeam_ChargeShot;
		beamIconIndex = 1;
		if(beam[2])
		{
			// Ice Wave
			beamShot = obj_IceWaveBeamShot;
			beamCharge = obj_IceWaveBeamChargeShot;
			beamChargeAmt = 2;
			beamIconIndex = 3;
			if(beam[4])
			{
				// Ice Wave Plasma
				beamShot = obj_IceWavePlasmaBeamShot;
				beamCharge = obj_IceWavePlasmaBeamChargeShot;
				beamSound = snd_IceComboShot;
				beamIconIndex = 11;
			}
		}
		else if(beam[4])
		{
			// Ice Plasma
			beamShot = obj_IcePlasmaBeamShot;
			beamCharge = obj_IcePlasmaBeamChargeShot;
			beamSound = snd_IceComboShot;
			beamIconIndex = 9;
		}
	}
	else if(beam[2] || (noBeamsActive && itemHighlighted[0] == 2))
	{
		// Wave
		beamShot = obj_WaveBeamShot;
		beamCharge = obj_WaveBeamChargeShot;
		beamChargeAnim = sprt_WaveBeamChargeAnim;
		beamSound = snd_WaveBeam_Shot;
		beamChargeSound = snd_WaveBeam_ChargeShot;
		beamChargeAmt = 2;
		beamIconIndex = 2;
		if(beam[4])
		{
			// Wave Plasma
			beamShot = obj_WavePlasmaBeamShot;
			beamCharge = obj_WavePlasmaBeamChargeShot;
			beamChargeAnim = sprt_PlasmaBeamChargeAnim;
			beamSound = snd_PlasmaBeam_Shot;
			beamChargeSound = snd_PlasmaBeam_ChargeShot;
			beamIconIndex = 10;
		}
	}
	else if(beam[4] || (noBeamsActive && itemHighlighted[0] == 4))
	{
		// Plasma
		beamShot = obj_PlasmaBeamShot;
		beamCharge = obj_PlasmaBeamChargeShot;
		beamChargeAnim = sprt_PlasmaBeamChargeAnim;
		beamSound = snd_PlasmaBeam_Shot;
		beamChargeSound = snd_PlasmaBeam_ChargeShot;
		beamIconIndex = 8;
	}
	
	beamDmg = 20;
	if(beam[1] || (noBeamsActive && itemHighlighted[0] == 1))
	{
		// Ice
		beamDmg = 30;
		if(beam[2])
		{
			// Ice Wave
			beamDmg = 60;
			if(beam[4])
			{
				// Ice Wave Plasma
				beamDmg = 300;
			}
		}
		else if(beam[4])
		{
			// Ice Plasma
			beamDmg = 200;
		}
	}
	else if(beam[2] || (noBeamsActive && itemHighlighted[0] == 2))
	{
		// Wave
		beamDmg = 50;
		if(beam[4])
		{
			// Wave Plasma
			beamDmg = 250;
		}
	}
	else if(beam[4] || (noBeamsActive && itemHighlighted[0] == 4))
	{
		// Plasma
		beamDmg = 150;
	}
	if(beam[3] || (noBeamsActive && itemHighlighted[0] == 3))
	{
		// Spazer
		beamDmg *= (2/3);
	}
#endregion
	
	var shotIndex = beamShot,
		damage = beamDmg,
		sSpeed = shootSpeed,
		delay = beamDelay,
		amount = beamAmt,
		sound = beamSound;
	if(itemSelected == 1 && itemHighlighted[1] <= 1)
	{
		if(itemHighlighted[1] == 0 && missileStat > 0 && item[0])
		{
			//shotIndex = obj_MissileShot;
			damage = 50;
			delay = 9;
			amount = 1;
			sound = snd_Missile_Shot;
		}
		if(itemHighlighted[1] == 1 && superMissileStat > 0 && item[1])
		{
			//shotIndex = obj_SuperMissileShot;
			damage = 250;
			sSpeed = shootSpeed/3;
			delay = 19;
			amount = 1;
			sound = snd_SuperMissile_Shot;
		}
	}
	
// ----- Shoot -----
#region Shoot
	if(cShoot && dir != 0 && !xRayActive && state != State.Death)
	{
		if(state != State.Morph && stateFrame != State.Morph)
		{
			if(itemSelected == 1 && itemHighlighted[1] == 3 && item[3] && canShoot)
			{
				// grapple
			}
			else if(shotDelayTime <= 0)
			{
				if(canShoot && (itemSelected == 0 || ((itemHighlighted[1] != 0 || missileStat > 0) && (itemHighlighted[1] != 1 || superMissileStat > 0))))
				{
					if(rShoot || (beam[0] && !unchargeable))
					{
						gunReady = true;
						justShot = 90;
					}
					if(rShoot)
					{
						if(itemSelected == 1 && itemHighlighted[1] <= 1)
						{
							if(itemHighlighted[1] == 0 && missileStat > 0 && item[0])
							{
								missileStat--;
							}
							if(itemHighlighted[1] == 1 && superMissileStat > 0 && item[1])
							{
								superMissileStat--;
							}
						}
						scr_Shoot(shotIndex,damage,sSpeed,delay,amount,sound);
					}
				}
			}
		}
		else
		{
			
		}
		
		if(beam[0] && !unchargeable && (canShoot || statCharge >= 10) &&
		((state != State.Morph && stateFrame != State.Morph) || (statCharge >= 10 && (itemSelected == 0 || (global.HUD <= 0 && itemHighlighted[1] == 4)))))
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
				if(beam[0] && !unchargeable)
				{
					if(statCharge >= maxCharge)
					{
						chargeReleaseFlash = 4;
						scr_Shoot(beamCharge,damage*chargeMult,sSpeed,beamChargeDelay,beamChargeAmt,beamChargeSound);
					}
					else if(statCharge >= 20)
					{
						scr_Shoot(shotIndex,damage,sSpeed,delay,amount,sound);
					}
				}
			}
			else
			{
				
			}
			statCharge = 0;
		}
		if(state == State.Spark || state == State.BallSpark || dir == 0)
		{
			statCharge = 0;
		}
	}
#endregion
	
	if(aimAngle != 0 || velX == 0 || notGrounded || abs(dirFrame) < 4 || state == State.Morph)
	{
		justShot = 0;
	}
	shotDelayTime = max(shotDelayTime - 1, 0);
	justShot = max(justShot - 1, 0);
	
	/*if(!instance_exists(obj_PowerBomb && !instance_exists(obj_PowerBombExplosion))
	{
		bombDelayTime = max(bombDelayTime - 1, 0);
	}*/
	
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
	
	oldDir = dir;
	
	prevAimAngle = aimAngle;
	
	StepSplash = max(StepSplash-1,0);
	outOfLiquid = (liquidState <= 0);
	shineRestarted = false;
	
	immuneTime = max(immuneTime - 1, 0);
	
// ----- Environmental Damage -----
#region Environmental Damage
	if(instance_exists(obj_Heat) && !suit[0])
	{
		//scr_ConstantDamageSamus(1, 4 + (2 * suit[1]));
	}
	
	
#endregion
}