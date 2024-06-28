/// @description 

//global.currentItemPercent = (ds_list_size(global.collectedItemList) / global.totalItems) * 100;

if(room != rm_MainMenu && !global.gamePaused)
{
	global.currentPlayTime += (1 / game_get_speed(gamespeed_fps)) * (oldDelta / delta_time);
	
	/*if(keyboard_check(vk_shift))
	{
		global.currentPlayTime += 3600;
	}*/
}

oldDelta = delta_time;