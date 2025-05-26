/// @description 

assistRadius = 30;//22.5;

grapObj_list = ds_list_create();
grapPoint_list = ds_list_create();
block_list = ds_list_create();

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
		var colFound = false;
		var num = collision_line_list(player.shootPosX,player.shootPosY, _x,_y, array_concat(ColType_Solid,ColType_MovingSolid), true,true,block_list,true);
		num += collision_line_list(player.x,player.y, player.shootPosX,player.shootPosY, array_concat(ColType_Solid,ColType_MovingSolid), true,true,block_list,true);
		if(num > 0)
		{
			for(var i = 0; i < num; i++)
			{
				if(instance_exists(block_list[| i]) && !object_is_in_array(block_list[| i].object_index, ColType_GrapplePoint))
				{
					colFound = true;
					var col = block_list[| i];
					if(col.object_index == obj_MovingTile || object_is_ancestor(col.object_index,obj_MovingTile))
					{
						colFound = col.grappleCollision;
					}
					break;
				}
			}
		}
		ds_list_clear(block_list);
		
		if(!colFound)
		{
			var gp = new GrapPoint(_x, _y);
			ds_list_add(grapPoint_list,gp);
		}
	}
}

shootDir = 0;
adjustedShootDir = 0;
targetPoint = noone;

frame = 0;
frameNum = 1;