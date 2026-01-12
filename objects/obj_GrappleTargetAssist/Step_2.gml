/// @description 
if(global.GamePaused())
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

shootDir = player.GetShootDirection(player.aimAngle, player.dir2);

var pos = self.GetPlayerPos();
var pX = pos.X, pY = pos.Y;

var num = collision_circle_list(player.x,player.y,player.grappleMaxDist, ColType_GrapplePoint, true,true,grapObj_list,true);
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
						self.AddPointToList(gpObj.x+8 + 16*xx, gpObj.y+8 + 16*yy);
					}
				}
			}
			else if(object_is_ancestor(gpObj.object_index,obj_Entity))
			{
				self.AddPointToList(scr_round(gpObj.Center(true).X), scr_round(gpObj.Center(true).Y));
			}
			else
			{
				self.AddPointToList(gpObj.x, gpObj.y);
			}
		}
	}
}
ds_list_clear(grapObj_list);

if(ds_list_size(grapPoint_list) > 0)
{
	targetPoint = grapPoint_list[| 0];
	for(var i = 0; i < ds_list_size(grapPoint_list); i++)
	{
		var gp = grapPoint_list[| i];
		var tgDir = point_direction(pX,pY, targetPoint.x,targetPoint.y),
			gpDir = point_direction(pX,pY, gp.x,gp.y);
		
		if(abs(angle_difference(gpDir,shootDir)) < abs(angle_difference(tgDir,shootDir)))
		{
			targetPoint = gp;
		}
	}
	
	var targX = pX,
		targY = pY;
	var tgDir = point_direction(pX,pY, targetPoint.x,targetPoint.y);
	for(var d = 8; d < player.grappleMaxDist; d += 8)
	{
		var breakFlag = false;
		var num2 = collision_line_list(pX,pY, pX+lengthdir_x(d,tgDir),pY+lengthdir_y(d,tgDir), array_concat(ColType_GrapplePoint,ColType_Solid,ColType_MovingSolid), true,true,grapObj_list,true);
		if(num2 > 0)
		{
			for(var i = 0; i < num2; i++)
			{
				if(instance_exists(grapObj_list[| i]))
				{
					targX = pX+lengthdir_x(d,tgDir);
					targY = pY+lengthdir_y(d,tgDir);
					
					breakFlag = true;
					break;
				}
			}
		}
		ds_list_clear(grapObj_list);
		
		if(breakFlag)
		{
			break;
		}
	}
	
	for(var i = 0; i < ds_list_size(grapPoint_list); i++)
	{
		var gp = grapPoint_list[| i];
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
	var targetDir = point_direction(player.shootPosX,player.shootPosY, targetPoint.x,targetPoint.y);
	adjustedShootDir = targetDir - shootDir;
}
else
{
	adjustedShootDir = 0;
}