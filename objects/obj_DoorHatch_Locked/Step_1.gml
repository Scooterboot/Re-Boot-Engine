/// @description Logic
event_inherited();

unlocked = UnlockCondition();

if(unlocked)
{
	unlockAnim = scr_wrap(unlockAnim+1,0,6);
	
	if(lockFrame < 4)
	{
		lockFrameCounter++;
		if(lockFrameCounter > 1)
		{
			lockFrame += 1;
			lockFrameCounter = 0;
		}
	}
}
else if(lockFrame > 0 && frame <= 0)
{
	lockFrameCounter++;
	if(lockFrameCounter > 1)
	{
		lockFrame -= 1;
		lockFrameCounter = 0;
	}
}
image_index = 4;

if(frame > 0)
{
	playLockedSnd = !unlocked;
}
else if(playLockedSnd)
{
	audio_play_sound(snd_Door_Locked,0,false);
	playLockedSnd = false;
}

if(unlocked && !prevUnlocked)
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
	
	mapIconIndex = 0;
	mapIcon[1] = mapIconIndex;
	UpdateMapIcon();
	
	prevUnlocked = unlocked;
}