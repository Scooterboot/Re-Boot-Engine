/// @description Initialize
event_inherited();

function PauseAI()
{
	return (global.GamePaused() || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

createPlatformOnFrozen = false;

mBlockOffset[0] = new Vector2(self.bb_left(0), self.bb_top(0));
mBlocks[0] = instance_create_layer(scr_round(self.bb_left()),scr_round(self.bb_top()),layer_get_id("Collision"),obj_Platform);
mBlocks[0].image_xscale = (self.bb_right()-self.bb_left()+1)/16;
mBlocks[0].image_yscale = (self.bb_bottom()-self.bb_top()+1)/16;
mBlocks[0].xRayHide = true;

function CanMoveDownSlope_Bottom() { return velY >= 0; }