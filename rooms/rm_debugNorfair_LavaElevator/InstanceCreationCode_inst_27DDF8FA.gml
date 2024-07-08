for(var i = 0; i < 5; i++)
{
	npcType[i] = obj_Gamet;
}
function ModifyNPC(_npc,_index)
{
	var _i = _index-2;
	_npc.attackDelay = 110 + 10*_i;
	_npc.heightOffset = 16*_i;
}