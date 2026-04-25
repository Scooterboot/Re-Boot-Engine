event_inherited();

damageType = DmgType.Misc;
damageSubType = array_create(DmgSubType_Misc._Length,false);
damageSubType[DmgSubType_Misc.All] = true;
damageSubType[DmgSubType_Misc.Grapple] = true;

particleType = -1;

direction = 0;
speed = 0;
image_speed = 0.5;
layer = layer_get_id("Projectiles_fg");

shootDir = 0;
grappleDist = 0;
grapReel = false;

enum GravGrapState
{
	None,
	Ground,
	Object
}
gravState = GravGrapState.None;
stateChanged = false;

grapBlock = noone;
grapBlockOffX = 0;
grapBlockOffY = 0;
grapObject = noone;

grapFrame = 0;

function GetPlayerPos()
{
	var player = creator;
	var _sdist = point_distance(player.x,player.y, player.shootPosX,player.shootPosY);
	var pX = player.shootPosX - lengthdir_x(_sdist, player.shootDir),
		pY = player.shootPosY - lengthdir_y(_sdist, player.shootDir);
	
	return new Vector2(pX, pY);
}

function GetGrapBlock(listNum)
{
	if(listNum > 0)
	{
		for(var i = 0; i < listNum; i++)
		{
			if(instance_exists(blockList[| i]))
			{
				var block = blockList[| i];
				var isSolid = true;
				if(block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
				{
					isSolid = block.isSolid;
				}
				
				if(isSolid)
				{
					ds_list_clear(blockList);
					return block;
				}
			}
		}
		ds_list_clear(blockList);
	}
	return noone;
}

function entity_collision(listNum)
{
	if(listNum > 0)
	{
		for(var i = 0; i < listNum; i++)
		{
			if(instance_exists(blockList[| i]))
			{
				var block = blockList[| i];
				var isSolid = true;
				if(block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
				{
					isSolid = block.isSolid;
				}
				
				if(isSolid)
				{
					ds_list_clear(blockList);
					return true;
				}
			}
		}
		ds_list_clear(blockList);
	}
	return false;
}
