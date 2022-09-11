/// @description Explode
event_inherited();
if(scr_WithinCamRange())
{
    scr_PlayExplodeSnd(0,false);
    var explo = instance_create_layer(x,y,"Projectiles_fg",obj_SuperMissileExplosion);
    explo.damage = damage / 2;
	explo.npcImmuneTime = npcImmuneTime;
	
	//var shake = instance_create_depth(x,y,0,obj_ScreenShaker);
	//shake.duration = 30;
	if(instance_exists(obj_ScreenShaker))
	{
		obj_ScreenShaker.Shake(30);
	}
}