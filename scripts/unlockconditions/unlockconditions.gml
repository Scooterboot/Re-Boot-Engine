
function Condition_ClearRoomEnemies()
{
	var flag = true;
	var n = instance_number(obj_NPC);
	if(n > 0)
	{
		for(var i = 0; i < n; i++)
		{
			var npc = instance_find(obj_NPC,i);
			if(instance_exists(npc) && !npc.dead && !npc.friendly)
			{
				flag = false;
				break;
			}
		}
	}
	return flag;
}

function Condition_KraidDefeated()
{
	return global.BossDowned("Kraid");
}