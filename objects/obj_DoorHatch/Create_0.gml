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

immune = false;
function Damage(_dmg)
{
	if(!immune)
	{
		hitPoints -= _dmg;
		if(hitPoints > 0)
		{
			hitAnim = 8;
		}
	}
}

unlocked = true;
unlockAnim = 0;
function UnlockCondition()
{
	return true;
}