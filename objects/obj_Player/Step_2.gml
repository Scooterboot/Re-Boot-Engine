/// @description Update Anims, Shoot, & Environmental Dmg

Set_Beams();

var sndFlag = false;

if(global.pauseState == PauseState.None || (VisorSelected(Visor.XRay) && global.pauseState == PauseState.XRay) || global.pauseState == PauseState.RoomTrans)
{
	#region Update Anims
	
	var roomTrans = (global.pauseState == PauseState.RoomTrans);
	
	drawMissileArm = false;
	shootFrame = (gunReady || justShot > 0 || instance_exists(grapple) || (cFire && (rFire || CanCharge())));
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
	if(VisorSelected(Visor.XRay))
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
	
	if((dir == 0 || lastDir == 0) && dirFrameF == 0 && stateFrame == State.Stand)
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
	else if(abs(dirFrameF) < 4 && stateFrame != State.Somersault && stateFrame != State.Morph && stateFrame != State.Grip && (stateFrame != State.Spark || shineRestart) && stateFrame != State.Grapple && stateFrame != State.Dodge)
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
		
		if(stateFrame == State.Spark)
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
				ArmPos(turnArmPosX[3,dirFrameF+3], turnArmPosY[3]);
			}
			else if(aimFrame < 0 && aimFrame > -3)
			{
				torsoR = sprt_Player_TurnAimDown;
				ArmPos(turnArmPosX[1,dirFrameF+3], turnArmPosY[1]);
			}
			else if(aimFrame >= 3)
			{
				torsoR = sprt_Player_TurnAimUpV;
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
				torsoR = sprt_Player_TurnAimDownV;
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
				torsoR = sprt_Player_Turn;
				ArmPos(turnArmPosX[2,dirFrameF+3], turnArmPosY[2,dirFrameF+3]);
			}
			legs = sprt_Player_TurnLeg;
			if(stateFrame == State.Crouch || stateFrame == State.Jump || !grounded)
			{
				legs = sprt_Player_TurnCrouchLeg;
			}
			if(stateFrame == State.Stand && crouchFrame < 5)
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
		SetArmPosStand();
		
		switch stateFrame
		{
			#region Stand
			case State.Stand:
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
				if(VisorSelected(Visor.Scan) || VisorSelected(Visor.XRay) || aimFrame != 0 || landFrame > 0 || recoilCounter > 0 || runToStandFrame[0] > 0 || runToStandFrame[1] > 0 || walkToStandFrame > 0)
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
							SetArmPosTrans();
						}
						if((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) ||
							(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
						{
							torsoR = sprt_Player_JumpAimRight;
							torsoL = sprt_Player_JumpAimLeft;
							SetArmPosJump();
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
							ArmPos((19+(2*bodyFrame))*dir,-(1+bodyFrame));
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
							ArmPos((18+(3*bodyFrame))*dir,-(1+bodyFrame));
						}
						else if(VisorSelected(Visor.Scan))
						{
							torsoR = sprt_Player_XRayRight;
							torsoL = sprt_Player_XRayLeft;
							var sdir = point_direction(x,y, scanVisor.GetRoomX(),scanVisor.GetRoomY());
							var xcone = abs(scr_wrap(sdir-90, -180, 180));
							bodyFrame = 4-scr_round(xcone/45);
						}
						else if(VisorSelected(Visor.XRay))
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
				
				SetArmPosJump();
				
				runYOffset = -mOffset[frame[Frame.Walk]];
				
				if(aimFrame != 0)
				{
					torsoR = sprt_Player_JumpAimRight;
					torsoL = sprt_Player_JumpAimLeft;
					if(transFrame < 2)
					{
						torsoR = sprt_Player_TransAimRight;
						torsoL = sprt_Player_TransAimLeft;
						SetArmPosTrans();
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
						ArmPos(18*dir,-1);
					}
					else if(bodyFrame == 1)
					{
						ArmPos(21*dir,-2);
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
				
				torsoR = sprt_Player_BrakeRight;
				torsoL = sprt_Player_BrakeLeft;
				legs = sprt_Player_BrakeLeg;
				
				bodyFrame = 4 - floor(frame[Frame.Moon]);
				legFrame = bodyFrame;
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
				SetArmPosJump();
				if((aimFrame != 0 && aimFrame != 2 && aimFrame != -2) || (frame[Frame.Run] < 2 && aimFrame != 0))
				{
					if(frame[Frame.Run] < 2)
					{
						torsoR = sprt_Player_TransAimRight;
						torsoL = sprt_Player_TransAimLeft;
						SetArmPosTrans();
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
						ArmPos(19*dir,-21);
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
			case State.Brake:
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
				ArmPos(armPos[0], armPos[1]);
				
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
					part_particles_create(obj_Particles.partSystemB,x-(8+random(4))*dir,bb_bottom()+random(4),obj_Particles.bDust[1],1);
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
				if(aimFrame != 0 || crouchFrame > 0 || recoilCounter > 0 || VisorSelected(Visor.Scan) || VisorSelected(Visor.XRay))
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
							if(VisorSelected(Visor.Scan))
							{
								torsoR = sprt_Player_XRayRight;
								torsoL = sprt_Player_XRayLeft;
								var sdir = point_direction(x,y, scanVisor.GetRoomX(),scanVisor.GetRoomY());
								var xcone = abs(scr_wrap(sdir-90, -180, 180));
								bodyFrame = 4-scr_round(xcone/45);
							}
							else if(VisorSelected(Visor.XRay))
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
								SetArmPosTrans();
							}
							if ((aimAngle == 2 && (lastAimAngle == 0 || (lastAimAngle == -1 && aimFrame >= 0))) ||
								(lastAimAngle == 2 && (aimAngle == 0 || (aimAngle == -1 && aimFrame >= 0))) || 
								(lastAimAngle == -2 && aimAngle != -1 && (aimAngle != 1 || aimFrame <= 0)))
							{
								torsoR = sprt_Player_JumpAimRight;
								torsoL = sprt_Player_JumpAimLeft;
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
				ArmPos(0,0);
				
				var ballAnimDir = dir;
				if(sign(velX) != 0)
				{
					ballAnimDir = sign(velX);
				}
				if(SpiderActive())
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
							SetArmPosTrans();
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
				fDir = grippedDir;
				if(climbIndex <= 0)
				{
					var usingVisor = (VisorSelected(Visor.Scan) || VisorSelected(Visor.XRay));
					var visorFrame = 2;
					if(VisorSelected(Visor.Scan))
					{
						var sdir = point_direction(x,y, scanVisor.GetRoomX(),scanVisor.GetRoomY());
						var xcone = abs(scr_wrap(sdir-90, -180, 180));
						visorFrame = 4-scr_round(xcone/45);
					}
					if(VisorSelected(Visor.XRay))
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
						ArmPos(-4*fDir, 11);
						if(bodyFrame > 0)
						{
							ArmPos(-5*fDir, 11);
						}
						
						if(!usingVisor)
						{
							if(aimFrame > 0 && aimFrame < 3)
							{
								torsoR = sprt_Player_GripTurnRight_AimUp;
								torsoL = sprt_Player_GripTurnLeft_AimUp;
								ArmPos(-4*fDir,-21);
								if(bodyFrame > 0)
								{
									ArmPos(-19*fDir,-21);
								}
							}
							else if(aimFrame < 0 && aimFrame > -3)
							{
								torsoR = sprt_Player_GripTurnRight_AimDown;
								torsoL = sprt_Player_GripTurnLeft_AimDown;
								ArmPos(-4*fDir,8);
								if(bodyFrame > 0)
								{
									ArmPos(-15*fDir,9);
								}
							}
							else if(aimFrame >= 3)
							{
								torsoR = sprt_Player_GripTurnRight_AimUpV;
								torsoL = sprt_Player_GripTurnLeft_AimUpV;
								ArmPos(-4*fDir,-30);
								if(bodyFrame > 0)
								{
									ArmPos(-7*fDir,-30);
								}
							}
							else if(aimFrame <= -3)
							{
								torsoR = sprt_Player_GripTurnRight_AimDownV;
								torsoL = sprt_Player_GripTurnLeft_AimDownV;
								ArmPos(-8*fDir,16);
								if(bodyFrame > 0)
								{
									ArmPos(-10*fDir,17);
								}
							}
							else
							{
								torsoR = sprt_Player_GripTurnRight;
								torsoL = sprt_Player_GripTurnLeft;
								ArmPos(0,-1);
								if(bodyFrame > 0)
								{
									ArmPos(-24*fDir,-3);
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
						ArmPos(-1*fDir, 9);
						finalArmFrame = 2;
						if(bodyFrame > 0)
						{
							ArmPos(2*fDir, 3);
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
							
							SetArmPosGrip();
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
					if(SparkDir_VertUp())
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
						
						SetArmPosSpark(0);
					}
					else if(SparkDir_VertDown())
					{
						if(abs(shineDownRot) < 180)
						{
							shineDownRot = clamp(shineDownRot - 45*dir, -180, 180);

							torsoR = sprt_Player_SomersaultRight;
							torsoL = sprt_Player_SomersaultLeft;
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
							
							SetArmPosSpark(shineDownRot);
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
	                ArmPos(-15*dir,-22);
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
					
					SetArmPosJump();
					var armR = point_direction(0,0,armOffsetX,armOffsetY),
						armL = point_distance(0,0,armOffsetX,armOffsetY);
					
					ArmPos(lengthdir_x(armL,armR+rotation),lengthdir_y(armL,armR+rotation));
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

	                ArmPos(lengthdir_x(31, rotation + 90),lengthdir_y(31, rotation + 90));
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
			case State.Hurt:
			{
				for(var i = 0; i < array_length(frame); i++)
				{
					frame[i] = 0;
					frameCounter[i] = 0;
				}
				frame[Frame.JAim] = 6;
				
				torsoR = sprt_Player_HurtRight;
				torsoL = sprt_Player_HurtLeft;
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
					
					SetArmPosSomersault(18, 40, bodyFrame);
					
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
								SetArmPosTrans();
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
		if(wjFrame <= 0 || stateFrame != State.Somersault)
		{
			wjGripAnim = false;
		}
		wjAnimDelay = max(wjAnimDelay - 1, 0);
		spaceJump = max(spaceJump - 1, 0);
		morphFrame = max(morphFrame - animSpeed, 0);
		
		if(stateFrame == State.Brake)
		{
			runToStandFrame[0] = 0;
			runToStandFrame[1] = 0;
			walkToStandFrame = 0;
		}
		else if(stateFrame == State.Stand)
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
			if(stateFrame == State.Crouch || stateFrame == State.Grip)
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
		if(stateFrame == State.Morph)
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
	
	
	if(global.pauseState == PauseState.None)
	{
		var canShoot = (!startClimb && !moonFallState && !isPushing && state != State.Somersault && state != State.Spark && state != State.BallSpark && 
						state != State.Hurt && (stateFrame != State.DmgBoost || dBoostFrame >= 19) && state != State.Dodge && state != State.Death);
		if(!canShoot)
		{
			enqueShot = false;
		}
	
		shootPosX = x+sprtOffsetX+shotOffsetX;
		shootPosY = y+sprtOffsetY+runYOffset+shotOffsetY;
	
		var shotIndex = beamShot,
			damage = beamDmg / beamAmt,
			sSpeed = shootSpeed,
			delay = beamDelay,
			amount = beamAmt,
			sound = beamSound,
			autoFire = 1;
		if(WeaponSelected(Weapon.Missile))
		{
			shotIndex = obj_MissileShot;
			damage = 100;
			sSpeed = shootSpeed/2;
			delay = 9;
			amount = 1;
			sound = snd_Missile_Shot;
			autoFire = 0;
		}
		else if(WeaponSelected(Weapon.SuperMissile))
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
			damage = 450;
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
			if(state != State.Morph && stateFrame != State.Morph)
			{
				if(WeaponSelected(Weapon.GrappleBeam) && canShoot)
				{
					delay = 14;
					
					if(!instance_exists(grapple))
					{
						if(shotDelayTime <= 0)
						{
							if(rFire || enqueShot)
							{
								grapple = Shoot(obj_GrappleBeamShot,20,0,0,1,snd_GrappleBeam_Shoot);
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
					
					if(canShoot && (weapIndex <= -1 || WeaponHasAmmo(weapIndex)))
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
								if(WeaponSelected(Weapon.Missile))
								{
									missileStat--;
								}
								if(WeaponSelected(Weapon.SuperMissile))
								{
									superMissileStat--;
								}
									
								if(!rFire && !enqueShot && autoFire == 1)
								{
									delay *= 2;
								}
								Shoot(shotIndex,damage,sSpeed,delay,amount,sound,beamIsWave,beamWaveStyleOffset);
								if(hyperBeam && shotIndex == obj_HyperBeamShot)
								{
									if(item[Item.Spazer])
									{
										Shoot(obj_HyperBeamLesserShot,damage,sSpeed,delay,2+2*beamIsWave,noone,beamIsWave,1);
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
						if(SpiderActive())
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
							
						if(WeaponSelected(Weapon.PowerBomb) || (item[Item.PowerBomb] && weapIndex >= 0 && weapSelected && powerBombStat > 0))
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
				
			if(item[Item.ChargeBeam] && CanCharge() && !enqueShot && !isPushing && cflag)
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
		
			if(canShoot && CanCharge() && dir != 0)
			{
				if(state != State.Morph && stateFrame != State.Morph)
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
						Shoot(beamCharge,damage,sSpeed,beamChargeDelay,beamChargeAmt,beamChargeSound,beamIsWave,beamWaveStyleOffset);
							
						chargeReleaseFlash = 4;
						recoil = true;
					}
					else if(statCharge >= 20)
					{
						Shoot(shotIndex,damage,sSpeed,delay,amount,sound,beamIsWave,beamWaveStyleOffset);
						recoil = true;
					}
				}
				else if(item[Item.MBBomb] && !WeaponSelected(Weapon.PowerBomb))
				{
					var bombPosX = x,
						bombPosY = y+3;
					if(SpiderActive())
					{
						bombPosX = x + lengthdir_x(-2,spiderJumpDir);
						bombPosY = y+1 + lengthdir_y(-2,spiderJumpDir);
					}
						
					if(statCharge >= 20)
					{
						var bChargeScale = min(statCharge / (maxCharge*1.5), 1);
							
						if(!grounded && !SpiderActive() && cPlayerDown)
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
						else if(SpiderActive())
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
		
		if(IsChargeSomersaulting() && !IsSpeedBoosting() && !IsScrewAttacking())
		{
			var psDmg = beamDmg*chargeMult * 2;
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
		
		if(IsSpeedBoosting())
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
		
		if(IsScrewAttacking())
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
		
		self.IncrInvFrames();
		
		// ----- Environmental Damage -----
		#region Environmental Damage
		
		var palFlag = false;
		
		if(global.rmHeated && !item[Item.VariaSuit])
		{
			ConstantDamage(1, 4 + (2 * item[Item.GravitySuit]));
			
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
		    ConstantDamage(1, 2 + (2 * (item[Item.VariaSuit])));
			
		    palFlag = true;
		    sndFlag2 = true;
			if(!liquidTop)
			{
				sndFlag3 = true;
			}
		}
		if(liquid && liquid.liquidType == LiquidType.Acid)
		{
			ConstantDamage(3, 2 + (2 * (item[Item.VariaSuit] + item[Item.GravitySuit])));
			
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
		
		if(stateFrame == State.Grip)
		{
			if(aimAngle != 0 || dir != grippedDir)
			{
				justShot = 0;
			}
		}
		else
		{
			if(aimAngle != 0 || (velX == 0 && stateFrame != State.Brake) || !grounded || abs(dirFrame) < 4 || state == State.Morph)
			{
				justShot = 0;
			}
		}
		if(stateFrame != State.Brake)
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
		
		stallCamera = false;
		
		movedVelX = 0;
		movedVelY = 0;
		
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
	audio_stop_sound(heatDmgSnd);
    audio_stop_sound(snd_LavaDamageLoop);
	audio_stop_sound(snd_LiquidTopDmgLoop);
}