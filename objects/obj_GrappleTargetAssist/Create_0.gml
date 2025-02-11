/// @description 

assistRadius = 22.5;

grapObj_list = ds_list_create();
grapPoint_list = ds_list_create();

function GrapPoint(_x, _y) constructor
{
	x = _x;
	y = _y;
}

function GetPlayerPos()
{
	var player = obj_Player;
	var playerShootPosX = player.x+player.sprtOffsetX+player.shotOffsetX,
		playerShootPosY = player.y+player.sprtOffsetY+player.shotOffsetY;
	var _sdist = point_distance(player.x,player.y, playerShootPosX,playerShootPosY);
	var pX = playerShootPosX - lengthdir_x(_sdist, shootDir),
		pY = playerShootPosY - lengthdir_y(_sdist, shootDir);
	
	return new Vector2(pX, pY);
}

function AddPointToList(_x, _y)
{
	var player = obj_Player;
	var pos = GetPlayerPos();
	var pX = pos.X, pY = pos.Y;
	
	if (point_distance(player.x,player.y, _x,_y) <= player.grappleMaxDist && 
		abs(angle_difference(point_direction(pX,pY, _x,_y), shootDir)) <= assistRadius)
	{
		var gp = new GrapPoint(_x, _y);
		ds_list_add(grapPoint_list,gp);
	}
}

shootDir = 0;
adjustedShootDir = 0;
targetPoint = noone;

frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,3,2,1];