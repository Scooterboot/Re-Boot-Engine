/// @description Initialize
event_inherited();

function PauseAI()
{
	return (global.gamePaused || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

platform = instance_create_layer(bbox_left,bbox_top,layer_get_id("Collision"),obj_Platform);
platform.image_xscale = (bbox_right-bbox_left+1)/16;
platform.image_yscale = (bbox_bottom-bbox_top+1)/16;
platform.xRayHide = true;

function DmgColPlayer()
{
	return collision_rectangle(bbox_left,bbox_top+2,bbox_right,bbox_bottom,obj_Player,false,true);
}

function CanMoveDownSlope_Bottom() { return velY >= 0; }