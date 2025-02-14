/// @description 
event_inherited();

isWave = true;
isPlasma = true;

multiHit = true;
tileCollide = false;

particleType = -1;

projLength = sprite_width;
rotFrame = 2;
rFrame = 0;

fired = 0;
firedFrame = 0;
firedFrameCounter = 0;
firedX = xstart;
firedY = ystart;

setWave = true;

damageType = DmgType.Misc;
damageSubType[1] = false;
damageSubType[2] = false;
damageSubType[3] = false;
damageSubType[4] = true;
damageSubType[5] = false;

array_fill(blockBreakType, true);
array_fill(doorOpenType, true);

impactObj = obj_HyperBeamImpact;
function OnImpact(posX,posY,waveImpact = false)
{
	if(impactSnd != noone && !waveImpact)
	{
		if(audio_is_playing(impactSnd))
		{
			audio_stop_sound(impactSnd);
		}
		audio_play_sound(impactSnd,0,false);
	}
	
	if(impactObj != noone)
	{
		var explo = instance_create_layer(posX,posY,"Projectiles_fg",impactObj);
	    explo.damage = damage;
		
		var ddepth = layer_get_depth(layer_get_id("Projectiles_fg"))+1;
		if(impactObj == obj_HyperBeamImpact)
		{
			var dist = instance_create_depth(0,0,ddepth,obj_Distort);
			dist.left = posX-18;
			dist.right = posX+18;
			dist.top = posY-18;
			dist.bottom = posY+18;
			dist.alpha = 0;
			dist.alphaNum = 1;
			dist.alphaRate = 0.125;
			dist.alphaRateMultDecr = 4;
			dist.colorMult = 0.5;
			dist.spread = 0.5;
			dist.width = 0.5;
		}
		else
		{
			var dist = instance_create_depth(0,0,ddepth,obj_Distort);
			dist.left = posX-8;
			dist.right = posX+8;
			dist.top = posY-8;
			dist.bottom = posY+8;
			dist.alpha = 0;
			dist.alphaNum = 1;
			dist.alphaRate = 0.125;
			dist.alphaRateMultDecr = 4;
			dist.colorMult = 0.05;
			dist.spread = 0.5;
			dist.width = 0.5;
		}
	}
}