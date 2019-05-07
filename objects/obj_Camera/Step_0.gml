/// @description Insert description here
// You can write your code in this editor
if(!global.gamePaused && instance_exists(obj_Player))
{
	var xx = x + (global.resWidth/2),
		yy = y + (global.resHeight/2);
	playerX = obj_Player.x;
	var ysp = obj_Player.y - obj_Player.yprevious;
	if((obj_Player.state == State.Stand || obj_Player.state == State.Crouch) && obj_Player.prevState != obj_Player.state)
	{
		ysp = 0;
	}
	var fysp = ysp;
	if(playerY < obj_Player.y)
	{
		fysp = min(ysp+1,obj_Player.y-playerY);
	}
	if(playerY > obj_Player.y)
	{
		fysp = max(ysp-1,obj_Player.y-playerY);
	}
	playerY += fysp;
	playerY = clamp(playerY,obj_Player.y-11,obj_Player.y+11);
	
	targetX = playerX;
	targetY = playerY;
	velX = 0;
	velY = 0;
	var angle = obj_Player.aimAngle,
		speedX = obj_Player.fVelX,
		speedY = obj_Player.fVelY,
		camKey = obj_Player.cAimLock;
	
	if(obj_Player.state == State.Hurt)
	{
		speedX = 0;
		speedY = 0;
	}
	if(obj_Player.state == State.Grapple || (obj_Player.state == State.Morph && obj_Player.spiderBall && obj_Player.spiderEdge != Edge.None))
	{
		speedX = obj_Player.x - obj_Player.xprevious;
		speedY = obj_Player.y - obj_Player.yprevious;
	}
	xDir = obj_Player.dir;
	yDir = sign(scr_round(speedY));
	if(camKey)
	{
		yDir = sign(angle) * -1;
	}
	if(obj_Player.state == State.Grip && obj_Player.gripGunReady && obj_Player.move != xDir)
	{
		xDir *= -1;
	}
	
	targetX = playerX + (camLimitX*xDir);
	if(obj_Player.state == State.Somersault && !camKey)
	{
		targetX = playerX;
	}
	targetY = playerY + (camLimitY*yDir);
	if(obj_Player.state == State.Grapple || (obj_Player.state == State.Morph && obj_Player.spiderBall && obj_Player.spiderEdge != Edge.None) || obj_Player.state == State.Elevator)
	{
		xDir = 0;
		yDir = 0;
		targetX = playerX;
		targetY = playerY;
		if(obj_Player.state == State.Grapple || obj_Player.state == State.Elevator)
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
		if(obj_Player.grounded && (!camKey || angle == 0))
		{
			camLimitY = max(camLimitY - 1, 0);
		}
		else
		{
			camLimitY = camLimitMax;
		}
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
	
	var col = camera_collide(0,0);
	if(instance_exists(col) && (col.image_angle == 90 || (col.image_angle == 270 && col.image_yscale < 0)) && playerX > col.x+(16*abs(col.image_yscale)))
	{
		fVelX = min(col.x+(16*abs(col.image_yscale)) - x, 1+abs(playerX-prevPlayerX));
	}
	else if(instance_exists(col) && (col.image_angle == 270 || (col.image_angle == 90 && col.image_yscale < 0)) && playerX < col.x-(16*abs(col.image_yscale)))
	{
		fVelX = max(col.x-(16*abs(col.image_yscale)) - (x+global.resWidth), -(1+abs(playerX-prevPlayerX)));
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
	var colX = camera_collide(max(abs(fVelX),1)*sign(fVelX),0);
	if(instance_exists(colX) && (
	(fVelX < 0 && (colX.image_angle == 90 || (colX.image_angle == 270 && colX.image_yscale < 0)) && playerX > colX.x+(16*abs(colX.image_yscale))) ||
	(fVelX > 0 && (colX.image_angle == 270 || (colX.image_angle == 90 && colX.image_yscale < 0)) && playerX < colX.x-(16*abs(colX.image_yscale)))))
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
		while(!camera_collide(sign(fVelX),0) && xnum > 0)
		{
			x += sign(fVelX);
			xnum--;
		}
		fVelX = 0;
	}
	x += fVelX;
	
	fVelY = velY;
	
	col = camera_collide(0,0);
	if(instance_exists(col) && (col.image_angle == 0 || (col.image_angle == 180 && col.image_yscale < 0)) && playerY > col.y+(16*abs(col.image_yscale)))
	{
		fVelY = min(col.y+(16*abs(col.image_yscale)) - y, 1+abs(playerY-prevPlayerY));
	}
	else if(instance_exists(col) && (col.image_angle == 180 || (col.image_angle == 0 && col.image_yscale < 0)) && playerY < col.y-(16*abs(col.image_yscale)))
	{
		fVelY = max(col.y-(16*abs(col.image_yscale)) - (y+global.resHeight), -(1+abs(playerY-prevPlayerY)));
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
	var colY = camera_collide(0,max(abs(fVelY),1)*sign(fVelY));
	if(instance_exists(colY) && (
	(fVelY < 0 && (colY.image_angle == 0 || (colY.image_angle == 180 && colY.image_yscale < 0)) && playerY > colY.y+(16*abs(colY.image_yscale))) ||
	(fVelY > 0 && (colY.image_angle == 180 || (colY.image_angle == 0 && colY.image_yscale < 0)) && playerY < colY.y-(16*abs(colY.image_yscale)))))
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
		while(!camera_collide(0,sign(fVelY)) && ynum > 0)
		{
			y += sign(fVelY);
			ynum--;
		}
		fVelY = 0;
	}
	y += fVelY;
	
	prevPlayerX = playerX;
	prevPlayerY = playerY;
}
x = clamp(x,0,room_width-global.resWidth);
y = clamp(y,0,room_height-global.resHeight);
var xDiff = scr_round(x-playerX),
	yDiff = scr_round(y-playerY);
camera_set_view_pos(view_camera[0], scr_round(playerX)+xDiff, scr_round(playerY)+yDiff);