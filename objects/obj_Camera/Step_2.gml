/// @description Camera movement
//if((!global.gamePaused || global.roomTrans) && instance_exists(obj_Player))
if((!global.gamePaused || global.roomTrans || (instance_exists(obj_XRay) && !obj_PauseMenu.pause)) && instance_exists(obj_Player))
{
	var player = obj_Player;
	var xx = x + (camWidth()/2),
		yy = y + (camHeight()/2);
	
	var xsp = player.x - player.xprevious,
		ysp = player.y - player.yprevious;
	if(player.stallCamera)
	{
		ysp = 0;
	}
	
	var fxsp = xsp,
		fysp = ysp;
	
	var pX = player.x,
		pY = player.y;
	//if(player.stateFrame == State.Morph)
	//{
	//	pY = player.y+8;
	//}
	
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
	
	if(global.roomTrans)
	{
		playerX = pX;
		playerY = pY;
	}
	
	playerXRayX = clamp(pX,xx-32,xx+32);
	playerXRayY = clamp(pY,yy-32,yy+32);
	targetX = playerX;
	targetY = playerY;
	velX = 0;
	velY = 0;
	camKey = player.cAimLock;
	
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
	/*if(player.state == State.Grapple || (player.state == State.Morph && player.spiderBall && player.spiderEdge != Edge.None))
	{
		speedX = player.x - player.xprevious;
		speedY = player.y - player.yprevious;
	}*/
	
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
	if(player.state == State.Grip && player.gripGunReady && player.move != xDir)
	{
		xDir *= -1;
	}
	
	targetX = playerX + camLimit_Right;
	if(xDir <= -1)
	{
		targetX = playerX + camLimit_Left;
	}
	if(player.state == State.Somersault && !camKey)
	{
		targetX = playerX;
	}
	targetY = playerY + camLimit_Bottom;
	if(yDir <= -1)
	{
		targetY = playerY + camLimit_Top;
	}
	
	var camLimSpd = 1;
	camLimitMax_Left = camLimitDefault_Left;
	camLimitMax_Right = camLimitDefault_Right;
	camLimitMax_Top = camLimitDefault_Top;
	camLimitMax_Bottom = camLimitDefault_Bottom;
	
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
	
	if(player.state == State.Grapple || player.state == State.Elevator || (player.state == State.Morph && player.SpiderActive()))
	{
		xDir = 0;
		yDir = 0;
		targetX = playerX;
		targetY = playerY;
		if(player.state == State.Morph && player.SpiderActive())
		{
			camLimSpd = 0.5;
		}
		
		camLimitMax_Left = 0;
		camLimitMax_Right = 0;
		camLimitMax_Top = 0;
		camLimitMax_Bottom = 0;
	}
	if(instance_exists(player.XRay))
	{
		camLimitMax_Left = -32;
		camLimitMax_Right = 32;
		camLimitMax_Top = -32;
		camLimitMax_Bottom = 32;
	}
	
	camLimit_Left = CamLimitIncr(camLimit_Left, camLimitMax_Left, camLimSpd, xx-prevPlayerX);
	camLimit_Right = CamLimitIncr(camLimit_Right, camLimitMax_Right, camLimSpd, xx-prevPlayerX);
	camLimit_Top = CamLimitIncr(camLimit_Top, camLimitMax_Top, camLimSpd, yy-prevPlayerY);
	camLimit_Bottom = CamLimitIncr(camLimit_Bottom, camLimitMax_Bottom, camLimSpd, yy-prevPlayerY);
	
	if(instance_exists(player.XRay))
	{
		targetX = playerX + lengthdir_x(32,player.XRay.coneDir);
		targetY = playerY + lengthdir_y(32,player.XRay.coneDir);
		
		var num2 = 1 + scr_floor(abs(targetX-xx) / 7);
		if(abs(targetX-xx) < 2)
		{
			num2 = 10;
		}
		if(targetX > xx)
		{
			velX = min(num2,targetX-xx);
		}
		if(targetX < xx)
		{
			velX = max(-num2,targetX-xx);
		}
		
		num2 = 1 + scr_floor(abs(targetY-yy) / 7);
		if(abs(targetY-yy) < 2)
		{
			num2 = 10;
		}
		if(targetY > yy)
		{
			velY = min(num2,targetY-yy);
		}
		if(targetY < yy)
		{
			velY = max(-num2,targetY-yy);
		}
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
		if(global.roomTrans || obj_Player.introAnimState == 0)
		{
			camSnap = true;
		}
	
		fVelX = velX;
		fVelY = velY;
		
		#region X Collision
		
			var _leftEdge = playerX + camLimit_Left,
				_rightEdge = playerX + camLimit_Right;
			if((xx+fVelX) < _leftEdge)
			{
				fVelX = min(_leftEdge - xx, 1 + max((playerX-prevPlayerX) + sign(velX),0));
				if(global.roomTrans)
				{
					fVelX = _leftEdge - xx;
				}
			}
			if((xx+fVelX) > _rightEdge)
			{
				fVelX = max(_rightEdge - xx, -1 + min((playerX-prevPlayerX) + sign(velX),0));
				if(global.roomTrans)
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
						fVelX = min(col.x+16 - x+wDiff, 1+abs(playerX-prevPlayerX));
						if(camSnap)
						{
							fVelX = col.x+16 - x+wDiff;
						}
						break;
					}
					else if(instance_exists(col) && col.active && col.facing == CamTileFacing.Left)
					{
						fVelX = max(col.x-16 - (x+wDiff+resWidth), -(1+abs(playerX-prevPlayerX)));
						if(camSnap)
						{
							fVelX = col.x-16 - (x+wDiff+resWidth);
						}
						break;
					}
				}
			}
			ds_list_clear(colList);
	
			_num = camera_collide(max(abs(fVelX),1)*sign(fVelX),0,colList);
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
		
			var _topEdge = playerY + camLimit_Top,
				_bottomEdge = playerY + camLimit_Bottom;
			if((yy+fVelY) < _topEdge)
			{
				fVelY = min(_topEdge - yy, 1 + max((playerY-prevPlayerY) + sign(velY),0));
				if(global.roomTrans)
				{
					fVelY = _topEdge - yy;
				}
			}
			if((yy+fVelY) > _bottomEdge)
			{
				fVelY = max(_bottomEdge - yy, -1 + min((playerY-prevPlayerY) + sign(velY),0));
				if(global.roomTrans)
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
						fVelY = min(col.y+16 - y, 1+abs(playerY-prevPlayerY));
						if(camSnap)
						{
							fVelY = col.y+16 - y;
						}
						break;
					}
					else if(instance_exists(col) && col.active && col.facing == CamTileFacing.Up)
					{
						fVelY = max(col.y-16 - (y+camHeight()), -(1+abs(playerY-prevPlayerY)));
						if(camSnap)
						{
							fVelY = col.y-16 - (y+camHeight());
						}
						break;
					}
				}
			}
			ds_list_clear(colList);
	
			_num = camera_collide(0,max(abs(fVelY),1)*sign(fVelY),colList);
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
if(instance_exists(obj_ScreenShaker) && obj_ScreenShaker.active)// && !global.gamePaused)
{
	shakeX += obj_ScreenShaker.shakeX;
	shakeY += obj_ScreenShaker.shakeY;
}

//var camX = scr_round(playerX+shakeX + (camWidth()-global.zoomResWidth)/2) + scr_round(x-playerX),
//	camY = scr_round(playerY+shakeY + (camHeight()-global.zoomResHeight)/2) + scr_round(y-playerY);
var camX = scr_round(playerX+shakeX) + scr_round(x-playerX),
	camY = scr_round(playerY+shakeY) + scr_round(y-playerY);
camera_set_view_pos(view_camera[0], camX, camY);