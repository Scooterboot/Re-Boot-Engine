/// @description Initialize
clampCam = true;

camLimitDefault_Left = -32;
camLimitDefault_Right = 32;
camLimitDefault_Top = -16;
camLimitDefault_Bottom = 16;

camLimitMax_Left = camLimitDefault_Left;
camLimitMax_Right = camLimitDefault_Right;
camLimitMax_Top = camLimitDefault_Top;
camLimitMax_Bottom = camLimitDefault_Bottom;

camLimit_Left = camLimitMax_Left;
camLimit_Right = camLimitMax_Right;
camLimit_Top = camLimitMax_Top;
camLimit_Bottom = camLimitMax_Bottom;

function LimitCamX()
{
	var xx = x + (global.resWidth/2);
	if((xx+fVelX) < (playerX + camLimit_Left))
	{
		fVelX = min((playerX+camLimit_Left) - xx, 1 + max((playerX-prevPlayerX) + sign(velX),0));
		if(global.roomTrans)
		{
			fVelX = (playerX+camLimit_Left) - xx;
		}
	}
	if((xx+fVelX) > (playerX + camLimit_Right))
	{
		fVelX = max((playerX+camLimit_Right) - xx, -1 + min((playerX-prevPlayerX) + sign(velX),0));
		if(global.roomTrans)
		{
			fVelX = (playerX+camLimit_Right) - xx;
		}
	}
}
function LimitCamY()
{
	var yy = y + (global.resHeight/2);
	if((yy+fVelY) < (playerY + camLimit_Top))
	{
		fVelY = min((playerY+camLimit_Top) - yy, 1 + max((playerY-prevPlayerY) + sign(velY),0));
		if(global.roomTrans)
		{
			fVelY = (playerY+camLimit_Top) - yy;
		}
	}
	if((yy+fVelY) > (playerY + camLimit_Bottom))
	{
		fVelY = max((playerY+camLimit_Bottom) - yy, -1 + min((playerY-prevPlayerY) + sign(velY),0));
		if(global.roomTrans)
		{
			fVelY = (playerY+camLimit_Bottom) - yy;
		}
	}
}

velX = 0;
velY = 0;
fVelX = velX;
fVelY = velY;
camSpeedX = 0;
camSpeedY = 0;
xDir = 0;
yDir = 0;
camKey = false;
playerX = x + (global.resWidth/2);
playerY = y + (global.resHeight/2);
targetX = playerX;
targetY = playerY;
if(instance_exists(obj_Player))
{
	playerX = obj_Player.x;
	playerY = obj_Player.y;
	targetX = playerX;
	targetY = playerY;
}
prevPlayerX = playerX;
prevPlayerY = playerY;

colList = ds_list_create();

function camera_collide(colX, colY, dsList)
{
	//return collision_rectangle_list(x+colX, y+colY, x+colX+global.resWidth-1, y+colY+global.resHeight-1,obj_CamTile,false,true,dsList,true);
	var col = collision_rectangle_list(x+colX, y+colY, x+colX+global.resWidth-1, y+colY+global.resHeight-1,obj_CamTile,false,true,dsList,true);
	
	var wDiff = abs(global.resWidth - global.ogResWidth)/2;
	col += collision_rectangle_list(x+wDiff+colX, y+colY, x+wDiff+colX+global.ogResWidth-1, y+colY+global.resHeight-1,obj_CamTile_NonWScreen,false,true,dsList,true);
	
	return col;
}

/*
function CamTileFacing_Down(camTile)
{
	return ((angle_difference(camTile.image_angle,0) == 0 && camTile.image_yscale > 0) || 
			(angle_difference(camTile.image_angle,180) == 0 && camTile.image_yscale < 0));
}
function CamTileFacing_Up(camTile)
{
	return ((angle_difference(camTile.image_angle,180) == 0 && camTile.image_yscale > 0) || 
			(angle_difference(camTile.image_angle,0) == 0 && camTile.image_yscale < 0));
}
function CamTileFacing_Right(camTile)
{
	return ((angle_difference(camTile.image_angle,90) == 0 && camTile.image_yscale > 0) || 
			(angle_difference(camTile.image_angle,-90) == 0 && camTile.image_yscale < 0));
}
function CamTileFacing_Left(camTile)
{
	return ((angle_difference(camTile.image_angle,-90) == 0 && camTile.image_yscale > 0) || 
			(angle_difference(camTile.image_angle,90) == 0 && camTile.image_yscale < 0));
}
*/