/// @description 

if(npcID != -1 && dead)
{
	ds_list_add(global.npcKillList,room_get_name(room)+"_NPCDowned_"+string(npcID));
}