/// @description Initialize
clampCam = true;

camLimitMax = 16;//32;
camLimitX = camLimitMax;
camLimitY = 0;
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

function camera_collide(colX, colY, dsList)
{
	//return collision_rectangle_list(x+colX, y+colY, x+colX+global.resWidth-1, y+colY+global.resHeight-1,obj_CamTile,false,true,dsList,true);
	var col = collision_rectangle_list(x+colX, y+colY, x+colX+global.resWidth-1, y+colY+global.resHeight-1,obj_CamTile,false,true,dsList,true);
	
	var wDiff = abs(global.resWidth - global.ogResWidth)/2;
	col += collision_rectangle_list(x+wDiff+colX, y+colY, x+wDiff+colX+global.ogResWidth-1, y+colY+global.resHeight-1,obj_CamTile_NonWScreen,false,true,dsList,true);
	
	return col;
}

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
