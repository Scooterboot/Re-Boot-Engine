/// @description 
if(global.gamePaused)
{
	exit;
}

#region Freeze timer & platform

if(frozen > 0 && !dead)
{
	if(!instance_exists(freezePlatform))
	{
	    freezePlatform = instance_create_layer(scr_round(bb_left()),scr_round(bb_top()),layer_get_id("Collision"),obj_Platform);
	    freezePlatform.image_xscale = (bb_right()-bb_left()+1)/16;
	    freezePlatform.image_yscale = (bb_bottom()-bb_top()+1)/16;
		freezePlatform.xRayHide = true;
	}
	else
	{
		freezePlatform.isSolid = false;
		freezePlatform.UpdatePosition(scr_round(bb_left()),scr_round(bb_top()));
		freezePlatform.isSolid = true;
	}
}
else if(instance_exists(freezePlatform))
{
	instance_destroy(freezePlatform);
}

frozenInvFrames = max(frozenInvFrames-1,0);
frozen = max(frozen - 1, 0);

#endregion

DamagePlayer();

