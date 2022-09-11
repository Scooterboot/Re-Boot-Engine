/// @description 

if(npcID != -1 && !dead && ds_list_find_index(global.npcKillList,room_get_name(room)+"_NPCDowned_"+string(npcID)) != -1)
{
	instance_destroy();
}