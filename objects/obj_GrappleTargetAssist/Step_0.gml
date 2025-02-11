/// @description 
if(global.gamePaused)
{
	exit;
}
if(!instance_exists(obj_Player))
{
	instance_destroy();
	exit;
}

var player = obj_Player;
if(instance_exists(player.grapple) && player.grapple.grappleState != GrappleState.None)
{
	ds_list_clear(grapObj_list);
	ds_list_clear(grapPoint_list);
	targetPoint = noone;
	adjustedShootDir = 0;
	exit;
}


if(player.aimAngle == 0)
{
	shootDir = 0;
	if(player.dir2 == -1)
	{
		shootDir = 180;
	}
}
else if(player.aimAngle == 1)
{
	shootDir = 45;
	if(player.dir2 == -1)
	{
		shootDir = 135;
	}
}
else if(player.aimAngle == -1)
{
	shootDir = 315;
	if(player.dir2 == -1)
	{
		shootDir = 225;
	}
}
else if(player.aimAngle == 2)
{
	shootDir = 90;
}
else if(player.aimAngle == -2)
{
	shootDir = 270;
}

var pos = GetPlayerPos();
var pX = pos.X, pY = pos.Y;

var num = collision_circle_list(player.x,player.y,player.grappleMaxDist, global.colArr_GrapplePoint, true,true,grapObj_list,true);
if(num > 0)
{
	for(var i = 0; i < num; i++)
	{
		if(instance_exists(grapObj_list[| i]))
		{
			var gpObj = grapObj_list[| i];
			
			if(object_is_ancestor(gpObj.object_index,obj_Tile))
			{
				for(var xx = 0; xx < gpObj.image_xscale; xx++)
				{
					for(var yy = 0; yy < gpObj.image_yscale; yy++)
					{
						var _gpX = gpObj.x+8 + 16*xx,
							_gpY = gpObj.y+8 + 16*yy;
						AddPointToList(_gpX, _gpY);
					}
				}
			}
			else if(object_is_ancestor(gpObj.object_index,obj_Entity))
			{
				AddPointToList(scr_round(gpObj.Center(true).X), scr_round(gpObj.Center(true).Y));
			}
			else
			{
				AddPointToList(gpObj.x, gpObj.y);
			}
		}
	}
}
ds_list_clear(grapObj_list);

if(ds_list_size(grapPoint_list) > 0)
{
	targetPoint = grapPoint_list[| 0];
	var targX = pX,
		targY = pY;
	
	for(var r = 0; r < assistRadius; r += assistRadius/10)
	{
		var flag0 = false;
		for(var d = 8; d < player.grappleMaxDist; d += 8)
		{
			for(var k = 0; k < 2; k++)
			{
				var _sDir = shootDir+r;
				if(k == 1)
				{
					_sDir = shootDir-r;
				}
				var num2 = collision_line_list(pX,pY, pX+lengthdir_x(d,_sDir),pY+lengthdir_y(d,_sDir), global.colArr_GrapplePoint, true,true,grapObj_list,true);
				if(num2 > 0)
				{
					for(var i = 0; i < num2; i++)
					{
						if(instance_exists(grapObj_list[| i]))
						{
							targX = pX+lengthdir_x(d,_sDir);
							targY = pY+lengthdir_y(d,_sDir);
						
							flag0 = true;
							break;
						}
					}
				}
				ds_list_clear(grapObj_list);
				
				if(flag0)
				{
					break;
				}
			}
			if(flag0)
			{
				break;
			}
		}
		if(flag0)
		{
			break;
		}
	}
	
	for(var i = 0; i < ds_list_size(grapPoint_list); i++)
	{
		var gp = grapPoint_list[| i];
		if(!is_struct(targetPoint))
		{
			targetPoint = gp;
		}
		if(point_distance(targX,targY, gp.x,gp.y) < point_distance(targX,targY, targetPoint.x,targetPoint.y))
		{
			targetPoint = gp;
		}
	}
}
else
{
	targetPoint = noone;
}

if(is_struct(targetPoint))
{
	var targetDir = point_direction(player.x,player.y, targetPoint.x,targetPoint.y);
	adjustedShootDir = targetDir;// - player.shootDir;
}