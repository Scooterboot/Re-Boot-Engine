/// @description Camera movement
if((!global.gamePaused || global.roomTrans) && instance_exists(obj_Player))
{
	var player = obj_Player;
	var xx = x + (global.resWidth/2),
		yy = y + (global.resHeight/2);
	
	var xsp = player.x - player.xprevious,
		ysp = player.y - player.yprevious;
	/*if(((player.state == State.Stand || player.state == State.Crouch || player.state == State.Dodge || player.state == State.Grip) && player.prevState != player.state)
		|| (player.prevState == State.Stand && player.state == State.Morph) || player.stallCamera)*/
	if(player.stallCamera)
	{
		ysp = 0;
	}
	/*if(player.state == State.Grip && player.startClimb)
	{
		xsp = 0;
		ysp = 0;
	}*/
	
	var fxsp = xsp,
		fysp = ysp;
	
	var num = 1 + scr_floor(abs(player.x-playerX) / 7);
	if(playerX < player.x)
	{
		fxsp = min(xsp+num,player.x-playerX);
	}
	if(playerX > player.x)
	{
		fxsp = max(xsp-num,player.x-playerX);
	}
	
	var pY = player.y;
	if(player.stateFrame == State.Morph)
	{
		pY = player.y+8;
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
		playerX = player.x;
		playerY = pY;
	}
	
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
	if(player.state == State.Grapple || player.state == State.Elevator || (player.state == State.Morph && player.spiderBall && player.spiderEdge != Edge.None))
	{
		xDir = 0;
		yDir = 0;
		targetX = playerX;
		targetY = playerY;
		var clspd = 0.5;
		if(player.state == State.Grapple || player.state == State.Elevator)
		{
			clspd = 1;
		}
		
		camLimit_Left = min(camLimit_Left + clspd, 0);
		camLimit_Right = max(camLimit_Right - clspd, 0);
		camLimit_Top = min(camLimit_Top + clspd, 0);
		camLimit_Bottom = max(camLimit_Bottom - clspd, 0);
	}
	else
	{
		camLimit_Left = max(camLimit_Left - 1, camLimitMax_Left);
		camLimit_Right = min(camLimit_Right + 1, camLimitMax_Right);
		camLimit_Top = max(camLimit_Top - 1, camLimitMax_Top);
		camLimit_Bottom = min(camLimit_Bottom + 1, camLimitMax_Bottom);
	}
	
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
	
	camSpeedY = playerMoveY + (max(abs(speedY*pointDistY)/4,1) * yDir);
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
	
	#region Collision
	
		var camSnap = false;
		if(global.roomTrans || obj_Player.introAnimState == 0)
		{
			camSnap = true;
		}
	
		fVelX = velX;
	
		#region X Collision
	
			//var _list = ds_list_create();
			var _num = camera_collide(0,0,colList);
			if(_num > 0)
			{
				for(var i = 0; i < _num; i++)
				{
					var col = colList[| i];
					var wDiff = 0;
					var resWidth = global.resWidth;
					if(col.object_index == obj_CamTile_NonWScreen || object_is_ancestor(col.object_index,obj_CamTile_NonWScreen))
					{
						wDiff = abs(global.resWidth - global.ogResWidth)/2;
						resWidth = global.ogResWidth;
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
					else
					{
						if((xx+fVelX) < (playerX + camLimit_Left))
						{
							fVelX = min((playerX+camLimit_Left) - xx, 1+abs((playerX-prevPlayerX) + velX));
						}
						if((xx+fVelX) > (playerX + camLimit_Right))
						{
							fVelX = max((playerX+camLimit_Right) - xx,-(1+abs((playerX-prevPlayerX) + velX)));
						}
					}
				}
			}
			else
			{
				if((xx+fVelX) < (playerX + camLimit_Left))
				{
					fVelX = min((playerX+camLimit_Left) - xx, 1+abs((playerX-prevPlayerX) + velX));
				}
				if((xx+fVelX) > (playerX + camLimit_Right))
				{
					fVelX = max((playerX+camLimit_Right) - xx,-(1+abs((playerX-prevPlayerX) + velX)));
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
					var resWidth = global.resWidth;
					if(colX.object_index == obj_CamTile_NonWScreen || object_is_ancestor(colX.object_index,obj_CamTile_NonWScreen))
					{
						wDiff = abs(global.resWidth - global.ogResWidth)/2;
						resWidth = global.ogResWidth;
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
						while(!collision_rectangle(x+wDiff+sign(fVelX),y,x+wDiff+sign(fVelX)+resWidth-1,y+global.resHeight-1,colX,false,true) && xnum > 0)
						{
							x += sign(fVelX);
							xnum--;
						}
						fVelX = 0;
					}
				}
			}
			ds_list_clear(colList);
	
			if(x >= 0 && x <= room_width-global.resWidth)
			{
				x += clamp(fVelX, -x, room_width-global.resWidth-x);
			}
			else
			{
				if(x < 0)
				{
					fVelX = max(5+abs(playerX-prevPlayerX) + velX,5);
				}
				if(x > room_width-global.resWidth)
				{
					fVelX = min(-(5+abs(playerX-prevPlayerX)) + velX,-5);
				}
				x += fVelX;
			}
	
		#endregion
	
		fVelY = velY;
	
		#region Y Collision
	
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
						fVelY = max(col.y-16 - (y+global.resHeight), -(1+abs(playerY-prevPlayerY)));
						if(camSnap)
						{
							fVelY = col.y-16 - (y+global.resHeight);
						}
						break;
					}
					else
					{
						if((yy+fVelY) < (playerY + camLimit_Top))
						{
							fVelY = min((playerY+camLimit_Top) - yy, 1+abs((playerY-prevPlayerY) + velY));
						}
						if((yy+fVelY) > (playerY + camLimit_Bottom))
						{
							fVelY = max((playerY+camLimit_Bottom) - yy,-(1+abs((playerY-prevPlayerY) + velY)));
						}
					}
				}
			}
			else
			{
				if((yy+fVelY) < (playerY + camLimit_Top))
				{
					fVelY = min((playerY+camLimit_Top) - yy, 1+abs((playerY-prevPlayerY) + velY));
				}
				if((yy+fVelY) > (playerY + camLimit_Bottom))
				{
					fVelY = max((playerY+camLimit_Bottom) - yy,-(1+abs((playerY-prevPlayerY) + velY)));
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
					var resWidth = global.resWidth;
					if(colY.object_index == obj_CamTile_NonWScreen || object_is_ancestor(colY.object_index,obj_CamTile_NonWScreen))
					{
						wDiff = abs(global.resWidth - global.ogResWidth)/2;
						resWidth = global.ogResWidth;
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
						while(!collision_rectangle(x+wDiff,y+sign(fVelY),x+wDiff+resWidth-1,y+sign(fVelY)+global.resHeight-1,colY,false,true) && ynum > 0)
						{
							y += sign(fVelY);
							ynum--;
						}
						fVelY = 0;
					}
				}
			}
			ds_list_clear(colList);
	
			if(y >= 0 && y <= room_height-global.resHeight)
			{
				y += clamp(fVelY, -y, room_height-global.resHeight-y);
			}
			else
			{
				if(y < 0)
				{
					fVelY = 1+abs(playerY-prevPlayerY);
				}
				if(y > room_height-global.resHeight)
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
	x = clamp(x,0,room_width-global.resWidth);
	y = clamp(y,0,room_height-global.resHeight);
	clampCam = false;
}

var shakeX = 0,
	shakeY = 0;
if(instance_exists(obj_ScreenShaker) && obj_ScreenShaker.active)// && !global.gamePaused)
{
	shakeX += obj_ScreenShaker.shakeX;
	shakeY += obj_ScreenShaker.shakeY;
}

var xDiff = scr_round(x-playerX),
	yDiff = scr_round(y-playerY);
camera_set_view_pos(view_camera[0], scr_round(playerX+shakeX)+xDiff, scr_round(playerY+shakeY)+yDiff);
