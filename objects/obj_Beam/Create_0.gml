/// @description Initialize

event_inherited();

#region Initialize Projectile Types

isCharge = (string_count("ChargeShot",object_get_name(object_index)) > 0);
isIce = (string_count("Ice",object_get_name(object_index)) > 0);
isWave = (string_count("Wave",object_get_name(object_index)) > 0);
isSpazer = (string_count("Spazer",object_get_name(object_index)) > 0);
isPlasma = (string_count("Plasma",object_get_name(object_index)) > 0);
isGrapple = (object_index == obj_GrappleBeamShot);

if(string_count("Beam",object_get_name(object_index)) > 0 && (sprite_index == mask_index || !sprite_exists(mask_index)))
{
	mask_index = mask_BeamShot;
	if(isCharge)
	{
		mask_index = mask_BeamChargeShot;
		if(isSpazer || isPlasma)
		{
			mask_index = mask_BeamChargeShot_Plasma;
		}
	}
}

frame = 0;
frameCounter = 0;

//isBeam = true;
type = ProjType.Beam;

damageType = DmgType.Beam;
if(isCharge)
{
	damageType = DmgType.Charge;
	dmgDelay = 1;
}
damageSubType[1] = true;
damageSubType[2] = isIce;
damageSubType[3] = isWave;
damageSubType[4] = isSpazer;
damageSubType[5] = isPlasma;

if(isIce)
{
    freezeType = 1 + isCharge;
	freezeKill = isPlasma;//isCharge;
}

particleType = 0;
if(isIce)
{
	particleType = 1;
}
else if(isPlasma)
{
	particleType = 4;
}
else if(isWave)
{
	particleType = 2;
}
else if(isSpazer)
{
	particleType = 3;
}
else if(isGrapple)
{
	particleType = -1;
}

particleDelay = 0;
particleDelay2 = 0;

impactSnd = snd_BeamImpact;

if((isIce || isCharge) && !isSpazer && !isPlasma)
{
	rotation = random(12)*30;
}

if(isWave)
{
	aiStyle = 1;
	amplitude = 8 + (2*isCharge);
	if(isSpazer)
	{
		amplitude = 16;
	}
	wavesPerSecond = 5-(isCharge);
	if(isSpazer)
	{
		wavesPerSecond = 2.5;
	}
	else if(isPlasma)
	{
		wavesPerSecond = 2.75;
	}
	tileCollide = false;
	switchCollide = false;
}
else if(isSpazer)
{
	aiStyle = 2;
	amplitude = 12 + isCharge;
	wavesPerSecond = 4;
}
if(isPlasma)
{
	if(isWave || isSpazer)
	{
		//delay += 3 + (3*isCharge);
		delay = 2 + (2*isCharge);
	}
	multiHit = true;
}
else if(isSpazer)
{
	//delay += 2 + (1*isCharge);
	delay = 1 + isCharge;
}
//wavesPerSecond *= 1.25;
wavesPerSecond *= 1.5;

if(isSpazer || isPlasma)
{
	projLength = sprite_width;
	rotFrame = 1 + (isCharge || isPlasma);
}
//if(!isCharge && !isIce && isWave && !isSpazer && !isPlasma)
if(object_index == obj_PowerBeamShot)
{
	rotFrame = 1;
}


image_speed = 0;//(image_number > 1 && rotFrame == 0);

#endregion

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
	if(particleType != -1 && particleType <= 4)
	{
		part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.bTrails[particleType],7*(1+isCharge));
		
		var ddepth = layer_get_depth(layer_get_id("Projectiles_fg"))+1;
		if(isCharge)
		{
			part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.cImpact[particleType],1);
			
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
			part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.impact[particleType],1);
			
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