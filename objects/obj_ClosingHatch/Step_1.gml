/// @description Close Logic
if(!place_meeting(x,y,obj_Player) && doorRespawnObj != noone)
{
    htc = instance_create_layer(x,y,layer,doorRespawnObj);
    htc.image_index = image_index;
    htc.direction = direction;
    htc.image_angle = image_angle;
    htc.image_xscale = image_xscale;
    htc.image_yscale = image_yscale;
    htc.frame = frame;
	htc.hatchID = hatchID;
	htc.hatchID_Global = hatchID_Global;
	htc.UnlockCondition = UnlockCondition;
    instance_destroy();
}