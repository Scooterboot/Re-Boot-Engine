/// @description Code
if(global.gamePaused)
{
	exit;
}

for(var i = 0; i < instance_number(obj_NPC); i++)
{
	if(i >= array_length(npcImmuneTime) && i < instance_number(obj_NPC))
	{
		npcImmuneTime[i] = 0;
	}
	else
	{
		npcImmuneTime[i] = max(npcImmuneTime[i]-1,0);
	}
}

alpha2 = abs((scaleTimer/2) - 75)/75;
pSpeed = abs(scaleTimer - 75)/75;
scaleTimer += max(3*pSpeed,0.1);
if(scaleTimer >= 60)
{
	pAlpha = (75 - scaleTimer)/15;
}

scr_OpenDoor(x,y,3);
scr_BreakBlock(x,y,4);

scr_DamageNPC(x,y,damage,damageType,0,-1,0);

if(scaleTimer >= 75)
{
	instance_destroy();
}
scale = 0.05*scaleTimer;
image_xscale = scale;
image_yscale = scale;
image_alpha = pAlpha*alpha2;