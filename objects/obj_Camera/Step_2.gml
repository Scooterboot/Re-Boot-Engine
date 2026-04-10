/// @description Camera movement

if((global.pauseState == PauseState.None || global.pauseState == PauseState.RoomTrans || global.pauseState == PauseState.XRay) && instance_exists(obj_Player))
{
	var player = obj_Player;
	var xx = x + (camWidth()/2),
		yy = y + (camHeight()/2);
	
	var xsp = player.x - player.xprevious,
		ysp = player.y - player.yprevious;
	if(stallX)
	{
		xsp = 0;
		stallX = false;
	}
	if(stallY)
	{
		ysp = 0;
		stallY = false;
	}
	
	var fxsp = xsp,
		fysp = ysp;
	
	var pX = player.x,
		pY = player.y;
	
	var num = 1 + scr_floor(abs(pX-playerX) / 7);
	if(playerX < pX)
	{
		fxsp = min(xsp+num,pX-playerX);
	}
	if(playerX > pX)
	{
		fxsp = max(xsp-num,pX-playerX);
	}
	
	num = 1 + scr_floor(abs(pY-playerY) / 7);
	if(playerY < pY)
	{
		fysp = min(ysp+num,pY-playerY);
	}
	if(playerY > pY)
	{
		fysp = max(ysp-num,pY-playerY);
	}
	
	playerX += fxsp;
	playerY += fysp;
	
	if(global.pauseState == PauseState.RoomTrans)
	{
		playerX = pX;
		playerY = pY;
	}
	
	playerXRayX = pX;
	playerXRayY = pY;
	targetX = playerX;
	targetY = playerY;
	velX = 0;
	velY = 0;
	camKey = player.cMoonwalk; // TODO: redo some logic involving this
	
	var angle = player.aimAngle,
		speedX = player.fVelX,
		speedY = player.fVelY;
	
	if(player.isPushing)
	{
		speedX = player.x - player.xprevious;
	}
	if(player.state == State.Hurt)
	{
		speedX = 0;
		speedY = 0;
	}
	if(player.state == State.Grapple || (player.state == State.Morph && player.SpiderActive()))
	{
		speedX = xsp;
		speedY = ysp;
	}
	
	var playerMoveX = playerX - prevPlayerX,
		playerMoveY = playerY - prevPlayerY;
	if(xsp == 0)
	{
		playerMoveX = 0;
	}
	if(ysp == 0)
	{
		playerMoveY = 0;
	}
	
	xDir = player.dir;
	yDir = sign(scr_round(speedY));
	if(camKey)
	{
		yDir = sign(angle) * -1;
	}
	
	targetX = playerX + scr_round(camLimit[CamLimit.Right]);
	if(xDir <= -1)
	{
		targetX = playerX - scr_round(camLimit[CamLimit.Left]);
	}
	if(player.state == State.Somersault && !camKey)
	{
		targetX = playerX;
	}
	targetY = playerY + scr_round(camLimit[CamLimit.Bottom]);
	if(yDir <= -1)
	{
		targetY = playerY - scr_round(camLimit[CamLimit.Top]);
	}
	
	for(var i = 0; i < 4; i++)
	{
		camLimitMax[i] = camLimitDef[i];
	}
	
	if(!player.GrappleActive())
	{
		var _spX = abs(player.velX),
			_spXMin = max(player.maxSpeed[MaxSpeed.Sprint,0], player.maxSpeed[MaxSpeed.MockBall,0]),
			_spXMax = player.maxSpeed[MaxSpeed.SpeedBoost,0];
		_spX = max(_spX - _spXMin, 0);
		_spXMax = max(_spXMax - _spXMin, 1);
		var _spXNum = clamp((_spX / _spXMax)*2, 0, 1);
		
		if(abs(player.velX) > _spXMin && _spXNum > 0)
		{
			var _lNumX = lerp(0, camLimit_ExtraX, _spXNum);
			camLimitMax[CamLimit.Left] += _lNumX;
			camLimitMax[CamLimit.Right] += _lNumX;
		}
		
		var _spY = abs(player.velY),
			_spYMin = max(player.jumpSpeed[1,0], player.fallSpeedMax),
			_spYMax = player.maxSpeed[MaxSpeed.SpeedBoost,0];
		_spY = max(_spY - _spYMin, 0);
		_spYMax = max(_spYMax - _spYMin, 1);
		var _spYNum = clamp(_spY / _spYMax, 0, 1);
		
		if(abs(player.velY) > _spYMin && _spYNum > 0)
		{
			var _lNumY = lerp(0, camLimit_ExtraY, _spYNum);
			camLimitMax[CamLimit.Top] += _lNumY;
			camLimitMax[CamLimit.Bottom] += _lNumY;
		}
	}
	
	var bossNum = instance_number(obj_NPC_Boss);
	if(bossNum > 0)
	{
		for(var i = 0; i < bossNum; i++)
		{
			var boss = instance_find(obj_NPC_Boss,i);
			if(instance_exists(boss) && !boss.dead && boss.boss)// && scr_WithinCamRange(boss.camPosX,boss.camPosX))
			{
				boss.CameraLogic();
				
				break;
			}
		}
	}
	
	if(player.GrappleActive() || (player.state == State.Morph && player.SpiderActive()))
	{
		xDir = 0;
		yDir = 0;
		targetX = playerX;
		targetY = playerY;
		if(player.state == State.Morph && player.SpiderActive() && !player.GrappleActive())
		{
			cLimDecrVelX = min(cLimDecrVelX, 0.5);
			cLimDecrVelY = min(cLimDecrVelY, 0.5);
		}
		
		for(var i = 0; i < 4; i++)
		{
			camLimitMax[i] = 0;
		}
	}
	if(player.VisorSelected(Visor.Scan) || player.VisorSelected(Visor.XRay))
	{
		camLimitMax[CamLimit.Left] = camLimitDef[CamLimit.Left] + camLimit_ExtraX;
		camLimitMax[CamLimit.Right] = camLimitDef[CamLimit.Right] + camLimit_ExtraX;
		camLimitMax[CamLimit.Top] = camLimitDef[CamLimit.Top] + camLimit_ExtraY;
		camLimitMax[CamLimit.Bottom] = camLimitDef[CamLimit.Bottom] + camLimit_ExtraY;
		
		cLimIncrVelX = 2;
		cLimIncrVelY = 2;
	}
	
	if(player.state == State.Elevator)
	{
		xDir = 0;
		yDir = 0;
		targetX = playerX;
		targetY = playerY;
		for(var i = 0; i < 4; i++)
		{
			camLimitMax[i] = 0;
		}
	}
	
	camLimit[CamLimit.Left] =	CamLimitIncr(camLimit[CamLimit.Left],	camLimitMax[CamLimit.Left],		max(cLimIncrVelX,0), max(cLimDecrVelX,0), -(xx-prevPlayerX));
	camLimit[CamLimit.Right] =	CamLimitIncr(camLimit[CamLimit.Right],	camLimitMax[CamLimit.Right],	max(cLimIncrVelX,0), max(cLimDecrVelX,0), xx-prevPlayerX);
	camLimit[CamLimit.Top] =	CamLimitIncr(camLimit[CamLimit.Top],	camLimitMax[CamLimit.Top],		max(cLimIncrVelY,0), max(cLimDecrVelY,0), -(yy-prevPlayerY));
	camLimit[CamLimit.Bottom] =	CamLimitIncr(camLimit[CamLimit.Bottom],	camLimitMax[CamLimit.Bottom],	max(cLimIncrVelY,0), max(cLimDecrVelY,0), yy-prevPlayerY);
	
	if (camLimit[CamLimit.Left] == camLimitMax[CamLimit.Left] && 
		camLimit[CamLimit.Right] == camLimitMax[CamLimit.Right])
	{
		cLimIncrVelX = 0;
		cLimDecrVelX = -0.1875;
	}
	else
	{
		cLimIncrVelX = min(cLimIncrVelX + cLimIncrSpd, 1);
		cLimDecrVelX = min(cLimDecrVelX + cLimDecrSpd, 1);
	}
	if (camLimit[CamLimit.Top] == camLimitMax[CamLimit.Top] && 
		camLimit[CamLimit.Bottom] == camLimitMax[CamLimit.Bottom])
	{
		cLimIncrVelY = 0;
		cLimDecrVelY = -0.1875;
	}
	else
	{
		cLimIncrVelY = min(cLimIncrVelY + cLimIncrSpd, 1);
		cLimDecrVelY = min(cLimDecrVelY + cLimDecrSpd, 1);
	}
	
	if(player.VisorSelected(Visor.Scan) || player.VisorSelected(Visor.XRay))
	{
		var clm_L = scr_round(camLimitMax[CamLimit.Left]),
			clm_R = scr_round(camLimitMax[CamLimit.Right]),
			clm_T = scr_round(camLimitMax[CamLimit.Top]),
			clm_B = scr_round(camLimitMax[CamLimit.Bottom]);
		if(player.VisorSelected(Visor.Scan))
		{
			var xdif = scr_round((player.scanVisor.GetRoomX() - prevPlayerX)*0.5),
				ydif = scr_round((player.scanVisor.GetRoomY() - prevPlayerY)*0.5);
			targetX = prevPlayerX + clamp(xdif, -clm_L, clm_R);
			targetY = prevPlayerY + clamp(ydif, -clm_T, clm_B);
		}
		if(player.VisorSelected(Visor.XRay))
		{
			var _lx = lengthdir_x(1,player.xrayVisor.coneDir),
				_ly = lengthdir_y(1,player.xrayVisor.coneDir);
			targetX = prevPlayerX + scr_round(_lx * (_lx < 0 ? clm_L : clm_R));
			targetY = prevPlayerY + scr_round(_ly * (_ly < 0 ? clm_T : clm_B));
		}
		
		var num2 = 2 + scr_floor(abs(targetX-xx) / 7);
		if(targetX > xx)
		{
			velX = min(num2,targetX-xx);
		}
		if(targetX < xx)
		{
			velX = max(-num2,targetX-xx);
		}
		velX += playerMoveX;
		
		num2 = 2 + scr_floor(abs(targetY-yy) / 7);
		if(targetY > yy)
		{
			velY = min(num2,targetY-yy);
		}
		if(targetY < yy)
		{
			velY = max(-num2,targetY-yy);
		}
		velY += playerMoveY;
	}
	else
	{
		var speedMult = 2,
			speedMax = 3,
			distX = abs(targetX - xx),
			distY = abs(targetY - yy),
			pointDistX = distX/16,
			pointDistY = distY/16;
		
		camSpeedX = playerMoveX + max(abs(speedX*pointDistX)/4,1) * sign(speedX);
		if(playerMoveX == 0 || camKey)
		{
			camSpeedX = playerMoveX + max(speedMult*pointDistX,1)*xDir;
		}
		
		camSpeedX = clamp(camSpeedX,playerMoveX-speedMax,playerMoveX+speedMax);
		if(playerMoveX != 0 || camKey || xDir == 0)
		{
			velX = camSpeedX;
		}
		
		camSpeedY = playerMoveY + max(abs(speedY*pointDistY)/4,1) * yDir;
		if(scr_round(playerMoveY) == 0)
		{
			camSpeedY = max(speedMult*pointDistY,1) * yDir;
		}
		camSpeedY = clamp(camSpeedY,playerMoveY-speedMax,playerMoveY+speedMax);
		if(angle != 0 && camKey)
		{
			if(sign(scr_round(playerMoveY)) != yDir && scr_round(playerMoveY) != 0)
			{
				velY = playerMoveY + speedMult*yDir;
			}
			else if(scr_round(playerMoveY) != 0)
			{
				velY = abs(camSpeedY+(yDir*speedMult)) * yDir;
			}
			else
			{
				velY = abs(camSpeedY) * yDir;
			}
		}
		else if(scr_round(playerMoveY) != 0)
		{
			velY = camSpeedY;
		}
	}
	
	#region Collision
	
		var camSnap = false;
		if(global.pauseState == PauseState.RoomTrans || obj_Player.introAnimState == 0)
		{
			camSnap = true;
		}
	
		fVelX = velX;
		fVelY = velY;
		
		#region X Collision
		
			var _leftEdge = playerX - scr_round(camLimit[CamLimit.Left]),
				_rightEdge = playerX + scr_round(camLimit[CamLimit.Right]);
			if((xx+fVelX) < _leftEdge)
			{
				fVelX = min(_leftEdge - xx, 1 + max((playerX-prevPlayerX) + sign(velX),0));
				if(global.pauseState == PauseState.RoomTrans)
				{
					fVelX = _leftEdge - xx;
				}
			}
			if((xx+fVelX) > _rightEdge)
			{
				fVelX = max(_rightEdge - xx, -1 + min((playerX-prevPlayerX) + sign(velX),0));
				if(global.pauseState == PauseState.RoomTrans)
				{
					fVelX = _rightEdge - xx;
				}
			}
			
			var _num = camera_collide(0,0,colList);
			if(_num > 0)
			{
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					var wDiff = 0;
					var resWidth = camWidth();
					if(col.object_index == obj_CamTile_NonWScreen || object_is_ancestor(col.object_index,obj_CamTile_NonWScreen))
					{
						wDiff = abs(camWidth() - camWidth_NonWide())/2;
						resWidth = camWidth_NonWide();
					}
					if(instance_exists(col) && col.active && col.facing == CamTileFacing.Right)
					{
						fVelX = min(col.x+16 - x+wDiff, max(playerX-prevPlayerX, 1));
						if(camSnap)
						{
							fVelX = col.x+16 - x+wDiff;
						}
						break;
					}
					else if(instance_exists(col) && col.active && col.facing == CamTileFacing.Left)
					{
						fVelX = max(col.x-16 - (x+wDiff+resWidth), min(playerX-prevPlayerX, -1));
						if(camSnap)
						{
							fVelX = col.x-16 - (x+wDiff+resWidth);
						}
						break;
					}
				}
				ds_list_clear(colList);
			}
	
			_num = camera_collide(max(abs(fVelX),1)*sign(fVelX),0,colList);
			if(_num > 0)
			{
				for(var i = 0; i < _num; i++)
				{
					var colX = colList[| i];
					if(instance_exists(colX))
					{
						var wDiff = 0;
						var resWidth = camWidth();
						if(colX.object_index == obj_CamTile_NonWScreen || object_is_ancestor(colX.object_index,obj_CamTile_NonWScreen))
						{
							wDiff = abs(camWidth() - camWidth_NonWide())/2;
							resWidth = camWidth_NonWide();
						}
						if ((fVelX < 0 && colX.active && colX.facing == CamTileFacing.Right) ||
							(fVelX > 0 && colX.active && colX.facing == CamTileFacing.Left))
						{
							if(fVelX > 0)
							{
								x = scr_floor(x);
							}
							if(fVelX < 0)
							{
								x = scr_ceil(x);
							}
							var xnum = abs(fVelX)+2;
							while(!collision_rectangle(x+wDiff+sign(fVelX),y,x+wDiff+sign(fVelX)+resWidth,y+camHeight(),colX,false,true) && xnum > 0)
							{
								x += sign(fVelX);
								xnum--;
							}
							fVelX = 0;
						}
					}
				}
				ds_list_clear(colList);
			}
			
			_num = camera_collide(0,0,colList,1);
			if(_num > 0)
			{
				var colX = x+camWidth();
				var colR = noone;
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					if(instance_exists(col) && col.active && col.facing == CamTileFacing.Left)
					{
						if(colR == noone || col.x < colX)
						{
							colR = col;
							colX = col.x;
						}
					}
				}
				colX = x;
				var colL = noone;
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					if(instance_exists(col) && col.active && col.facing == CamTileFacing.Right)
					{
						if(colL == noone || col.x > colX)
						{
							colL = col;
							colX = col.x;
						}
					}
				}
				
				if(instance_exists(colR) && instance_exists(colL))
				{
					var lX = colL.x+16,
						rX = colR.x-16,
						midX = lX + (rX-lX)/2,
						cenX = x+(camWidth()/2);
					
					fVelX = clamp(midX - cenX, min(playerX-prevPlayerX, -1), max(playerX-prevPlayerX, 1));
					if(camSnap)
					{
						fVelX = midX - cenX;
					}
				}
				
				ds_list_clear(colList);
			}
	
			if(x >= 0 && x <= room_width-camWidth())
			{
				x += clamp(fVelX, -x, room_width-camWidth()-x);
			}
			else
			{
				if(x < 0)
				{
					fVelX = max(5+abs(playerX-prevPlayerX) + velX,5);
				}
				if(x > room_width-camWidth())
				{
					fVelX = min(-(5+abs(playerX-prevPlayerX)) + velX,-5);
				}
				x += fVelX;
			}
		
		#endregion
		
		#region Y Collision
		
			var _topEdge = playerY - scr_round(camLimit[CamLimit.Top]),
				_bottomEdge = playerY + scr_round(camLimit[CamLimit.Bottom]);
			if((yy+fVelY) < _topEdge)
			{
				fVelY = min(_topEdge - yy, 1 + max((playerY-prevPlayerY) + sign(velY),0));
				if(global.pauseState == PauseState.RoomTrans)
				{
					fVelY = _topEdge - yy;
				}
			}
			if((yy+fVelY) > _bottomEdge)
			{
				fVelY = max(_bottomEdge - yy, -1 + min((playerY-prevPlayerY) + sign(velY),0));
				if(global.pauseState == PauseState.RoomTrans)
				{
					fVelY = _bottomEdge - yy;
				}
			}
			
			_num = camera_collide(0,0,colList);
			if(_num > 0)
			{
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					if(instance_exists(col) && col.active && col.facing == CamTileFacing.Down)
					{
						fVelY = min(col.y+16 - y, max(playerY-prevPlayerY, 1));
						if(camSnap)
						{
							fVelY = col.y+16 - y;
						}
						break;
					}
					else if(instance_exists(col) && col.active && col.facing == CamTileFacing.Up)
					{
						fVelY = max(col.y-16 - (y+camHeight()), min(playerY-prevPlayerY, -1));
						if(camSnap)
						{
							fVelY = col.y-16 - (y+camHeight());
						}
						break;
					}
				}
				ds_list_clear(colList);
			}
	
			_num = camera_collide(0,max(abs(fVelY),1)*sign(fVelY),colList);
			if(_num > 0)
			{
				for(var i = 0; i < _num; i++)
				{
					var colY = colList[| i];
					if(instance_exists(colY))
					{
						var wDiff = 0;
						var resWidth = camWidth();
						if(colY.object_index == obj_CamTile_NonWScreen || object_is_ancestor(colY.object_index,obj_CamTile_NonWScreen))
						{
							wDiff = abs(camWidth() - camWidth_NonWide())/2;
							resWidth = camWidth_NonWide();
						}
						if ((fVelY < 0 && colY.active && colY.facing == CamTileFacing.Down) ||
							(fVelY > 0 && colY.active && colY.facing == CamTileFacing.Up))
						{
							if(fVelY > 0)
							{
								y = scr_floor(y);
							}
							if(fVelY < 0)
							{
								y = scr_ceil(y);
							}
							var ynum = abs(fVelY)+2;
							while(!collision_rectangle(x+wDiff,y+sign(fVelY),x+wDiff+resWidth,y+sign(fVelY)+camHeight(),colY,false,true) && ynum > 0)
							{
								y += sign(fVelY);
								ynum--;
							}
							fVelY = 0;
						}
					}
				}
				ds_list_clear(colList);
			}
			
			_num = camera_collide(0,0,colList,,1);
			if(_num > 0)
			{
				var colY = y+camHeight();
				var colB = noone;
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					if(instance_exists(col) && col.active && col.facing == CamTileFacing.Up)
					{
						if(colB == noone || col.y < colY)
						{
							colB = col;
							colY = col.y;
						}
					}
				}
				colY = y;
				var colT = noone;
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					if(instance_exists(col) && col.active && col.facing == CamTileFacing.Down)
					{
						if(colT == noone || col.y > colY)
						{
							colT = col;
							colY = col.y;
						}
					}
				}
				
				if(instance_exists(colB) && instance_exists(colT))
				{
					var tY = colT.y+16,
						bY = colB.y-16,
						midY = tY + (bY-tY)/2,
						cenY = y+(camHeight()/2);
					
					fVelY = clamp(midY - cenY, min(playerY-prevPlayerY, -1), max(playerY-prevPlayerY, 1));
					if(camSnap)
					{
						fVelY = midY - cenY;
					}
				}
				
				ds_list_clear(colList);
			}
	
			if(y >= 0 && y <= room_height-camHeight())
			{
				y += clamp(fVelY, -y, room_height-camHeight()-y);
			}
			else
			{
				if(y < 0)
				{
					fVelY = 1+abs(playerY-prevPlayerY);
				}
				if(y > room_height-camHeight())
				{
					fVelY = -(1+abs(playerY-prevPlayerY));
				}
				y += fVelY;
			}
		
		#endregion
	
	#endregion
	
	prevPlayerX = playerX;
	prevPlayerY = playerY;
}

if(clampCam)
{
	x = clamp(x,0,room_width-camWidth());
	y = clamp(y,0,room_height-camHeight());
	clampCam = false;
}
if(room_width < camWidth())
{
	x = (room_width-camWidth())/2;
}
if(room_height < camHeight())
{
	y = (room_height-camHeight())/2;
}

var shakeX = 0,
	shakeY = 0;
if(instance_exists(obj_ScreenShaker) && obj_ScreenShaker.active)
{
	shakeX += obj_ScreenShaker.shakeX;
	shakeY += obj_ScreenShaker.shakeY;
}

//var camX = scr_round(playerX+shakeX + (camWidth()-global.zoomResWidth)/2) + scr_round(x-playerX),
//	camY = scr_round(playerY+shakeY + (camHeight()-global.zoomResHeight)/2) + scr_round(y-playerY);
var camX = scr_round(playerX+shakeX) + scr_round(x-playerX),
	camY = scr_round(playerY+shakeY) + scr_round(y-playerY);
camera_set_view_pos(view_camera[0], camX, camY);