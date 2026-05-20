/// @description 
if(!global.GamePaused())
{
	if(createPlatformOnFrozen && !freezeImmune)
	{
		if(frozen > 0 && !dead)
		{
			if(array_length(mBlocks) <= 0 || !instance_exists(mBlocks[0]))
			{
				mBlockOffset[0] = new Vector2(self.bb_left(0), self.bb_top(0));
			    mBlocks[0] = instance_create_layer(x+mBlockOffset[0].X, y+mBlockOffset[0].Y, layer_get_id("Collision"), obj_Platform);
			    mBlocks[0].image_xscale = (self.bb_right()-self.bb_left()+1)/16;
			    mBlocks[0].image_yscale = (self.bb_bottom()-self.bb_top()+1)/16;
				mBlocks[0].xRayHide = true;
			}
			else
			{
				self.UpdateMovingTiles();
			}
		}
		else if(array_length(mBlocks) > 0 && instance_exists(mBlocks[0]))
		{
			instance_destroy(mBlocks[0]);
			mBlocks = [];
		}
	}
	frozenInvFrames = max(frozenInvFrames-1,0);
	frozen = max(frozen - 1, 0);
	
	self.LifeBoxes();
}