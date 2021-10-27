/// @description Camera movement
if((!global.gamePaused || global.roomTrans) && instance_exists(obj_Player))
{
	var player = obj_Player;
	var xx = x + (global.resWidth/2),
		yy = y + (global.resHeight/2);
	playerX = player.x;
	var ysp = player.y - player.yprevious;
	if(((player.state == State.Stand || player.state == State.Crouch || player.state == State.Dodge || player.state == State.Grip) && player.prevState != player.state)
		|| (player.prevState == State.Stand && player.state == State.Morph))
	{
		ysp = 0;
	}
	var fysp = ysp;
	if(playerY < player.y)
	{
		fysp = min(ysp+1,player.y-playerY);
	}
	if(playerY > player.y)
	{
		fysp = max(ysp-1,player.y-playerY);
	}
	playerY += fysp;
	playerY = clamp(playerY,player.y-11,player.y+11);
	
	targetX = playerX;
	targetY = playerY;
	velX = 0;
	velY = 0;
	var angle = player.aimAngle,
		speedX = player.fVelX,
		speedY = player.fVelY,
		camKey = player.cAimLock;
	
	if(player.state == State.Hurt)
	{
		speedX = 0;
		speedY = 0;
	}
	if(player.state == State.Grapple || (player.state == State.Morph && player.spiderBall && player.spiderEdge != Edge.None))
	{
		speedX = player.x - player.xprevious;
		speedY = player.y - player.yprevious;
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
	
	targetX = playerX + (camLimitX*xDir);
	if(player.state == State.Somersault && !camKey)
	{
		targetX = playerX;
	}
	targetY = playerY + (camLimitY*yDir);
	if(player.state == State.Grapple || (player.state == State.Morph && player.spiderBall && player.spiderEdge != Edge.None) || player.state == State.Elevator)
	{
		xDir = 0;
		yDir = 0;
		targetX = playerX;
		targetY = playerY;
		if(player.state == State.Grapple || player.state == State.Elevator)
		{
			camLimitX = max(camLimitX - 1, 0);
			camLimitY = max(camLimitY - 1, 0);
		}
		else
		{
			camLimitX = max(camLimitX - max(camLimitX/8,1),0);
			camLimitY = max(camLimitY - max(camLimitY/8,1),0);
		}
	}
	else
	{
		camLimitX = camLimitMax;
		/*if(player.grounded && (!camKey || angle == 0))
		{
			camLimitY = max(camLimitY - 1, 0);
		}
		else
		{*/
			camLimitY = camLimitMax;
		//}
	}
	var speedMult = 2,
		speedMax = 3,
		distX = abs(targetX - xx),
		distY = abs(targetY - yy),
		pointDistX = distX/(max(camLimitX,1)/2),
		pointDistY = distY/(max(camLimitY,1)/2);
	
	camSpeedX = speedX + max(abs(speedX*pointDistX)/4,1) * sign(speedX);
	if(speedX == 0 || camKey)
	{
		camSpeedX = speedX + max(speedMult*pointDistX,1)*xDir;
	}
	
	camSpeedX = clamp(camSpeedX,speedX-speedMax,speedX+speedMax);
	if(speedX != 0 || camKey || xDir == 0)
	{
		velX = camSpeedX;
	}
	
	camSpeedY = speedY + (max(abs(speedY*pointDistY)/4,1) * yDir);
	if(scr_round(speedY) == 0)
	{
		camSpeedY = max(speedMult*pointDistY,1) * yDir;
	}
	camSpeedY = clamp(camSpeedY,speedY-speedMax,speedY+speedMax);
	if(angle != 0 && camKey)
	{
		if(sign(scr_round(speedY)) != yDir && scr_round(speedY) != 0)
		{
			velY = speedY + speedMult*yDir;
		}
		else if(scr_round(speedY) != 0)
		{
			velY = abs(camSpeedY+(yDir*speedMult)) * yDir;
		}
		else
		{
			velY = abs(camSpeedY) * yDir;
		}
	}
	else if(scr_round(speedY) != 0)
	{
		velY = camSpeedY;
	}
	
	fVelX = velX;
	
	var _list = ds_list_create();
	var _num = camera_collide(0,0,_list);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			var col = _list[| i];
			if(instance_exists(col) && (angle_difference(col.image_angle,90) == 0 || (angle_difference(col.image_angle,-90) == 0 && col.image_yscale < 0)) && playerX > col.x+(16*abs(col.image_yscale)))
			{
				fVelX = min(col.x+(16*abs(col.image_yscale)) - x, 1+abs(playerX-prevPlayerX));
				break;
			}
			else if(instance_exists(col) && (angle_difference(col.image_angle,-90) == 0 || (angle_difference(col.image_angle,90) == 0 && col.image_yscale < 0)) && playerX < col.x-(16*abs(col.image_yscale)))
			{
				fVelX = max(col.x-(16*abs(col.image_yscale)) - (x+global.resWidth), -(1+abs(playerX-prevPlayerX)));
				break;
			}
			else
			{
				if((xx+fVelX) < (playerX - camLimitX))
				{
					fVelX = min((playerX-camLimitX) - xx, 1+abs((playerX-prevPlayerX) + velX));
				}
				if((xx+fVelX) > (playerX + camLimitX))
				{
					fVelX = max((playerX+camLimitX) - xx,-(1+abs((playerX-prevPlayerX) + velX)));
				}
			}
		}
	}
	else
	{
		if((xx+fVelX) < (playerX - camLimitX))
		{
			fVelX = min((playerX-camLimitX) - xx, 1+abs((playerX-prevPlayerX) + velX));
		}
		if((xx+fVelX) > (playerX + camLimitX))
		{
			fVelX = max((playerX+camLimitX) - xx,-(1+abs((playerX-prevPlayerX) + velX)));
		}
	}
	ds_list_clear(_list);
	
	_num = camera_collide(max(abs(fVelX),1)*sign(fVelX),0,_list);
	for(var i = 0; i < _num; i++)
	{
		var colX = _list[| i];
		if(instance_exists(colX) && (
		(fVelX < 0 && (angle_difference(colX.image_angle,90) == 0 || (angle_difference(colX.image_angle,-90) == 0 && colX.image_yscale < 0)) && playerX > colX.x+(16*abs(colX.image_yscale))) ||
		(fVelX > 0 && (angle_difference(colX.image_angle,-90) == 0 || (angle_difference(colX.image_angle,90) == 0 && colX.image_yscale < 0)) && playerX < colX.x-(16*abs(colX.image_yscale)))))
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
			//while(!camera_collide(sign(fVelX),0) && xnum > 0)
			while(!collision_rectangle(x+sign(fVelX),y,x+sign(fVelX)+global.resWidth-1,y+global.resHeight-1,colX,false,true) && xnum > 0)
			{
				x += sign(fVelX);
				xnum--;
			}
			fVelX = 0;
		}
	}
	ds_list_clear(_list);
	
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
	
	
	fVelY = velY;
	
	_num = camera_collide(0,0,_list);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			col = _list[| i];
			if(instance_exists(col) && (col.image_angle == 0 || (angle_difference(col.image_angle,180) == 0 && col.image_yscale < 0)) && playerY > col.y+(16*abs(col.image_yscale)))
			{
				fVelY = min(col.y+(16*abs(col.image_yscale)) - y, 1+abs(playerY-prevPlayerY));
				break;
			}
			else if(instance_exists(col) && (angle_difference(col.image_angle,180) == 0 || (col.image_angle == 0 && col.image_yscale < 0)) && playerY < col.y-(16*abs(col.image_yscale)))
			{
				fVelY = max(col.y-(16*abs(col.image_yscale)) - (y+global.resHeight), -(1+abs(playerY-prevPlayerY)));
				break;
			}
			else
			{
				if((yy+fVelY) < (playerY - camLimitY))
				{
					fVelY = min((playerY-camLimitY) - yy, 1+abs((playerY-prevPlayerY) + velY));
				}
				if((yy+fVelY) > (playerY + camLimitY))
				{
					fVelY = max((playerY+camLimitY) - yy,-(1+abs((playerY-prevPlayerY) + velY)));
				}
			}
		}
	}
	else
	{
		if((yy+fVelY) < (playerY - camLimitY))
		{
			fVelY = min((playerY-camLimitY) - yy, 1+abs((playerY-prevPlayerY) + velY));
		}
		if((yy+fVelY) > (playerY + camLimitY))
		{
			fVelY = max((playerY+camLimitY) - yy,-(1+abs((playerY-prevPlayerY) + velY)));
		}
	}
	ds_list_clear(_list);
	
	_num = camera_collide(0,max(abs(fVelY),1)*sign(fVelY),_list);
	for(var i = 0; i < _num; i++)
	{
		var colY = _list[| i];
		if(instance_exists(colY) && (
		(fVelY < 0 && (colY.image_angle == 0 || (angle_difference(colY.image_angle,180) == 0 && colY.image_yscale < 0)) && playerY > colY.y+(16*abs(colY.image_yscale))) ||
		(fVelY > 0 && (angle_difference(colY.image_angle,180) == 0 || (colY.image_angle == 0 && colY.image_yscale < 0)) && playerY < colY.y-(16*abs(colY.image_yscale)))))
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
			//while(!camera_collide(0,sign(fVelY)) && ynum > 0)
			while(!collision_rectangle(x,y+sign(fVelY),x+global.resWidth-1,y+sign(fVelY)+global.resHeight-1,colY,false,true) && ynum > 0)
			{
				y += sign(fVelY);
				ynum--;
			}
			fVelY = 0;
		}
	}
	ds_list_destroy(_list);
	
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
	
	prevPlayerX = playerX;
	prevPlayerY = playerY;
}

if(clampCam)
{
	x = clamp(x,0,room_width-global.resWidth);
	y = clamp(y,0,room_height-global.resHeight);
	clampCam = false;
}

var xDiff = scr_round(x-playerX),
	yDiff = scr_round(y-playerY);
camera_set_view_pos(view_camera[0], scr_round(playerX)+xDiff, scr_round(playerY)+yDiff);