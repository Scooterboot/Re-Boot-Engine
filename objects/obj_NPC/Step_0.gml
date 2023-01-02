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
		freezePlatform.XRayHide = true;
	}
}
else if(instance_exists(freezePlatform))
{
	instance_destroy(freezePlatform);
}

frozenImmuneTime = max(frozenImmuneTime-1,0);
frozen = max(frozen - 1, 0);

#endregion

#region Damage to Player
if(!friendly && damage > 0 && !frozen && !dead)
{
    var player = instance_place(x,y,obj_Player);
    if(instance_exists(player))
    {
        if (player.immuneTime <= 0 && (!player.immune || ignorePlayerImmunity))//!player.isChargeSomersaulting && !player.isScrewAttacking && !player.isSpeedBoosting)
        {
            //var ang = point_direction(x,y,obj_Samus.x,obj_Samus.y);
            var ang = 45;
            if(player.bbox_bottom > bbox_bottom)
            {
                ang = 315;
            }
            if(player.x < x)
            {
                ang = 135;
                if(player.bbox_bottom > bbox_bottom)
                {
                    ang = 225;
                }
            }
            var knockX = lengthdir_x(knockBackSpeed,ang),
                knockY = lengthdir_y(knockBackSpeed,ang);
            scr_DamagePlayer(damage,knockBack,knockX,knockY,damageImmuneTime);
        }
    }
}
#endregion

