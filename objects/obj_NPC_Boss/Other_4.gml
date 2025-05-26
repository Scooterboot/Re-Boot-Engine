/// @description 

if(npcID != -1 && !dead && ds_list_find_index(global.npcKillList,"BossDowned_"+string(npcID)) != -1)
{
	instance_destroy();
}