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

function CamLimitIncr(_limit, _max, _spd, _pos)
{
	if(_limit < _max)
	{
		_limit = max(_limit,min(_pos,0));
		_limit = min(_limit+_spd,_max);
	}
	if(_limit > _max)
	{
		_limit = min(_limit,max(_pos,0));
		_limit = max(_limit-_spd,_max);
	}
	return _limit;
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
playerXRayX = playerX;
playerXRayY = playerY;
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
	var col = collision_rectangle_list(x+colX, y+colY, x+colX+global.resWidth, y+colY+global.resHeight,obj_CamTile,false,true,dsList,true);
	
	var wDiff = abs(global.resWidth - global.ogResWidth)/2;
	col += collision_rectangle_list(x+wDiff+colX, y+colY, x+wDiff+colX+global.ogResWidth, y+colY+global.resHeight,obj_CamTile_NonWScreen,false,true,dsList,true);
	
	return col;
}