/// @description Initialize

global.openHatchList = ds_list_create();

global.collectedItemList = ds_list_create();
global.totalItems = 100;

global.npcKillList = ds_list_create();

global.BossDowned = function(name)
{
	return (ds_list_find_index(global.npcKillList,"BossDowned_"+name) != -1);
}

oldDelta = delta_time;