/// @description Initialize
event_inherited();

function PauseAI()
{
	return (global.gamePaused || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

platform = instance_create_layer(bbox_left,bbox_top,layer_get_id("Collision"),obj_Platform);
platform.image_xscale = (bbox_right-bbox_left+1)/16;
platform.image_yscale = (bbox_bottom-bbox_top+1)/16;
platform.XRayHide = true;
oldPlatX = platform.x;
oldPlatY = platform.y;

function DmgColPlayer()
{
	//return instance_place(x,y,obj_Player);
	return collision_rectangle(bbox_left,bbox_top+2,bbox_right,bbox_bottom,obj_Player,false,true);
}


//lhc_inherit_interface("IPlatform");

/*function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	if(place_meeting(xx+offsetX,yy+offsetY,obj_Player))
	{
		if(playerColCheck(offsetX,offsetY,xx,yy))
		{
			return true;
		}
	}
	
	return entity_place_meeting(xx+offsetX,yy+offsetY,"ISolid");
}
function playerColCheck()
{
	/// @description playerColCheck
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	if (place_meeting(xx+offsetX,yy+offsetY,obj_Player) && !place_meeting(xx,yy,obj_Player) && offsetY < 0 && obj_Player.velY < 0)
	{
		return true;
	}
	return false;
}*/

function CanMoveDownSlope_Bottom() { return velY >= 0; }