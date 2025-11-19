/// @description Explode
event_inherited();
if(outsideCam <= 1 && exploProj != noone)
{
	if(exploSnd == -1)
	{
		scr_PlayExplodeSnd(0,false);
	}
	else if(exploSnd != noone)
	{
		audio_play_sound(exploSnd,0,false);
	}
    var explo = instance_create_layer(x,y,"Projectiles_fg",exploProj);
    explo.damage = damage * exploDmgMult;
	explo.sourceVelX = x-xprevious;
	explo.sourceVelY = y-yprevious;
	
	ds_list_copy(explo.iFrameCounters, iFrameCounters);
	
	self.MovePushBlock();
}