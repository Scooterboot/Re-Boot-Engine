/// @description Convert to blue door
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
	falseDestroy = true;
	instance_destroy();
}