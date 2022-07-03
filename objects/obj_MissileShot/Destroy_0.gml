/// @description Explode
event_inherited();
if(scr_WithinCamRange())
{
    scr_PlayExplodeSnd(0,false);
    var explo = instance_create_layer(x,y,"Projectiles_fg",obj_MissileExplosion);
    explo.damage = damage;
}