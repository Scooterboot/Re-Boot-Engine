/// @description Logic

var player = noone;
for(var i = 0; i < (room_width+room_height)/2; i+= 16)
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
if(instance_exists(player) && frame >= 4)
{
    var htc = instance_create_layer(x,y,layer,obj_ClosingHatch);
    htc.image_index = image_index;
    htc.direction = direction;
    htc.image_angle = image_angle;
    htc.image_xscale = image_xscale;
    htc.image_yscale = image_yscale;
    htc.frame = frame;
    htc.doorRespawnObj = object_index;
	htc.hatchID = hatchID;
	htc.hatchID_Global = hatchID_Global;
	htc.UnlockCondition = UnlockCondition;
	htc.mapIcon = mapIcon;
    falseDestroy = true;
    instance_destroy();
}

if(frame > 0)
{
    if(frame == 4 && !audio_is_playing(snd_Door_Close) && !global.roomTrans)
    {
        audio_play_sound(snd_Door_Close,0,false);
    }
    frameCounter += 1;
    if(frameCounter > 1)
    {
        frame -= 1;
        frameCounter = 0;
    }
}

if(hitAnim > 0)
{
	if(hitAnim == 8)
	{
		audio_stop_sound(snd_Door_Damaged);
		audio_play_sound(snd_Door_Damaged,0,false);
	}
	hitAnim--;
}

immune = false;
if(place_meeting(x,y,obj_Gadora))
{
	immune = true;
}

if(hitPoints <= 0)
{
	destroy = true;
}

if(destroy)
{
    instance_destroy();
}