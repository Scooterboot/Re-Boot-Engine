/// @description Logic
event_inherited();

unlocked = UnlockCondition();

if(unlocked)
{
	unlockAnim = scr_wrap(unlockAnim+1,0,6);
	
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
}