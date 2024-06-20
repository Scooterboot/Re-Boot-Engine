/// @description Code
if(global.gamePaused)
{
	exit;
}

alpha2 = abs((scaleTimer/2) - 75)/75;
pSpeed = abs(scaleTimer - 75)/75;
scaleTimer += max(3*pSpeed,0.1);
if(scaleTimer >= 60)
{
	pAlpha = (75 - scaleTimer)/15;
}

TileInteract(x,y);

scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,8);

if(scaleTimer >= 75)
{
	instance_destroy();
}
scale = 0.05*scaleTimer;
image_xscale = scale;
image_yscale = scale;
image_alpha = pAlpha*alpha2 * 0.5;

for(var i = 0; i < array_length(npcInvFrames); i++)
{
	npcInvFrames[i] = max(npcInvFrames[i]-1,0);
}