/// @description Logic
/*if(!idCheck)
{
	var flag = false;
	if(hatchID_Global != -1)
	{
		if(ds_list_find_index(global.openHatchList,"global_hatchOpened_"+string(hatchID_Global)) != -1)
		{
			flag = true;
		}
	}
	else if(hatchID != -1)
	{
		if(ds_list_find_index(global.openHatchList,room_get_name(room)+"_hatchOpened_"+string(hatchID)) != -1)
		{
			flag = true;
		}
	}
	if(flag)
	{
		htc = instance_create_layer(x,y,layer,obj_DoorHatch);
		htc.image_index = image_index;
		htc.direction = direction;
		htc.image_angle = image_angle;
		htc.image_xscale = image_xscale;
		htc.image_yscale = image_yscale;
		htc.frame = frame;
		htc.idCheck = true;
		falseDestroy = true;
		instance_destroy();
		exit;
	}
	else
	{
		idCheck = true;
	}
}
else*/ if(place_meeting(x,y,obj_Player) && frame >= 4)
{
    htc = instance_create_layer(x,y,layer,obj_ClosingHatch);
    htc.image_index = image_index;
    htc.direction = direction;
    htc.image_angle = image_angle;
    htc.image_xscale = image_xscale;
    htc.image_yscale = image_yscale;
    htc.frame = frame;
    htc.doorRespawnObj = object_index;
	htc.hatchID = hatchID;
	htc.hatchID_Global = hatchID_Global;
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

if(hitPoints <= 0)
{
	destroy = true;
}

if(destroy)
{
    instance_destroy();
}