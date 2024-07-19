/// @description Close Logic
var player = noone;
for(var i = 0; i < (room_width+room_height)/2; i+= 32)
{
	var _checkX = x - lengthdir_x(i,image_angle)*sign(image_xscale),
		_checkY = y - lengthdir_y(i,image_angle)*sign(image_xscale);
	if(place_meeting(_checkX,_checkY,obj_Player))
	{
		player = instance_place(_checkX,_checkY,obj_Player);
		break;
	}
	else if(place_meeting(_checkX,_checkY,obj_Door))
	{
		break;
	}
}
if(!instance_exists(player) && doorRespawnObj != noone)
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
	htc.mapIcon = mapIcon;
    instance_destroy();
}