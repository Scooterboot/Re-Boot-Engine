/// @description 
event_inherited();

/* NPC Spawner creation code ref

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

*/

life = 20;
lifeMax = 20;
damage = 16;
dmgMult[DmgType.Misc][1] = 1; // grapple beam

image_speed = 0;
frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1,3,4,5,4];
frameSeq2 = [1,2,5,4,1,2,5,4];