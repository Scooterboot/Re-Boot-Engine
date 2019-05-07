/// @description scr_Shoot(shotIndex, damage, speed, cooldown, shotAmt, soundIndex)

var ShotIndex = argument[0],
	Damage = argument[1],
	Speed = argument[2],
	CoolDown = argument[3],
	ShotAmount = argument[4],
	SoundIndex = argument[5],
	
	spawnX = shootPosX,
	spawnY = shootPosY;

if(SoundIndex != noone)
{
	if(audio_is_playing(global.prevShotSndIndex))
	{
		var gain = 0;
		if(asset_get_index(audio_get_name(global.prevShotSndIndex)) != SoundIndex)
		{
			gain = audio_sound_get_gain(global.prevShotSndIndex)*0.5;
		}
		audio_sound_gain(global.prevShotSndIndex,gain,25);
	}
	var snd = audio_play_sound(SoundIndex,1,false);
	audio_sound_gain(snd,global.soundVolume,0);
	global.prevShotSndIndex = snd;
}

if(ShotIndex != noone)
{
	for(var i = 0; i < ShotAmount; i++)
	{
		var lyr = layer_get_id("Projectiles");
		var shot = instance_create_layer(spawnX,spawnY,lyr,ShotIndex);
		shot.damage = Damage;
		shot.velocity = Speed;
		if(!shot.isBomb)
		{
			shot.direction = shootDir;
			shot.image_angle = shootDir;
		}
		shot.speed_x = extraSpeed_x;
		shot.speed_y = extraSpeed_y;
		shot.waveStyle = i;
		shot.dir = dir2;
		shot.waveDir = waveDir;
		shot.creator = object_index;
	}
	shotDelayTime = CoolDown;
	if(shot.particleType >= 0 && !shot.isGrapple)
	{
		var partSys = obj_Particles.partSystemB;
		if(shot.isWave)
		{
			partSys = obj_Particles.partSystemA;
		}
		
		part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.bTrails[shot.particleType],7+(5*(statCharge >= maxCharge)));
        part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.mFlare[shot.particleType],1);
	}
	waveDir *= -1;
	if(instance_exists(shot))
	{
		return shot;
	}
}
return noone;