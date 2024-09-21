/// @description Initialize
event_inherited();

function PauseAI()
{
	return (global.gamePaused || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

platform = instance_create_layer(scr_round(bb_left()),scr_round(bb_top()),layer_get_id("Collision"),obj_Platform);
platform.image_xscale = (bb_right()-bb_left()+1)/16;
platform.image_yscale = (bb_bottom()-bb_top()+1)/16;
platform.xRayHide = true;

function DmgColPlayer()
{
	return collision_rectangle(bb_left(),bb_top()+2,bb_right(),bb_bottom(),obj_Player,false,true);
}

function CanMoveDownSlope_Bottom() { return velY >= 0; }