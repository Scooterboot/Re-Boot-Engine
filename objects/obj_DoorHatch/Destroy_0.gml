/// @description Spawn open object

if(!falseDestroy)
{
	if(hatchID_Global != -1 && 
		ds_list_find_index(global.openHatchList,"global_hatchOpened_"+string(hatchID_Global)) <= -1)
	{
		ds_list_add(global.openHatchList,"global_hatchOpened_"+string(hatchID_Global));
	}
	else if(hatchID != -1 && 
		ds_list_find_index(global.openHatchList,room_get_name(room)+"_hatchOpened_"+string(hatchID)) <= -1)
	{
		ds_list_add(global.openHatchList,room_get_name(room)+"_hatchOpened_"+string(hatchID));
	}
	
	audio_stop_sound(snd_Door_Open);
    audio_play_sound(snd_Door_Open,0,false);
	
    var prt = instance_create_layer(x,y,layer,obj_HatchOpen);
	prt.sprite_index = sprite_index;
    prt.image_index = image_index;
    prt.direction = direction;
    prt.image_angle = image_angle;
    prt.image_xscale = image_xscale;
    prt.image_yscale = image_yscale;
	
	mapIconIndex = 0;
	mapIcon[1] = mapIconIndex;
	UpdateMapIcon();
}