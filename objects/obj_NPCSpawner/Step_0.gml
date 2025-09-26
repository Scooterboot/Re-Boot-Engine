/// @description 
if(global.GamePaused() || !scr_WithinCamRange())
{
	exit;
}

if(coolDown <= 0)
{
	for(var i = 0; i < array_length(npcType); i++)
	{
		if(npcType[i] != noone)
		{
			var _npc = instance_create_layer(x,y,spawnLayer,npcType[i]);
			_npc.spawnerObj = id;
			_npc.respawning = true;
			ModifyNPC(_npc,i);
			spawnedNPC[i] = _npc;
		}
	}
	coolDown = coolDownMax;
}

var _flag = false;
for(var i = 0; i < array_length(spawnedNPC); i++)
{
	if(instance_exists(spawnedNPC[i]))
	{
		_flag = true;
		break;
	}
}

if(!_flag)
{
	array_clear(spawnedNPC);
	array_resize(spawnedNPC,0);
	coolDown = max(coolDown-1,0);
}