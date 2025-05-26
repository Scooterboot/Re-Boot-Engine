/// @description 

if(npcID != -1 && dead)
{
	ds_list_add(global.npcKillList,"BossDowned_"+string(npcID));
}