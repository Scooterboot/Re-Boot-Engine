/// @description Initialize
clampCam = true;

enum CamLimit
{
	Left,
	Right,
	Top,
	Bottom
}
camLimitDef[CamLimit.Left] = 32;
camLimitDef[CamLimit.Right] = 32;
camLimitDef[CamLimit.Top] = 16;
camLimitDef[CamLimit.Bottom] = 16;

for(var i = 0; i < 4; i++)
{
	camLimitMax[i] = camLimitDef[i];
	camLimit[i] = camLimitDef[i];
}

camLimit_ExtraX = 32;
camLimit_ExtraY = 32;

cLimIncrVelX = 1;
cLimIncrVelY = 1;
cLimIncrSpd = 0.0375;
cLimDecrVelX = 1;
cLimDecrVelY = 1;
cLimDecrSpd = 0.01875;

function CamLimitIncr(_limit, _max, _incrSpd, _decrSpd, _pos)
{
	if(_limit < _max)
	{
		_limit = max(_limit,min(_pos,0));
		_limit = min(_limit+_incrSpd,_max);
	}
	if(_limit > _max)
	{
		_limit = min(_limit,max(_pos,0));
		_limit = max(_limit-_decrSpd,_max);
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

stallX = false;
stallY = false;

function camWidth()
{
	return ceil(global.zoomResWidth);
}
function camWidth_NonWide()
{
	return ceil(global.ogResWidth*global.zoomScale);
}
function camHeight()
{
	return ceil(global.zoomResHeight);
}

colList = ds_list_create();

function camera_collide(colX, colY, dsList, _wMod = 0, _hMod = 0)
{
	var col = collision_rectangle_list(x+colX - _wMod, y+colY - _hMod, x+colX+camWidth() + _wMod, y+colY+camHeight() + _hMod,obj_CamTile,false,true,dsList,true);
	
	var wDiff = abs(camWidth() - camWidth_NonWide())/2;
	col += collision_rectangle_list(x+wDiff+colX - _wMod, y+colY - _hMod, x+wDiff+colX+camWidth_NonWide() + _wMod, y+colY+camHeight() + _hMod,obj_CamTile_NonWScreen,false,true,dsList,true);
	
	return col;
}