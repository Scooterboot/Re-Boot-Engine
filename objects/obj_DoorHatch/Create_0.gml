/// @description Initialize
event_inherited();
hatchID = -1;
hatchID_Global = -1;
//idCheck = false;

image_index = 0;
image_speed = 0;

frame = 0;
frameCounter = 0;

destroy = false;
falseDestroy = false;

hitPoints = 1;

hitAnim = 0;

function Damage(_dmg)
{
	hitPoints -= _dmg;
	if(hitPoints > 0)
	{
		hitAnim = 8;
	}
}