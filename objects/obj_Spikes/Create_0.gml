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
/*function PlayerKnockBackDir(_player)
{
	var _upRight = 45,
		_upLeft = 135,
		_downLeft = 225,
		_downRight = 315;
	
	var ang = (_player.dir == 1) ? _upLeft : _upRight;
	if(_player.bbox_bottom > bbox_top)
	{
		if(_player.bbox_top >= bbox_bottom)
		{
			ang = (_player.dir == 1) ? _downLeft : _downRight;
		}
		else
		{
			var _dir = sign((bbox_left+(bbox_right-bbox_left)/2) - _player.Center(true).X);
			ang = (_dir == 1) ? _downLeft : _downRight;
		}
	}
	
	return ang;
}*/

frame = 0;
frameCounter = 0;
frameSeq = [2,3,4,3];

image_speed = 0;
