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
	    freezePlatform = instance_create_layer(bbox_left,bbox_top,layer_get_id("Collision"),obj_Platform);
	    freezePlatform.image_xscale = (bbox_right-bbox_left+1)/16;
	    freezePlatform.image_yscale = (bbox_bottom-bbox_top+1)/16;
		freezePlatform.xRayHide = true;
	}
	else
	{
		freezePlatform.x = bbox_left;
		freezePlatform.y = bbox_top;
	}
}
else if(instance_exists(freezePlatform))
{
	instance_destroy(freezePlatform);
}

frozenImmuneTime = max(frozenImmuneTime-1,0);
frozen = max(frozen - 1, 0);

#endregion

DamagePlayer();

