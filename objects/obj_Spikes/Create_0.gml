/// @description Initialize
event_perform_object(obj_Breakable,ev_create,0);
event_perform_object(obj_Entity,ev_create,0);

snd = noone;
respawnTime = 0;

damage = 16;
playerKnockBackDur = 10;
playerKnockBackSpd = 5;
playerInvFrames = 60;
ignorePlayerImmunity = true;
function PlayerKnockBackDir(_player)
{
	var ang = 45;
	if(_player.Center(true).Y > bbox_top+(bbox_bottom-bbox_top)/2)
	{
		ang = 315;
	}
	if(_player.dir == 1)
	{
		ang = 135;
		if(_player.Center(true).Y > bbox_top+(bbox_bottom-bbox_top)/2)
		{
			ang = 225;
		}
	}
	return ang;
}

frame = 0;
frameCounter = 0;
frameSeq = [2,3,4,3];

image_speed = 0;